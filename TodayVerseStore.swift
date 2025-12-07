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

        print("🟡 [TodayVerseStore] init in bundle:",
              Bundle.main.bundleIdentifier ?? "nil",
              "suiteName:", suiteName)

        if let ud = UserDefaults(suiteName: suiteName) {
            defaults = ud
            print("🟢 [TodayVerseStore] Using App Group UserDefaults")
        } else {
            defaults = .standard
            print("🔴 [TodayVerseStore] FAILED to init App Group. Using .standard")
        }
    }

    // MARK: - 24시간 구절 캐시 (새로운 방식)
    
    func saveHourlyVerses(_ hourlyVerses: HourlyVerses) {
        do {
            let data = try JSONEncoder().encode(hourlyVerses)
            defaults.set(data, forKey: hourlyKey)
            defaults.synchronize()  // 즉시 디스크에 저장
            print("✅ [TodayVerseStore] Saved hourlyVerses, count:", hourlyVerses.verses.count)
        } catch {
            print("❌ [TodayVerseStore] Failed to encode hourlyVerses:", error)
        }
    }

    func loadHourlyVerses() -> HourlyVerses? {
        guard let data = defaults.data(forKey: hourlyKey) else {
            print("ℹ️ [TodayVerseStore] No hourlyVerses data")
            return nil
        }
        do {
            let hourlyVerses = try JSONDecoder().decode(HourlyVerses.self, from: data)
            print("✅ [TodayVerseStore] Loaded hourlyVerses, valid:", hourlyVerses.isValid)
            return hourlyVerses
        } catch {
            print("❌ [TodayVerseStore] Failed to decode hourlyVerses:", error)
            return nil
        }
    }

    /// 현재 시간에 해당하는 구절 반환
    func currentVerse() -> TodayVerse? {
        guard let hourlyVerses = loadHourlyVerses(),
              hourlyVerses.isValid else {
            print("ℹ️ [TodayVerseStore] No valid hourlyVerses cache")
            return nil
        }
        return hourlyVerses.verse(for: Date())
    }

    /// 현재 구절 또는 기본값 반환
    func currentVerseOrDefault() -> TodayVerse {
        if let verse = currentVerse() {
            return verse
        }
        return TodayVerse(
            reference: "시23:1",
            text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
        )
    }
}
