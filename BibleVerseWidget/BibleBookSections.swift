//
//  BibleBookSections.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/15/25.
//

import Foundation

struct BibleBookSection: Identifiable {
    let id = UUID()
    let testamentTitle: String   // "구약" / "신약"
    let sectionTitle: String     // "오경" 등
    let bookCodes: [String]      // JSON의 book 코드들
}

enum BibleBookSections {

    // ✅ 네 JSON book 코드 기준
    static let all: [BibleBookSection] = [

        // ===== 구약 =====
        BibleBookSection(testamentTitle: "구약", sectionTitle: "오경",
                         bookCodes: ["Gen","Exod","Lev","Num","Deut"]),

        BibleBookSection(testamentTitle: "구약", sectionTitle: "역사서",
                         bookCodes: ["Josh","Judg","Ruth","1Sam","2Sam","1Kgs","2Kgs","1Chr","2Chr","Ezra","Neh","Esth"]),

        BibleBookSection(testamentTitle: "구약", sectionTitle: "시가서",
                         bookCodes: ["Job","Ps","Prov","Eccl","Song"]),

        BibleBookSection(testamentTitle: "구약", sectionTitle: "대선지서",
                         bookCodes: ["Isa","Jer","Lam","Ezek","Dan"]),

        BibleBookSection(testamentTitle: "구약", sectionTitle: "소선지서",
                         bookCodes: ["Hos","Joel","Amos","Obad","Jonah","Mic","Nah","Hab","Zeph","Hag","Zech","Mal"]),

        // ===== 신약 =====
        BibleBookSection(testamentTitle: "신약", sectionTitle: "복음서 + 사도행전",
                         bookCodes: ["Matt","Mark","Luke","John","Acts"]),

        BibleBookSection(testamentTitle: "신약", sectionTitle: "바울서신",
                         bookCodes: ["Rom","1Cor","2Cor","Gal","Eph","Phil","Col","1Thess","2Thess","1Tim","2Tim","Titus","Phlm"]),

        BibleBookSection(testamentTitle: "신약", sectionTitle: "공동서신 + 요한계시록",
                         bookCodes: ["Heb","Jas","1Pet","2Pet","1John","2John","3John","Jude","Rev"])
    ]
}
