//
//  CompletionResponse.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation

struct OllamaCompletionResponse: Decodable {
    let model: String
    let created_at: String
    let response: String?
    let done: Bool
}
