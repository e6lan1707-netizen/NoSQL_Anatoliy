
from pymongo import MongoClient
import random

random.seed(42)

client = MongoClient(
    "mongodb://localhost:27017",
    serverSelectionTimeoutMS=3000
)

client.admin.command("ping")

db = client["nosql_lab12"]
collection = db["books"]

collection.drop()

books = []

for i in range(5000):
    book = {
        "categoryId": random.randint(1, 20),
        "publishedYear": random.randint(1950, 2026),
        "title": f"Book {i + 1}",
        "authorId": random.randint(1, 300),
        "pages": random.randint(100, 1000)
    }

    books.append(book)

collection.insert_many(books)

print("База данных:", db.name)
print("Коллекция:", collection.name)
print("Количество книг:", collection.count_documents({}))

client.close()
