// ЛР №13, вариант 13 - Банк (макет)
// Запускать ОДИН РАЗ из mongosh под администратором.
// Пароли вводятся интерактивно и в файл не записываются.

const lab = db.getSiblingDB("bank_lab13");

// Коллекции варианта:
// accounts     — рабочая коллекция
// transactions — защищённая коллекция
// audit_events — отдельный журнал для аудитора

lab.createCollection("accounts");
lab.createCollection("transactions");
lab.createCollection("audit_events");

// 10 синтетических счетов
lab.accounts.insertMany([
  { accountId: 2001, owner: "Клиент А", type: "current", currency: "KZT", status: "active" },
  { accountId: 2002, owner: "Клиент Б", type: "savings", currency: "KZT", status: "active" },
  { accountId: 2003, owner: "Клиент В", type: "current", currency: "USD", status: "active" },
  { accountId: 2004, owner: "Клиент Г", type: "deposit", currency: "KZT", status: "frozen" },
  { accountId: 2005, owner: "Клиент Д", type: "current", currency: "EUR", status: "active" },
  { accountId: 2006, owner: "Клиент Е", type: "savings", currency: "KZT", status: "active" },
  { accountId: 2007, owner: "Клиент Ж", type: "current", currency: "KZT", status: "closed" },
  { accountId: 2008, owner: "Клиент З", type: "deposit", currency: "USD", status: "active" },
  { accountId: 2009, owner: "Клиент И", type: "current", currency: "KZT", status: "active" },
  { accountId: 2010, owner: "Клиент К", type: "savings", currency: "EUR", status: "active" }
]);

// 10 синтетических транзакций. Роли viewer/editor/auditor не должны иметь к ним доступа.
lab.transactions.insertMany([
  { txId: 5001, accountId: 2001, amount: 150000, direction: "credit", status: "completed" },
  { txId: 5002, accountId: 2001, amount: 25000, direction: "debit", status: "completed" },
  { txId: 5003, accountId: 2002, amount: 500000, direction: "credit", status: "completed" },
  { txId: 5004, accountId: 2003, amount: 1200, direction: "debit", status: "pending" },
  { txId: 5005, accountId: 2004, amount: 75000, direction: "credit", status: "rejected" },
  { txId: 5006, accountId: 2005, amount: 450, direction: "debit", status: "completed" },
  { txId: 5007, accountId: 2006, amount: 320000, direction: "credit", status: "completed" },
  { txId: 5008, accountId: 2008, amount: 2000, direction: "credit", status: "completed" },
  { txId: 5009, accountId: 2009, amount: 18500, direction: "debit", status: "completed" },
  { txId: 5010, accountId: 2010, amount: 900, direction: "debit", status: "pending" }
]);

// Журнал аудита: синтетические записи
lab.audit_events.insertMany([
  { eventId: 1, event: "database_created", source: "lab_setup", level: "info" },
  { eventId: 2, event: "accounts_seeded", source: "lab_setup", level: "info" },
  { eventId: 3, event: "transactions_seeded", source: "lab_setup", level: "info" }
]);

// Пользовательские роли: права выданы только на конкретные коллекции.
lab.createRole({
  role: "bankViewer",
  privileges: [
    { resource: { db: "bank_lab13", collection: "accounts" }, actions: ["find"] }
  ],
  roles: []
});

lab.createRole({
  role: "bankEditor",
  privileges: [
    { resource: { db: "bank_lab13", collection: "accounts" },
      actions: ["find", "insert", "update", "remove"] }
  ],
  roles: []
});

lab.createRole({
  role: "bankAuditor",
  privileges: [
    { resource: { db: "bank_lab13", collection: "audit_events" }, actions: ["find"] }
  ],
  roles: []
});

// Создание пользователей. Введите три разных учебных пароля при запросе.
lab.createUser({
  user: "viewer13",
  pwd: passwordPrompt(),
  roles: [{ role: "bankViewer", db: "bank_lab13" }]
});

lab.createUser({
  user: "editor13",
  pwd: passwordPrompt(),
  roles: [{ role: "bankEditor", db: "bank_lab13" }]
});

lab.createUser({
  user: "auditor13",
  pwd: passwordPrompt(),
  roles: [{ role: "bankAuditor", db: "bank_lab13" }]
});

print("Готово: база bank_lab13, коллекции, данные, роли и пользователи созданы.");
print("Проверьте количество документов:");
print("accounts = " + lab.accounts.countDocuments());
print("transactions = " + lab.transactions.countDocuments());
print("audit_events = " + lab.audit_events.countDocuments());
