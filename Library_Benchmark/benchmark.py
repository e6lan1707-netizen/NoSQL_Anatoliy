
from pymongo import MongoClient
from concurrent.futures import ThreadPoolExecutor
from time import perf_counter
import math
import csv
import os
import sys

client = MongoClient(
    "mongodb://localhost:27017",
    serverSelectionTimeoutMS=3000
)

client.admin.command("ping")

db = client["nosql_lab12"]
collection = db["books"]

QUERY = {
    "categoryId": 10,
    "publishedYear": 2000
}

WORKERS = [1, 4, 8]
REPEATS = 3
REQUESTS = 400
WARMUP = 40

MODE = sys.argv[1] if len(sys.argv) > 1 else "without_index"


def one():
    start = perf_counter()

    try:
        list(collection.find(QUERY).limit(100))
        return (perf_counter() - start) * 1000, True

    except Exception as error:
        print("Ошибка запроса:", error)
        return (perf_counter() - start) * 1000, False


def percentile(values, p):
    values = sorted(values)

    if not values:
        return float("nan")

    index = (len(values) - 1) * p / 100
    low = math.floor(index)
    high = math.ceil(index)

    return values[low] + (
        values[high] - values[low]
    ) * (index - low)


def run(workers):
    for _ in range(WARMUP):
        one()

    start = perf_counter()

    with ThreadPoolExecutor(max_workers=workers) as pool:
        results = list(
            pool.map(lambda _: one(), range(REQUESTS))
        )

    duration = perf_counter() - start

    latencies = [
        ms for ms, success in results if success
    ]

    success = len(latencies)
    errors = REQUESTS - success

    return {
        "mode": MODE,
        "workers": workers,
        "success": success,
        "errors": errors,
        "duration": round(duration, 4),
        "rps": round(success / duration, 2),
        "p50": round(percentile(latencies, 50), 3),
        "p95": round(percentile(latencies, 95), 3),
        "p99": round(percentile(latencies, 99), 3)
    }


results_file = "results.csv"

file_exists = os.path.exists(results_file)

with open(results_file, "a", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(
        file,
        fieldnames=[
            "mode", "workers", "repeat",
            "success", "errors", "duration",
            "rps", "p50", "p95", "p99"
        ]
    )

    if not file_exists:
        writer.writeheader()

    for workers in WORKERS:
        for repeat in range(1, REPEATS + 1):
            result = run(workers)
            result["repeat"] = repeat

            writer.writerow(result)
            file.flush()

            print(
                f"{MODE} | "
                f"Клиенты: {workers} | "
                f"Повтор: {repeat} | "
                f"RPS: {result['rps']} | "
                f"P95: {result['p95']} ms | "
                f"Ошибки: {result['errors']}"
            )

print("\nЭксперимент завершён!")
print("Результаты сохранены в", results_file)

client.close()
