-- UNION
-- Usando la tabla GAME, unir juegos de nivel 1 y nivel 2

-- Unir los usuarios cuyo tipo sea 1 con los usuarios cuyo tipo sea 2, mostrando nombre, apellido y tipo donde los usuarios terminen su email en  `.edu`

SELECT * FROM coderhouse_gamers.SYSTEM_USER
WHERE 
		email LIKE "%.edu" 
	AND id_user_type = 1
UNION
SELECT * FROM coderhouse_gamers.SYSTEM_USER
WHERE 
		email LIKE "%.edu" 
	AND id_user_type = 2
;

SELECT * FROM coderhouse_gamers.SYSTEM_USER
WHERE 
		email LIKE "%.edu" 
	AND id_user_type IN (20,25); -- no te da un rango --> te selecciona valores especificos
    -- between te selecciona valores del tipo rango : 20, 21, 22, ... 25



-- 1. Usuarios cuyo nombre comience con 'J'
-- 2. Usuarios cuyo apellido contenga la letra 'W'
-- 3. Usuarios cuyo nombre contenga 'i' en segundo lugar
-- 4. Usuarios cuyo nombre finalice con 'k'
-- 5. Usuarios cuyo nombre NO incluya 'ch'
-- 6. Usuarios cuyo nombre incluya 'ch' en cualquier posición

-- EXTRA

/*
Buscar en la tabla GAME:

- Juegos cuyo nombre comience con 'F'
- Juegos que contengan la palabra 'Ultimate'
- Juegos cuyo nombre termine con '2022'

*/

SELECT *
FROM coderhouse_gamers.GAME
WHERE 
	-- name LIKE 'F%'
	-- name LIKE "%ultimate%"
    name LIKE "%2022"
;

-- SUB QUERIES 
-- Mostrar todos los usuarios que tienen el tipo de usuario con el ID más alto.

-- 8:40 estamos back


SELECT *
FROM coderhouse_gamers.SYSTEM_USER
WHERE id_user_type = (
	-- SELECT MAX(id_user_type) 
	-- FROM coderhouse_gamers.USER_TYPE
    SELECT id_user_type
	FROM coderhouse_gamers.USER_TYPE
    ORDER BY id_user_type DESC LIMIT 1
);

SELECT *
FROM coderhouse_gamers.SYSTEM_USER AS s
WHERE 
/*
	EXISTS 
    (
	SELECT * 
	FROM (
		SELECT MAX(id_user_type) AS valores
		FROM coderhouse_gamers.USER_TYPE
		UNION
		SELECT MIN(id_user_type) 
		FROM coderhouse_gamers.USER_TYPE) AS new_tabla
    WHERE new_tabla.valores = s.id_user_type
)
*/
	id_user_type IN
    (
		SELECT MAX(id_user_type) AS valores
		FROM coderhouse_gamers.USER_TYPE
		UNION
		SELECT MIN(id_user_type) 
		FROM coderhouse_gamers.USER_TYPE
        )
;

-- JOINS
-- 1 - Juegos jugados por jugador: Listar los juegos que cada usuario ha jugado (completados).
SELECT * 
FROM coderhouse_gamers.play as p
INNER JOIN coderhouse_gamers.game as g
on p.id_game = g.id_game
where completed = 1
order by id_system_user;

SELECT su.first_name, su.last_name, g.name, p.completed
FROM coderhouse_gamers.SYSTEM_USER su
JOIN coderhouse_gamers.PLAY p ON su.id_system_user = p.id_system_user
JOIN coderhouse_gamers.GAME g ON p.id_game = g.id_game
WHERE p.completed = TRUE;

SELECT 
    CONCAT(system_user.first_name,
            ' ',
            system_user.last_name) AS Usuario,
    game.name AS Juego,
    play.completed AS Terminado
FROM
    coderhouse_gamers.play
        JOIN
    coderhouse_gamers.system_user ON play.id_system_user = system_user.id_system_user
        JOIN
    coderhouse_gamers.game ON play.id_system_user = game.id_game
WHERE
    play.completed = 1
ORDER BY Usuario;

-- 2 - Usuarios que han jugado más de 3 juegos (usando HAVING):

SELECT 
	su.id_system_user,
    su.first_name,
    su.last_name,
    COUNT(p.id_game) AS total_juegos
    
FROM coderhouse_gamers.SYSTEM_USER AS su
JOIN coderhouse_gamers.PLAY AS p 
	ON su.id_system_user = p.id_system_user
    
GROUP BY su.id_system_user, su.first_name, su.last_name
HAVING COUNT(p.id_game) > 3;


-- 9:35 -- CREACION DE TABLA 
/*
Crear una consulta que:

	- Una usuarios con juegos jugados
	- Filtre por juegos completados
	- Agrupe por usuario contando juegos
	- Muestre solo los que tienen más de 2 juegos completados
	- Ordene por cantidad de juegos descendente
    
    15 mins --> lo hacemos en el general. --> 9:50
    
    Les paso algunos tips: 
		tablas -> system user & play 
			-> checkear que los juegos esten completados
             y agrupar por el usuario id, first_name  y last_name
             
*/





-- 9:35 estamos back
SELECT 
	s.first_name,
    s.last_name,
    COUNT(p.id_game)  AS juegos_completados
FROM coderhouse_gamers.SYSTEM_USER AS s
INNER JOIN coderhouse_gamers.PLAY AS p 
	ON s.id_system_user = p.id_system_user
WHERE p.completed IS TRUE
GROUP BY s.id_system_user, s.first_name, s.last_name
HAVING COUNT(p.id_game) > 2
ORDER BY juegos_completados DESC
;



