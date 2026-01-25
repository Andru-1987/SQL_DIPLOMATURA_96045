# Unidad 03 - Consultas, Subconsultas y DDL

[_Material en clase_](https://docs.google.com/presentation/d/1sEJj0T3u-4-DvFYFwYO25pjEI_Uc579GxWDzi31V37g/edit?slide=id.p132#slide=id.p132)


## **Posta 1: UNION y Tipos de Datos (20 minutos)**

### **Ejercicio 1 (Material PDF – Págs. 9-10):**
Unir los juegos de nivel 1 y nivel 2 en una sola lista sin duplicados.

```sql
-- Usando la tabla GAME, unir juegos de nivel 1 y nivel 2
SELECT id_game, name, description, id_level, id_class 
FROM GAME 
WHERE id_level = 1 
UNION 
SELECT id_game, name, description, id_level, id_class 
FROM GAME 
WHERE id_level = 2;
```

### **Ejercicio Adicional 1:**
Unir los usuarios cuyo tipo sea 1 con los usuarios cuyo tipo sea 2, mostrando nombre, apellido y tipo.

```sql
SELECT first_name, last_name, id_user_type
FROM SYSTEM_USER
WHERE id_user_type = 1
UNION
SELECT first_name, last_name, id_user_type
FROM SYSTEM_USER
WHERE id_user_type = 2;
```

---

## **Posta 2: Operador LIKE y Comodines (30 minutos)**

### **Ejercicio 2 (Material PDF – Pág. 23):**
Realizar las siguientes consultas sobre la tabla `SYSTEM_USER`:

```sql
-- 1. Usuarios cuyo nombre comience con 'J'
SELECT * FROM SYSTEM_USER WHERE first_name LIKE 'J%';

-- 2. Usuarios cuyo apellido contenga la letra 'W'
SELECT * FROM SYSTEM_USER WHERE last_name LIKE '%W%';

-- 3. Usuarios cuyo nombre contenga 'i' en segundo lugar
SELECT * FROM SYSTEM_USER WHERE first_name LIKE '_i%';

-- 4. Usuarios cuyo nombre finalice con 'k'
SELECT * FROM SYSTEM_USER WHERE first_name LIKE '%k';

-- 5. Usuarios cuyo nombre NO incluya 'ch'
SELECT * FROM SYSTEM_USER WHERE first_name NOT LIKE '%ch%';

-- 6. Usuarios cuyo nombre incluya 'ch' en cualquier posición
SELECT * FROM SYSTEM_USER WHERE first_name LIKE '%ch%';
```

### **Ejercicio Adicional 2:**
Buscar en la tabla `GAME`:
- Juegos cuyo nombre comience con 'F'
- Juegos que contengan la palabra 'Ultimate'
- Juegos cuyo nombre termine con '2022'

```sql
-- Comienza con F
SELECT * FROM GAME WHERE name LIKE 'F%';

-- Contiene 'Ultimate'
SELECT * FROM GAME WHERE name LIKE '%Ultimate%';

-- Termina con '2022'
SELECT * FROM GAME WHERE name LIKE '%2022';
```

---

## **Posta 3: Subconsultas SQL (40 minutos)**

### **Ejercicio 3 (Material PDF – Págs. 26-27):**
Mostrar los usuarios que tienen el tipo de usuario con el ID más alto.

```sql
SELECT id_system_user, first_name, last_name 
FROM SYSTEM_USER 
WHERE id_user_type = (SELECT MAX(id_user_type) FROM USER_TYPE);
```

### **Ejercicio 4 (Material PDF – Pág. 31):**
1. **Juegos jugados por jugador:** Listar los juegos que cada usuario ha jugado (completados).

```sql
SELECT su.first_name, su.last_name, g.name, p.completed
FROM SYSTEM_USER su
JOIN PLAY p ON su.id_system_user = p.id_system_user
JOIN GAME g ON p.id_game = g.id_game
WHERE p.completed = TRUE;
```

2. **Usuarios que han jugado más de 3 juegos (usando HAVING):**

```sql
SELECT su.id_system_user, su.first_name, su.last_name, COUNT(p.id_game) AS total_juegos
FROM SYSTEM_USER su
JOIN PLAY p ON su.id_system_user = p.id_system_user
GROUP BY su.id_system_user, su.first_name, su.last_name
HAVING COUNT(p.id_game) > 3;
```

### **Ejercicio Adicional 3:**
Encontrar los juegos que han recibido votos con valor mayor al promedio.

```sql
SELECT g.name, v.value
FROM GAME g
JOIN VOTE v ON g.id_game = v.id_game
WHERE v.value > (SELECT AVG(value) FROM VOTE);
```

---

## **Posta 4: Funciones Escalares y DDL (40 minutos)**

### **Ejercicio 5 (Material PDF – Pág. 51 adaptado):**
Usar funciones escalares con datos de la base:

```sql
-- 1. Concatenar nombre y apellido de usuarios
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo 
FROM SYSTEM_USER;

-- 2. Convertir nombres a mayúsculas y minúsculas
SELECT UPPER(first_name) AS nombre_mayus, LOWER(last_name) AS apellido_minus 
FROM SYSTEM_USER;

-- 3. Dividir el ID del usuario por 10 (ejemplo numérico)
SELECT id_system_user, (id_system_user / 10) AS division FROM SYSTEM_USER;

-- 4. Valor absoluto del resultado anterior
SELECT id_system_user, ABS(id_system_user / 10) AS valor_absoluto FROM SYSTEM_USER;

-- 5. Días transcurridos desde el primer comentario hasta hoy
SELECT id_system_user, first_date, DATEDIFF(CURDATE(), first_date) AS dias_desde_comentario 
FROM COMMENT;

-- 6. Día de la semana del primer comentario
SELECT id_system_user, first_date, DAYNAME(first_date) AS dia_semana 
FROM COMMENT;
```

### **Ejercicio 6 (Material PDF – Pág. 33):**
Practicar con DDL usando la tabla `friend` (crear, truncar, eliminar).

```sql
-- 1. Crear tabla FRIEND (si no existe)
CREATE TABLE IF NOT EXISTS FRIEND (
    id_friend INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    age INT
);

-- 2. Insertar datos
INSERT INTO FRIEND (name, age) VALUES ('Juan', 25), ('Ana', 30);

-- 3. Truncar tabla (eliminar todos los datos)
TRUNCATE TABLE FRIEND;

-- 4. Eliminar tabla
DROP TABLE FRIEND;
```

### **Ejercicio Adicional 4:**
Calcular la longitud de los nombres de los juegos y extraer los primeros 10 caracteres.

```sql
SELECT name, CHAR_LENGTH(name) AS longitud, SUBSTRING(name, 1, 10) AS primeros_10 
FROM GAME;
```

---

## **Cierre y Repaso (20 minutos)**

### **Actividad de Integración:**
Crear una consulta que:
1. Una usuarios con juegos jugados
2. Filtre por juegos completados
3. Agrupe por usuario contando juegos
4. Muestre solo los que tienen más de 2 juegos completados
5. Ordene por cantidad de juegos descendente

```sql
SELECT 
    su.first_name, 
    su.last_name, 
    COUNT(p.id_game) AS juegos_completados
FROM SYSTEM_USER su
JOIN PLAY p ON su.id_system_user = p.id_system_user
WHERE p.completed = TRUE
GROUP BY su.id_system_user, su.first_name, su.last_name
HAVING COUNT(p.id_game) > 2
ORDER BY juegos_completados DESC;
```

### **Ejercicio Extra para Tarea:**
Crear una vista que muestre:
- Nombre completo del usuario
- Juegos que ha jugado
- Valor promedio de sus votos
- Solo para usuarios con más de 5 comentarios

```sql

SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS nombre_completo,
    g.name AS juego_jugado,
    ROUND(AVG(v.value), 2) AS promedio_votos,
    COUNT(DISTINCT c.id_commentary) AS total_comentarios
FROM SYSTEM_USER u
-- Unir con juegos jugados (tabla PLAY)
INNER JOIN PLAY p ON u.id_system_user = p.id_system_user
-- Obtener información del juego
INNER JOIN GAME g ON p.id_game = g.id_game
-- Unir con votos (LEFT JOIN porque no todos los juegos pueden tener votos)
LEFT JOIN VOTE v ON p.id_game = v.id_game AND p.id_system_user = v.id_system_user
-- Unir con comentarios para filtrar usuarios con más de 5 comentarios
INNER JOIN (
    -- Subconsulta: usuarios con más de 5 comentarios
    SELECT id_system_user
    FROM COMMENTARY
    GROUP BY id_system_user
    HAVING COUNT(*) > 5
) usuarios_con_comentarios ON u.id_system_user = usuarios_con_comentarios.id_system_user
-- Unir con comentarios para contar (opcional, para incluir en SELECT)
LEFT JOIN COMMENTARY c ON u.id_system_user = c.id_system_user
GROUP BY u.id_system_user, u.first_name, u.last_name, g.id_game, g.name
-- Filtrar solo usuarios con promedio de votos (opcional, comentar si se quieren todos)
HAVING AVG(v.value) IS NOT NULL
ORDER BY nombre_completo, juego_jugado
```