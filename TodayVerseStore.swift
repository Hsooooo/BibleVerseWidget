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
            print("ℹ️ [TodayVerseStore] No hourlyVerses data")
            return nil
        }
        print("✅ [TodayVerseStore] hourlyVerses bytes:", data.count)
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
        // 1) 오늘 저장된 말씀 (가장 안정)
        if let v = loadTodayVerse() {
            return v
        }
        // 2) 시간별 캐시에서 가져와서 todayVerse로 저장 (앱-위젯 동기화)
        if let hourly = loadHourlyVerses(), hourly.isValid, let v = hourly.verse() {
            saveTodayVerse(v)
            print("✅ [TodayVerseStore] auto-saved todayVerse from hourly:", v.reference)
            return v
        }
        // 3) 기본값
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
    
    private func todayKey(for date: Date = Date()) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "ko_KR")
        f.timeZone = TimeZone.current
        f.dateFormat = "yyyy-MM-dd"
        return "todayVerse_\(f.string(from: date))"
    }
    
    func saveTodayVerse(_ verse: TodayVerse, date: Date = Date()) {
        do {
            let data = try JSONEncoder().encode(verse)
            defaults.set(data, forKey: todayKey(for: date))
            print("✅ [TodayVerseStore] Saved todayVerse:", todayKey(for: date))
        } catch {
            print("❌ [TodayVerseStore] Encode todayVerse failed:", error)
        }
    }

    func loadTodayVerse(date: Date = Date()) -> TodayVerse? {
        guard let data = defaults.data(forKey: todayKey(for: date)) else {
            print("ℹ️ [TodayVerseStore] No todayVerse:", todayKey(for: date))
            return nil
        }
        return try? JSONDecoder().decode(TodayVerse.self, from: data)
    }
}
