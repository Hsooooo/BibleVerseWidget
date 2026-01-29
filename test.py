import json
import os
from collections import defaultdict

INPUT = "bible_structured.json"      # 기존 한 파일 (전체 구절 배열)
OUT_DIR = "out/Bible"                # 권별 JSON 저장 폴더
INDEX_OUT = "out/bible_index.json"   # 메타 인덱스

os.makedirs(OUT_DIR, exist_ok=True)

with open(INPUT, "r", encoding="utf-8") as f:
    verses = json.load(f)

# book별 분리
by_book = defaultdict(list)
index = []

for v in verses:
    # v는 네 구조 그대로라고 가정:
    # id, book, book_eng_full, book_kor, book_kor_full, chapter, verse, reference, text
    book = v["book"]
    by_book[book].append(v)

    # 전체 랜덤 풀용 메타 (가볍게)
    index.append({
        "id": v["id"],
        "book": v["book"],
        "chapter": v["chapter"],
        "verse": v["verse"]
    })

# 각 권 정렬 + 저장
for book, arr in by_book.items():
    arr.sort(key=lambda x: (x["chapter"], x["verse"]))
    out_path = os.path.join(OUT_DIR, f"{book}.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(arr, f, ensure_ascii=False, separators=(",", ":"))

# 인덱스 저장
with open(INDEX_OUT, "w", encoding="utf-8") as f:
    json.dump(index, f, ensure_ascii=False, separators=(",", ":"))

print("DONE")
print("books:", len(by_book))
print("verses:", len(verses))
print("index:", len(index))
print("out:", os.path.abspath("out"))

