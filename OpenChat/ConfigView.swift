//
//  ConfigView.swift
//  OpenChat
//
//  Created by Duncan Anderson on 03/08/2023.
//

import SwiftUI
import OpenAI

struct ConfigView: View {
    @Binding var showConfig: Bool
    @Binding var modelHost: Host
    @Binding var modelName: String
    @Binding var modelUrl: String
    @Binding var openaiKey: String
    @Binding var openaiAPI: OpenAI?
    var ollamaDefaultUrl = "http://127.0.0.1:11434/api/generate"
    var localaiDefaultUrl = "http://127.0.0.1:8080/v1/chat/completions"
    var localaiUrl = "https://localai.io"
    var ollamaUrl = "https://ollama.ai"
    var openaiUrl = "https://openai.com"

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Model source:", selection: $modelHost) {
                    ForEach(Host.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                HStack {
                    switch modelHost {
                        case .ollama:
                            Link(ollamaUrl, destination: URL(string: ollamaUrl)!)
                                .font(.footnote)
                                .buttonStyle(.borderless)
                        case .localai:
                            Link(localaiUrl, destination: URL(string: localaiUrl)!)
                                .font(.footnote)
                                .buttonStyle(.borderless)
                        case .openai:
                            Link(openaiUrl, destination: URL(string: openaiUrl)!)
                                .font(.footnote)
                                .buttonStyle(.borderless)
                    }
                    Spacer()
                }
                HStack {
                    if modelHost == .ollama {
                        Text("Model URL:").padding(.trailing)
                            .padding(.top, 20)
                        TextField("Model URL...", text: $modelUrl)
                            .onAppear {
                                modelUrl = ollamaDefaultUrl
                            }
                            .padding(.top, 20)
                    }
                    if modelHost == .localai {
                        Text("Model URL:").padding(.trailing)
                            .padding(.top, 20)
                        TextField("Model URL...", text: $modelUrl)
                            .onAppear {
                                modelUrl = localaiDefaultUrl
                            }
                            .padding(.top, 20)
                    }
                    Spacer()
                }
                if [.ollama, .openai, .localai].contains(modelHost) {
                    HStack {
                        Text("Model name:").padding(.trailing)
                        TextField("Model name...", text: $modelName)
                    }
                    .padding(.top, 20)
                }
                if modelHost == .openai {
                    HStack {
                        Text("OpenAI key:").padding(.trailing)
                        TextField("OpenAI key...", text: $openaiKey)
                            .onChange(of: openaiKey) { newOpenaiKey in
                                openaiAPI = OpenAI(apiToken: newOpenaiKey)
                            }
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
            .padding(.top, 20)
            .navigationBarTitle("Configuration", displayMode: .inline)
            .toolbar {
                Button(
                    action: {
                        showConfig = false
                    },
                    label: {
                        Text("Done")
                    }
                )
                .padding(.leading)
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(
            showConfig: .constant(false),
            modelHost: .constant(.ollama),
            modelName: .constant("llama2"),
            modelUrl: .constant(""),
            openaiKey: .constant(""),
            openaiAPI: .constant(nil)
        )
    }
}
