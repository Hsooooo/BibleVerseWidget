//
//  FavoriteRow.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import SwiftUI

struct FavoriteRow: View {
    let verse: Verse

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(verse.bookKorFull) \(verse.chapter):\(verse.verse)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(verse.text)
                .font(.callout)
                .lineLimit(2)
        }
        .padding(.vertical, 6)
    }
}

