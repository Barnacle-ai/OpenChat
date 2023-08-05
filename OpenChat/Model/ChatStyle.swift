//
//  ChatStyle.swift
//  ChatApp
//
//  Created by Duncan Anderson on 29/03/2023.
//

import Foundation
import SwiftUI

enum ChatUIStyle: String, CaseIterable {
    case light = "light"
    case dark = "dark"
}

struct ChatStyle {
    enum TypingIndicator {
        case typing
        case terminal
        case none
    }

    var name: ChatUIStyle
    var backgroundColor: Color
    var userMessageColor: Color
    var systemMessageColor: Color
    var userMessageFont: Font
    var systemMessageFont: Font
    var userMessageAlignment: HorizontalAlignment
    var systemMessageAlignment: HorizontalAlignment
    var userMessageBackgroundColor: Color
    var userMessageBubbleColor: Color
    var systemMessageBackgroundColor: Color
    var systemMessageBubbleColor: Color
    var inputBoxOutlineColor: Color
    var inputBoxBackgroundColor: Color
    var inputTextColor: Color
    var inputTextFont: Font
}
