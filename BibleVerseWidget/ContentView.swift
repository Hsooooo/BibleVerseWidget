//
//  ContentView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = "로딩 중..."

    var body: some View {
        VStack(spacing: 12) {
            Text("이 시간의 말씀")
                .font(.headline)

            Text(text)
                .multilineTextAlignment(.leading)
                .font(.body)
        }
        .padding()
        .onAppear {
            let verse = TodayVerseStore.shared.currentVerseOrDefault()
            text = "\(verse.reference)\n\(verse.text)"
        }
    }
}

#Preview {
    ContentView()
}
