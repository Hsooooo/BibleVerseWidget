//
//  Verse.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//
struct Verse: Identifiable, Hashable, Codable {
    let id: String              // "Gen.1.1"
    let book: String            // "Gen"
    let bookEngFull: String     // "Genesis"
    let bookKor: String         // "창"
    let bookKorFull: String     // "창세기"
    let chapter: Int            // 1
    let verse: Int              // 1
    let reference: String       // "창1:1"
    let text: String            // 본문

    enum CodingKeys: String, CodingKey {
        case id
        case book
        case bookEngFull = "book_eng_full"
        case bookKor = "book_kor"
        case bookKorFull = "book_kor_full"
        case chapter
        case verse
        case reference
        case text
    }
}
