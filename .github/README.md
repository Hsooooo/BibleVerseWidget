# BibleVerseWidget - AI Coding Instructions

## 프로젝트 개요
iOS 홈화면/잠금화면 위젯으로 매일 랜덤한 성경 구절을 표시하는 SwiftUI 앱입니다.

## 아키텍처

### 핵심 데이터 흐름
```
앱 실행 → VerseProvider.dailyVerse() → BibleRepository(bible.json)
                    ↓
        TodayVerseStore.save() → App Group UserDefaults
                    ↓
        Widget Timeline → TodayVerseStore.load() → 위젯 표시
```

### 주요 컴포넌트
| 컴포넌트 | 역할 | 위치 |
|---------|------|------|
| `BibleRepository` | bible.json에서 31,102개 구절 로드 (싱글톤) | `BibleVerseWidget/` |
| `VerseProvider` | 60일 중복 방지 로직으로 오늘의 구절 선택 | `BibleVerseWidget/` |
| `TodayVerseStore` | App Group으로 앱↔위젯 데이터 공유 | 루트 |
| `VerseHistoryStore` | 날짜별 구절 히스토리 관리 (앱 전용) | 루트 |

### 타겟 구조
- **BibleVerseWidget**: 메인 앱 (구절 선택 및 저장)
- **BibleVerseWidgetExtension**: 위젯 (저장된 구절 표시만 담당)

## 핵심 패턴

### App Group 데이터 공유
앱과 위젯 간 통신은 반드시 `group.hs.lee.BibleVerseWidget` App Group을 통해야 합니다:
```swift
// TodayVerseStore.swift 참고
UserDefaults(suiteName: "group.hs.lee.BibleVerseWidget")
```

### 모델 구조
- `Verse`: 전체 성경 구절 (31,102개, bible.json 기반)
- `TodayVerse`: 위젯 표시용 경량 모델 (reference + text만)

### 위젯 패밀리 지원
`BibleVerseWidgetExtension.swift`에서 5가지 위젯 크기 지원:
- 홈화면: `.systemSmall`, `.systemMedium`
- 잠금화면: `.accessoryInline`, `.accessoryCircular`, `.accessoryRectangular`

## 개발 시 주의사항

### 파일 위치 규칙
- **공유 모델/스토어** (`Verse.swift`, `TodayVerse.swift`, `TodayVerseStore.swift`): 루트에 위치, 양쪽 타겟에 포함
- **앱 전용 로직** (`BibleRepository`, `VerseProvider`): `BibleVerseWidget/` 폴더
- **위젯 전용** (`BibleVerseWidgetExtension.swift`): `BibleVerseWidgetExtension/` 폴더

### 위젯 갱신 정책
타임라인은 자정에 갱신 (`.after(nextUpdate)` 정책). 즉시 갱신이 필요하면:
```swift
WidgetCenter.shared.reloadAllTimelines()
```

### 디버깅 로그
모든 주요 작업에 이모지 prefix 로그 패턴 사용:
- `✅` 성공, `❌` 실패, `ℹ️` 정보, `🟡` 초기화, `🟢🔴` 상태

## 빌드 및 실행
Xcode에서 직접 빌드. 위젯 테스트 시 Extension 스킴 선택 필요.
