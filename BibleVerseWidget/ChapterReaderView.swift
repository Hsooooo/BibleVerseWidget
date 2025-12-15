//
//  ChapterReaderView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import SwiftUI

struct ChapterReaderView: View {
    @State private var isFavoriteToday: Bool = false
    let today: TodayVerse
    let verses: [Verse]
    let highlightVerseId: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    headerCard

                    VStack(spacing: 10) {
                        ForEach(verses, id: \.id) { v in
                            VerseRow(
                                verse: v,
                                isHighlighted: v.id == highlightVerseId
                            )
                            .id(v.id)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("\(today.book_kor_full) \(today.chapter)장")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // ✅ 강조 구절로 자동 스크롤
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        proxy.scrollTo(highlightVerseId, anchor: .center) // ✅ 변경
                    }
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("지금의 말씀")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    copyCurrentVerse()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.callout)
                }
                Button {
                    FavoriteStore.shared.toggle(today.id)
                    isFavoriteToday = FavoriteStore.shared.isFavorite(today.id)
                } label: {
                    Image(systemName: isFavoriteToday ? "star.fill" : "star")
                            .foregroundStyle(isFavoriteToday ? .yellow : .primary)
                }
            }

            Text(today.reference)
                .font(.headline)

            Text(today.text)
                .font(.callout)
                .foregroundStyle(.primary)
                .lineSpacing(2)
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.35), lineWidth: 1)
        ).onAppear {
            isFavoriteToday = FavoriteStore.shared.isFavorite(today.id)
        }
    }
    private func copyCurrentVerse() {
        let copyText = """
        \(today.book_kor_full) \(today.chapter):\(today.verse)
        \(today.text)
        """
        UIPasteboard.general.string = copyText
    }

}

private struct VerseRow: View {
    let verse: Verse
    let isHighlighted: Bool

    private var isFavorite: Bool {
        FavoriteStore.shared.isFavorite(verse.id)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(verse.verse)")
                .font(.caption)
                .foregroundStyle(isHighlighted ? .primary : .secondary)
                .frame(width: 26, alignment: .trailing)

            Text(verse.text)
                .font(.callout)
                .foregroundStyle(.primary)
                .lineSpacing(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(border)
        .contextMenu {
            Button {
                copyVerse()
            } label: {
                Label("복사", systemImage: "doc.on.doc")
            }

            Button {
                FavoriteStore.shared.toggle(verse.id)
            } label: {
                Label(
                    isFavorite ? "즐겨찾기 해제" : "즐겨찾기",
                    systemImage: isFavorite ? "star.slash" : "star"
                )
            }
        }
    }

    // MARK: - UI Helpers

    private var backgroundColor: Color {
        if isHighlighted {
            return Color.yellow.opacity(0.22)      // 오늘의 말씀
        }
        if isFavorite {
            return Color.orange.opacity(0.15)     // 즐겨찾기 강조
        }
        return Color(.secondarySystemGroupedBackground)
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .strokeBorder(
                isHighlighted
                    ? Color.yellow.opacity(0.55)
                    : isFavorite
                        ? Color.orange.opacity(0.45)
                        : Color(.separator).opacity(0.18),
                lineWidth: 1
            )
    }

    // MARK: - Actions

    private func copyVerse() {
        let text = """
        \(verse.bookKorFull) \(verse.chapter):\(verse.verse)
        \(verse.text)
        """
        UIPasteboard.general.string = text
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
