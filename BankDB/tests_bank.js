// ЛР №13, вариант 13 - команды тестирования.
// Каждую группу выполняйте в ОТДЕЛЬНОМ окне mongosh.
// При подключении введите пароль интерактивно. Не вставляйте пароль в команду.

// Подключение viewer:
// mongosh --host 127.0.0.1 --port 27017 --authenticationDatabase bank_lab13 -u viewer13 -p
use bank_lab13
db.accounts.findOne({ accountId: 2001 })                 // РАЗРЕШЕНО
db.accounts.insertOne({ accountId: 2099, owner: "Тест" }) // ЗАПРЕЩЕНО: ожидается Unauthorized
db.transactions.findOne({ txId: 5001 })                   // ЗАПРЕЩЕНО: ожидается Unauthorized

// Подключение editor (новое окно):
// mongosh --host 127.0.0.1 --port 27017 --authenticationDatabase bank_lab13 -u editor13 -p
use bank_lab13
db.accounts.findOne({ accountId: 2001 })                 // РАЗРЕШЕНО
db.accounts.insertOne({ accountId: 2099, owner: "Тест редактора", type: "current", currency: "KZT", status: "active" }) // РАЗРЕШЕНО
db.transactions.findOne({ txId: 5001 })                   // ЗАПРЕЩЕНО: ожидается Unauthorized
db.audit_events.findOne({ eventId: 1 })                   // ЗАПРЕЩЕНО: ожидается Unauthorized

// Подключение auditor (новое окно):
// mongosh --host 127.0.0.1 --port 27017 --authenticationDatabase bank_lab13 -u auditor13 -p
use bank_lab13
db.audit_events.findOne({ eventId: 1 })                   // РАЗРЕШЕНО
db.audit_events.insertOne({ eventId: 99, event: "forbidden_test" }) // ЗАПРЕЩЕНО: ожидается Unauthorized
db.accounts.findOne({ accountId: 2001 })                 // ЗАПРЕЩЕНО: ожидается Unauthorized

// Проверка минимальных привилегий (выполнить под администратором):
// use bank_lab13
// db.getRole("bankViewer", { showPrivileges: true })
// db.getRole("bankEditor", { showPrivileges: true })
// db.getRole("bankAuditor", { showPrivileges: true })
// Убедитесь, что каждый privilege.resource указывает ровно на одну коллекцию,
// а не на { db: "bank_lab13", collection: "" } и не на { db: "bank_lab13", collection: "*" }.
