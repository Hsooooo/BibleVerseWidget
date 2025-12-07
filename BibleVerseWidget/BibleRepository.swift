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
        self.verses = Self.loadBible()
    }

    private static func loadBible() -> [Verse] {
        guard let url = Bundle.main.url(forResource: "bible_structured", withExtension: "json") else {
            print("❌ [BibleRepository] bible.json not found in Bundle.main")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let verses = try decoder.decode([Verse].self, from: data)
            print("✅ [BibleRepository] Loaded \(verses.count) verses")
            return verses
        } catch {
            print("❌ [BibleRepository] Failed to decode bible.json:", error)
            return []
        }
    }
}
