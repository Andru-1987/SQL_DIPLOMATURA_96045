-- Crear nuestra primera db
-- ACCION -> QUE? -> Su nombre
CREATE DATABASE mi_primera_db ; -- || GO --> // $$ 
create schema mi_segunda_db;
-- schema == database ==> no son iguales PG ORACLE SERVER --> schema--> subconjunto de una base de datos
-- pepito != Pepito
-- buenas practicas by el tio Andru:
-- Palabras reservadas en mayusculas
-- Identacion
-- Respetar los nombres de los objetos tal cual se crearon

DROP DATABASE mi_primera_db ;

-- intento dos de borrar
DROP DATABASE IF EXISTS mi_primera_db ;
DROP DATABASE mi_segunda_db ;


-- como se arma mi primera sentencia SQL  CONSULTA
-- me indica que debo traer
-- SELECT
-- donde tiene las cosas | columnas| caracteristicas  que le voy a colocar al usuario final
-- FROM --> de donde me traes esa info
-- FILTROS | ORDEN | AGRUPAMIENTO DE DATOS

-- <Jugamos?> --
USE coderhouse_gamers;

SELECT * FROM GAME;
-- columnas especificas
-- query para  : traer info de juegos
SELECT 
	-- columnas pedidas
	name, -- keyword no usar a menos que sea necesario
    id_level,
    id_class 
-- tabla principal de juegos
FROM GAME;


SELECT 
	-- * 
    DISTINCT name AS nombre_de_juego
FROM GAME
WHERE
	-- id_level = 15 AND 
    name LIKE 'A%'
LIMIT 3
    ; -- POSIX
-- ORDER BY id_level;


-- funciones de agregacion
SELECT  
	id_level,
    COUNT(DISTINCT name) AS freq_juegos
FROM GAME
WHERE id_level != 15 -- omito a todos los id_level 15
GROUP BY id_level
HAVING COUNT(DISTINCT name) >= 6 -- filtro por agrupacion
ORDER BY freq_juegos ASC -- ASC es default
-- LIMIT 4, 2
;

SELECT * FROM GAME;
--

SELECT * 
FROM COMMENTARY AS c -- << left
INNER JOIN SYSTEM_USER AS s -- default ---> join --> inner join << right
	ON s.id_system_user = c.id_system_user
;


SELECT * 
FROM COMMENTARY AS c -- << left
RIGHT JOIN SYSTEM_USER AS s -- default ---> join --> inner join << right
	ON s.id_system_user = c.id_system_user
;




SELECT * 
FROM COMMENTARY AS c -- << left
LEFT JOIN SYSTEM_USER AS s -- default ---> join --> inner join << right
	ON s.id_system_user = c.id_system_user
;

-- FULL JOIN |  FULL OUTER JOIN
SELECT c.*, s.*
FROM COMMENTARY AS c
LEFT JOIN SYSTEM_USER AS s
    ON s.id_system_user = c.id_system_user

UNION ALL

SELECT c.*, s.*
FROM SYSTEM_USER AS s
LEFT JOIN COMMENTARY AS c
    ON s.id_system_user = c.id_system_user
WHERE c.id_system_user IS NULL;



SELECT * FROM SYSTEM_USER;























