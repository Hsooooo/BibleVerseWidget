//
//  BibleVerseWidgetApp.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import SwiftUI
import WidgetKit

@main
struct BibleVerseWidgetApp: App {

    init() {
        // 1) 이미 유효한 hourly 캐시가 있으면 재생성 금지
        let existingHourly = TodayVerseStore.shared.loadHourlyVerses()
        let hourlyIsValid = (existingHourly?.isValid == true)

        // 2) 오늘 저장된 todayVerse가 있으면 재저장 금지
        let hasToday = (TodayVerseStore.shared.loadTodayVerse() != nil)

        print("🟡 [App] init. hourlyValid:", hourlyIsValid, "hasToday:", hasToday)

        // hourly가 없거나 무효면 새로 생성
        let hourly: HourlyVerses
        if hourlyIsValid, let existingHourly {
            hourly = existingHourly
        } else {
            hourly = VerseProvider.generateHourlyVerses()
            TodayVerseStore.shared.saveHourlyVerses(hourly)
            print("✅ [App] new hourly generated")
        }

        // todayVerse가 없으면 현재 시간 구절을 today로 저장
        if !hasToday, let nowVerse = hourly.verse(for: Date()) {
            TodayVerseStore.shared.saveTodayVerse(nowVerse)
            print("✅ [App] todayVerse saved:", nowVerse.reference)
        }

        // 항상 위젯 타임라인 갱신 (앱과 위젯 동기화 보장)
        WidgetCenter.shared.reloadTimelines(ofKind: "BibleVerseWidgetExtension")
        print("✅ [App] reloadTimelines called")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
