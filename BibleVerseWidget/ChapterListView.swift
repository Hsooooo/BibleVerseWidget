//
//  ChapterListView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import SwiftUI

struct ChapterListView: View {
    let bookKorFull: String
    private var chapters: [Int] {
        BibleRepository.shared.chapters(bookKorFull: bookKorFull)
    }

    var body: some View {
        List(chapters, id: \.self) { chapter in
            NavigationLink("\(chapter)장") {
                VersePickView(bookKorFull: bookKorFull, chapter: chapter)
                    .navigationTitle("\(chapter)장")
            }
        }
    }
}
