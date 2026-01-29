//
//  VersePickView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import SwiftUI

struct VersePickView: View {
    let bookCode: String
    let chapter: Int

    @State private var verses: [Verse] = []

    var body: some View {
        Group {
            if verses.isEmpty {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("구절을 불러오는 중입니다.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .onAppear { load() }
            } else {
                List(verses, id: \.id) { v in
                    NavigationLink {
                        ChapterReaderView(
                            today: TodayVerse(
                                id: v.id,
                                book: v.book,
                                book_kor_full: v.bookKorFull,
                                chapter: v.chapter,
                                verse: v.verse,
                                reference: v.reference,
                                text: v.text
                            ),
                            verses: verses,
                            highlightVerseId: v.id
                        )
                    } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Text("\(v.verse)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 28, alignment: .trailing)

                            Text(v.text)
                                .font(.callout)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }

    private func load() {
        verses = BibleRepository.shared.chapter(bookCode: bookCode, chapter: chapter)
    }
}
