CREATE DATABASE objetos_db;
USE objetos_db;

CREATE TABLE  objetos_db.estudiante(
	id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(200),
    email VARCHAR(200) UNIQUE, -- regla de negocio
    dob DATE,
    PRIMARY KEY (id)
);

CREATE TABLE objetos_db.curso(
	id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) DEFAULT 'undefined', -- 254 --> MEDIUM TEXT
	PRIMARY KEY(id)
);


CREATE TABLE objetos_db.inscripciones(
	id_curso INT, -- fk
    id_estudiante INT, -- fk
    fecha_inscripion DATE DEFAULT  (CURRENT_DATE),
	FOREIGN KEY (id_curso) REFERENCES objetos_db.curso(id),
	FOREIGN KEY (id_estudiante) REFERENCES objetos_db.estudiante(id),
	PRIMARY KEY (id_curso,id_estudiante)
);
 



EXPLAIN  -- te da mayores utilidades de query.
	objetos_db.estudiante;
    
    
-- views 

CREATE VIEW objetos_db.juegos_para_marketing AS
SELECT 
		g.name AS nombre_juego,
        g.description AS descripcion_juego,
        c.commentary AS comentario
	FROM coderhouse_gamers.GAME  AS g
	JOIN coderhouse_gamers.commentary AS c USING(id_game)
    WHERE YEAR(c.comment_date) IN (2021,2022)
	AND g.name LIKE 'C%'
;

SELECT * FROM objetos_db.juegos_para_marketing;

-- functions -> query -> SELECT
DELIMITER $$

CREATE FUNCTION objetos_db.fn_description_by_id( primary_key INT) 
RETURNS VARCHAR(200)
DETERMINISTIC -- definicion de funcion
BEGIN
    -- variables
    DECLARE valor_retorno VARCHAR(200);
    
    SELECT l.description INTO valor_retorno
    FROM coderhouse_gamers.GAME AS g
    JOIN coderhouse_gamers.LEVEL_GAME AS l USING(id_level)
    WHERE g.id_game = primary_key
    LIMIT 1;
    
    RETURN valor_retorno;
END$$

DELIMITER ;


SELECT 
	id_game,
    objetos_db.fn_description_by_id(id_game) AS level
FROM coderhouse_gamers.COMMENTARY;

-- procedures
-- ETL extracciom -> transformacion -> carga ?? 
DELIMITER $$
CREATE PROCEDURE objetos_db.etl_process()
BEGIN
	-- EXTR & TRANSFORMAR
    CREATE TEMPORARY TABLE transformada AS
    SELECT UCASE(name) AS nombre , description
	FROM coderhouse_gamers.GAME;
    
    -- LOAD
    CREATE TABLE IF NOT EXISTS 
		objetos_db.game_info AS
	SELECT * FROM transformada;
END$$

DELIMITER ;


CALL objetos_db.etl_process();

-- 





