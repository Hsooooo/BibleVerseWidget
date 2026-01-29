//
//  VerseProvider.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

struct VerseProvider {

    /// BibleBookSections에 정의된 "정경 순서 book 코드" 전체 목록
    private static var allBookCodes: [String] {
        BibleBookSections.all.flatMap { $0.bookCodes }
    }

    static func generateHourlyVerses() -> HourlyVerses {
        var selected: Set<String> = []
        var result: [TodayVerse] = []

        // 안전장치: 무한 루프 방지
        var guardCount = 0
        let maxTries = 5000

        while result.count < 24 && guardCount < maxTries {
            guardCount += 1

            // 1) 책 랜덤 선택
            guard let bookCode = allBookCodes.randomElement() else { break }

            // 2) 해당 책 구절 로드
            let bookVerses = BibleRepository.shared.loadBook(code: bookCode)
            if bookVerses.isEmpty { continue }

            // 3) 그 책 안에서 랜덤 구절 선택
            guard let v = bookVerses.randomElement() else { continue }
            if selected.contains(v.id) { continue }

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

        // 혹시 부족하면 기본값으로 채우기(실제로는 거의 안 탐)
        while result.count < 24 {
            result.append(
                TodayVerse(
                    id: "Ps.23.1",
                    book: "Ps",
                    book_kor_full: "시편",
                    chapter: 23,
                    verse: 1,
                    reference: "시23:1",
                    text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
                )
            )
        }

        return HourlyVerses(
            generatedAt: Date(),
            verses: result
        )
    }
}
