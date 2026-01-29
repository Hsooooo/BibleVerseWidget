//
//  BibleRepository.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

final class BibleRepository {
    static let shared = BibleRepository()

    // ✅ 간단 캐시 (최근에 읽은 책들을 메모리에 보관)
    private var cache: [String: [Verse]] = [:]

    private init() {}

    // MARK: - Public

    /// 책(code) 단위로 로드: "Gen", "Ps", "1Cor" ...
    func loadBook(code: String) -> [Verse] {
        if let cached = cache[code] { return cached }

        let fileName = code
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ [BibleRepository] \(fileName).json not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let verses = try JSONDecoder().decode([Verse].self, from: data)

            cache[code] = verses
            print("✅ [BibleRepository] Loaded \(code): \(verses.count) verses")
            return verses
        } catch {
            print("❌ [BibleRepository] Decode failed for \(code):", error)
            return []
        }
    }

    /// 책+장 단위로 가져오기
    func chapter(bookCode: String, chapter: Int) -> [Verse] {
        loadBook(code: bookCode)
            .filter { $0.chapter == chapter }
            .sorted { $0.verse < $1.verse }
    }

    /// 책의 장 목록
    func chapters(bookCode: String) -> [Int] {
        let book = loadBook(code: bookCode)
        return Array(Set(book.map { $0.chapter })).sorted()
    }

    /// 책 코드 → 한글 권명 (파일 로드 후 첫 구절에서 뽑기)
    func bookKorFullByCode(_ code: String) -> String? {
        loadBook(code: code).first?.bookKorFull
    }

    /// 필요하면 캐시 비우기
    func clearCache() {
        cache.removeAll()
    }
}
