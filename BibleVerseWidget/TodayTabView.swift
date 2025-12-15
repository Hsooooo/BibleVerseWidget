//
//  TodayTabView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import SwiftUI

struct TodayTabView: View {
    @State private var today: TodayVerse = TodayVerseStore.shared.currentVerseOrDefault()
    @State private var chapterVerses: [Verse] = []

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            Group {
                if chapterVerses.isEmpty {
                    loadingView
                } else {
                    ChapterReaderView(today: today, verses: chapterVerses, highlightVerseId: today.id)
                }
            }
            .onAppear { reload() }
            .onChange(of: scenePhase) { phase in
                if phase == .active { reload() }
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 10) {
            ProgressView()
            Text("말씀을 불러오는 중입니다.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func reload() {
        let v = TodayVerseStore.shared.currentVerseOrDefault()
        today = v
        chapterVerses = BibleRepository.shared.chapter(book: v.book, chapter: v.chapter)
    }
}

