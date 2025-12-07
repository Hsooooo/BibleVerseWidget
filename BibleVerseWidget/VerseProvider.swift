//
//  VerseProvider.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

struct VerseProvider {
    static let repo = BibleRepository.shared
    static let history = VerseHistoryStore.shared

    /// 24시간 구절 미리 생성 (앱 실행 시 호출)
    static func generateHourlyVerses() -> HourlyVerses {
        let verses = repo.verses
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        
        // 최근 60일 동안 사용된 구절 제외
        let excludedIds = history.verseIds(inLastDays: 60, from: now)
        let candidates = verses.filter { !excludedIds.contains($0.id) }
        let pool = candidates.isEmpty ? verses : candidates
        
        // 24개 구절 랜덤 선택 (중복 허용 - 31,102개 중 24개라 거의 안 겹침)
        var selectedVerses: [TodayVerse] = []
        for _ in 0..<24 {
            if let verse = pool.randomElement() {
                selectedVerses.append(TodayVerse(
                    reference: verse.reference,
                    text: verse.text
                ))
            }
        }
        
        // 24개 못 채우면 기본값으로 채우기
        while selectedVerses.count < 24 {
            selectedVerses.append(TodayVerse(
                reference: "시23:1",
                text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
            ))
        }
        
        let hourlyVerses = HourlyVerses(
            generatedAt: now,
            startHour: currentHour,
            verses: selectedVerses
        )
        
        print("✅ [VerseProvider] Generated 24 hourly verses starting at hour:", currentHour)
        return hourlyVerses
    }

    /// 오늘의 구절 (최근 60일 중복 방지) - 기존 메서드 유지
    static func dailyVerse(for date: Date = Date()) -> Verse? {
        let verses = repo.verses
        guard !verses.isEmpty else {
            print("❌ [VerseProvider] verses is empty")
            return nil
        }

        // 이미 오늘 뽑아둔 게 있으면 그대로 사용
        if let id = history.verseId(for: date),
           let existing = verses.first(where: { $0.id == id }) {
            print("ℹ️ [VerseProvider] Reusing verse for today:", existing.reference)
            return existing
        }

        // 최근 60일 동안 사용된 구절 제외
        let excludedIds = history.verseIds(inLastDays: 60, from: date)
        print("ℹ️ [VerseProvider] Excluded last 60 days:", excludedIds.count)

        let candidates = verses.filter { !excludedIds.contains($0.id) }
        let pool = candidates.isEmpty ? verses : candidates

        guard let chosen = pool.randomElement() else {
            print("❌ [VerseProvider] randomElement() returned nil")
            return nil
        }

        // 히스토리에 저장
        history.setVerseId(chosen.id, for: date)
        print("✅ [VerseProvider] Chosen verse:", chosen.reference)

        return chosen
    }
}
