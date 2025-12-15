//
//  TodayVerseStore.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//
import Foundation

final class TodayVerseStore {
    static let shared = TodayVerseStore()

    private let defaults: UserDefaults
    private let hourlyKey = "hourlyVerses"

    private init() {
        let suiteName = "group.hs.lee.BibleVerseWidget"

        if let ud = UserDefaults(suiteName: suiteName) {
            defaults = ud
            print("🟢 [TodayVerseStore] App Group OK:", suiteName)
        } else {
            defaults = .standard
            print("🔴 [TodayVerseStore] App Group FAILED → standard")
        }
    }

    // MARK: - Save / Load

    func saveHourlyVerses(_ hourly: HourlyVerses) {
        do {
            let data = try JSONEncoder().encode(hourly)
            defaults.set(data, forKey: hourlyKey)
            print("✅ [TodayVerseStore] Saved hourly verses")
        } catch {
            print("❌ [TodayVerseStore] Encode failed:", error)
        }
    }

    func loadHourlyVerses() -> HourlyVerses? {
        guard let data = defaults.data(forKey: hourlyKey) else {
            return nil
        }
        return try? JSONDecoder().decode(HourlyVerses.self, from: data)
    }

    // MARK: - Public API

    func currentVerse() -> TodayVerse? {
        guard let hourly = loadHourlyVerses(), hourly.isValid else {
            return nil
        }
        return hourly.verse()
    }

    func currentVerseOrDefault() -> TodayVerse {
        if let v = currentVerse() {
            return v
        }
        return TodayVerse(
            id: "Ps.23.1",
            book: "Ps",
            book_kor_full: "시편",
            chapter: 23,
            verse: 1,
            reference: "시23:1",
            text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
        )
    }
}
