//
//  LocalaiController.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation
import SwiftUI

class LocalaiController: NSObject, URLSessionDataDelegate {
    @ObservedObject var dataModel: DataModel

    init(dataModel: DataModel) {
        self.dataModel = dataModel
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let jsonDecoder = JSONDecoder()
        let completionResponse = try! jsonDecoder.decode(CompletionResponse.self, from: data)
        let responseText = completionResponse.choices.first?.message.content ?? ""
        DispatchQueue.main.async {
            self.dataModel.awaitingResponse = false
            let responseMessage = ChatMessage(
                role: .assistant,
                content: responseText
            )
            self.dataModel.messages.append(responseMessage)
        }
    }

    func sendLocalaiMessage(message: String, modelUrl: String, modelName: String) {
        dataModel.messages.append(ChatMessage(role: .user, content: message))
        dataModel.awaitingResponse = true

        let sessionConfig = URLSessionConfiguration.default
        let responseHandler = LocalaiController(dataModel: dataModel)

        let session = URLSession(configuration: sessionConfig, delegate: responseHandler, delegateQueue: OperationQueue())
        guard let URL = URL(string: modelUrl) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LocalaiInputMessage(
            temperature: 0.9,
            model: modelName,
            messages: dataModel.messages)
        let jsonEncoder = JSONEncoder()
        request.httpBody = try! jsonEncoder.encode(body)

        let task = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
