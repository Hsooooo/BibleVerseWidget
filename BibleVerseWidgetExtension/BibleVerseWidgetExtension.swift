//
//  BibleVerseWidgetExtension.swift
//  BibleVerseWidgetExtension
//
//  Created by 이한수 on 12/6/25.
//

import WidgetKit
import SwiftUI

// MARK: - Entry

struct VerseEntry: TimelineEntry {
    let date: Date
    let verse: TodayVerse
}

// MARK: - Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(
            date: Date(),
            verse: TodayVerse(
                id: "Gen.1.1",
                book: "Gen",
                book_kor_full: "창세기",
                chapter: 1,
                verse: 1,
                reference: "창1:1",
                text: "태초에 하나님이 천지를 창조하시니라"
            )
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let verse = TodayVerseStore.shared.currentVerseOrDefault()
        completion(VerseEntry(date: Date(), verse: verse))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let now = Date()

        // 현재 시간 구절
        let verse = TodayVerseStore.shared.currentVerseOrDefault()
        let entry = VerseEntry(date: now, verse: verse)

        // 다음 정각에 업데이트 요청
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current

        let nextHour = cal.date(byAdding: .hour, value: 1, to: now) ?? now
        let nextUpdate = cal.date(bySettingHour: cal.component(.hour, from: nextHour), minute: 0, second: 0, of: nextHour) ?? nextHour

        // 디버그(필요 없으면 삭제)
        if let hourly = TodayVerseStore.shared.loadHourlyVerses() {
            print("✅ [Widget] hourly cache valid:", hourly.isValid, "count:", hourly.verses.count)
        } else {
            print("❌ [Widget] hourly cache is nil (run app once)")
        }
        print("ℹ️ [Widget] now:", verse.reference, "next:", nextUpdate)

        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
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

    private var inlineView: some View {
        Text(entry.verse.reference)
    }

    private var circularView: some View {
        ZStack {
            // "창1:1" -> "1:1"만
            let parts = entry.verse.reference.split(separator: ":", maxSplits: 1)
            Text(parts.last.map(String.init) ?? "")
                .font(.system(size: 10, weight: .bold))
                .minimumScaleFactor(0.5)
        }
    }

    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.verse.reference)
                .font(.caption)
                .bold()
                .lineLimit(1)

            Text(entry.verse.text)
                .font(.caption2)
                .lineLimit(2)
        }
    }

    private var homeScreenView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.verse.reference)
                .font(.headline)
                .lineLimit(1)

            Text(entry.verse.text)
                .font(.caption)
                .lineLimit(3)
        }
        .padding()
    }
}

// MARK: - Widget

struct BibleVerseWidgetExtension: Widget {
    let kind = "BibleVerseWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BibleVerseWidgetExtensionEntryView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("성경 말씀 위젯")
        .description("매시간 새로운 성경 구절을 보여줍니다.")
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
            id: "Ps.23.1",
            book: "Ps",
            book_kor_full: "시편",
            chapter: 23,
            verse: 1,
            reference: "시23:1",
            text: "여호와는 나의 목자시니 내게 부족함이 없으리로다"
        )
    )
}
