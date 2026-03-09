USE coderhouse_gamers;

DELIMITER //

DROP FUNCTION IF EXISTS get_game//

CREATE FUNCTION get_game(p_id_game INT)
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_game_name VARCHAR(255);

    SELECT name INTO v_game_name
    FROM game
    WHERE id_game = p_id_game;

    RETURN v_game_name;
    
END //

DELIMITER ;



-- Como implementamos esta funcion? 
SELECT 
	v.* ,
`coderhouse_gamers`.`get_game`(v.id_game) AS nombre_juego
FROM `coderhouse_gamers`.`vote` AS v;

-- Función para calcular el promedio de votos de un juego 
-- arg : id_game
-- Si llega a ser el caso de que el promedio no exista los juegos return --> 0

DELIMITER //

DROP FUNCTION IF EXISTS fn_promedio_votos//

CREATE FUNCTION fn_promedio_votos(p_id_game INT) -- te falto el tipo de dato
	RETURNS DECIMAL(5,2)
	DETERMINISTIC
	READS SQL DATA
BEGIN
	DECLARE v_promedio_votos DECIMAL(5,2); -- te faltaba el punto y coma
    
    SELECT AVG(value) INTO v_promedio_votos
    FROM `coderhouse_gamers`.`vote`
    WHERE id_game = p_id_game;
    
    RETURN IFNULL(v_promedio_votos, 0.0);
    
END //

DELIMITER ;


SELECT 
	name,
    coderhouse_gamers.fn_promedio_votos(id_game) as promedio_votos
FROM GAME;


--  Función para contar los comentarios de un usuario

DELIMITER //
DROP FUNCTION IF EXISTS fn_cant_comentarios//

CREATE FUNCTION fn_cant_comentarios(p_id_system_user INT)
	RETURNS INT
	DETERMINISTIC
	READS SQL DATA
BEGIN
	
    DECLARE c_total INT;
    
    SELECT COUNT(*) INTO c_total
    FROM coderhouse_gamers.commentary
    WHERE id_system_user = p_id_system_user;
    
    RETURN c_total;
    
END //

DELIMITER ;




SELECT 
	s.first_name,
	s.last_name, 
    fn_cant_comentarios(s.id_system_user) as total_comentarios
FROM SYSTEM_USER  AS s;

-- STORED PROCEDURES

-- Stored Procedure para registrar un nuevo juego (con validaciones)
-- validacion: 
	-- no exista el level_game solicitado
    -- no exista el nivel 
-- argumentos
    -- IN p_name VARCHAR(100),
    -- IN p_description VARCHAR(300),
    -- IN p_id_level INT,
    -- IN p_id_class INT


DELIMITER //

DROP PROCEDURE IF EXISTS sp_registrar_game//

CREATE PROCEDURE sp_registrar_game(
    IN p_name VARCHAR(100),
    IN p_description VARCHAR(300),
    IN p_id_level INT,
    IN p_id_class INT
)
BEGIN

--    DECLARE v_level_exists INT;
--    DECLARE v_class_exists INT;

/*
    SELECT COUNT(*) INTO v_level_exists
    FROM level_game
    WHERE id_level = p_id_level;


    SELECT COUNT(*)
    INTO v_class_exists
    FROM class
    WHERE id_class = p_id_class;


    IF v_level_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El level indicado no existe';
    END IF;

    IF v_class_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La class indicada no existe';
    END IF;

 
    INSERT INTO game(name, description, id_level, id_class)
    VALUES(p_name, p_description, p_id_level, p_id_class);
*/


	IF NOT EXISTS(SELECT 1 FROM coderhouse_gamers.LEVEL_GAME WHERE id_level = p_id_level)
		THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El level indicado no existe';
	END IF;
    
	IF NOT EXISTS(
		SELECT 1 FROM coderhouse_gamers.CLASS 
			WHERE id_level = p_id_level AND id_class = p_id_class
		)
		THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La clase indicada no existe ni el level';
	END IF;
    

	INSERT INTO coderhouse_gamers.GAME(id_game, name, description, id_level, id_class)
    SELECT 
		-- auto incremental de mentira
        IFNULL(MAX(id_game),0) + 1,
        p_name,
        p_description,
        p_id_level,
        p_id_class
    FROM coderhouse_gamers.GAME;
    
END //

DELIMITER ;

CALL sp_registrar_game("Lucio", "salvar a la princesa", 11, 300);
SELECT * FROM coderhouse_gamers.GAME ORDER BY id_game DESC;

-- Prepared Statement para búsqueda dinámica
-- valores permitidos como campos de busqueda: name,description,id_level,id_class

/*
IN p_campo VARCHAR(50),
IN p_valor_busqueda VARCHAR(100)

    SET v_sql = CONCAT(
        'SELECT g.id_game, g.name, g.description, lg.description as nivel, c.description as clase, ',
        'fn_promedio_votos(g.id_game) as promedio_votos ',
        'FROM GAME g ',
        'INNER JOIN LEVEL_GAME lg ON g.id_level = lg.id_level ',
        'INNER JOIN CLASS c ON g.id_class = c.id_class AND g.id_level = c.id_level ',
        'WHERE g.', p_campo, ' LIKE ? ',
        'ORDER BY g.name'
    );

;*/


CALL sp_buscar_game_dinamico('name', 'Call');

CALL sp_buscar_game_dinamico('description', 'morbi');

CALL sp_buscar_game_dinamico('descripcion', 'morbi');




DELIMITER //

DROP PROCEDURE IF EXISTS sp_buscar_game_dinamico//

CREATE PROCEDURE sp_buscar_game_dinamico(
    IN p_campo VARCHAR(50),
    IN p_valor_busqueda VARCHAR(100)
)
BEGIN

    DECLARE v_sql TEXT;

	DECLARE v_campos_permitidos VARCHAR(200) DEFAULT 'name,description,id_level,id_class';


	IF p_campo NOT IN ('name','description','id_level','id_class') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo de búsqueda no permitido';
	END IF;

	IF  FIND_IN_SET( p_campo , v_campos_permitidos) = 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'campeon, este campo no esta permitido en la busqueda';
    END IF;


    SET v_sql = CONCAT(
        'SELECT g.id_game, g.name, g.description, ',
        'lg.description AS nivel, ',
        'c.description AS clase, ',
        'fn_promedio_votos(g.id_game) AS promedio_votos ',
        'FROM game g ',
        'INNER JOIN level_game lg ON g.id_level = lg.id_level ',
        'INNER JOIN class c ON g.id_class = c.id_class AND g.id_level = c.id_level ',
        'WHERE g.', p_campo, ' LIKE ? ',
        'ORDER BY g.name'
    );

    SET @sql = v_sql;
    SET @valor = CONCAT('%', p_valor_busqueda, '%');

    PREPARE stmt FROM @sql;
		EXECUTE stmt USING @valor;
    DEALLOCATE PREPARE stmt;

END //

DELIMITER ;


