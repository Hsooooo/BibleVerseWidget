//
//  FavoritesTabView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import SwiftUI

struct FavoritesTabView: View {
    @State private var favorites: [Verse] = []

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    emptyView
                } else {
                    listView
                }
            }
            .navigationTitle("즐겨찾기")
            .onAppear {
                load()
            }
        }
    }

    // MARK: - List

    private var listView: some View {
        List {
            ForEach(favorites, id: \.id) { v in
                NavigationLink {
                    ChapterReaderView(
                        today: TodayVerse(
                            id: v.id,
                            book: v.book,
                            book_kor_full: v.bookKorFull,
                            chapter: v.chapter,
                            verse: v.verse,
                            reference: v.reference,
                            text: v.text
                        ),
                        verses: BibleRepository.shared.chapter(
                            bookKorFull: v.bookKorFull,
                            chapter: v.chapter
                        ),
                        highlightVerseId: v.id
                    )
                } label: {
                    FavoriteRow(verse: v)
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Empty

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "star")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text("즐겨찾기한 말씀이 없습니다.")
                .font(.headline)

            Text("마음에 드는 구절을 길게 눌러\n즐겨찾기에 추가해 보세요.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Data

    private func load() {
        let ids = FavoriteStore.shared.allSortedByRecent()
            favorites = ids.compactMap { id in
                BibleRepository.shared.verses.first(where: { $0.id == id })
            }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { idx in
            FavoriteStore.shared.toggle(favorites[idx].id)
        }
        load()
    }
}
