## **Sección 1: Sentencia WHERE**

**Consignas:**
1. Selecciona todos los datos de los usuarios cuyo nombre sea 'Gillie'.
2. Obtén el nombre y apellido de los usuarios que pertenezcan al tipo de usuario con ID 334.
3. Muestra el nombre y apellido del usuario con ID 56.
4. Selecciona todos los datos de los usuarios llamados 'Reinaldos'.

**Queries:**
```sql
-- 1
SELECT * FROM system_user WHERE first_name = 'Gillie';
-- 2
SELECT first_name, last_name FROM system_user WHERE id_user_type = 334;
-- 3
SELECT first_name, last_name FROM system_user WHERE id_system_user = 56;
-- 4
SELECT * FROM system_user WHERE first_name = 'Reinaldos';
```

---

## **Sección 2: Operadores de comparación**

**Consignas:**
1. Seleccionar todos los comentarios sobre juegos desde 2019 en adelante.
2. Seleccionar todos los comentarios sobre juegos anteriores a 2011.
3. Mostrar los usuarios y texto de aquellos comentarios sobre juegos cuyo código de juego (id_game) sea 73.
4. Mostrar los usuarios y texto de aquellos comentarios sobre juegos cuyo id de juego no sea 73.
5. Seleccionar todos los juegos de nivel 1.
6. Seleccionar todos los juegos de nivel 14 o superior.
7. Seleccionar todos los juegos de nombre 'Riders Republic' o 'The Dark Pictures: House Of Ashes'.
8. Seleccionar todos los juegos cuyo nombre empiece con 'Gran'.
9. Seleccionar todos los juegos cuyo nombre contenga ‘field’.
10. Seleccionar todos los juegos que tengan un nivel entre 3 y 7 inclusive, su nombre contenga la palabra "War" y no sean de la clase 25.

**Queries:**
```sql
-- 1
SELECT * FROM COMMENTARY WHERE YEAR(comment_date) >= 2019;
-- 2
SELECT * FROM COMMENTARY WHERE YEAR(comment_date) < 2011;
-- 3
SELECT id_system_user, commentary FROM COMMENTARY WHERE id_game = 73;
-- 4
SELECT id_system_user, commentary FROM COMMENTARY WHERE id_game != 73;
-- 5
SELECT * FROM GAME WHERE id_level = 1;
-- 6
SELECT * FROM GAME WHERE id_level >= 14;
-- 7
SELECT * FROM GAME WHERE name IN ('Riders Republic', 'The Dark Pictures: House Of Ashes');
-- 8
SELECT * FROM GAME WHERE name LIKE 'Gran%';
-- 9
SELECT * FROM GAME WHERE name LIKE '%field%';
-- 10
SELECT * FROM GAME WHERE id_level BETWEEN 3 AND 7 AND name LIKE '%War%' AND id_class != 25;
```

---

## **Sección 3: Ordenamiento de datos**

**Consignas:**
1. Seleccionar todos los juegos cuyo nombre contenga 'of' y ordenarlos por nombre de forma ascendente.
2. Listar todos los usuarios ordenados primero por tipo de usuario de forma ascendente y luego por apellido de forma ascendente, limitando los resultados a los primeros 5 registros.

**Queries:**
```sql
-- 1
SELECT * FROM game WHERE name LIKE '%of%' ORDER BY name ASC;
-- 2
SELECT id_system_user, first_name, last_name, id_user_type 
FROM SYSTEM_USER ORDER BY id_user_type ASC, last_name ASC LIMIT 5;
```

---

## **Sección 4: Funciones de agregación**

**Consigna:**
1. Calcular el total de votos, el promedio, el valor máximo y mínimo de los votos para el juego con id_game = 1.

**Query:**
```sql
SELECT  COUNT(*) AS total_votes, 
        AVG(value) AS average_value, 
        MAX(value) AS max_value,
        MIN(value) AS min_value 
FROM VOTE WHERE id_game = 1;
```

---

## **Sección 5: Agrupamiento de datos**

**Consignas:**
1. Seleccionar todos los comentarios ordenados por id_system_user en orden descendente.
2. Seleccionar todos los comentarios ordenados por id_system_user y limitar los resultados a los primeros 3 registros.
3. Contar la cantidad de comentarios por usuario y mostrar el número de comentarios junto al identificador del usuario.
4. Contar la cantidad de comentarios por usuario, pero mostrar solo aquellos usuarios que tengan más de 2 comentarios.
5. Contar cuántos juegos hay por cada nivel, pero solo mostrar los niveles que tengan más de 10 juegos.

**Queries:**
```sql
-- 1
SELECT * FROM commentary ORDER BY id_system_user DESC;
-- 2
SELECT * FROM commentary ORDER BY id_system_user LIMIT 3;
-- 3
SELECT COUNT(id_system_user) AS comments, id_system_user FROM commentary GROUP BY id_system_user;
-- 4
SELECT COUNT(id_system_user) AS comments, id_system_user FROM commentary GROUP BY id_system_user HAVING comments > 2;
-- 5
SELECT id_level, COUNT(*) AS total_games FROM GAME GROUP BY id_level HAVING total_games > 10;
```

---

## **Sección 6: Combinación de tablas (JOIN)**

**Consigna:**
1. Listar el nombre del juego, su descripción, el nombre de su clase y el nivel correspondiente, para todos los juegos que tengan nivel mayor a 10, ordenados por nivel descendente.

**Query:**
```sql
SELECT 
    G.name AS game_name,
    G.description AS game_description,
    C.description AS class_description,
    LG.description AS level_description 
FROM GAME G 
INNER JOIN CLASS C ON G.id_class = C.id_class AND G.id_level = C.id_level 
INNER JOIN LEVEL_GAME LG ON G.id_level = LG.id_level 
WHERE G.id_level > 10 ORDER BY G.id_level DESC;
```