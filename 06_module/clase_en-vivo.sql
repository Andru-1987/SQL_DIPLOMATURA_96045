-- DML 
CREATE DATABASE dml_database;
USE dml_database;


CREATE TABLE dml_database.PAY(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(6,2) DEFAULT 200.00,
    currency  VARCHAR(10) DEFAULT 'U$S',
    date_pay DATE NOT NULL DEFAULT(CURRENT_DATE),
    id_system_user INT,
    id_game INT
);

-- insert 1 rows

INSERT INTO dml_database.PAY 
VALUES (NULL, DEFAULT,DEFAULT,DEFAULT,1,1);

SELECT * FROM dml_database.PAY;

-- no ingresa dato en un valor null con default que no sea auto_increment
INSERT INTO dml_database.PAY 
VALUES (NULL, DEFAULT,DEFAULT,NULL,1,1);

INSERT INTO dml_database.PAY (id_system_user, id_game)
VALUES (2,3);


INSERT INTO dml_database.PAY (id_game, id_system_user)
VALUES (4,2);


INSERT INTO dml_database.PAY (amount,currency,date_pay, id_system_user,id_game)
	VALUES
  (250, 'U$S', '2021-07-22', 850, 77),
  (3700, 'Arg$', '2021-07-22', 38, 31),
  (180, 'Libras', '2021-07-22', 175, 16);



-- UPDATE 

UPDATE dml_database.PAY  
	SET currency = "U$S"
    WHERE id IN (9,10);

UPDATE dml_database.PAY  
	SET date_pay = date_pay - 1
    WHERE id_system_user = 2;


UPDATE dml_database.PAY  
	SET currency = "U$S"
    WHERE currency NOT LIKE 'U$S';

SET autocommit = 0;

START TRANSACTION;

DELETE  FROM dml_database.PAY  ;

SELECT * FROM dml_database.PAY  ;

ROLLBACK;

START TRANSACTION;
TRUNCATE dml_database.PAY  ;



COMMIT;

-- mysql  --> AUTO COMMIT 
-- DELETE

DELETE FROM dml_database.PAY  
	WHERE currency != "U$S" ;


-- DML con SubQueries
-- UNA tabla donde contenga la cantidad de comentarios para cada juego

CREATE TABLE dml_database.COMMENTARY_METRICS (
	periodo CHAR(6), -- '202501'
	ig_game INT,
    comentarios INT
);


INSERT INTO dml_database.COMMENTARY_METRICS
SELECT 
	DATE_FORMAT(comment_date, '%Y%m') AS periodo,
    id_game,
    COUNT(id_commentary) AS comentarios
FROM coderhouse_gamers.COMMENTARY
GROUP BY 
	DATE_FORMAT(comment_date, '%Y%m'), id_game
ORDER BY periodo, id_game;



SELECT * FROM dml_database.COMMENTARY_METRICS;



-- INGRESO DE 20 RECORDS
INSERT INTO dml_database.PAY (amount, currency, date_pay, id_system_user, id_game) VALUES
(150.00, 'U$S', '2026-01-01', 1, 1),
(220.50, 'U$S', '2026-01-02', 2000, 3),
(199.99, 'U$S', '2026-01-03', 3000, 2),
(300.00, 'U$S', '2026-01-04', 4000, 4),
(175.75, 'U$S', '2026-01-05', 5000, 1),
(210.40, 'U$S', '2026-01-06', 6000, 2),
(89.90,  'U$S', '2026-01-07', 7000, 5),
(450.00, 'U$S', '2026-01-08', 8, 3),
(120.00, 'U$S', '2026-01-09', 9, 4),
(275.35, 'U$S', '2026-01-10', 10, 2),
(310.60, 'U$S', '2026-01-11', 400, 5),
(95.00,  'U$S', '2026-01-12', 2, 4),
(180.80, 'U$S', '2026-01-13', 3, 1),
(260.00, 'U$S', '2026-01-14', 4, 3),
(140.25, 'U$S', '2026-01-15', 5, 2),
(500.00, 'U$S', '2026-01-16', 6, 5),
(75.50,  'U$S', '2026-01-17', 300, 1),
(330.90, 'U$S', '2026-01-18', 8, 4),
(410.10, 'U$S', '2026-01-19', 200, 3),
(60.00,  'U$S', '2026-01-20', 10, 2);


SELECT * FROM dml_database.PAY;

SELECT * FROM coderhouse_gamers.SYSTEM_USER ORDER BY id_system_user DESC;


CREATE TABLE dml_database.pay_from_unknown_users AS
SELECT * 
FROM dml_database.PAY
WHERE id_system_user NOT IN (
	SELECT id_system_user FROM coderhouse_gamers.SYSTEM_USER
);


SELECT * FROM dml_database.pay_from_unknown_users;

DELETE FROM  dml_database.PAY
WHERE id_system_user NOT IN (
	SELECT id_system_user FROM coderhouse_gamers.SYSTEM_USER
);


SELECT * FROM dml_database.PAY;


