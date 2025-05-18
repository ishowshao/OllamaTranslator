//
//  ContentView.swift
//  OllamaTranslator
//
//  Created by 荒野老男人 on 2025/5/18.
//

import SwiftUI
import AppKit
import NaturalLanguage

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var translation: String = ""
    @State private var detectedLanguage: String = ""
    @FocusState private var isInputFocused: Bool
    var body: some View {
        VStack {
            // Multi-line editor
            TextEditor(text: $inputText)
                .focused($isInputFocused)
                .padding(4)
                .onChange(of: isInputFocused) { _, focused in
                    if focused, inputText.isEmpty {
                        if let clipboard = NSPasteboard.general.string(forType: .string) {
                            inputText = clipboard
                            detectedLanguage = mainLanguage(of: clipboard)
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString("hello", forType: .string)
                            translation = "hello"
                        }
                    }
                }
            TextEditor(text: $translation)
                .padding(4)
            Text("Detected language: \(detectedLanguage)")
                .padding(4)
            Button("Done") {
                isInputFocused = false
                inputText = ""
                translation = ""
                detectedLanguage = ""
            }

        }
        .padding()
    }
    
    /// Detect the dominant language of a string and map common codes to readable names.
    private func mainLanguage(of text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        guard let lang = recognizer.dominantLanguage else { return "Unknown" }

        switch lang {
        case .simplifiedChinese, .traditionalChinese:
            return "Chinese"
        case .english:
            return "English"
        default:
            return lang.rawValue   // e.g. "ja", "fr", etc.
        }
    }
}

#Preview {
    ContentView()
}
