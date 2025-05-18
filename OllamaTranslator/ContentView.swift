//
//  ContentView.swift
//  OllamaTranslator
//
//  Created by 荒野老男人 on 2025/5/18.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            TextField("Input", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputFocused)
                .onChange(of: isInputFocused) { _, focused in
                    if focused {
                        if let clipboard = NSPasteboard.general.string(forType: .string) {
                            inputText = clipboard
                        }
                    }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
