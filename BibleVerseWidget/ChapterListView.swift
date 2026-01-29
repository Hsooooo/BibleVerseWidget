//
//  ChapterListView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import SwiftUI

struct ChapterListView: View {
    let bookCode: String   // ✅ "Gen", "John", "1Cor" 등

    private var bookKorFull: String {
        BibleRepository.shared.bookKorFullByCode(bookCode) ?? bookCode
    }

    private var chapters: [Int] {
        BibleRepository.shared.chapters(bookCode: bookCode)
    }

    var body: some View {
        List(chapters, id: \.self) { chapter in
            NavigationLink("\(chapter)장") {
                VersePickView(bookCode: bookCode, chapter: chapter)   // ✅ 여기 바뀜
                    .navigationTitle("\(bookKorFull) \(chapter)장")
            }
        }
        .navigationTitle(bookKorFull)
    }
}
