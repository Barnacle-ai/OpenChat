//
//  UserMessageView.swift
//  ChatApp
//
//  Created by Duncan Anderson on 29/03/2023.
//

import SwiftUI

struct SystemMessageView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var chatStyle: ChatStyle
    @State var errorGettingInspiration = false
    @Binding var systemMessage: ChatMessage

    var body: some View {
        HStack {
            if chatStyle.systemMessageAlignment == .trailing {
                Spacer()
            }
            VStack(alignment: chatStyle.systemMessageAlignment) {
                if systemMessage.role == .assistant {
                    VStack {
                        HStack {
                            Text(systemMessage.content)
                                .font(chatStyle.systemMessageFont)
                                .foregroundColor(chatStyle.systemMessageColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 15).fill(chatStyle.systemMessageBubbleColor))

                            Spacer()
                        }
                    }
                } else {
                    Text(systemMessage.content)
                        .font(chatStyle.systemMessageFont)
                        .foregroundColor(chatStyle.systemMessageColor)
                }
            }
            if chatStyle.systemMessageAlignment == .leading {
                Spacer()
            }
        }
        .background(chatStyle.systemMessageBackgroundColor)
    }
}

struct SystemMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SystemMessageView(
            chatStyle: ChatStyle(
                name: .light,
                backgroundColor: .white,
                userMessageColor: .white,
                systemMessageColor: .black,
                userMessageFont: .system(.body, design: .default),
                systemMessageFont: .system(.body, design: .default),
                userMessageAlignment: .trailing,
                systemMessageAlignment: .leading,
                userMessageBackgroundColor: .clear,
                userMessageBubbleColor: Color(red:0.041, green:0.502, blue:1.000),
                systemMessageBackgroundColor: .clear,
                systemMessageBubbleColor: Color(red:0.914, green:0.914, blue:0.922),
                inputBoxOutlineColor: .black,
                inputBoxBackgroundColor: .white,
                inputTextColor: .black,
                inputTextFont: .system(.body, design: .default)
            ),
            systemMessage: .constant(ChatMessage(
                role: .assistant,
                content: "Hello there!"
            ))
        )
    }
}
