//
//  TodayVerse.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

/// 단일 구절 정보
struct TodayVerse: Codable {
    let reference: String   // "창1:1"
    let text: String        // "태초에 하나님이 천지를 창조하시니라"
}

/// 24시간 구절 캐시 (앱에서 생성, 위젯에서 읽기)
struct HourlyVerses: Codable {
    let generatedAt: Date           // 생성 시점
    let startHour: Int              // 시작 시간 (0-23)
    let verses: [TodayVerse]        // 24개 구절 (index = hour offset)
    
    /// 특정 시간의 구절 반환
    func verse(for date: Date) -> TodayVerse? {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        
        // startHour부터의 offset 계산
        var offset = currentHour - startHour
        if offset < 0 { offset += 24 }
        
        guard offset >= 0 && offset < verses.count else { return nil }
        return verses[offset]
    }
    
    /// 캐시가 유효한지 (생성 후 24시간 이내)
    var isValid: Bool {
        let elapsed = Date().timeIntervalSince(generatedAt)
        return elapsed < 24 * 60 * 60  // 24시간
    }
}
