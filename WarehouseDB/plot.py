
import matplotlib.pyplot as plt
import numpy as np

strategies = [
    "warehouseId",
    "hashed_item",
    "range_event",
    "composite_item_day"
]

shard_a = [28219, 9759, 11466, 10051]
shard_b = [1169, 9390, 11503, 9891]
shard_c = [612, 10851, 7031, 10058]

x = np.arange(len(strategies))
width = 0.25

plt.figure(figsize=(11, 6))

plt.bar(x - width, shard_a, width, label="Shard A")
plt.bar(x, shard_b, width, label="Shard B")
plt.bar(x + width, shard_c, width, label="Shard C")

plt.xlabel("Sharding strategy")
plt.ylabel("Number of requests")
plt.title("Request distribution (80% warehouse, hot load)")

plt.xticks(x, strategies, rotation=15)
plt.legend()
plt.grid(axis="y", linestyle="--", alpha=0.5)

plt.tight_layout()
plt.savefig("sharding_results.png", dpi=300)
plt.show()
