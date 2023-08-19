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
    let context: [Int]?
    let total_duration: Int?
    let load_duration: Int?
    let sample_count: Int?
    let sample_duration: Int?
    let prompt_eval_count: Int?
    let prompt_eval_duration: Int?
    let eval_count: Int?
    let eval_duration: Int?
}
