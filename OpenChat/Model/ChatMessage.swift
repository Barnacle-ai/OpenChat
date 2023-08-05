//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Duncan Anderson on 29/03/2023.
//

enum Role: String, Codable {
    case assistant = "assistant"
    case user = "user"
}

struct ChatMessage: Codable {
    var role: Role
    var content: String
}
