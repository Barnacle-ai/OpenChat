//
//  TypingIndicatorProgressView.swift
//  ChatApp
//
//  Created by Duncan Anderson on 30/03/2023.
//

import SwiftUI

struct TypingAnimationProgressViewStyle: ProgressViewStyle {
    @State private var isTyping = false

    func makeBody(configuration: ProgressViewStyleConfiguration) -> some View {
        VStack {
            Spacer().frame(height: 10)
            HStack(spacing: 4) {
                Circle()
                    .frame(width: 10, height: 15)
                    .opacity(isTyping ? 1 : 0.1)
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: true), value: isTyping)
                Circle()
                    .frame(width: 10, height: 10)
                    .opacity(isTyping ? 1 : 0.1)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isTyping)
                Circle()
                    .frame(width: 10, height: 10)
                    .opacity(isTyping ? 1 : 0.1)
                    .animation(.easeIn(duration: 1).repeatForever(autoreverses: true), value: isTyping)
            }
            .padding(.top, 20)
            .padding(.leading, 10)
            Spacer().frame(height: 15)
        }
       .onAppear{
           isTyping.toggle()
       }
    }
}

struct TypingAnimationProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 50, total: 100)
            .progressViewStyle(TypingAnimationProgressViewStyle())
            .padding()
    }
}
