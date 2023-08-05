//
//  ContentView.swift
//  OpenChat
//
//  Created by Duncan Anderson on 12/06/2023.
//

import SwiftUI
import OpenAI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var dataModel: DataModel = DataModel()
    @State var input: String = ""
    @Namespace var bottomID
    @State var showConfig = false
    @State var modelHost = Host.ollama
    @State var modelName = "llama2"
    @State var openaiKey = ""
    @State var openaiAPI: OpenAI?
    @State var modelUrl: String = ""
    @State var chatStyle = ChatStyle(
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
    )
    var darkChatStyle = ChatStyle(
        name: .dark,
        backgroundColor: .black,
        userMessageColor: .white,
        systemMessageColor: .white,
        userMessageFont: .system(.body, design: .default),
        systemMessageFont: .system(.body, design: .default),
        userMessageAlignment: .trailing,
        systemMessageAlignment: .leading,
        userMessageBackgroundColor: .clear,
        userMessageBubbleColor: Color(red:0.041, green:0.502, blue:1.000),
        systemMessageBackgroundColor: .clear,
        systemMessageBubbleColor: Color(red:0.231, green:0.231, blue:0.240),
        inputBoxOutlineColor: .gray,
        inputBoxBackgroundColor: .white,
        inputTextColor: .white,
        inputTextFont: .system(.body, design: .default)
    )

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ScrollView([.vertical])  {
                    ScrollViewReader { value in
                        LazyVStack(alignment: .leading) {
                            if dataModel.messages.count > 0 {
                                ForEach(0..<dataModel.messages.count, id: \.self) { index in
                                    if dataModel.messages[index].role != .user {
                                        SystemMessageView(
                                            chatStyle: chatStyle,
                                            systemMessage: $dataModel.messages[index]
                                        )
                                    } else {
                                        UserMessageView(
                                            chatStyle: chatStyle,
                                            userMessage: $dataModel.messages[index]
                                        )
                                    }
                                }
                                .onChange(of: dataModel.messages.count) { _ in
                                    value.scrollTo(dataModel.messages.count - 1, anchor: .bottom)
                                }
                                .onChange(of: dataModel.messages[dataModel.messages.count-1].content) { _ in
                                    value.scrollTo(dataModel.messages.count - 1, anchor: .bottom)
                                }
                            }
                            if dataModel.awaitingResponse == true {
                                ProgressView()
                                    .id(bottomID)
                                    .progressViewStyle(TypingAnimationProgressViewStyle())
                            }
                        }
                        .onChange(of: dataModel.awaitingResponse) { _ in
                            if dataModel.awaitingResponse {
                                value.scrollTo(bottomID, anchor: .bottom)
                            }
                        }
                    }
                }

                UserInputBarView(
                    dataModel: dataModel,
                    input: $input,
                    chatStyle: $chatStyle,
                    modelHost: $modelHost,
                    modelName: $modelName,
                    modelUrl: $modelUrl,
                    openaiAPI: $openaiAPI
                )
            }
            .padding()
            .toolbar {
                Button(
                    action: {
                        showConfig = true
                    },
                    label: {
                        Image(systemName: "gear")
                    }
                )

            }
        }
        .background(chatStyle.backgroundColor)
        .onAppear {
            dataModel.messages = []
            if colorScheme == .dark {
                chatStyle = darkChatStyle
            }
        }
        .navigationTitle("\(modelHost.rawValue): \(modelName)")
        .sheet(isPresented: $showConfig) {
            ConfigView(
                showConfig: $showConfig,
                modelHost: $modelHost,
                modelName: $modelName,
                modelUrl: $modelUrl,
                openaiKey: $openaiKey,
                openaiAPI: $openaiAPI
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
