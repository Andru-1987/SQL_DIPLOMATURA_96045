# SubLenguaje DML

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