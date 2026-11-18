import pandas as pd
import matplotlib.pyplot as plt
import os

columns = [
    "mode",
    "workers",
    "run",
    "requests",
    "errors",
    "duration",
    "rps",
    "p50",
    "p95",
    "p99"
]

df = pd.read_csv("results.csv", header=None, names=columns)

os.makedirs("charts", exist_ok=True)

print("Загруженные результаты:")
print(df.to_string(index=False))

summary = df.groupby(
    ["mode", "workers"]
).agg({
    "p95": "median",
    "rps": "median"
}).reset_index()

print("\nСводная таблица:")
print(summary.to_string(index=False))

labels = {
    "without_index": "Без индекса",
    "with_index": "С индексом"
}

colors = {
    "without_index": "tomato",
    "with_index": "steelblue"
}

plt.figure(figsize=(9, 5))

for mode in ["without_index", "with_index"]:
    data = summary[summary["mode"] == mode]

    plt.plot(
        data["workers"],
        data["p95"],
        marker="o",
        linewidth=2,
        markersize=8,
        label=labels[mode],
        color=colors[mode]
    )

plt.title("Сравнение P95 Latency")
plt.xlabel("Количество параллельных клиентов")
plt.ylabel("Время отклика (мс)")
plt.xticks([1, 4, 8])
plt.grid(True, linestyle="--", alpha=0.5)
plt.legend()
plt.tight_layout()

plt.savefig("charts/p95_comparison.png", dpi=300)
plt.show()

plt.figure(figsize=(9, 5))

for mode in ["without_index", "with_index"]:
    data = summary[summary["mode"] == mode]

    plt.plot(
        data["workers"],
        data["rps"],
        marker="o",
        linewidth=2,
        markersize=8,
        label=labels[mode],
        color=colors[mode]
    )

plt.title("Сравнение Throughput")
plt.xlabel("Количество параллельных клиентов")
plt.ylabel("Количество запросов в секунду (RPS)")
plt.xticks([1, 4, 8])
plt.grid(True, linestyle="--", alpha=0.5)
plt.legend()
plt.tight_layout()

plt.savefig("charts/throughput_comparison.png", dpi=300)
plt.show()

summary.to_csv(
    "charts/summary.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nГрафики успешно сохранены!")
print("charts/p95_comparison.png")
print("charts/throughput_comparison.png")
print("charts/summary.csv")
