//
//  UserMessageView.swift
//  ChatApp
//
//  Created by Duncan Anderson on 29/03/2023.
//

import SwiftUI

struct UserMessageView: View {
    @State var chatStyle: ChatStyle
    @Binding var userMessage: ChatMessage

    var body: some View {
        HStack {
            if chatStyle.userMessageAlignment == .trailing {
                Spacer()
            }
            VStack(alignment: chatStyle.userMessageAlignment) {
                Text(userMessage.content)
                    .font(chatStyle.userMessageFont)
                    .foregroundColor(chatStyle.userMessageColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(chatStyle.userMessageBubbleColor))
            }
            if chatStyle.userMessageAlignment == .leading {
                Spacer()
            }
        }
        .background(chatStyle.userMessageBackgroundColor)
    }
}

struct UserMessageView_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageView(
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
            userMessage: .constant(
                ChatMessage(
                    role: .user,
                    content: "Hi"
                )
            )
        )
    }
}
