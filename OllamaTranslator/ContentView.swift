//
//  ContentView.swift
//  OllamaTranslator
//
//  Created by 荒野老男人 on 2025/5/18.
//

import SwiftUI
import AppKit
import NaturalLanguage
import Foundation

// MARK: - Ollama API helpers
private struct OllamaRequest: Codable {
    let model: String
    let prompt: String
    let stream: Bool
}

private struct OllamaResponse: Codable {
    let response: String
}

/// Call the local Ollama server (default port 11434) to translate text.
/// - Parameters:
///   - text: Original text that needs translation.
///   - source: Human‑readable language code produced by `mainLanguage` ("Chinese" / "English").
/// - Returns: Translated text, or an error description.
private func translateWithOllama(text: String, source: String) async -> String {
    // Decide target language & craft prompt
    let prompt: String
    switch source {
    case "Chinese":
        prompt = "Translate the following content into English:\n\(text)"
    case "English":
        prompt = "把接下来的内容翻译成中文：\n\(text)"
    default:
        return text     // Unknown language → no translation
    }

    guard let url = URL(string: "http://127.0.0.1:11434/api/generate") else {
        return "Invalid Ollama endpoint"
    }

    let body = OllamaRequest(model: "qwen2.5:1.5b", prompt: prompt, stream: false)
    do {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(OllamaResponse.self, from: data)
        return decoded.response.trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
        return "Translation error: \(error.localizedDescription)"
    }
}

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
                            translation = "Translating..."
                            Task {
                                let result = await translateWithOllama(text: clipboard,
                                                                        source: detectedLanguage)
                                await MainActor.run {
                                    translation = result
                                }
                            }
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
