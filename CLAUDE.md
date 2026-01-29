# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Open `BibleVerseWidget.xcodeproj` in Xcode and build directly. No external dependencies or package managers.

**Widget Testing:** Select the `BibleVerseWidgetExtension` scheme to test the widget.

**Widget Refresh:** After data changes, call `WidgetCenter.shared.reloadAllTimelines()` to update widgets immediately.

## Architecture

### Data Flow
```
App Launch → VerseProvider generates 24 hourly verses
                    ↓
        TodayVerseStore saves to App Group UserDefaults
                    ↓
        Widget Timeline loads from TodayVerseStore → Display
```

### Target Structure
- **BibleVerseWidget**: Main app - verse selection, browsing, favorites
- **BibleVerseWidgetExtension**: Widget - displays stored verse only (no generation logic)

### File Location Rules
| Type | Location | Included In |
|------|----------|-------------|
| Shared models (`Verse.swift`, `TodayVerse.swift`, `TodayVerseStore.swift`) | Root | Both targets |
| App logic (`BibleRepository`, `VerseProvider`, Views) | `BibleVerseWidget/` | App only |
| Widget logic | `BibleVerseWidgetExtension/` | Widget only |
| Bible JSON files (66 books) | `BibleVerseWidget/resource/` | App only |

### Key Singletons
- `BibleRepository.shared` - Loads and caches verses from JSON files
- `TodayVerseStore.shared` - App Group data sharing between app and widget
- `FavoriteStore.shared` - Favorites management

### App Group
App-widget communication uses `group.hs.lee.BibleVerseWidget`:
```swift
UserDefaults(suiteName: "group.hs.lee.BibleVerseWidget")
```

### Data Models
- `Verse` - Full verse with all metadata (31,102 total across 66 books)
- `TodayVerse` - Lightweight model for widget display
- `HourlyVerses` - 24-verse cache with same-day validation

### Widget Families
5 supported sizes in `BibleVerseWidgetExtension.swift`:
- Home screen: `.systemSmall`, `.systemMedium`
- Lock screen: `.accessoryInline`, `.accessoryCircular`, `.accessoryRectangular`

## Bible Data Organization

Books organized by Testament and section in `BibleBookSections.swift`:
- 구약 (OT): 오경, 역사서, 시가서, 대선지서, 소선지서
- 신약 (NT): 복음서+사도행전, 바울서신, 공동서신+계시록

Book codes follow standard abbreviations (Gen, Exod, Matt, Rev, etc.).

## Logging Convention
Use emoji prefixes for debug logs:
- `✅` Success, `❌` Failure, `ℹ️` Info, `🟡` Init, `🟢🔴` State
