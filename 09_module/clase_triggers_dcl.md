# Unidad 9: Triggers y Sublenguaje DCL

## Resumen Teórico para Clase

---

## Parte 1: TRIGGERS

### 1.1 Concepto General

Un **Trigger** (disparador) es un conjunto de instrucciones SQL que se almacena en el servidor de base de datos y se ejecuta **automáticamente** cuando ocurre un evento específico sobre una tabla. Los eventos que activan un trigger son operaciones de manipulación de datos (DML): `INSERT`, `UPDATE` y `DELETE`.

El trigger "se despierta" y ejecuta su lógica en el momento exacto en que ocurre la operación asociada, sin necesidad de intervención manual.

### 1.2 Usos Principales

**Tablas de Auditoría (Logs o Bitácoras)**

El uso más común de los triggers es alimentar tablas de auditoría. Estas tablas secundarias almacenan información que no es crítica para el negocio pero sí para el departamento de IT y seguridad informática:

- Quién creó un registro
- Fecha y hora de creación
- Quién modificó un registro y cuándo
- Quién eliminó un registro

Por ejemplo, mientras una tabla `Productos` guarda información comercial (código, descripción, precio), una tabla de auditoría paralela registra los cambios históricos sobre esos productos.

### 1.3 Tipos de Triggers según el Momento de Ejecución

| Tipo | Descripción |
|------|-------------|
| **BEFORE** | Se ejecuta **antes** de que la operación DML se realice sobre la tabla |
| **AFTER** | Se ejecuta **después** de que la operación DML se haya completado |

### 1.4 Sintaxis Básica

```sql
CREATE TRIGGER nombre_del_trigger
{BEFORE | AFTER} {INSERT | UPDATE | DELETE} ON nombre_tabla
FOR EACH ROW
BEGIN
    -- Lógica del trigger
    -- Instrucciones SQL
END;
```

### 1.5 Palabras Clave Importantes

- **`NEW`**: Hace referencia a los valores del nuevo registro (en operaciones INSERT y UPDATE). Se utiliza como `NEW.columna`.
- **`OLD`**: Hace referencia a los valores del registro antes del cambio (en operaciones UPDATE y DELETE).
- **`FOR EACH ROW`**: Indica que el trigger se ejecutará una vez por cada fila afectada por la operación. Es especialmente importante para operaciones masivas.

### 1.6 Funciones del Sistema Útiles en Triggers

**Funciones de Fecha y Hora:**
- `NOW()`: Fecha y hora actual
- `CURDATE()` o `CURRENT_DATE()`: Fecha actual
- `CURTIME()` o `CURRENT_TIME()`: Hora actual
- `CURRENT_TIMESTAMP()`: Fecha y hora actual (similar a NOW)

**Funciones de Usuario:**
- `USER()`: Usuario actual de la sesión
- `SESSION_USER()`: Usuario de la sesión actual
- `SYSTEM_USER()`: Usuario del sistema

**Funciones de Plataforma:**
- `DATABASE()`: Base de datos actual
- `VERSION()`: Versión de MySQL

---

## Parte 2: Sublenguaje DCL (Data Control Language)

### 2.1 Concepto General

El **Lenguaje de Control de Datos (DCL)** permite gestionar usuarios y sus permisos dentro del motor de base de datos MySQL. Con DCL podemos:

- Crear, renombrar y eliminar usuarios
- Establecer contraseñas
- Otorgar o revocar permisos sobre objetos de la base de datos

### 2.2 La Base de Datos del Sistema `mysql`

MySQL cuenta con una base de datos llamada **`mysql`** que almacena información del sistema. Dentro de ella, la tabla **`user`** contiene los datos de todos los usuarios y sus permisos:

```sql
USE mysql;
SELECT host, user, Select_priv, Insert_priv, Update_priv, Delete_priv 
FROM user;
```

### 2.3 Comandos DCL para Gestión de Usuarios

#### **CREATE USER**: Crear un nuevo usuario

```sql
-- Usuario sin contraseña
CREATE USER 'nombre_usuario'@'localhost';

-- Usuario con contraseña
CREATE USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'contraseña';

-- Usuario con dominio específico
CREATE USER 'admin'@'192.168.1.100' IDENTIFIED BY 'clave_segura';
```

Los dominios pueden ser:
- `'usuario'@'localhost'`: solo desde la misma máquina
- `'usuario'@'%'`: desde cualquier host
- `'usuario'@'192.168.1.%'`: desde un rango de IP

#### **ALTER USER**: Modificar contraseña

```sql
ALTER USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'nueva_contraseña';
```

#### **RENAME USER**: Renombrar un usuario

```sql
RENAME USER 'nombre_viejo'@'localhost' TO 'nombre_nuevo'@'localhost';
```

#### **DROP USER**: Eliminar un usuario

```sql
DROP USER 'nombre_usuario'@'localhost';
```

---

## Ejemplos Prácticos con la Base de Datos `coderhouse_gamers`

---

### Ejemplo 1: Trigger para Auditoría de Nuevos Juegos

**Objetivo:** Crear una tabla de auditoría que registre cada vez que se inserta un nuevo juego en la tabla `GAME`, almacenando quién lo hizo, cuándo y qué juego se agregó.

**Paso 1: Crear la tabla de auditoría**

```sql
USE coderhouse_gamers;

CREATE TABLE game_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_game INT,
    nombre_anterior VARCHAR(100),
    nombre_nuevo VARCHAR(100),
    accion VARCHAR(20),
    usuario VARCHAR(50),
    fecha DATETIME,
    ip_conexion VARCHAR(50)
);
```

**Paso 2: Crear el trigger AFTER INSERT**

```sql
DELIMITER //

CREATE TRIGGER trg_game_after_insert
AFTER INSERT ON game
FOR EACH ROW
BEGIN
    INSERT INTO game_auditoria (
        id_game, 
        nombre_nuevo, 
        accion, 
        usuario, 
        fecha, 
        ip_conexion
    ) VALUES (
        NEW.id_game,
        NEW.name,
        'INSERT',
        USER(),
        NOW(),
        (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END //

DELIMITER ;
```

**Paso 3: Probar el trigger**

```sql
-- Insertar un nuevo juego
INSERT INTO game (id_game, name, description, id_level, id_class) 
VALUES (101, 'The Legend of Zelda', 'Aventura épica', 10, 41);

-- Verificar la auditoría
SELECT * FROM game_auditoria;
```

---

### Ejemplo 2: Trigger BEFORE UPDATE para Evitar Cambios No Permitidos

**Objetivo:** Evitar que se modifique el nombre de un juego a un valor vacío o NULL.

```sql
DELIMITER //

CREATE TRIGGER trg_game_before_update
BEFORE UPDATE ON game
FOR EACH ROW
BEGIN
    -- Si el nuevo nombre está vacío o es NULL, mantener el anterior
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SET NEW.name = OLD.name;
    END IF;
END //

DELIMITER ;
```

**Prueba:**

```sql
-- Intentar actualizar con nombre vacío
UPDATE game SET name = '' WHERE id_game = 1;

-- Verificar que no se modificó
SELECT id_game, name FROM game WHERE id_game = 1;
```

---

### Ejemplo 3: Trigger para Auditoría de Eliminaciones

**Objetivo:** Registrar cuando alguien elimina un juego, guardando la información antes de que desaparezca.

```sql
DELIMITER //

CREATE TRIGGER trg_game_before_delete
BEFORE DELETE ON game
FOR EACH ROW
BEGIN
    INSERT INTO game_auditoria (
        id_game, 
        nombre_anterior, 
        accion, 
        usuario, 
        fecha
    ) VALUES (
        OLD.id_game,
        OLD.name,
        'DELETE',
        USER(),
        NOW()
    );
END //

DELIMITER ;
```

**Prueba:**

```sql
-- Eliminar un juego
DELETE FROM game WHERE id_game = 101;

-- Verificar la auditoría
SELECT * FROM game_auditoria WHERE accion = 'DELETE';
```

---

### Ejemplo 4: Trigger para Control de Integridad en Votaciones

**Objetivo:** Evitar que un usuario vote con un valor fuera del rango permitido (1 a 10).

```sql
DELIMITER //

CREATE TRIGGER trg_vote_before_insert
BEFORE INSERT ON vote
FOR EACH ROW
BEGIN
    -- Si el valor está fuera del rango 1-10, forzar a 1
    IF NEW.value < 1 OR NEW.value > 10 THEN
        SET NEW.value = 1;
    END IF;
END //

DELIMITER ;
```

**Prueba:**

```sql
-- Insertar un voto con valor inválido
INSERT INTO vote (id_vote, value, id_game, id_system_user) 
VALUES (1001, 15, 1, 5);

-- Verificar que se corrigió a 1
SELECT * FROM vote WHERE id_vote = 1001;
```

---

### Ejemplo 5: Gestión de Usuarios con DCL

**Crear usuarios para diferentes roles:**

```sql
-- Administrador con acceso completo
CREATE USER 'admin_gamers'@'localhost' IDENTIFIED BY 'Admin123!';

-- Usuario para consultas (solo lectura)
CREATE USER 'consultor'@'%' IDENTIFIED BY 'Consultor123!';

-- Usuario para mantenimiento
CREATE USER 'mantenimiento'@'192.168.1.%' IDENTIFIED BY 'Mant2024!';
```

**Otorgar permisos:**

```sql
-- Admin: todos los permisos sobre toda la base de datos
GRANT ALL PRIVILEGES ON coderhouse_gamers.* TO 'admin_gamers'@'localhost';

-- Consultor: solo SELECT en todas las tablas
GRANT SELECT ON coderhouse_gamers.* TO 'consultor'@'%';

-- Mantenimiento: permisos de INSERT, UPDATE, DELETE en tablas específicas
GRANT INSERT, UPDATE, DELETE ON coderhouse_gamers.game TO 'mantenimiento'@'192.168.1.%';
GRANT INSERT, UPDATE, DELETE ON coderhouse_gamers.vote TO 'mantenimiento'@'192.168.1.%';
```

**Verificar permisos:**

```sql
-- Ver permisos de un usuario
SHOW GRANTS FOR 'consultor'@'%';
```

**Revocar permisos:**

```sql
-- Quitar permiso de eliminación
REVOKE DELETE ON coderhouse_gamers.game FROM 'mantenimiento'@'192.168.1.%';
```

---

### Ejemplo 6: Crear un LOG de Conexiones de Usuarios

**Objetivo:** Crear un trigger que registre cada intento de inserción en `SYSTEM_USER` (simulando un alta de usuario).

```sql
-- Tabla de log de altas de usuarios del sistema
CREATE TABLE user_alta_log (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_system_user INT,
    nombre_completo VARCHAR(100),
    email VARCHAR(30),
    usuario_creador VARCHAR(50),
    fecha_alta DATETIME
);

DELIMITER //

CREATE TRIGGER trg_system_user_after_insert
AFTER INSERT ON system_user
FOR EACH ROW
BEGIN
    INSERT INTO user_alta_log (
        id_system_user,
        nombre_completo,
        email,
        usuario_creador,
        fecha_alta
    ) VALUES (
        NEW.id_system_user,
        CONCAT(NEW.first_name, ' ', NEW.last_name),
        NEW.email,
        USER(),
        NOW()
    );
END //

DELIMITER ;
```

**Prueba:**

```sql
-- Insertar un nuevo usuario
INSERT INTO system_user (id_system_user, first_name, last_name, email, password, id_user_type) 
VALUES (1001, 'Juan', 'Pérez', 'jperez@email.com', 'pass123', 1);

-- Verificar el log
SELECT * FROM user_alta_log;
```

---

## Resumen Visual de Conceptos

| Concepto | Propósito | Palabra Clave |
|----------|-----------|---------------|
| **Trigger BEFORE** | Ejecutar lógica antes de la operación | `BEFORE INSERT/UPDATE/DELETE` |
| **Trigger AFTER** | Ejecutar lógica después de la operación | `AFTER INSERT/UPDATE/DELETE` |
| **NEW** | Acceder a valores del nuevo registro | `NEW.columna` |
| **OLD** | Acceder a valores del registro antes del cambio | `OLD.columna` |
| **FOR EACH ROW** | Ejecutar por cada fila afectada | `FOR EACH ROW` |
| **CREATE USER** | Crear nuevo usuario | `CREATE USER 'user'@'host'` |
| **GRANT** | Otorgar permisos | `GRANT SELECT ON db.* TO 'user'@'host'` |
| **REVOKE** | Quitar permisos | `REVOKE DELETE ON db.* FROM 'user'@'host'` |

---

## Conclusión

Los **Triggers** son herramientas poderosas para mantener la integridad de los datos y llevar un registro automático de los cambios, especialmente útil para auditoría. El **lenguaje DCL** complementa esta funcionalidad permitiendo un control granular sobre quién puede hacer qué en la base de datos, garantizando así la seguridad y el orden en entornos multiusuario.Por supuesto. Aquí tienes un resumen teórico con ejemplos prácticos basados en la base de datos `coderhouse_gamers`.