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
        // 기존 캐시 확인 - 유효하면 재사용
        if let existing = TodayVerseStore.shared.loadHourlyVerses(), existing.isValid {
            print("ℹ️ [App] Using existing hourly verses cache")
        } else {
            // 24시간 구절 생성 및 저장
            let hourlyVerses = VerseProvider.generateHourlyVerses()
            TodayVerseStore.shared.saveHourlyVerses(hourlyVerses)
            print("✅ [App] Generated and saved 24 hourly verses")
        }
        
        // 위젯 타임라인 갱신
        WidgetCenter.shared.reloadAllTimelines()
        print("✅ [App] Reloaded widget timelines")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
