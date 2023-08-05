//
//  DataModel.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import Foundation

class DataModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var awaitingResponse = false
}
