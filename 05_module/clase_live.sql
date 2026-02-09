CREATE DATABASE views_from_coderhouse;
USE views_from_coderhouse;

CREATE VIEW views_from_coderhouse.view_usuarios_completed_games AS (
	SELECT 
		s.first_name,
        s.last_name,
        s.email,
        p.id_game
        
    FROM coderhouse_gamers.SYSTEM_USER AS s
    LEFT JOIN coderhouse_gamers.PLAY AS p USING(id_system_user)
		WHERE p.completed IS TRUE
    
);


SELECT DISTINCT first_name, last_name, email FROM 
views_from_coderhouse.view_usuarios_completed_games ;

-- UPDATE DE VISTAS



CREATE OR REPLACE VIEW views_from_coderhouse.view_usuarios_completed_games AS (
	SELECT 
		CONCAT('Congrants: ',s.last_name,', ',s.first_name, '.') AS message,
        s.email,
        COUNT( DISTINCT p.id_game) AS Q_games
        
    FROM coderhouse_gamers.SYSTEM_USER AS s
    LEFT JOIN coderhouse_gamers.PLAY AS p USING(id_system_user)
		WHERE p.completed IS TRUE
	GROUP BY s.last_name,s.first_name, s.email
);

-- CALCULO en la vista -> 

CREATE OR REPLACE VIEW views_from_coderhouse.view_usuarios_marketing AS(
	SELECT 
		message,
        email,
        CASE 
			WHEN Q_games > 5 THEN 'mega_user'
			WHEN (Q_games <= 5 AND Q_games >= 3 ) THEN 'medium_user' 
			ELSE 'low_user'
		END AS user_category
        FROM views_from_coderhouse.view_usuarios_completed_games
);


SELECT * FROM
views_from_coderhouse.view_usuarios_marketing
WHERE user_category LIKE 'low_user';


-- RLS


CREATE VIEW views_from_coderhouse.view_usuarios_per_area AS (
	SELECT 
		s.first_name,
        s.last_name,
        s.email,
        p.id_game,
        CASE
			WHEN s.email LIKE '%.info' THEN 'RRHH'
            WHEN s.email LIKE '%.gov' THEN 'GOV'
			WHEN s.email LIKE '%.org' THEN 'ORG'
			ELSE 'REGULAR'
		END AS role
    FROM coderhouse_gamers.SYSTEM_USER AS s
    LEFT JOIN coderhouse_gamers.PLAY AS p USING(id_system_user)
		WHERE p.completed IS TRUE
    
);


SELECT * FROM
views_from_coderhouse.view_usuarios_per_area;

-- GOB
CREATE OR REPLACE VIEW views_from_coderhouse.view_users (
	nombre, apellido,correo_electronico,id_juego
) AS (
	SELECT 
		first_name,
        last_name,
        email,
        id_game
	FROM views_from_coderhouse.view_usuarios_per_area
    WHERE role  = "GOV"
);

DROP VIEW views_from_coderhouse.view_usuarios_completed_games ;


SHOW CREATE VIEW views_from_coderhouse.view_usuarios_completed_games;


-- GENERAR UNA VIEW donde me permita ver cantidad de comentarios de los juegos en una ventana de 1 mes
-- Negocio 

-- 15 mins
-- 9:40 estamos de vuelta.


CREATE VIEW vw_comentarios_mes AS
SELECT
    g.id_game,
    g.name AS nombre_juego,
    COUNT(c.id_commentary) AS cantidad_comentarios,
    DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AS date
FROM coderhouse_gamers.GAME AS g
LEFT JOIN coderhouse_gamers.COMMENTARY AS c
    ON g.id_game = c.id_game AND c.comment_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY
    g.id_game,
    g.name;




SELECT
    g.id_game,
    g.name AS nombre_juego,
    YEAR(c.comment_date)  AS anio,
    MONTH(c.comment_date) AS mes,
    COUNT(c.id_commentary) AS cantidad_comentarios
FROM coderhouse_gamers.GAME AS g
LEFT JOIN coderhouse_gamers.COMMENTARY AS c
    ON g.id_game = c.id_game
GROUP BY
    g.id_game,
    g.name,
     YEAR(c.comment_date),
    MONTH(c.comment_date);


CREATE VIEW views_from_coderhouse.vw_comentarios_mes AS
SELECT 
    DATE_FORMAT(c.comment_date, '%Y%m') AS periodo,
    g.id_game,
    g.name AS nombre_juego,
    COUNT(c.id_commentary) AS cantidad_comentarios
FROM coderhouse_gamers.GAME AS g
LEFT JOIN coderhouse_gamers.COMMENTARY AS c ON g.id_game = c.id_game
GROUP BY 
    g.id_game, 
    g.name, 
    DATE_FORMAT(c.comment_date, '%Y%m')
ORDER BY 
    periodo DESC,
    g.name;
    

SELECT * FROM 
 views_from_coderhouse.vw_comentarios_mes;





