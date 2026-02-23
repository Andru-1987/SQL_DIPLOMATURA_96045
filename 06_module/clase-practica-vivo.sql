-- SENTENCIAS DE INSERCION DE DATOS EN UNA BASE DE DATOS? 
-- DML ? 
-- COMO NOS AYUDA LAS TRANSACCIONES A EVITAR ALGUN INCONVENIENTE?
/*
INSERT INTO <TABLA> (COLS ...)
	VALUES
(),() ...,();
*/

CREATE DATABASE dml_database_practica;
USE dml_database_practica;

-- insercion por subqueries?
-- insertar registros a una tabla donde tenga los siguientes campos: 
/*
CREAR TABLA 
- fecha y tiempo de transacccion (sugiero un default) TIME STAMP --> DATETIME 
- monto de transaccion 
- monto de descuento
- id_transaccion
- cuenta bancaria origen (sugiero un default)
- cuenta bancaria final
- tipo transaccion (si es deposito, transferencia o indeterminada , sugiero usar ENUMS)

INSERTAR n registros*/


CREATE TABLE dml_database_practica.transacciones (
	id_transaccion			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	monto_transaccion 		DECIMAL(12,2) NOT NULL, 
	monto_descuento 		DECIMAL(12,2) DEFAULT(0),  -- COBOL --> 0.0001000000005 -->  fix .2 |  *100 | PIC 
	fecha_transaccion 		DATETIME DEFAULT(NOW()),
	cuenta_bancaria_origen 	INT NOT NULL DEFAULT(1234567),
	cuenta_bancaria_final 	INT NOT NULL,
	tipo_transaccion 		ENUM("transferencia","deposito","indeterminada")
);


INSERT INTO dml_database_practica.transacciones (monto_transaccion,cuenta_bancaria_final,tipo_transaccion)
VALUES (20000,234567,2);

SELECT * FROM dml_database_practica.transacciones;

/*
Migración de datos con control de duplicados

Enunciado:
La tabla CLASS necesita ser limpiada. Se ha creado una tabla nueva CLASS_BACKUP con la misma estructura. Tu tarea es:
Crear la tabla CLASS_BACKUP idéntica a CLASS.
Insertar en CLASS_BACKUP todos los registros de CLASS cuya descripción contenga la palabra 'comedy' (usando LIKE '%comedy%').
De esos mismos registros copiados, actualizar en la tabla CLASS original la descripción añadiendo el sufijo " [BACKUP]" al final.
*/

-- CREATE TABLE dml_database_practica.CLASS_BACKUP LIKE coderhouse_gamers.CLASS;

-- SELECT * FROM dml_database_practica.CLASS_BACKUP;
-- asegurarnos de que el auto commit este apagado
SET AUTOCOMMIT = 0;
-- empezar la transaccion

START TRANSACTION;
-- ingreso los registros
INSERT INTO dml_database_practica.CLASS_BACKUP
SELECT 
	id_level,
    id_class,
    CONCAT(description,'_BACKUP')  AS description
 FROM coderhouse_gamers.CLASS
WHERE description LIKE '%comedy%';

-- update 
UPDATE coderhouse_gamers.CLASS
SET description = CONCAT(description,'_BACKUP')
WHERE
    description LIKE '%comedy%';

ROLLBACK;

SELECT * FROM coderhouse_gamers.CLASS;

UPDATE coderhouse_gamers.CLASS AS c
JOIN dml_database_practica.CLASS_BACKUP AS b 
	USING(id_level,id_class)
SET c.description = b.description;

COMMIT;
	
    
    
    
-- SINCRO de tablas con operaciones

-- La tabla PLAY registra qué usuarios han jugado qué juegos. 
/*
Se necesita actualizar la tabla COMMENT 
para que todos los usuarios que tienen juegos completados (completed = TRUE) en PLAY tengan un registro en COMMENT 
con first_date igual a la fecha actual, pero solo si no existe ya un registro para ese par  (usuario, juego -- pk ).
Si ya existe, se debe actualizar last_date a la fecha actual.
*/

-- MODIFICANDO TABLAS PRODUCTIVAS --> recomendacion usar TRANSACTIONS
-- insertaria los que no existen
-- update los que ya existen

START TRANSACTION;


INSERT INTO coderhouse_gamers.COMMENT(id_system_user, id_game, first_date, last_date)

SELECT p.id_system_user, p.id_game, CURRENT_DATE(), NULL
FROM coderhouse_gamers.PLAY p
WHERE p.completed = TRUE
	AND NOT EXISTS (
		-- declara la existencia en esta tabla pero no en la de play
		SELECT 1 FROM coderhouse_gamers.COMMENT c
		WHERE c.id_system_user = p.id_system_user
		  AND c.id_game = p.id_game
	);

INSERT INTO coderhouse_gamers.COMMENT(id_system_user, id_game, first_date, last_date)
SELECT p.id_system_user, p.id_game, CURRENT_DATE(), NULL 
	FROM coderhouse_gamers.PLAY p
	LEFT JOIN coderhouse_gamers.COMMENT AS c USING(id_game,id_system_user)
	WHERE p.completed IS TRUE AND c.id_game IS NULL;


SELECT * FROM coderhouse_gamers.COMMENT ;

-- actualizo datos.
UPDATE 	coderhouse_gamers.COMMENT AS c
JOIN	coderhouse_gamers.PLAY AS p 
		ON c.id_system_user = p.id_system_user AND c.id_game = p.id_game 
SET 	c.last_date = CURRENT_DATE()
WHERE
    p.completed = TRUE;


UPDATE 	coderhouse_gamers.COMMENT AS c
JOIN	coderhouse_gamers.PLAY AS p 
		-- ON c.id_system_user = p.id_system_user AND c.id_game = p.id_game 
        USING(id_game,id_system_user)
SET 	c.last_date = CURRENT_DATE()
WHERE 	p.completed IS TRUE;

SELECT * FROM coderhouse_gamers.COMMENT WHERE first_date = CURRENT_DATE();


COMMIT;