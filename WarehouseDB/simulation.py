
import random
import hashlib
from collections import Counter

# случайные значения
random.seed(42)

# параметры эксперимента
N = 12000
Q = 30000
SHARDS = 3

# документы
rows = [
    {
        "itemId": i % 2500,
        "warehouseId": i % 5,
        "event_id": i
    }
    for i in range(N)
]

# 80% товаров на одном складе
rows_80 = []

for i in range(N):
    if i < int(N * 0.8):
        warehouse = 0
    else:
        warehouse = ((i - int(N * 0.8)) % 4) + 1

    rows_80.append({
        "itemId": i % 2500,
        "warehouseId": warehouse,
        "event_id": i
    })

# хеширование идентификатора товара
def stable_hash(value):
    digest = hashlib.sha256(str(value).encode()).digest()
    return int.from_bytes(digest[:8], "big")


# низкокардинальный ключ warehouseId
def low_card(row):
    return row["warehouseId"] % SHARDS


# хеширование itemId
def hashed_item(row):
    return stable_hash(row["itemId"]) % SHARDS


# составной ключ itemId + day_bucket
def hashed_composite(row):
    day_bucket = row["event_id"] // 1000

    composite_key = (
        f"{row['itemId']}:{day_bucket}"
    )

    return stable_hash(composite_key) % SHARDS


# диапазонное распределение event_id
def range_event(row):
    return min(
        row["event_id"] // (N // SHARDS),
        SHARDS - 1
    )


# анализ распределения
def describe(name, assign, requests):
    docs = Counter(assign(r) for r in rows)
    load = Counter(assign(r) for r in requests)

    d = [docs[i] for i in range(SHARDS)]
    q = [load[i] for i in range(SHARDS)]

    print(
        name,
        "docs=", d,
        "queries=", q,
        "doc_max_mean=", round(max(d) / (sum(d) / SHARDS), 2),
        "query_max_mean=", round(max(q) / (sum(q) / SHARDS), 2)
    )


# равномерная нагрузка
uniform = random.choices(rows, k=Q)

# повышенная нагрузка
hot_rows = [
    r for r in rows
    if r["warehouseId"] == 0
]

hot = [
    random.choice(hot_rows)
    if random.random() < 0.6
    else random.choice(rows)
    for _ in range(Q)
]


# запуск всех экспериментов
for name, fn in [
    ("warehouseId", low_card),
    ("hashed_item", hashed_item),
    ("range_event", range_event),
    ("composite_item_day", hashed_composite)
]:
    describe(name + "/uniform", fn, uniform)
    describe(name + "/hot", fn, hot)


# дополнительный эксперимент

print("\n--- EXPERIMENT: 80% WAREHOUSE ---")

def describe_80(name, assign, requests):
    docs = Counter(assign(r) for r in rows_80)
    load = Counter(assign(r) for r in requests)

    d = [docs[i] for i in range(SHARDS)]
    q = [load[i] for i in range(SHARDS)]

    print(
        name,
        "docs=", d,
        "queries=", q,
        "doc_max_mean=", round(max(d) / (sum(d) / SHARDS), 2),
        "query_max_mean=", round(max(q) / (sum(q) / SHARDS), 2)
    )


uniform_80 = random.choices(rows_80, k=Q)

hot_80_rows = [
    r for r in rows_80
    if r["warehouseId"] == 0
]

hot_80 = [
    random.choice(hot_80_rows)
    if random.random() < 0.6
    else random.choice(rows_80)
    for _ in range(Q)
]

for name, fn in [
    ("warehouseId", low_card),
    ("hashed_item", hashed_item),
    ("range_event", range_event),
    ("composite_item_day", hashed_composite)
]:
    describe_80(name + "/uniform_80", fn, uniform_80)
    describe_80(name + "/hot_80", fn, hot_80)
