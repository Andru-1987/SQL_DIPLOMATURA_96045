# Consultas, Subconsultas y DDL

[_Material de clase_](https://docs.google.com/presentation/d/1zArJ4x5x1N4jgg-lYNZGOwNAhf1aXlpeTmfNPIStlwI/edit?slide=id.g11939ed5aa5_1_165#slide=id.g11939ed5aa5_1_165)


---

## **Posta 1: Unión de Tablas con UNION**

**Concepto Clave:**  
La cláusula `UNION` permite combinar los resultados de dos o más consultas en un único conjunto de resultados, siempre que tengan la misma estructura (mismo número y tipo de columnas). Elimina duplicados por defecto.

**Ejemplo del Material:**
```sql
SELECT id_game, name, description, id_level, id_class 
FROM game 
WHERE id_level = 1 
UNION 
SELECT id_game, name, description, id_level, id_class 
FROM game 
WHERE id_level = 2;
```

**Material Adicional Recomendado:**  
- *“Fundamentos de Bases de Datos”* (Elmasri & Navathe) – Capítulo sobre álgebra relacional y operaciones de conjuntos.  
- Documentación oficial de MySQL: [UNION Syntax](https://dev.mysql.com/doc/refman/8.0/en/union.html)

---

## **Posta 2: Tipos de Datos y Operador LIKE**

**Conceptos Clave:**
- **Tipos de datos básicos en SQL:** `INT`, `VARCHAR(n)`, `TEXT`, `DATE`, `DATETIME`, `BOOLEAN`, `DECIMAL`, `NUMERIC`.
- **Operador LIKE:** Permite búsquedas con patrones de texto usando comodines:
  - `%` → Cualquier secuencia de caracteres.
  - `_` → Un único carácter.
  - `[ ]` → Rango o conjunto de caracteres permitidos.
  - `[^ ]` → Exclusión de caracteres.

**Ejemplos del Material:**
```sql
-- Nombres que comienzan con 'FIFA'
WHERE name LIKE 'FIFA%';

-- Nombres que contienen 'Ultimate' en cualquier parte
WHERE name LIKE '%Ultimate%';

-- Excluir nombres que comiencen con D o V
WHERE name LIKE '[^DV]%';
```

**Material Adicional Recomendado:**  
- *“SQL para Análisis de Datos”* (Cathy Tanimura) – Capítulo sobre filtrado de texto.  
- W3Schools: [SQL LIKE Operator](https://www.w3schools.com/sql/sql_like.asp)

---

## **Posta 3: Subconsultas SQL**

**Concepto Clave:**  
Una subconsulta es una consulta anidada dentro de otra (en `WHERE`, `SELECT`, `FROM`, etc.). Puede ser:
- **Escalar:** Devuelve un único valor.
- **De fila múltiple:** Devuelve un conjunto de resultados.

**Ejemplo del Material:**
```sql
SELECT id_system_user, last_name 
FROM system_user 
WHERE id_user_type = (SELECT MAX(id_user_type) FROM user_type);
```

**Material Adicional Recomendado:**  
- *“SQL Antipatterns”* (Bill Karwin) – Capítulo sobre subconsultas y optimización.  
- Microsoft Docs: [Subqueries in SQL Server](https://docs.microsoft.com/en-us/sql/relational-databases/performance/subqueries?view=sql-server-ver15)

---

## **Posta 4: Lenguaje de Definición de Datos (DDL)**

**Conceptos Clave:**  
DDL incluye comandos para definir, modificar y eliminar estructuras de la base de datos:
- `CREATE TABLE`
- `ALTER TABLE`
- `DROP TABLE`
- `TRUNCATE TABLE`

**Ejemplo del Material:**
```sql
TRUNCATE TABLE friend;
```

**Material Adicional Recomendado:**  
- *“Database System Concepts”* (Silberschatz, Korth, Sudarshan) – Capítulo sobre DDL y esquemas.  
- PostgreSQL Tutorial: [DDL Commands](https://www.postgresqltutorial.com/postgresql-data-definition-language/)

---

## **Posta 5: Funciones Escalares**

**Conceptos Clave:**  
Funciones que operan sobre un solo valor y devuelven un solo resultado:
- **Cadenas:** `CONCAT()`, `UPPER()`, `LOWER()`, `TRIM()`, `SUBSTRING()`, `REVERSE()`.
- **Numéricas:** `ROUND()`, `FLOOR()`, `CEILING()`, `TRUNCATE()`, operadores aritméticos.
- **Fechas:** `CURDATE()`, `NOW()`, `DATEDIFF()`, `DAYNAME()`.

**Ejemplos del Material:**
```sql
-- Concatenar nombres
SELECT CONCAT(first_name, ' ', last_name) AS complete_name FROM system_user;

-- Fecha actual
SELECT CURDATE();
```

**Material Adicional Recomendado:**  
- MySQL Official Documentation: [String Functions](https://dev.mysql.com/doc/refman/8.0/en/string-functions.html), [Date Functions](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html)  
- *“SQL Cookbook”* (Anthony Molinaro) – Capítulo sobre manipulación de datos.

---

## **Posta 6: Funciones de Transformación y Agregación con GROUP BY y HAVING**

**Conceptos Clave:**  
- **Funciones de agregación:** `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`.
- **GROUP BY:** Agrupa resultados por una o más columnas.
- **HAVING:** Filtra grupos después de la agregación (similar a `WHERE` pero para grupos).

**Ejemplo Sugerido (no incluido en el PDF pero relevante):**
```sql
SELECT id_user_type, COUNT(*) AS total_usuarios
FROM system_user
GROUP BY id_user_type
HAVING COUNT(*) > 5;
```

**Material Adicional Recomendado:**  
- *“SQL para Ciencia de Datos”* (Renée M. P. Teate) – Capítulo sobre agregaciones y agrupamientos.  
- Oracle Tutorial: [GROUP BY and HAVING](https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_10002.htm)

---

## **Orden Recomendado de Enseñanza:**

1. **Posta 1:** Unión de tablas con `UNION` – fundamento de conjuntos.
2. **Posta 2:** Tipos de datos y filtrado con `LIKE` – manejo básico de datos.
3. **Posta 3:** Subconsultas – consultas anidadas para filtrado avanzado.
4. **Posta 4:** DDL – definición y modificación de estructura.
5. **Posta 5:** Funciones escalares – transformación de datos a nivel de fila.
6. **Posta 6:** Funciones de agregación y `GROUP BY` – análisis de grupos de datos.

Cada posta incluye ejemplos prácticos, actividades sugeridas (como las del PDF) y referencias a material bibliográfico y documentación oficial para profundización.
