//
//  FavoriteStore.swift
//  BibleVerseWidget
//
//  Created by 이한수 on 12/14/25.
//
import Foundation

final class FavoriteStore {
    static let shared = FavoriteStore()
    private let key = "favoriteVerses" // id : timestamp

    private var dict: [String: TimeInterval] {
        get {
            (UserDefaults.standard.dictionary(forKey: key) as? [String: TimeInterval]) ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    func isFavorite(_ id: String) -> Bool {
        dict[id] != nil
    }

    func toggle(_ id: String) {
        var d = dict
        if d[id] != nil {
            d.removeValue(forKey: id)
        } else {
            d[id] = Date().timeIntervalSince1970
        }
        dict = d
    }

    func allSortedByRecent() -> [String] {
        dict
            .sorted { $0.value > $1.value }   // 최근 순
            .map { $0.key }
    }
}

