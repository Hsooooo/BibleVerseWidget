//
//  Verse.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/6/25.
//
struct Verse: Identifiable, Hashable, Codable {
    let id: String
    let book: String
    let bookEngFull: String
    let bookKor: String
    let bookKorFull: String
    let chapter: Int
    let verse: Int
    let reference: String
    let text: String

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
