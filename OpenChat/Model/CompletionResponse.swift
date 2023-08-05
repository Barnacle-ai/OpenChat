//
//  CompletionResponse.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation

struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Choice: Decodable {
    let finishReason: String?
    let message: ChatMessage
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}
