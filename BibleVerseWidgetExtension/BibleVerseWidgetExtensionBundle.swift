//
//  BibleVerseWidgetExtensionBundle.swift
//  BibleVerseWidgetExtension
//
//  Created by 이한수 on 12/6/25.
//

import WidgetKit
import SwiftUI

@main
struct BibleVerseWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        BibleVerseWidgetExtension()
        BibleVerseWidgetExtensionControl()
        BibleVerseWidgetExtensionLiveActivity()
    }
}
