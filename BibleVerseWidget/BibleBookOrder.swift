//
//  BibleBookOrder.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//

import Foundation

enum BibleBookOrder {

    /// ✅ 네 bible_structured.json 기준 실제 book 코드 + 정경 순서
    static let order: [String] = [
        // 오경
        "Gen","Exod","Lev","Num","Deut",

        // 역사서
        "Josh","Judg","Ruth",
        "1Sam","2Sam","1Kgs","2Kgs",
        "1Chr","2Chr","Ezra","Neh","Esth",

        // 시가서
        "Job","Ps","Prov","Eccl","Song",

        // 대선지서
        "Isa","Jer","Lam","Ezek","Dan",

        // 소선지서
        "Hos","Joel","Amos","Obad","Jonah","Mic",
        "Nah","Hab","Zeph","Hag","Zech","Mal",

        // 복음서 + 사도행전
        "Matt","Mark","Luke","John","Acts",

        // 바울서신
        "Rom","1Cor","2Cor","Gal","Eph","Phil","Col",
        "1Thess","2Thess","1Tim","2Tim","Titus","Phlm",

        // 공동서신 + 요한계시록
        "Heb","Jas","1Pet","2Pet",
        "1John","2John","3John","Jude","Rev"
    ]
}
