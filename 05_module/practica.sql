-- VIEW -> que era una view? 
-- alamacena  -> query! jamas alamacena datos ->  LOS DATOS SE GUARDAN UNICAMENTE EN LAS TABLAS .
-- CREATE OR REPLACE VIEW <base_datos>.<nombre> AS -->
-- * CREATE OR REPLACE  --> caso contrario que no tengas permisos de creacion de views. 

-- crear una base de datos para almacenar views

CREATE DATABASE  ventas_views_business;
USE ventas_views_business;

-- una vista de usuarios que tengan `@webnode.com` en el email.

CREATE OR REPLACE VIEW ventas_views_business.view_users_webnode AS
SELECT 
	CONCAT(first_name, ', ',last_name) AS full_name,
    email
    -- EXCEPT TERADATA  BIGQUERY 
FROM coderhouse_gamers.SYSTEM_USER
WHERE email LIKE '%@webnode.com';

SELECT * FROM ventas_views_business.view_users_webnode ;

-- 
-- 8:18 
-- Crear una vista que muestre todos los datos de los juegos que han sido marcados como completados (completed = true) en la tabla PLAY.
-- Lucio
SELECT 
	DISTINCT g.name, g.description, g.id_level, g.id_class
FROM coderhouse_gamers.PLAY AS p
LEFT JOIN coderhouse_gamers.GAME AS g ON g.id_game = p.id_game
WHERE p.completed = TRUE
ORDER BY id_level;

CREATE OR REPLACE VIEW ventas_views_business.view_completed_games AS
SELECT DISTINCT g.*
FROM coderhouse_gamers.GAME AS g 
JOIN coderhouse_gamers.PLAY AS p  ON  g.id_game = p.id_game -- USING(id_game), de un solo campo --> se usa para n campos, los nombres sean iguales en ambas tablas
WHERE p.completed IS TRUE;

SELECT * FROM ventas_views_business.view_completed_games;


-- 8:34 estamos de vuelta
-- Crear una vista que muestre los nombres de los juegos que tengan una votación (value) mayor a 9. -- detalle: mayor a 9 ;)  y 


CREATE OR REPLACE VIEW ventas_views_business.view_high_ranked AS
SELECT 
	DISTINCT g.name
FROM coderhouse_gamers.GAME AS g
JOIN coderhouse_gamers.VOTE AS v USING(id_game)
WHERE v.value > 9 ;

EXPLAIN coderhouse_gamers.VOTE ;
EXPLAIN  FORMAT=JSON  SELECT * FROM ventas_views_business.view_high_ranked;

-- 8:53
-- Crear una vista que muestre el first_name, last_name y email de los usuarios que juegan al juego 'FIFA 22'
CREATE OR REPLACE VIEW ventas_views_business.view_fifa_22_users AS
SELECT 
-- 	s.* ,
--     p.*,
--     g.*    
    s.first_name,
    s.last_name,
    s.email
FROM coderhouse_gamers.SYSTEM_USER AS s 
LEFT JOIN coderhouse_gamers.PLAY AS p USING(id_system_user)
LEFT JOIN coderhouse_gamers.GAME AS g USING(id_game)
WHERE g.name LIKE '%FIFA 22%';



-- Crear una vista que muestre el nombre completo del usuario, el nombre del juego y si lo ha completado, ordenado por usuario.
-- el juego este completado -- 1 --> 'Completado', -- 0 'En progreso'

CREATE OR REPLACE VIEW ventas_views_business.view_games_status AS
SELECT 
	CONCAT(s.first_name, ', ',s.last_name)AS nombre_completo,
	g.name,
    CASE 
		WHEN p.completed IS NULL THEN 'No esta jugando este juego'
		WHEN p.completed IS TRUE THEN 'Completado'
        ELSE 'En progreso'
	END AS estado
FROM coderhouse_gamers.SYSTEM_USER AS s
LEFT JOIN coderhouse_gamers.PLAY AS p USING(id_system_user)
LEFT JOIN coderhouse_gamers.GAME AS g USING(id_game);

SELECT * FROM ventas_views_business.view_games_status;


-- Crear una vista que muestre el nombre del juego y el promedio de sus votaciones, solo para juegos con más de 5 votos.
CREATE OR REPLACE  VIEW ventas_views_business.view_summary_votes AS 

SELECT 
	g.name AS juego,
    AVG(v.value) AS avg_votacion
FROM coderhouse_gamers.GAME AS g
LEFT JOIN coderhouse_gamers.VOTE AS v USING(id_game)
GROUP BY g.id_game
HAVING COUNT(v.id_vote) > 5 ;


-- Crear una vista que muestre el nombre del juego, el comentario y la fecha del comentario de los comentarios realizados en el último mes (usar CURDATE() e INTERVAL).


-- 1 archivo ppt | pdf | https://www.canva.com/templates --> debe tener el modelo de nego, el motivo, DER ontologico(a mano) | DER hecho por workbench --> sus definiciones de dtypes y ademas como minimo 5 tables.

-- 1 sql -> creacion del database, y sus tablas con relaciones 


