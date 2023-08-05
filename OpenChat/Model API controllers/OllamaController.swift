//
//  OllamaController.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation
import SwiftUI

class OllamaController: NSObject, URLSessionDataDelegate {
    @ObservedObject var dataModel: DataModel

    init(dataModel: DataModel) {
        self.dataModel = dataModel
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var arrayOfJsonResponse: [OllamaCompletionResponse] = []
        let responseString = String(data: data, encoding: String.Encoding.utf8)
        let responses = responseString?.components(separatedBy: "\n")
        var responseText = ""
        if let responses = responses {
            for index in 0..<responses.count-1 {
                if responses[index].count > 0 {
                    let responseData = responses[index].data(using: .utf8)
                    if let responseData = responseData {
                        let jsonDecoder = JSONDecoder()
                        let completionResponse = try! jsonDecoder.decode(OllamaCompletionResponse.self, from: responseData)
                        arrayOfJsonResponse.append(completionResponse)
                    }
                }
            }
            arrayOfJsonResponse = arrayOfJsonResponse.filter({ $0.done != true })
            responseText = arrayOfJsonResponse.map { $0.response ?? "" }.joined()
        }
        if self.dataModel.messages.last?.role == .assistant {
            DispatchQueue.main.async {
                self.dataModel.messages[self.dataModel.messages.count-1].content = "\(self.dataModel.messages.last?.content ?? "")\(responseText)"
            }
        } else {
            DispatchQueue.main.async {
                let responseMessage = ChatMessage(
                    role: .assistant,
                    content: responseText
                )
                self.dataModel.messages.append(responseMessage)
            }
        }
        DispatchQueue.main.async {
            self.dataModel.awaitingResponse = false
        }
    }

    func sendOllamaMessage(message: String, modelUrl: String, modelName: String) {
        dataModel.messages.append(ChatMessage(role: .user, content: message))
        dataModel.awaitingResponse = true

        let sessionConfig = URLSessionConfiguration.default
        let responseHandler = OllamaController(dataModel: dataModel)

        let session = URLSession(configuration: sessionConfig, delegate: responseHandler, delegateQueue: OperationQueue())
        guard let URL = URL(string: modelUrl) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = OllamaInputMessage(
            model: modelName,
            prompt: message)
        let jsonEncoder = JSONEncoder()
        request.httpBody = try! jsonEncoder.encode(body)

        let task = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
