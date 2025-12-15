//
//  HourlyVerses.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import Foundation

struct HourlyVerses: Codable {
    let generatedAt: Date            // 생성 시점 (오늘)
    let verses: [TodayVerse]         // index = hour (0-23)

    func verse(for date: Date = Date()) -> TodayVerse? {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        let hour = cal.component(.hour, from: date)
        guard verses.count == 24, (0..<24).contains(hour) else { return nil }
        return verses[hour]
    }

    /// 오늘 날짜까지만 유효 (자정 지나면 무효)
    var isValid: Bool {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        let startOfToday = cal.startOfDay(for: generatedAt)
        guard let startOfTomorrow = cal.date(byAdding: .day, value: 1, to: startOfToday) else {
            return false
        }
        return Date() < startOfTomorrow
    }
}
