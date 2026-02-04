/*
Ejercicios sobre Tablas y Relaciones
Páginas 10-16: Creación y análisis de tablas friend y troops.
Paso 1: Crear la tabla Friend dentro del esquema Gammers usando CREATE TABLE.
Paso 2: Insertar registros en la tabla Friend. En la columna troop, se deben usar números que coincidirán con otra tabla.
Paso 3: Crear la tabla troops usando CREATE TABLE.
Paso 4: Insertar registros en la tabla troops, asegurando que los valores en su columna id coincidan con los números usados en friend.troop.

Análisis: Responder:  
¿Por qué se pueden eliminar registros en friend a pesar de tener una relación lógica con troops?
¿Por qué NO se pueden eliminar registros en troops si hay registros en friend que dependen de ellos?
-- 


integgridad referencial

*/

-- PAINT-BALL

-- siempre va en el lado de la cardinalidad de muchos
-- <FRIEND>   n -- {} -- 1 <TROOP>
-- dimensional --> informacion de un usuario nombre, division, email, FK referencial TROOP
-- dimensional -> equipo, nombre, categoria




CREATE TABLE coderhouse_gamers.FRIEND(
	id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(200),
    email VARCHAR(200) UNIQUE,
    id_troop INT, -- FK
    PRIMARY KEY (id)
    -- , FOREIGN KEY(id_troop) REFERENCES coderhouse_gamers.TROOP(id)
);

CREATE TABLE coderhouse_gamers.TROOP(
	id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(200) UNIQUE,
	PRIMARY KEY(id)
);


ALTER TABLE coderhouse_gamers.FRIEND
	ADD FOREIGN KEY(id_troop) REFERENCES coderhouse_gamers.TROOP(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


INSERT INTO coderhouse_gamers.FRIEND 
VALUES
(DEFAULT,  "pepe", "pepe@mail.com", 1);


INSERT INTO coderhouse_gamers.TROOP
VALUES
(DEFAULT, "tropa do elite");

-- Registros para TROOP
INSERT INTO coderhouse_gamers.TROOP (nombre) VALUES
('Alpha Squad'),
('Beta Force'),
('Gamma Legion');


-- Registros para FRIEND
INSERT INTO coderhouse_gamers.FRIEND (nombre, email, id_troop) VALUES
('Juan Perez', 'juan.perez@gmail.com', 1),
('Maria Gomez', 'maria.gomez@gmail.com', 1),
('Lucas Fernandez', 'lucas.fernandez@gmail.com', 2),
('Sofia Martinez', 'sofia.martinez@gmail.com', 2),
('Martin Lopez', 'martin.lopez@gmail.com', 3),
('Valentina Suarez', 'valentina.suarez@gmail.com', 3),
('Nicolas Romero', 'nicolas.romero@gmail.com', 1),
('Camila Torres', 'camila.torres@gmail.com', 2),
('Agustin Morales', 'agustin.morales@gmail.com', 3),
('Florencia Diaz', 'florencia.diaz@gmail.com', 1);



SELECT * FROM coderhouse_gamers.TROOP;

SELECT * FROM coderhouse_gamers.FRIEND;

DELETE FROM coderhouse_gamers.FRIEND AS f
WHERE f.id = 1;


DELETE FROM coderhouse_gamers.TROOP AS t
WHERE t.id = 2;



UPDATE coderhouse_gamers.TROOP AS t
	SET t.id = 10
	WHERE t.id = 3;



-- CREAR MI DB en base al DER generado

DROP DATABASE IF EXISTS andru_house;

CREATE DATABASE andru_house;
USE andru_house;


CREATE TABLE andru_house.DOCENTE(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100)
);

CREATE TABLE andru_house.MATERIA(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200)
);

CREATE TABLE andru_house.ALUMNO(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(120)
);



CREATE TABLE andru_house.NOTAS(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    calificacion VARCHAR(30)
);

CREATE TABLE andru_house.ESTADO_CURSO(
	id_alumno INT,
    idcurso INT,
    id_nota INT,
    estado VARCHAR(200)  -- agregar un campo que sea calificacion
);


-- BUENO, MALO, REGULAR, APROBADO  -> 4
-- 0.00, 0.01, 0.02   ....  -> 10.00

CREATE TABLE andru_house.CERTIFICADO(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    fecha_emision DATE DEFAULT(CURRENT_DATE)
);


CREATE TABLE andru_house.CURSO(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200),
    id_docente INT,
    id_materia INT
);




-- ALTERACIONES PARA LAS FK de

ALTER TABLE andru_house.CURSO
	ADD FOREIGN KEY (id_docente) REFERENCES andru_house.DOCENTE(id);

ALTER TABLE andru_house.CURSO
	ADD FOREIGN KEY (id_materia) REFERENCES andru_house.MATERIA(id);
    
    
ALTER TABLE andru_house.ESTADO_CURSO
	ADD FOREIGN KEY (id_alumno) REFERENCES andru_house.ALUMNO(id);

ALTER TABLE andru_house.ESTADO_CURSO
	ADD FOREIGN KEY (idcurso) REFERENCES andru_house.CURSO(id);

ALTER TABLE andru_house.ESTADO_CURSO
	ADD FOREIGN KEY (id_nota) REFERENCES andru_house.NOTAS(id);


ALTER TABLE andru_house.CERTIFICADO
	ADD FOREIGN KEY (id_alumno) REFERENCES andru_house.ALUMNO(id);


-- agregado PK
ALTER TABLE andru_house.ESTADO_CURSO
	ADD PRIMARY KEY (id_alumno,idcurso);



