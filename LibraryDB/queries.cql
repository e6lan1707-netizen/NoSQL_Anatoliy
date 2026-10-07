CREATE KEYSPACE IF NOT EXISTS library_lab6
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

USE library_lab6;

DESCRIBE KEYSPACE library_lab6;

CREATE TABLE loans_by_reader (
    reader_id text,
    issue_date date,
    issue_id text,
    book_id text,
    book_title text,
    category text,
    due_date date,
    return_date date,
    status text,
    PRIMARY KEY ((reader_id), issue_date, issue_id)
) WITH CLUSTERING ORDER BY (
    issue_date DESC,
    issue_id ASC
);

CREATE TABLE loans_by_due_date (
    due_date date,
    reader_id text,
    issue_id text,
    book_id text,
    book_title text,
    category text,
    issue_date date,
    status text,
    PRIMARY KEY ((due_date), reader_id, issue_id)
) WITH CLUSTERING ORDER BY (
    reader_id ASC,
    issue_id ASC
);

CREATE TABLE loan_history_by_book (
    book_id text,
    issue_date date,
    issue_id text,
    reader_id text,
    book_title text,
    category text,
    due_date date,
    return_date date,
    status text,
    PRIMARY KEY ((book_id), issue_date, issue_id)
) WITH CLUSTERING ORDER BY (
    issue_date DESC,
    issue_id ASC
);

CREATE TABLE loans_by_period (
    period text,
    issue_date date,
    issue_id text,
    reader_id text,
    book_id text,
    book_title text,
    category text,
    due_date date,
    status text,
    PRIMARY KEY ((period), issue_date, issue_id)
) WITH CLUSTERING ORDER BY (
    issue_date ASC,
    issue_id ASC
);

CREATE TABLE active_loans_by_reader (
    reader_id text,
    due_date date,
    issue_id text,
    book_id text,
    book_title text,
    category text,
    issue_date date,
    status text,
    PRIMARY KEY ((reader_id), due_date, issue_id)
) WITH CLUSTERING ORDER BY (
    due_date ASC,
    issue_id ASC
);


INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R001','2026-09-01','L001','B001','Война и мир','Классика','2026-09-15','2026-09-14','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R001','2026-09-10','L002','B003','Мастер и Маргарита','Классика','2026-09-24','2026-09-23','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R001','2026-10-01','L003','B004','1984','Антиутопия','2026-10-15',null,'active');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R001','2026-10-03','L004','B006','Дюна','Фантастика','2026-10-17',null,'active');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R002','2026-09-02','L005','B002','Преступление и наказание','Классика','2026-09-16','2026-09-15','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R002','2026-09-12','L006','B005','Три товарища','Роман','2026-09-26','2026-09-25','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R002','2026-10-02','L007','B001','Война и мир','Классика','2026-10-16',null,'active');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R002','2026-10-04','L008','B004','1984','Антиутопия','2026-10-18',null,'active');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R003','2026-09-05','L009','B003','Мастер и Маргарита','Классика','2026-09-19','2026-09-18','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R003','2026-09-20','L010','B006','Дюна','Фантастика','2026-10-04','2026-10-03','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R003','2026-10-05','L011','B005','Три товарища','Роман','2026-10-19',null,'active');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R004','2026-09-07','L012','B001','Война и мир','Классика','2026-09-21','2026-09-20','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R004','2026-09-25','L013','B002','Преступление и наказание','Классика','2026-10-09','2026-10-08','returned');

INSERT INTO loans_by_reader
(reader_id, issue_date, issue_id, book_id, book_title, category, due_date, return_date, status)
VALUES
('R004','2026-10-06','L014','B003','Мастер и Маргарита','Классика','2026-10-20',null,'active');



INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-15','R001','L003','B004','1984','Антиутопия','2026-10-01','active');

INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-17','R001','L004','B006','Дюна','Фантастика','2026-10-03','active');

INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-16','R002','L007','B001','Война и мир','Классика','2026-10-02','active');

INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-18','R002','L008','B004','1984','Антиутопия','2026-10-04','active');

INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-19','R003','L011','B005','Три товарища','Роман','2026-10-05','active');

INSERT INTO loans_by_due_date
(due_date, reader_id, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('2026-10-20','R004','L014','B003','Мастер и Маргарита','Классика','2026-10-06','active');



INSERT INTO loan_history_by_book
(book_id, issue_date, issue_id, reader_id, book_title, category, due_date, return_date, status)
VALUES
('B001','2026-09-01','L001','R001','Война и мир','Классика','2026-09-15','2026-09-14','returned');

INSERT INTO loan_history_by_book
(book_id, issue_date, issue_id, reader_id, book_title, category, due_date, return_date, status)
VALUES
('B001','2026-09-07','L012','R004','Война и мир','Классика','2026-09-21','2026-09-20','returned');

INSERT INTO loan_history_by_book
(book_id, issue_date, issue_id, reader_id, book_title, category, due_date, return_date, status)
VALUES
('B001','2026-10-02','L007','R002','Война и мир','Классика','2026-10-16',null,'active');

INSERT INTO loan_history_by_book
(book_id, issue_date, issue_id, reader_id, book_title, category, due_date, return_date, status)
VALUES
('B004','2026-10-01','L003','R001','1984','Антиутопия','2026-10-15',null,'active');

INSERT INTO loan_history_by_book
(book_id, issue_date, issue_id, reader_id, book_title, category, due_date, return_date, status)
VALUES
('B004','2026-10-04','L008','R002','1984','Антиутопия','2026-10-18',null,'active');



INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-09','2026-09-01','L001','R001','B001','Война и мир','Классика','2026-09-15','returned');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-09','2026-09-02','L005','R002','B002','Преступление и наказание','Классика','2026-09-16','returned');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-09','2026-09-05','L009','R003','B003','Мастер и Маргарита','Классика','2026-09-19','returned');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-09','2026-09-07','L012','R004','B001','Война и мир','Классика','2026-09-21','returned');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-01','L003','R001','B004','1984','Антиутопия','2026-10-15','active');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-02','L007','R002','B001','Война и мир','Классика','2026-10-16','active');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-03','L004','R001','B006','Дюна','Фантастика','2026-10-17','active');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-04','L008','R002','B004','1984','Антиутопия','2026-10-18','active');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-05','L011','R003','B005','Три товарища','Роман','2026-10-19','active');

INSERT INTO loans_by_period
(period, issue_date, issue_id, reader_id, book_id, book_title, category, due_date, status)
VALUES
('2026-10','2026-10-06','L014','R004','B003','Мастер и Маргарита','Классика','2026-10-20','active');



INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R001','2026-10-15','L003','B004','1984','Антиутопия','2026-10-01','active');

INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R001','2026-10-17','L004','B006','Дюна','Фантастика','2026-10-03','active');

INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R002','2026-10-16','L007','B001','Война и мир','Классика','2026-10-02','active');

INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R002','2026-10-18','L008','B004','1984','Антиутопия','2026-10-04','active');

INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R003','2026-10-19','L011','B005','Три товарища','Роман','2026-10-05','active');

INSERT INTO active_loans_by_reader
(reader_id, due_date, issue_id, book_id, book_title, category, issue_date, status)
VALUES
('R004','2026-10-20','L014','B003','Мастер и Маргарита','Классика','2026-10-06','active');



SELECT *
FROM loans_by_reader
WHERE reader_id = 'R001';

SELECT *
FROM loans_by_due_date
WHERE due_date = '2026-10-15';

SELECT *
FROM loan_history_by_book
WHERE book_id = 'B001';

SELECT *
FROM loans_by_period
WHERE period = '2026-10'
AND issue_date >= '2026-10-01'
AND issue_date <= '2026-10-31';

SELECT *
FROM active_loans_by_reader
WHERE reader_id = 'R001';

SELECT *
FROM loans_by_reader
WHERE reader_id = 'R001'
AND issue_date = '2026-10-01'
AND issue_id = 'L003';

UPDATE loans_by_reader
SET due_date = '2026-10-16'
WHERE reader_id = 'R001'
AND issue_date = '2026-10-01'
AND issue_id = 'L003';

SELECT *
FROM loans_by_reader
WHERE reader_id = 'R001'
AND issue_date = '2026-10-01'
AND issue_id = 'L003';

SELECT *
FROM loans_by_reader
WHERE reader_id = 'R001'
AND issue_date = '2026-10-03'
AND issue_id = 'L004';

DELETE FROM loans_by_reader
WHERE reader_id = 'R001'
AND issue_date = '2026-10-03'
AND issue_id = 'L004';

SELECT *
FROM loans_by_reader
WHERE reader_id = 'R001'
AND issue_date = '2026-10-03'
AND issue_id = 'L004';

SELECT *
FROM active_loans_by_reader
WHERE reader_id = 'R001';

