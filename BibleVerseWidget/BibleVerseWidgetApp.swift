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
            let hourly = VerseProvider.generateHourlyVerses()
            TodayVerseStore.shared.saveHourlyVerses(hourly)
        }

        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
}
