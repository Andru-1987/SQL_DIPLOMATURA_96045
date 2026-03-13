# Ejercicios Prácticos - Triggers y DCL
## Base de Datos: coderhouse_gamers

---

## Estructura de la Clase Práctica

| Parte | Tema | Duración | Ejercicios |
|-------|------|----------|------------|
| 1 | Triggers - Fundamentos | 30 min | E1, E2 |
| 2 | Triggers - Casos de Uso | 30 min | E3, E4 |
| 3 | DCL - Gestión de Usuarios | 30 min | E5, E6 |
| 4 | Integración y Desafío Final | 30 min | E7 |

---

## Parte 1: Triggers - Fundamentos 

### Ejercicio E1: Trigger AFTER INSERT para Auditoría de Juegos

**Objetivo:** Crear un trigger que registre automáticamente cada nuevo juego agregado a la tabla `GAME`.

**Tablas involucradas:** `GAME`, `game_auditoria` (crear)

#### Consigna:
1. Crear una tabla llamada `game_auditoria` con los siguientes campos:
   - `id_auditoria` (INT, AUTO_INCREMENT, PRIMARY KEY)
   - `id_game` (INT)
   - `nombre_juego` (VARCHAR(100))
   - `descripcion` (VARCHAR(300))
   - `id_level` (INT)
   - `id_class` (INT)
   - `usuario` (VARCHAR(50))
   - `fecha_hora` (DATETIME)
   - `tipo_operacion` (VARCHAR(20)) - valor fijo 'INSERT'

2. Crear un trigger llamado `trg_game_after_insert` que:
   - Se ejecute DESPUÉS de cada INSERT en la tabla `GAME`
   - Inserte un registro en `game_auditoria` con los valores del nuevo juego
   - Use la función `USER()` para capturar el usuario
   - Use `NOW()` para la fecha y hora

<details>
<summary>Ver Solución E1</summary>

```sql
-- 1. Crear tabla de auditoría
USE coderhouse_gamers;

CREATE TABLE game_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_game INT NOT NULL,
    nombre_juego VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    id_level INT NOT NULL,
    id_class INT NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    tipo_operacion VARCHAR(20) NOT NULL
);

-- 2. Crear trigger AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_game_after_insert
AFTER INSERT ON game
FOR EACH ROW
BEGIN
    INSERT INTO game_auditoria (
        id_game,
        nombre_juego,
        descripcion,
        id_level,
        id_class,
        usuario,
        fecha_hora,
        tipo_operacion
    ) VALUES (
        NEW.id_game,
        NEW.name,
        NEW.description,
        NEW.id_level,
        NEW.id_class,
        USER(),
        NOW(),
        'INSERT'
    );
END //

DELIMITER ;

-- 3. Prueba del trigger
-- Insertar un nuevo juego
INSERT INTO game (id_game, name, description, id_level, id_class) 
VALUES (200, 'Clase Práctica - Nuevo Juego', 'Juego creado para probar trigger', 5, 41);

-- Verificar que se registró en auditoría
SELECT * FROM game_auditoria;
```
</details>

---

### Ejercicio E2: Trigger BEFORE UPDATE para Validación

**Objetivo:** Crear un trigger que impida modificar el nombre de un juego a un valor vacío.

**Tabla involucrada:** `GAME`

#### Consigna:
1. Crear un trigger llamado `trg_game_before_update` que:
   - Se ejecute ANTES de cada UPDATE en la tabla `GAME`
   - Verifique si el nuevo nombre (`NEW.name`) está vacío o es NULL
   - Si está vacío, mantener el nombre anterior (`OLD.name`)

2. Probar el trigger:
   - Actualizar un juego existente intentando poner nombre vacío
   - Verificar que el nombre no cambió

<details>
<summary>Ver Solución E2</summary>

```sql
DELIMITER //

CREATE TRIGGER trg_game_before_update
BEFORE UPDATE ON game
FOR EACH ROW
BEGIN
    -- Si el nuevo nombre está vacío o es NULL, mantener el original
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SET NEW.name = OLD.name;
    END IF;
END //

DELIMITER ;

-- Prueba del trigger
-- Ver el nombre actual del juego con ID 1
SELECT id_game, name FROM game WHERE id_game = 1;

-- Intentar actualizar con nombre vacío
UPDATE game SET name = '' WHERE id_game = 1;

-- Verificar que el nombre NO cambió
SELECT id_game, name FROM game WHERE id_game = 1;

-- Actualizar con nombre válido (debería funcionar)
UPDATE game SET name = 'Forza Horizon 5 - Edición Actualizada' WHERE id_game = 1;

-- Verificar el cambio
SELECT id_game, name FROM game WHERE id_game = 1;
```
</details>

---

## Parte 2: Triggers - Casos de Uso Avanzados (30 minutos)

### Ejercicio E3: Trigger para Control de Votaciones

**Objetivo:** Crear un trigger que valide y registre los votos de los usuarios, asegurando que estén en el rango correcto.

**Tablas involucradas:** `VOTE`, `voto_auditoria` (crear)

#### Consigna:
1. Crear una tabla `voto_auditoria` para registrar intentos de voto inválidos:
   - `id_auditoria` (INT, AUTO_INCREMENT, PRIMARY KEY)
   - `id_vote` (INT)
   - `valor_intentado` (INT)
   - `id_game` (INT)
   - `id_system_user` (INT)
   - `fecha` (DATETIME)
   - `mensaje` (VARCHAR(100))

2. Crear un trigger `trg_vote_before_insert` que:
   - Se ejecute ANTES de INSERT en `VOTE`
   - Si el valor está entre 1 y 10, permitir la inserción normalmente
   - Si el valor está fuera de rango (<1 o >10):
     - Insertar un registro en `voto_auditoria` con el valor intentado
     - Cancelar la inserción del voto (generar un error)

3. Usar `SIGNAL SQLSTATE` para generar el error

<details>
<summary>Ver Solución E3</summary>

```sql
-- 1. Crear tabla de auditoría para votos inválidos
CREATE TABLE voto_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_vote INT NOT NULL,
    valor_intentado INT NOT NULL,
    id_game INT NOT NULL,
    id_system_user INT NOT NULL,
    fecha DATETIME NOT NULL,
    mensaje VARCHAR(100) NOT NULL
);

-- 2. Crear trigger con validación
DELIMITER //

CREATE TRIGGER trg_vote_before_insert
BEFORE INSERT ON vote
FOR EACH ROW
BEGIN
    -- Validar rango de votación (1 a 10)
    IF NEW.value < 1 OR NEW.value > 10 THEN
        -- Registrar el intento inválido
        INSERT INTO voto_auditoria (
            id_vote,
            valor_intentado,
            id_game,
            id_system_user,
            fecha,
            mensaje
        ) VALUES (
            NEW.id_vote,
            NEW.value,
            NEW.id_game,
            NEW.id_system_user,
            NOW(),
            'Intento de voto con valor fuera de rango'
        );
        
        -- Cancelar la inserción con un mensaje de error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El valor del voto debe estar entre 1 y 10';
    END IF;
END //

DELIMITER ;

-- 3. Pruebas
-- Probar voto válido (debería funcionar)
INSERT INTO vote (id_vote, value, id_game, id_system_user) 
VALUES (2000, 8, 1, 10);

-- Verificar que se insertó
SELECT * FROM vote WHERE id_vote = 2000;

-- Probar voto inválido (debería fallar y registrar en auditoría)
INSERT INTO vote (id_vote, value, id_game, id_system_user) 
VALUES (2001, 15, 1, 11);

-- Verificar que se registró en auditoría
SELECT * FROM voto_auditoria;
```
</details>

---

### Ejercicio E4: Trigger BEFORE DELETE con Auditoría

**Objetivo:** Crear un trigger que registre en una tabla de auditoría los juegos que se eliminan, antes de que desaparezcan.

**Tablas involucradas:** `GAME`, `game_auditoria` (ya creada en E1)

#### Consigna:
1. Modificar la tabla `game_auditoria` (o crear una nueva si prefieres) para que pueda almacenar también eliminaciones
2. Crear un trigger `trg_game_before_delete` que:
   - Se ejecute ANTES de DELETE en `GAME`
   - Inserte un registro en `game_auditoria` con los datos del juego que se está eliminando
   - El campo `tipo_operacion` debe ser 'DELETE'

<details>
<summary>Ver Solución E4</summary>

```sql
-- Nota: Si ya creaste game_auditoria en E1, puedes usarla directamente
-- Si no, créala con esta estructura:

CREATE TABLE IF NOT EXISTS game_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_game INT NOT NULL,
    nombre_juego VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    id_level INT NOT NULL,
    id_class INT NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    tipo_operacion VARCHAR(20) NOT NULL
);

-- Crear trigger BEFORE DELETE
DELIMITER //

CREATE TRIGGER trg_game_before_delete
BEFORE DELETE ON game
FOR EACH ROW
BEGIN
    INSERT INTO game_auditoria (
        id_game,
        nombre_juego,
        descripcion,
        id_level,
        id_class,
        usuario,
        fecha_hora,
        tipo_operacion
    ) VALUES (
        OLD.id_game,
        OLD.name,
        OLD.description,
        OLD.id_level,
        OLD.id_class,
        USER(),
        NOW(),
        'DELETE'
    );
END //

DELIMITER ;

-- Prueba del trigger
-- Primero, insertar un juego para luego eliminarlo
INSERT INTO game (id_game, name, description, id_level, id_class) 
VALUES (201, 'Juego Temporal', 'Será eliminado', 3, 25);

-- Verificar que existe
SELECT * FROM game WHERE id_game = 201;

-- Eliminar el juego
DELETE FROM game WHERE id_game = 201;

-- Verificar que se registró en auditoría
SELECT * FROM game_auditoria WHERE id_game = 201;
```
</details>

---

## Parte 3: DCL - Gestión de Usuarios (30 minutos)

### Ejercicio E5: Creación y Gestión de Usuarios

**Objetivo:** Practicar la creación, modificación y eliminación de usuarios en MySQL.

#### Consigna:
1. Crear los siguientes usuarios con sus respectivas contraseñas:
   - `lector_gamers`@`localhost` con contraseña `Lectura2024`
   - `editor_gamers`@`%` con contraseña `Edicion2024`
   - `admin_gamers`@`192.168.1.%` con contraseña `Admin2024!`

2. Modificar la contraseña del usuario `lector_gamers` a `NuevoPass123`

3. Renombrar el usuario `editor_gamers` a `colaborador_gamers`

4. Eliminar el usuario `admin_gamers`

5. Verificar todos los cambios consultando la tabla `mysql.user`

<details>
<summary>Ver Solución E5</summary>

```sql
-- 1. Crear usuarios
CREATE USER 'lector_gamers'@'localhost' IDENTIFIED BY 'Lectura2024';
CREATE USER 'editor_gamers'@'%' IDENTIFIED BY 'Edicion2024';
CREATE USER 'admin_gamers'@'192.168.1.%' IDENTIFIED BY 'Admin2024!';

-- Verificar creación
SELECT user, host FROM mysql.user 
WHERE user IN ('lector_gamers', 'editor_gamers', 'admin_gamers');

-- 2. Modificar contraseña
ALTER USER 'lector_gamers'@'localhost' IDENTIFIED BY 'NuevoPass123';

-- 3. Renombrar usuario
RENAME USER 'editor_gamers'@'%' TO 'colaborador_gamers'@'%';

-- 4. Eliminar usuario
DROP USER 'admin_gamers'@'192.168.1.%';

-- 5. Verificar cambios finales
SELECT user, host FROM mysql.user 
WHERE user IN ('lector_gamers', 'colaborador_gamers', 'admin_gamers');
```
</details>

---

### Ejercicio E6: Gestión de Permisos (GRANT y REVOKE)

**Objetivo:** Asignar y revocar permisos específicos sobre la base de datos `coderhouse_gamers`.

#### Consigna:
1. Utilizando los usuarios creados en el ejercicio anterior:

   a. Otorgar permisos al usuario `lector_gamers`@`localhost`:
      - Solo SELECT en TODAS las tablas de `coderhouse_gamers`

   b. Otorgar permisos al usuario `colaborador_gamers`@`%`:
      - SELECT, INSERT, UPDATE en las tablas `GAME` y `VOTE`
      - Solo SELECT en las demás tablas

   c. Crear un nuevo usuario `reportes_gamers`@`localhost` con contraseña `Reportes2024`
      - Otorgarle permisos solo de SELECT en las tablas `GAME` y `SYSTEM_USER`

2. Verificar los permisos otorgados con `SHOW GRANTS`

3. Revocar el permiso de UPDATE de `colaborador_gamers` en la tabla `VOTE`

4. Verificar los cambios

<details>
<summary>Ver Solución E6</summary>

```sql
-- 1a. Permisos para lector_gamers (solo SELECT en todo)
GRANT SELECT ON coderhouse_gamers.* TO 'lector_gamers'@'localhost';

-- 1b. Permisos para colaborador_gamers
-- Permisos específicos en GAME y VOTE
GRANT SELECT, INSERT, UPDATE ON coderhouse_gamers.game TO 'colaborador_gamers'@'%';
GRANT SELECT, INSERT, UPDATE ON coderhouse_gamers.vote TO 'colaborador_gamers'@'%';

-- Permisos de solo SELECT en las demás tablas
GRANT SELECT ON coderhouse_gamers.class TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.comment TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.commentary TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.level_game TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.play TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.suggest TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.system_user TO 'colaborador_gamers'@'%';
GRANT SELECT ON coderhouse_gamers.user_type TO 'colaborador_gamers'@'%';

-- 1c. Crear usuario de reportes y otorgar permisos
CREATE USER 'reportes_gamers'@'localhost' IDENTIFIED BY 'Reportes2024';
GRANT SELECT ON coderhouse_gamers.game TO 'reportes_gamers'@'localhost';
GRANT SELECT ON coderhouse_gamers.system_user TO 'reportes_gamers'@'localhost';

-- 2. Verificar permisos
SHOW GRANTS FOR 'lector_gamers'@'localhost';
SHOW GRANTS FOR 'colaborador_gamers'@'%';
SHOW GRANTS FOR 'reportes_gamers'@'localhost';

-- 3. Revocar permiso de UPDATE en VOTE para colaborador_gamers
REVOKE UPDATE ON coderhouse_gamers.vote FROM 'colaborador_gamers'@'%';

-- 4. Verificar que el permiso ya no está
SHOW GRANTS FOR 'colaborador_gamers'@'%';
```
</details>

---

## Parte 4: Integración y Desafío Final (30 minutos)

### Ejercicio E7: Proyecto Integrador - Sistema de Moderación de Comentarios

**Objetivo:** Crear un sistema completo de moderación para los comentarios de los usuarios, combinando triggers y una tabla de auditoría, y gestionar los usuarios que tendrán acceso al sistema.

**Contexto:** La plataforma de juegos necesita un sistema que:
- Registre todos los comentarios nuevos en una tabla de auditoría
- Evite comentarios con palabras prohibidas
- Permita a usuarios moderadores ocultar comentarios inapropiados
- Gestione diferentes roles con permisos específicos

#### Consigna Completa:

**Parte A: Estructura de Datos (5 minutos)**

1. Crear una tabla `palabras_prohibidas` con:
   - `id_palabra` INT AUTO_INCREMENT PRIMARY KEY
   - `palabra` VARCHAR(50) UNIQUE NOT NULL
   - `fecha_registro` DATETIME
   - `usuario_registro` VARCHAR(50)

2. Crear una tabla `comentario_auditoria` para registrar todos los comentarios:
   - `id_auditoria` INT AUTO_INCREMENT PRIMARY KEY
   - `id_commentary` INT
   - `id_game` INT
   - `id_system_user` INT
   - `comentario_original` VARCHAR(200)
   - `comentario_moderado` VARCHAR(200)
   - `estado` ENUM('aprobado', 'pendiente', 'rechazado')
   - `fecha_comentario` DATE
   - `fecha_registro` DATETIME
   - `usuario_moderador` VARCHAR(50)
   - `observaciones` VARCHAR(200)

**Parte B: Triggers (10 minutos)**

3. Crear un trigger `trg_commentary_before_insert` que:
   - Verifique si el comentario contiene alguna palabra prohibida
   - Si contiene, cambiar el comentario por "[COMENTARIO MODERADO]" y registrar en auditoría con estado 'rechazado'
   - Si no contiene, registrar en auditoría con estado 'aprobado'
   - La verificación debe ser insensible a mayúsculas/minúsculas

4. Insertar algunas palabras prohibidas de ejemplo: "spam", "publicidad", "trampa", "hack"

**Parte C: DCL - Gestión de Roles (10 minutos)**

5. Crear los siguientes usuarios con sus roles:
   - `moderador1`@`localhost` - Podrá leer comentarios y actualizar el estado
   - `supervisor`@`%` - Podrá gestionar palabras prohibidas
   - `analista`@`localhost` - Solo podrá consultar las tablas de auditoría

6. Asignar los permisos correspondientes según el rol

**Parte D: Prueba Integral (5 minutos)**

7. Probar todo el sistema:
   - Insertar un comentario normal
   - Insertar un comentario con palabra prohibida
   - Verificar la tabla de auditoría
   - Probar que los permisos funcionan (simulado)

<details>
<summary>Ver Solución E7 (Partes A y B)</summary>

```sql
-- PARTE A: Estructura de Datos

-- 1. Tabla de palabras prohibidas
CREATE TABLE palabras_prohibidas (
    id_palabra INT AUTO_INCREMENT PRIMARY KEY,
    palabra VARCHAR(50) UNIQUE NOT NULL,
    fecha_registro DATETIME DEFAULT NOW(),
    usuario_registro VARCHAR(50) DEFAULT USER()
);

-- 2. Tabla de auditoría de comentarios
CREATE TABLE comentario_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_commentary INT NOT NULL,
    id_game INT NOT NULL,
    id_system_user INT NOT NULL,
    comentario_original VARCHAR(200) NOT NULL,
    comentario_moderado VARCHAR(200),
    estado ENUM('aprobado', 'pendiente', 'rechazado') DEFAULT 'pendiente',
    fecha_comentario DATE NOT NULL,
    fecha_registro DATETIME DEFAULT NOW(),
    usuario_moderador VARCHAR(50),
    observaciones VARCHAR(200)
);

-- PARTE B: Triggers

-- 4. Insertar palabras prohibidas de ejemplo
INSERT INTO palabras_prohibidas (palabra) VALUES 
('spam'), 
('publicidad'), 
('trampa'), 
('hack'), 
('estafa');

-- 3. Trigger de moderación
DELIMITER //

CREATE TRIGGER trg_commentary_before_insert
BEFORE INSERT ON commentary
FOR EACH ROW
BEGIN
    DECLARE palabra_encontrada VARCHAR(50);
    DECLARE contiene_prohibida BOOLEAN DEFAULT FALSE;
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor para recorrer palabras prohibidas
    DECLARE cur_palabras CURSOR FOR 
        SELECT palabra FROM palabras_prohibidas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Verificar si el comentario contiene alguna palabra prohibida
    OPEN cur_palabras;
    
    verificar: LOOP
        FETCH cur_palabras INTO palabra_encontrada;
        IF done THEN
            LEAVE verificar;
        END IF;
        
        -- Búsqueda insensible a mayúsculas/minúsculas
        IF LOWER(NEW.commentary) LIKE CONCAT('%', LOWER(palabra_encontrada), '%') THEN
            SET contiene_prohibida = TRUE;
            SET palabra_encontrada = palabra_encontrada;
            LEAVE verificar;
        END IF;
    END LOOP;
    
    CLOSE cur_palabras;
    
    -- Registrar en auditoría según el resultado
    IF contiene_prohibida THEN
        -- Rechazar el comentario
        INSERT INTO comentario_auditoria (
            id_commentary, id_game, id_system_user, 
            comentario_original, comentario_moderado, estado, 
            fecha_comentario, observaciones
        ) VALUES (
            NEW.id_commentary, NEW.id_game, NEW.id_system_user,
            NEW.commentary, '[COMENTARIO MODERADO]', 'rechazado',
            NEW.comment_date, CONCAT('Contiene palabra prohibida: ', palabra_encontrada)
        );
        
        -- Modificar el comentario original
        SET NEW.commentary = '[COMENTARIO MODERADO]';
    ELSE
        -- Aprobar el comentario
        INSERT INTO comentario_auditoria (
            id_commentary, id_game, id_system_user, 
            comentario_original, estado, fecha_comentario
        ) VALUES (
            NEW.id_commentary, NEW.id_game, NEW.id_system_user,
            NEW.commentary, 'aprobado',
            NEW.comment_date
        );
    END IF;
END //

DELIMITER ;
```
</details>

<details>
<summary>Ver Solución E7 (Partes C y D)</summary>

```sql
-- PARTE C: DCL - Gestión de Roles

-- 5. Crear usuarios
CREATE USER 'moderador1'@'localhost' IDENTIFIED BY 'Moderador2024';
CREATE USER 'supervisor'@'%' IDENTIFIED BY 'Supervisor2024';
CREATE USER 'analista'@'localhost' IDENTIFIED BY 'Analista2024';

-- 6. Asignar permisos según rol

-- Moderador: puede leer comentarios y actualizar estado
GRANT SELECT ON coderhouse_gamers.commentary TO 'moderador1'@'localhost';
GRANT SELECT ON coderhouse_gamers.comment TO 'moderador1'@'localhost';
GRANT SELECT, UPDATE ON coderhouse_gamers.comentario_auditoria TO 'moderador1'@'localhost';

-- Supervisor: gestión completa de palabras prohibidas
GRANT ALL PRIVILEGES ON coderhouse_gamers.palabras_prohibidas TO 'supervisor'@'%';
GRANT SELECT ON coderhouse_gamers.comentario_auditoria TO 'supervisor'@'%';

-- Analista: solo lectura en tablas de auditoría
GRANT SELECT ON coderhouse_gamers.comentario_auditoria TO 'analista'@'localhost';
GRANT SELECT ON coderhouse_gamers.palabras_prohibidas TO 'analista'@'localhost';

-- Verificar permisos
SHOW GRANTS FOR 'moderador1'@'localhost';
SHOW GRANTS FOR 'supervisor'@'%';
SHOW GRANTS FOR 'analista'@'localhost';

-- PARTE D: Prueba Integral

-- 7a. Insertar comentario normal (debería aprobarse)
INSERT INTO commentary (id_commentary, id_game, id_system_user, comment_date, commentary) 
VALUES (2000, 1, 5, CURDATE(), 'Excelente juego, me encantó la jugabilidad');

-- 7b. Insertar comentario con palabra prohibida (debería moderarse)
INSERT INTO commentary (id_commentary, id_game, id_system_user, comment_date, commentary) 
VALUES (2001, 1, 6, CURDATE(), 'Este juego tiene publicidad molesta y es una trampa');

-- 7c. Verificar resultados en auditoría
SELECT * FROM comentario_auditoria;

-- Verificar los comentarios reales en la tabla commentary
SELECT id_commentary, commentary FROM commentary 
WHERE id_commentary IN (2000, 2001);

-- 7d. Probar permisos (simulado - estos comandos se ejecutarían con cada usuario)
-- Con usuario analista:
-- SELECT * FROM comentario_auditoria; -- Debería funcionar
-- INSERT INTO palabras_prohibidas (palabra) VALUES ('nuevapalabra'); -- Debería fallar

-- Con usuario supervisor:
-- INSERT INTO palabras_prohibidas (palabra) VALUES ('nuevapalabra'); -- Debería funcionar
```
</details>

---

## Resumen de la Clase

| Ejercicio | Tema | Conceptos Clave |
|-----------|------|-----------------|
| E1 | AFTER INSERT | Auditoría básica, NEW, USER(), NOW() |
| E2 | BEFORE UPDATE | Validación, NEW vs OLD |
| E3 | BEFORE INSERT con validación | SIGNAL SQLSTATE, auditoría de intentos |
| E4 | BEFORE DELETE | OLD, registro antes de eliminar |
| E5 | Gestión de usuarios | CREATE, ALTER, RENAME, DROP USER |
| E6 | Permisos | GRANT, REVOKE, SHOW GRANTS |
| E7 | Proyecto integrador | Todos los conceptos combinados |

---

## Material de Apoyo para el Alumno

### Sintaxis Rápida

```sql
-- Triggers
CREATE TRIGGER nombre
{BEFORE | AFTER} {INSERT | UPDATE | DELETE} ON tabla
FOR EACH ROW
BEGIN
    -- Lógica con NEW y OLD
END;

-- Gestión de usuarios
CREATE USER 'usuario'@'host' IDENTIFIED BY 'password';
ALTER USER 'usuario'@'host' IDENTIFIED BY 'nuevo_password';
RENAME USER 'viejo'@'host' TO 'nuevo'@'host';
DROP USER 'usuario'@'host';

-- Permisos
GRANT permiso ON base_datos.tabla TO 'usuario'@'host';
REVOKE permiso ON base_datos.tabla FROM 'usuario'@'host';
SHOW GRANTS FOR 'usuario'@'host';
```

### Funciones Útiles
- `USER()`: Usuario actual
- `NOW()`: Fecha y hora actual
- `CURDATE()`: Fecha actual
- `DATABASE()`: Base de datos actual