//
//  VerseProvider.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

struct VerseProvider {

    static func generateHourlyVerses() -> HourlyVerses {
        let verses = BibleRepository.shared.verses
        var selected: Set<String> = []
        var result: [TodayVerse] = []

        while result.count < 24 {
            guard let v = verses.randomElement(),
                  !selected.contains(v.id) else { continue }

            selected.insert(v.id)
            result.append(
                TodayVerse(
                    id: v.id,
                    book: v.book,
                    book_kor_full: v.bookKorFull,
                    chapter: v.chapter,
                    verse: v.verse,
                    reference: v.reference,
                    text: v.text
                )
            )
        }

        return HourlyVerses(
            generatedAt: Date(),
            verses: result
        )
    }
}
