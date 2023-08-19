//
//  InputMessage.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation

struct LocalaiInputMessage: Codable {
    var temperature: Decimal
    var model: String
    var messages: [ChatMessage]
}

struct OllamaInputMessage: Codable {
    var model: String
    var prompt: String
    var context: [Int]?
}
