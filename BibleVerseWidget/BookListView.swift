import SwiftUI

struct BookListView: View {

    var body: some View {
        List {
            // ✅ 구약
            Section {
                ForEach(BibleBookSections.all.filter { $0.testamentTitle == "구약" }) { sec in
                    Section {
                        ForEach(sec.bookCodes, id: \.self) { code in
                            if let name = BibleRepository.shared.bookKorFullByCode(code) {
                                NavigationLink(name) {
                                    ChapterListView(bookCode: code)
                                }
                            }
                        }
                    } header: {
                        MinorHeader(title: sec.sectionTitle)   // ✅ 오경/역사서... 스타일
                    }
                }
            } header: {
                MajorHeader(title: "구약")                   // ✅ 구약 스타일
            }

            // ✅ 신약
            Section {
                ForEach(BibleBookSections.all.filter { $0.testamentTitle == "신약" }) { sec in
                    Section {
                        ForEach(sec.bookCodes, id: \.self) { code in
                            if let name = BibleRepository.shared.bookKorFullByCode(code) {
                                NavigationLink(name) {
                                    ChapterListView(bookCode: code)
                                }
                            }
                        }
                    } header: {
                        MinorHeader(title: sec.sectionTitle)
                    }
                }
            } header: {
                MajorHeader(title: "신약")
            }
        }
        .listStyle(.insetGrouped)
    }

    private func bookName(code: String) -> String? {
        BibleRepository.shared.bookKorFullByCode(code)
    }
}

private struct MajorHeader: View {
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: title == "구약" ? "scroll" : "cross")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

private struct MinorHeader: View {
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            Divider().opacity(0.5)
        }
        .padding(.top, 6)
        .padding(.bottom, 2)
        .textCase(nil)
    }
}

