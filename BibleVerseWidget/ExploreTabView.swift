//
//  ExploreTabView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import SwiftUI

struct ExploreTabView: View {
    var body: some View {
        NavigationStack {
            BookListView()
                .navigationTitle("탐색")
        }
    }
}

