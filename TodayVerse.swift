//
//  TodayVerse.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//

import Foundation

/// 단일 구절 정보
struct TodayVerse: Codable, Identifiable {
    let id: String              // "Gen.1.1"
    let book: String            // "Gen"
    let book_kor_full: String   // "창세기"
    let chapter: Int            // 1
    let verse: Int              // 1

    let reference: String       // "창1:1"
    let text: String            // 본문
}
