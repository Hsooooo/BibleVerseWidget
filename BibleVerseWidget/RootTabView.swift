//
//  RootTabView.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            TodayTabView()
                .tabItem {
                    Label("오늘", systemImage: "sun.max")
                }

            ExploreTabView()
                .tabItem {
                    Label("탐색", systemImage: "book")
                }

            FavoritesTabView()
                .tabItem {
                    Label("즐겨찾기", systemImage: "star")
                }
        }
    }
}

