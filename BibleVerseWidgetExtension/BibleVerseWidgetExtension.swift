//
//  BibleVerseWidgetExtension.swift
//  BibleVerseWidgetExtension
//
//  Created by 이한수 on 12/6/25.
//

import WidgetKit
import SwiftUI

// MARK: - Entry

/// 위젯이 표시할 데이터 1건
struct VerseEntry: TimelineEntry {
    let date: Date
    let verse: TodayVerse?   // App Group에서 읽어온 오늘의 말씀
}

// MARK: - Timeline Provider

struct Provider: TimelineProvider {
    /// 위젯 갤러리에서 보이는 샘플
    func placeholder(in context: Context) -> VerseEntry {
        let sample = TodayVerse(
            reference: "창1:1",
            text: "태초에 하나님이 천지를 창조하시니라"
        )
        return VerseEntry(date: Date(), verse: sample)
    }

    /// 위젯 스냅샷 (빠른 미리보기용)
    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> ()) {
        let verse = TodayVerseStore.shared.currentVerseOrDefault()
        let entry = VerseEntry(date: Date(), verse: verse)
        completion(entry)
    }

    /// 실제 타임라인 구성
    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> ()) {
        let currentDate = Date()
        let calendar = Calendar.current

        // 디버깅: hourlyVerses 로드 상태 확인
        if let hourly = TodayVerseStore.shared.loadHourlyVerses() {
            print("✅ [Widget] hourlyVerses loaded, valid:", hourly.isValid, "startHour:", hourly.startHour)
        } else {
            print("❌ [Widget] hourlyVerses is nil!")
        }

        // 현재 시간의 구절 로드
        let verse = TodayVerseStore.shared.currentVerseOrDefault()
        let entry = VerseEntry(date: currentDate, verse: verse)

        // 매시간 정각에 새로고침 (다음 시간 00분)
        var nextUpdate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        nextUpdate = calendar.date(bySetting: .minute, value: 0, of: nextUpdate) ?? nextUpdate
        nextUpdate = calendar.date(bySetting: .second, value: 0, of: nextUpdate) ?? nextUpdate

        print("ℹ️ [Widget] Current verse:", verse.reference, "next update at:", nextUpdate)

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - View

struct BibleVerseWidgetExtensionEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: VerseEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            inlineView
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        default:
            homeScreenView
        }
    }

    // 잠금화면 - 시계 위 한 줄
    private var inlineView: some View {
        Group {
            if let verse = entry.verse {
                Text(verse.reference)
            } else {
                Text("앱을 실행해 주세요")
            }
        }
    }

    // 잠금화면 - 동그라미
    private var circularView: some View {
        ZStack {
            if let verse = entry.verse {
                // "창1:1"에서 "1:1"만 보여주기
                let parts = verse.reference.split(separator: ":", maxSplits: 1)
                Text(parts.last.map(String.init) ?? "")
                    .font(.system(size: 10, weight: .bold))
                    .minimumScaleFactor(0.5)
            } else {
                Text("…")
                    .font(.system(size: 10, weight: .bold))
            }
        }
    }

    // 잠금화면 - 직사각형
    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let verse = entry.verse {
                Text(verse.reference)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)

                Text(verse.text)
                    .font(.caption2)
                    .lineLimit(2)
            } else {
                Text("앱을 실행하면\n말씀이 보입니다.")
                    .font(.caption2)
            }
        }
    }

    // 홈 화면 위젯(systemSmall / systemMedium)
    private var homeScreenView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let verse = entry.verse {
                Text(verse.reference)
                    .font(.headline)
                    .lineLimit(1)

                Text(verse.text)
                    .font(.caption)
                    .lineLimit(3)
            } else {
                Text("앱을 실행하면\n말씀이 보입니다.")
                    .font(.caption2)
            }
        }
        .padding()
    }
}

// MARK: - Widget 정의

struct BibleVerseWidgetExtension: Widget {
    let kind: String = "BibleVerseWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BibleVerseWidgetExtensionEntryView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("성경 말씀 위젯")
        .description("매일 새로운 성경 구절을 보여줍니다.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    BibleVerseWidgetExtension()
} timeline: {
    VerseEntry(
        date: .now,
        verse: TodayVerse(
            reference: "시23:1",
            text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
        )
    )
}

