##  DML Material teorico
### Principales temas:

1. **INSERT**:
   - Permite agregar uno o varios registros a una tabla.
   - Sintaxis básica: `INSERT INTO tabla (campos) VALUES (valores)`.
   - Se pueden insertar datos parciales (solo algunos campos); los omitidos tomarán valor por defecto o NULL.
   - Para campos AUTOINCREMENT se debe indicar NULL.
   - Inserción múltiple separando cada registro con coma.
   - Los tipos de datos determinan el uso de comillas (texto sí, números no).

2. **UPDATE**:
   - Modifica valores de registros existentes.
   - Sintaxis: `UPDATE tabla SET campo = valor, ...` (con o sin WHERE).
   - Es fundamental usar WHERE para limitar los registros afectados; sin él se actualizan todos.
   - Se pueden actualizar varios campos separados por coma.

3. **DELETE**:
   - Elimina registros de una tabla.
   - Sintaxis: `DELETE FROM tabla WHERE condición`.
   - **Advertencia**: olvidar WHERE elimina todos los registros.
   - Si hay restricciones de clave foránea, el DELETE puede fallar (error 1451).
   - Alternativa **TRUNCATE** para eliminar todos los registros de forma más rápida y sin registro individual.

4. **Subconsultas integradas**:
   - **INSERT con subconsulta**: permite insertar resultados de una consulta SELECT en otra tabla.
   - **UPDATE con subconsulta**: actualiza basándose en valores obtenidos de una subconsulta.
   - **CREATE TABLE ... SELECT**: crea una nueva tabla a partir de los resultados de una consulta (copia estructura y datos).

5. **Buenas prácticas**:
   - Siempre especificar los campos en INSERT para evitar errores de orden.
   - Usar WHERE con precaución en UPDATE y DELETE.
   - Conocer las restricciones de integridad referencial para evitar errores.

---

## Postas de conocimiento (fragmentación en módulos)

A continuación se presentan los conceptos clave organizados en bloques temáticos:

| **Posta** | **Título** | **Contenido esencial** |
|-----------|------------|------------------------|
| 1 | **Introducción al DML** | Definición de DML, diferencia con DQL, sentencias básicas (INSERT, UPDATE, DELETE). |
| 2 | **INSERT – Inserción de registros** | Sintaxis básica, inserción completa vs. parcial, inserción múltiple, tipos de datos y comillas. |
| 3 | **UPDATE – Actualización de registros** | Sintaxis básica, actualización sin condición (todos los registros), actualización con WHERE. |
| 4 | **DELETE – Eliminación de registros** | Sintaxis básica, importancia del WHERE, error por clave foránea, comparación con TRUNCATE. |
| 5 | **Subconsultas en INSERT** | Uso de SELECT dentro de INSERT para insertar datos derivados de otra tabla. |
| 6 | **Subconsultas en UPDATE** | Uso de SELECT dentro de UPDATE para condicionar la actualización con valores de otra tabla. |
| 7 | **Creación de tablas con SELECT** | `CREATE TABLE ... AS SELECT` para duplicar estructura y datos de una consulta. |
| 8 | **Buenas prácticas y advertencias** | Recordatorios: no olvidar WHERE, respetar tipos de datos, manejo de AUTOINCREMENT, restricciones FK. |

---

## Orden incremental de aprendizaje

Para que el alumno pueda avanzar de manera lógica y progresiva, se sugiere la siguiente secuencia:

1. **Conceptos fundamentales**  
   - Qué es DML y sus sentencias.  
   - Diferencia entre DML y DQL.

2. **Inserción de datos (INSERT)**  
   - Sintaxis básica y ejemplos simples.  
   - Inserción parcial y múltiple.  
   - Manejo de tipos de datos y AUTOINCREMENT.

3. **Actualización de datos (UPDATE)**  
   - Sintaxis básica y ejemplos.  
   - Actualización con condición (WHERE).  
   - Actualización de múltiples campos.

4. **Eliminación de datos (DELETE)**  
   - Sintaxis básica con WHERE.  
   - Peligros de omitir WHERE.  
   - Introducción a TRUNCATE como alternativa.

5. **Integración de subconsultas**  
   - Uso de subconsultas en INSERT (insertar resultados de SELECT).  
   - Uso de subconsultas en UPDATE (condiciones basadas en otras tablas).  
   - Creación de tablas a partir de consultas (`CREATE TABLE ... SELECT`).

6. **Consideraciones avanzadas**  
   - Restricciones de claves foráneas y errores comunes.  
   - Comparación DELETE vs TRUNCATE (rendimiento y efectos).  
   - Buenas prácticas generales.

---

## Ejercicios y ejemplos extraídos del material

A continuación se listan los ejemplos prácticos y ejercicios planteados en el PDF:

### Ejemplos de código SQL

1. **INSERT básico** (pág. 19):
   ```sql
   INSERT INTO pay (id_pay, amount, currency, date_pay, id_system_user, id_game)
   VALUES (NULL, 300, 'U$S', '2021-07-22', 501, 13);
   ```

2. **INSERT múltiple** (pág. 23):
   ```sql
   INSERT INTO pay VALUES 
     (NULL, 250, 'U$S', '2021-07-22', 'Paypal', 850, 77),
     (NULL, 3700, 'Pesos Arg', '2021-07-22', 'Visa', 38, 31),
     (NULL, 180, 'Libras', '2021-07-22', 'Transfer', 175, 16);
   ```

3. **UPDATE con condición** (pág. 34):
   ```sql
   UPDATE pay
   SET date_pay = CURRENT_DATE - 1
   WHERE date_pay = CURRENT_DATE;
   ```

4. **DELETE con múltiples condiciones** (pág. 40):
   ```sql
   DELETE FROM class WHERE id_level = 1 AND id_class = 999;
   ```

5. **INSERT con subconsulta** (pág. 61):
   ```sql
   INSERT INTO new_level_game (id_level, description)
   SELECT DISTINCT id_level, 'New level'
   FROM new_class
   WHERE id_level NOT IN (SELECT id_level FROM level_game);
   ```

6. **CREATE TABLE ... SELECT** (pág. 65-66):
   ```sql
   CREATE TABLE PLAY_INCOMPLETED AS
   (SELECT * FROM PLAY WHERE completed = 'FALSE');
   ```
   ```sql
   CREATE TABLE PLAY_INCOMPLETED_W AS
   (SELECT id_game, id_system_user FROM PLAY WHERE completed = 'FALSE');
   ```

7. **UPDATE con subconsulta** (pág. 70):
   ```sql
   UPDATE tabla SET unCampo = valor
   WHERE otroCampo = (SELECT campo FROM tabla WHERE condiciones);
   ```

### Ejercicios para reflexión

- **Página 25**: ¿Es más efectivo insertar múltiples registros usando un INSERT por cada uno o una única sentencia INSERT para todos? (Encuesta en clase).
- **Página 42**: Analizar el error de clave foránea al intentar eliminar un registro padre.
- **Página 74**: Reflexión humorística sobre la importancia de no olvidar el WHERE en DELETE.## Texto extraído del archivo

A continuación se presenta el contenido textual relevante del PDF "Unidad 6 - Sublenguaje DML.pdf" (segundo archivo), omitiendo elementos gráficos o repetitivos:

- **Página 2**: Objetivos de la clase:
  - Reconocer e implementar las sentencias del sublenguaje DDL (nota: probablemente quiso decir DML).
  - Identificar en qué situación usar cada sentencia.
  - Implementar subconsultas para complementar a las sentencias DML.
- **Página 5-8**: Ejemplo en vivo de INSERT:
  ```sql
  INSERT INTO class (id_level, id_class, description) VALUES (1, 999, 'Spain comedy');
  ```
  Se explica que el total de datos insertados corresponde con el total de campos.
- **Página 9-11**: Inserción de datos parciales:
  ```sql
  INSERT INTO pay (id_pay, currency, date_pay, pay_type, id_system_user, id_game)
  VALUES (NULL, 'U$S', '2021-07-22', '', 127, 91);
  ```
- **Página 12-14**: Inserción múltiple:
  ```sql
  INSERT INTO pay VALUES
    (NULL, 250, 'U$S', '2021-07-22', 'Paypal', 850, 77),
    (NULL, 3700, 'Pesos Arg', '2021-07-22', 'Visa', 38, 31),
    (NULL, 180, 'Libras', '2021-07-22', 'Transfer', 175, 16);
  ```
- **Página 15**: Pregunta reflexiva: ¿Es más efectivo insertar múltiples registros con un solo INSERT o varios INSERT individuales?
- **Página 16-18**: Ejemplo en vivo de UPDATE:
  ```sql
  UPDATE pay SET currency = 'U$S' WHERE id_pay = 4;
  ```
- **Página 19**: Ejercicio para pensar:
  > Si deseamos actualizar los niveles de las clases de juegos, pasar a nivel 8 todas las clases que están entre la 1 y la 20 inclusive y cuyos niveles actuales están por debajo del 13 ¿Cuántos registros se actualizarían y cuál sería la cláusula UPDATE?
- **Página 20-25**: DELETE:
  - Sintaxis: `DELETE FROM nombre_tabla WHERE condición;`
  - Advertencia: ¡no olvidar el WHERE!
  - Ejemplo: `DELETE FROM class WHERE id_level = 1 AND id_class = 999;`
- **Página 26-28**: Errores por clave foránea:
  - `Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails`
  - Solución: eliminar primero los registros hijos.
- **Página 29-30**: TRUNCATE TABLE:
  ```sql
  TRUNCATE nombre_tabla;
  ```
  Más rápido que DELETE sin WHERE porque no registra cada eliminación.
- **Página 31-32**: Actividad práctica "Inserción y actualización de tablas" (10 minutos):
  - Basado en las tablas del diagrama E-R de la clase anterior, insertar al menos 2 registros en cada tabla.
  - Luego, elegir una tabla y modificar al menos un dato de un registro insertado.
- **Página 33-38**: INSERT con subconsulta (ejemplo en vivo):
  - Crear tablas `NEW_CLASS` y `NEW_LEVEL_GAME`.
  - Insertar en `NEW_CLASS`.
  - Luego insertar en `NEW_LEVEL_GAME` usando una subconsulta que trae los `id_level` de `NEW_CLASS` que no existen en `level_game`:
    ```sql
    INSERT INTO new_level_game (id_level, description)
    (SELECT DISTINCT id_level, 'New level' FROM new_class
     WHERE id_level NOT IN (SELECT id_level FROM level_game));
    ```
- **Página 39-42**: UPDATE con subconsulta (ejemplo en vivo) – aunque no se muestra la sentencia completa, se indica que se actualizarán registros en `NEW_CLASS`.
- **Página 43-47**: DELETE con subconsulta:
  ```sql
  DELETE FROM NEW_CLASS
  WHERE id_level NOT IN (SELECT id_level FROM NEW_LEVEL_GAME);
  ```
  Se valida que los registros hayan sido eliminados.
- **Página 48**: Pregunta para pensar: ¿Se pueden anidar más de una subconsulta? (Sí).
- **Página 49-50**: Actividad práctica "Inserción y actualización de tablas II" (20 minutos) sobre la BD GAMERS:
  - Crear tabla `ADVERGAME` para juegos de propaganda.
  - Crear 5 juegos nuevos en `ADVERGAME`.
  - Insertar registros en `ADVERCLASS` obteniendo mediante subconsulta los id de las clases y niveles nuevos insertados.
- **Página 52**: Referencias a videos/material ampliado.
- **Página 54**: Resumen de la clase:
  - INSERT, UPDATE, DELETE.
  - Implementación de cada sentencia.
  - Complemento con subconsultas.
  - Implementación del sublenguaje.