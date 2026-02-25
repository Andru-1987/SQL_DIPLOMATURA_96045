CREATE DATABASE integridad_referencial;
USE integridad_referencial;

CREATE TABLE pais(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200)
);

CREATE TABLE ciudadano(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20),
    email VARCHAR(200),
    ciudad VARCHAR(200),
    pais_ref INT
);


-- Insertar países
INSERT INTO pais (nombre) VALUES 
('España'),
('México'),
('Argentina'),
('Colombia');

-- Insertar ciudadanos (entre 4 y 10 por país)
-- España (5 ciudadanos)
INSERT INTO ciudadano (dni, email, ciudad, pais_ref) VALUES
('12345678A', 'carlos.garcia@email.com', 'Madrid', 1),
('87654321B', 'maria.lopez@email.com', 'Barcelona', 1),
('45678912C', 'juan.rodriguez@email.com', 'Valencia', 1),
('78912345D', 'ana.martinez@email.com', 'Sevilla', 1),
('23456789E', 'pedro.sanchez@email.com', 'Bilbao', 1);

-- México (8 ciudadanos)
INSERT INTO ciudadano (dni, email, ciudad, pais_ref) VALUES
('MEX123456', 'javier.hernandez@email.com', 'Ciudad de México', 2),
('MEX234567', 'sofia.ramirez@email.com', 'Guadalajara', 2),
('MEX345678', 'diego.torres@email.com', 'Monterrey', 2),
('MEX456789', 'valeria.flores@email.com', 'Puebla', 2),
('MEX567890', 'luis.reyes@email.com', 'Tijuana', 2),
('MEX678901', 'fernanda.castro@email.com', 'León', 2),
('MEX789012', 'alejandro.guzman@email.com', 'Querétaro', 2),
('MEX890123', 'paulina.ortiz@email.com', 'Mérida', 2);

-- Argentina (6 ciudadanos)
INSERT INTO ciudadano (dni, email, ciudad, pais_ref) VALUES
('ARG1234567', 'martin.gonzalez@email.com', 'Buenos Aires', 3),
('ARG2345678', 'laura.diaz@email.com', 'Córdoba', 3),
('ARG3456789', 'pablo.fernandez@email.com', 'Rosario', 3),
('ARG4567890', 'carla.martinez@email.com', 'Mendoza', 3),
('ARG5678901', 'nicolas.lopez@email.com', 'La Plata', 3),
('ARG6789012', 'florencia.perez@email.com', 'San Miguel de Tucumán', 3);

-- Colombia (7 ciudadanos)
INSERT INTO ciudadano (dni, email, ciudad, pais_ref) VALUES
('COL1234567', 'andres.molina@email.com', 'Bogotá', 4),
('COL2345678', 'carolina.restrepo@email.com', 'Medellín', 4),
('COL3456789', 'camilo.ospina@email.com', 'Cali', 4),
('COL4567890', 'natalia.jimenez@email.com', 'Barranquilla', 4),
('COL5678901', 'felipe.gomez@email.com', 'Cartagena', 4),
('COL6789012', 'daniela.castro@email.com', 'Santa Marta', 4),
('COL7890123', 'santiago.ruiz@email.com', 'Pereira', 4);


-- QUERY DE TOTAL DE POBLACION
SELECT 
	COALESCE(p.id, NULL, "NO DETERMINADO") id_pais,
    p.nombre,
    COALESCE(COUNT(c.id), 1) as total_ciudadanos
FROM pais p
RIGHT JOIN ciudadano c ON p.id = c.pais_ref
GROUP BY p.id, p.nombre;



ALTER TABLE integridad_referencial.ciudadano
	ADD CONSTRAINT fk_restriccion_ciudadano
    FOREIGN KEY(pais_ref) REFERENCES integridad_referencial.pais(id)
    ON DELETE SET NULL -- RESTRICT -- NO ACTION
    ON UPDATE CASCADE;
    
    


DELETE FROM integridad_referencial.pais
	WHERE nombre LIKE 'Espa%';
	

UPDATE  integridad_referencial.pais
	SET nombre='República de Colombia',
		id=20
WHERE nombre LIKE 'Colombia';

-- IMPORTACION dentro de tablas productivas


CREATE TABLE integridad_referencial.importacion_jugador(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre	VARCHAR(200),
    apellido	VARCHAR(200),
    dob	DATE,
    posicion VARCHAR(200),	
    pie_habil	VARCHAR(200),
    valoracion	DECIMAL(12,2) DEFAULT 1000000.00,
    club INT
);


CREATE TABLE integridad_referencial.importacion_club(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre	VARCHAR(200),
    fecha_fundacion	DATE,
    socios	INT,
    patrocinador_ppal VARCHAR(200)
);


ALTER TABLE integridad_referencial.importacion_jugador
	ADD CONSTRAINT fk_contrato
    FOREIGN KEY(club) REFERENCES integridad_referencial.importacion_club(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

