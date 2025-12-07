//
//  VerseHistoryStore.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

final class VerseHistoryStore {
    static let shared = VerseHistoryStore()

    private let defaults = UserDefaults.standard   // 이건 App Group 안 써도 됨 (앱 로컬 히스토리)
    private let key = "verseHistory"               // [String: String]  "YYYY-MM-DD" -> verseId

    private var history: [String: String]

    private init() {
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            history = decoded
        } else {
            history = [:]
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(history) {
            defaults.set(data, forKey: key)
        }
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    /// 날짜+시간 키 (매시간 구절 변경용)
    private func dateHourString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd-HH"
        return formatter.string(from: date)
    }

    /// 오늘 날짜에 해당하는 verseId 조회
    func verseId(for date: Date) -> String? {
        history[dateString(date)]
    }

    /// 현재 시간에 해당하는 verseId 조회 (매시간용)
    func verseIdForHour(for date: Date) -> String? {
        history[dateHourString(date)]
    }

    /// 오늘 날짜에 verseId 저장
    func setVerseId(_ id: String, for date: Date) {
        history[dateString(date)] = id
        save()
    }

    /// 현재 시간에 verseId 저장 (매시간용)
    func setVerseIdForHour(_ id: String, for date: Date) {
        history[dateHourString(date)] = id
        save()
    }

    /// 최근 n일 동안 사용된 verseId들 집합
    func verseIds(inLastDays days: Int, from date: Date) -> Set<String> {
        let cal = Calendar(identifier: .gregorian)
        var result = Set<String>()

        for offset in 0..<days {
            if let d = cal.date(byAdding: .day, value: -offset, to: date) {
                let key = dateString(d)
                if let id = history[key] {
                    result.insert(id)
                }
            }
        }
        return result
    }
}
