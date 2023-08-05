//
//  OpenaiController.swift
//  OpenChat
//
//  Created by Duncan Anderson on 03/08/2023.
//

import Foundation
import SwiftUI
import OpenAI

class OpenaiController {
    @ObservedObject var dataModel: DataModel

    init(dataModel: DataModel) {
        self.dataModel = dataModel
    }

    func openaiMessages(model: String) -> [Chat] {
        var openaiMessages: [Chat] = []
        for message in dataModel.messages {
            var role: Chat.Role = Chat.Role.assistant
            switch message.role {
                case .assistant:
                    role = .assistant
                case .user:
                    role = .user
            }
            let openaiMessage = Chat(
                role: role,
                content: message.content
            )
            openaiMessages.append(openaiMessage)
        }
        return openaiMessages
    }

    func sendOpenaiMessage(message: String, openaiAPI: OpenAI?, modelName: String) async {
        if let openaiAPI = openaiAPI {
            dataModel.messages.append(ChatMessage(role: .user, content: message))
            dataModel.awaitingResponse = true

            var messages = OpenaiController(dataModel: dataModel).openaiMessages(model: modelName)
            messages.append(
                Chat(role: .user, content: message)
            )
            var gptModel = Model()
            switch modelName {
                case "gpt-4":
                    gptModel = Model.gpt4
                case "gpt-3.5-turbo":
                    gptModel = Model.gpt3_5Turbo0613
                default:
                    ()
            }
            let query = ChatQuery(
                model: gptModel,
                messages: messages
            )

            openaiAPI.chatsStream(query: query) { partialResult in
                switch partialResult {
                    case .success(let result):
                        print(result.choices)
                        for chunk in result.choices {
                            DispatchQueue.main.async {
                                self.dataModel.awaitingResponse = false
                                if let word = chunk.delta.content {
                                    if self.dataModel.messages.last?.role == .assistant {
                                        self.dataModel.messages[self.dataModel.messages.count-1].content = "\(self.dataModel.messages.last?.content ?? "")\(word)"
                                    } else {
                                        let responseMessage = ChatMessage(
                                            role: .assistant,
                                            content: word
                                        )
                                        self.dataModel.messages.append(responseMessage)
                                    }
                                }
                            }
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            } completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
