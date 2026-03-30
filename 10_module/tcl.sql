-- TCL -> SP -> Error HANDLER
/*
Consigna: La plataforma coderhouse_gamers necesita un proceso que registre la actividad completa de un usuario cuando comienza a jugar un nuevo titulo. El proceso tiene tres etapas encadenadas: registrar la partida (obligatoria), registrar el voto (opcional) y registrar el comentario (opcional).

Problematica: Si la operacion falla a mitad del camino, la base queda en estado inconsistente: un voto sin PLAY registrado, o un COMMENTARY sin su cabecera COMMENT. Ademas, si el usuario pasa un voto invalido, no deberia perderse el registro principal de la partida, solo deberia descartarse el voto.
*/


DELIMITER //
DROP PROCEDURE IF EXISTS coderhouse_gamers.sp_registro_user_and_game//
CREATE PROCEDURE coderhouse_gamers.sp_registro_user_and_game(
	_id_game INT
,	_id_system_user INT
,	_valor_vote INT
,	_comentario VARCHAR(200)
)
BEGIN
	DECLARE v_juego_existe INT DEFAULT 0;
	DECLARE v_usuario_existe INT DEFAULT 0;
	DECLARE v_ya_registro_juego INT DEFAULt 0;
	
    DECLARE next_v_id_value INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			SELECT 'Chango! Hubo un lio, asi que hacemos un Rollback';
			RESIGNAL;
		END;

	-- Validaciones Previas a la insercion
    
    SELECT COUNT(*) INTO v_juego_existe
    FROM coderhouse_gamers.GAME WHERE id_game = _id_game;

    
    SELECT COUNT(*) INTO v_usuario_existe
    FROM coderhouse_gamers.SYSTEM_USER WHERE id_system_user = _id_system_user;
    
        
    SELECT COUNT(*) INTO v_ya_registro_juego
    FROM coderhouse_gamers.PLAY 
		WHERE id_game = _id_game
        AND id_system_user = _id_system_user
        ;
    
    IF v_juego_existe = 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existe el juego';
	END IF;
    
    IF v_usuario_existe = 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existe el usuario';
	END IF;
    
    
	IF v_ya_registro_juego > 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ya esta jugando esta partida';
	END IF;
    

	START TRANSACTION;
    
    registro:BEGIN
		INSERT INTO coderhouse_gamers.PLAY (id_game,id_system_user,completed) 
        VALUES (_id_game, _id_system_user,FALSE);
    
		SAVEPOINT sp_checkpoint;
        
        
        IF _valor_vote IS NULL THEN LEAVE registro;
        END IF;
        
        IF _valor_vote < 1 OR _valor_vote > 10 THEN
			ROLLBACK TO SAVEPOINT sp_checkpoint;
            LEAVE registro;
        END IF;
        
        -- voto valido
        SELECT MAX(id_vote) + 1 INTO next_v_id_value FROM coderhouse_gamers.VOTE;
        
        INSERT INTO coderhouse_gamers.VOTE(id_vote,value,id_game,id_system_user)
        VALUES
        (next_v_id_value, _valor_vote,_id_game,_id_system_user);
        
        SAVEPOINT sp_checkpoint_vote;
        
        INSERT INTO coderhouse_gamers.COMMENT(id_game,id_system_user,first_date,last_date)
        VALUES
        (_id_game, _id_system_user, CURRENT_DATE(),NULL);
        
        INSERT INTO coderhouse_gamers.COMMENTARY(id_commentary,id_game,id_system_user,comment_date,commentary)
        SELECT 
			MAX(id_commentary) + 1 AS id_commentary_last,
			_id_game,
            _id_system_user,
            CURRENT_DATE(),
            TRIM(_comentario)
			FROM coderhouse_gamers.COMMENTARY;
	
    END registro;
    
    COMMIT;
    
END//

DELIMITER ;



CALL coderhouse_gamers.sp_registro_user_and_game(74,4,15,'Este comentario no se va a guardar!!!');

SELECT *
FROM coderhouse_gamers.VOTE 
	WHERE id_game = 74
	-- AND id_system_user = 3
	;



