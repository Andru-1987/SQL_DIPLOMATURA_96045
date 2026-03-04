-- funciones 
-- stored procedures

-- functiones built : deterministas & no deterministas
-- [ 3 huevos + 250 ml leche + horno] -> bizcochuelo (Determinista)
-- [ 3 huevos + 250 ml leche + horno] -> pastel papas  NO determinista

SELECT 1+3 ;
SELECT RAND();
-- funcion -> ejecuta en un contexto de query. 
SELECT CONCAT("a","+","b");

-- functions custom ->  fx(........ [variables entrada]) --> 1 valor de retorno
-- informacion sobre una obra construccion --> 

CREATE DATABASE routines_database;
USE routines_database;

DROP TABLE routines_database.presupuesto_paredes ;
CREATE TABLE routines_database.presupuesto_paredes (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    alto FLOAT,
	largo FLOAT,
	manos_pintura INT,
	precio_final FLOAT
);

INSERT INTO routines_database.presupuesto_paredes (alto, largo, manos_pintura, precio_final) VALUES
(2.80, 4.50, 2, 50400.00),
(3.00, 5.00, 3, 90000.00),
(2.60, 3.80, 2, 39520.00),
(2.75, 6.00, 2, 66000.00),
(3.20, 4.20, 3, 80640.00),
(2.50, 3.50, 1, 21875.00),
(2.90, 4.80, 2, 55680.00),
(3.00, 7.00, 3, 126000.00),
(2.70, 5.50, 2, 59400.00),
(2.85, 4.00, 1, 22800.00),
(3.10, 6.20, 2, 76880.00),
(2.40, 3.00, 2, 28800.00),
(2.95, 5.80, 3, 102660.00),
(3.30, 4.50, 2, 59400.00),
(2.65, 3.90, 1, 20670.00),
(3.00, 6.50, 2, 78000.00),
(2.75, 4.70, 3, 77550.00),
(2.50, 5.00, 2, 50000.00),
(3.20, 5.50, 1, 35200.00),
(2.85, 6.00, 2, 68400.00);


SELECT 
	p.*,
    -- calculo de litros de pintura
    --  area * manos de pintura * rendimiento (0.5)
    ((p.alto * p.largo) * p.manos_pintura * 0.5) AS total_litros
FROM routines_database.presupuesto_paredes AS p;


DELIMITER //
DROP FUNCTION IF EXISTS routines_database.fn_calculo_litros//
CREATE FUNCTION routines_database.fn_calculo_litros(
	_alto FLOAT,
    _largo FLOAT,
    _manos_pintura INT,
    _rendimiento FLOAT
) RETURNS FLOAT
DETERMINISTIC 
NO SQL
BEGIN
	DECLARE valor_de_retorno FLOAT;
    
    -- validacion
    IF _rendimiento < 0 THEN
		SET valor_de_retorno = ((_alto * _largo) * _manos_pintura * 0) ;
    ELSEIF _rendimiento BETWEEN 0.4 AND 0.6 THEN
		SET valor_de_retorno = ((_alto * _largo) * _manos_pintura * _rendimiento) * 1.1 ;
	ELSE
		SET valor_de_retorno = ((_alto * _largo) * _manos_pintura * _rendimiento) ;
	END IF;
    
	RETURN valor_de_retorno ;
END //


DELIMITER ;


-- implementa en un contexto de query
SELECT 
	p.*,
    -- calculo de litros de pintura
    --  area * manos de pintura * rendimiento (0.5)
    routines_database.fn_calculo_litros(p.alto, p.largo, p.manos_pintura , 0.4) AS total_litros,
    
    ((p.alto * p.largo) * p.manos_pintura * 0.4) AS total_litros_manual
FROM routines_database.presupuesto_paredes AS p;


-- procedimiento es una secuencia de pasos --> DML - SQL - TRANSACTIONS 
-- VARIABLES DE IN  - OUT - IN/OUT 
-- CONTEXTO de un SP --> ROUTINE EXEC 
-- CALL 

-- ETL ->  extraer transformar cargar

CREATE TABLE routines_database.presupuesto_paredes_distintas_marcas (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    alto FLOAT,
	largo FLOAT,
	manos_pintura INT,
	costo_por_litro FLOAT,
    marca VARCHAR(200),
    rendimiento FLOAT
);


DELIMITER //
DROP PROCEDURE IF EXISTS routines_database.sp_generar_presupuesto //

CREATE PROCEDURE routines_database.sp_generar_presupuesto(
	IN _marca VARCHAR(200),
    IN _rendimiento FLOAT,
    IN _column_order_by VARCHAR(200)
)
BEGIN
	
	IF _rendimiento < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Zapallo, Como vas a tener un rendimiento negativo?';
    END IF; 

	DELETE FROM routines_database.presupuesto_paredes_distintas_marcas
		WHERE marca = _marca;

	INSERT INTO routines_database.presupuesto_paredes_distintas_marcas
    SELECT 
		NULL,
        p.alto,
        p.largo,
        p.manos_pintura,
		p.precio_final / routines_database.fn_calculo_litros(p.alto, p.largo, p.manos_pintura , _rendimiento) AS costo_por_litro,
        _marca,
        _rendimiento
	FROM routines_database.presupuesto_paredes AS p;

	SET @sql_statement = "SELECT * FROM routines_database.presupuesto_paredes_distintas_marcas";
	
    SET @sql_statement = CONCAT(@sql_statement," ", "ORDER BY ", _column_order_by, " " ,"DESC"); 
    
    SELECT @sql_statement AS query_final;
    
    PREPARE execute_statemnt FROM @sql_statement;
    EXECUTE execute_statemnt;
    
    DEALLOCATE PREPARE execute_statemnt;
    

END //

DELIMITER ;


-- llamo al procedure

SET @@sql_safe_updates= FALSE;

CALL routines_database.sp_generar_presupuesto("MelbaColors", 0.2, 'marca');











