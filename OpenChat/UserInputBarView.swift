//
//  UserInputBarView.swift
//  OpenChat
//
//  Created by Duncan Anderson on 14/06/2023.
//

import SwiftUI
import OpenAI

struct UserInputBarView: View {
    @StateObject var dataModel: DataModel = DataModel()
    @Binding var input: String
    @Binding var chatStyle: ChatStyle
    @Binding var modelHost: Host
    @Binding var modelName: String
    @Binding var modelUrl: String
    @Binding var openaiAPI: OpenAI?
    @FocusState private var inputInFocus: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(chatStyle.inputBoxOutlineColor, lineWidth: 0.5)
                .frame(height: 44)
                .foregroundColor(chatStyle.inputBoxBackgroundColor)
            HStack {
                TextField(
                    text: $input,
                    label: {
                        Text("")
                            .font(.system(.body, design: .monospaced))
                    }
                )
                .padding(.leading, 10)
                .foregroundColor(chatStyle.inputTextColor)
                .font(chatStyle.inputTextFont)
                .disabled(dataModel.awaitingResponse)
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .focused($inputInFocus)
                .onSubmit {
                    Task {
                        await sendMessage(message: input)
                    }
                }
                Button(
                    action: {
                        Task {
                            await sendMessage(message: input)
                        }
                    },
                    label: {
                        if input.count > 0 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(red:0.041, green:0.502, blue:1.000))
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 35, height: 35)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color.gray)
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 35, height: 35)
                        }
                    }
                )
                .disabled(input.count == 0)
                .padding(.trailing, 5)
                .buttonStyle(.borderless)
            }
        }
    }

    private func sendMessage(message: String) async {
        switch modelHost {
            case .localai:
                LocalaiController(dataModel: dataModel).sendLocalaiMessage(
                    message: input,
                    modelUrl: modelUrl,
                    modelName: modelName
                )
            case .ollama:
                OllamaController(dataModel: dataModel).sendOllamaMessage(
                    message: input,
                    modelUrl: modelUrl,
                    modelName: modelName
                )
            case .openai:
                await OpenaiController(dataModel: dataModel).sendOpenaiMessage(
                    message: input,
                    openaiAPI: openaiAPI,
                    modelName: modelName
                )
        }
        input = ""
    }
}

struct UserInputBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputBarView(
            input: .constant("Hi!"),
            chatStyle: .constant(ChatStyle(
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
            )),
            modelHost: .constant(Host.ollama),
            modelName: .constant("llama2"),
            modelUrl: .constant(""),
            openaiAPI: .constant(nil)
        )
    }
}
