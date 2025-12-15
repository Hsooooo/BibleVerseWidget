//
//  BibleRepository.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

final class BibleRepository {
    static let shared = BibleRepository()

    let verses: [Verse]

    private init() {
        verses = Self.load()
    }

    private static func load() -> [Verse] {
        guard let url = Bundle.main.url(
            forResource: "bible_structured",
            withExtension: "json"
        ) else {
            print("❌ bible_structured.json not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let verses = try JSONDecoder().decode([Verse].self, from: data)
            print("✅ Loaded verses:", verses.count)
            return verses
        } catch {
            print("❌ Decode failed:", error)
            return []
        }
    }

    func chapter(book: String, chapter: Int) -> [Verse] {
        verses
            .filter { $0.book == book && $0.chapter == chapter }
            .sorted { $0.verse < $1.verse }
    }
    
    func books() -> [String] {
            Array(Set(verses.map { $0.bookKorFull })).sorted()
        }
    
    func chapters(of book: String) -> [Int] {
            Array(Set(
                verses
                    .filter { $0.bookKorFull == book }
                    .map { $0.chapter }
            )).sorted()
        }
    /// 특정 권의 장 목록
    func chapters(bookKorFull: String) -> [Int] {
        Array(Set(
            verses
                .filter { $0.bookKorFull == bookKorFull }
                .map { $0.chapter }
        )).sorted()
    }

    /// 특정 권/장의 전체 구절
    func chapter(bookKorFull: String, chapter: Int) -> [Verse] {
        verses
            .filter { $0.bookKorFull == bookKorFull && $0.chapter == chapter }
            .sorted { $0.verse < $1.verse }
    }
    
    
    func booksKorFull() -> [String] {
            Array(Set(verses.map { $0.bookKorFull })).sorted()
        }
    
    /// 정경 순서대로 권 목록 반환 (korFull로 표시)
    func booksInCanonicalOrder() -> [String] {
        print(Set(BibleRepository.shared.verses.map { $0.book }).sorted())
        // book 코드 -> korFull (중복 키는 최초 1회만 반영)
        var bookCodeToKorFull: [String: String] = [:]
        for v in verses {
            if bookCodeToKorFull[v.book] == nil {
                bookCodeToKorFull[v.book] = v.bookKorFull
            }
        }

        // 정경 순서대로 존재하는 권만 반환
        return BibleBookOrder.order.compactMap { code in
            bookCodeToKorFull[code]
        }
    }
    
    /// 권 이름(korFull) -> book 코드 얻기
    func bookCode(forKorFull korFull: String) -> String? {
        verses.first(where: { $0.bookKorFull == korFull })?.book
    }
    
    func bookKorFullByCode(_ code: String) -> String? {
            verses.first(where: { $0.book == code })?.bookKorFull
        }

}
