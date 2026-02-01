### **Unidad 4: Objetos y Tablas en SQL**
---

#### **1. Ejercicios sobre Tablas y Relaciones**

*   **Páginas 10-16: Creación y análisis de tablas `friend` y `troops`.**
    *   **Paso 1:** Crear la tabla `Friend` dentro del esquema `Gammers` usando `CREATE TABLE`.
    *   **Paso 2:** Insertar registros en la tabla `Friend`. En la columna `troop`, se deben usar números que coincidirán con otra tabla.
    *   **Paso 3:** Crear la tabla `troops` usando `CREATE TABLE`.
    *   **Paso 4:** Insertar registros en la tabla `troops`, asegurando que los valores en su columna `id` coincidan con los números usados en `friend.troop`.
    *   **Análisis:** Responder:
        1.  ¿Por qué se pueden eliminar registros en `friend` a pesar de tener una relación lógica con `troops`?
        2.  ¿Por qué NO se pueden eliminar registros en `troops` si hay registros en `friend` que dependen de ellos?

---

#### **2. Ejercicio sobre Funciones**
*   **Páginas 18-20: Crear una función de usuario.**
    *   Crear una función que retorne la cantidad de integrantes (registros) que tiene una `troop` específica.
    *   La función debe recibir como parámetro de entrada el identificador (`id`) de la troop.
    *   **Nota:** Las funciones se almacenan y solo están disponibles en el esquema (Schema) donde fueron creadas.

---

#### **3. Ejercicio sobre Triggers**
*   **Páginas 22-25: Implementar y probar un Trigger.**
    *   Crear un trigger que se active **ANTES** (o **DESPUÉS**) de una operación `INSERT` en la tabla `troops`.
    *   **Lógica del Trigger:** Si el valor insertado en la columna `description` es `NULL`, el trigger debe reemplazarlo automáticamente con el texto `'default description'`.
    *   **Actividad de Pensamiento:** Diseñar un esquema donde sea necesario aplicar un trigger con `AFTER` y otro con `BEFORE`, identificando las tablas involucradas y el evento que los dispararía.

---

#### **4. Actividad Integradora: Diagrama E-R y Base de Datos**
*   **Página 27: Implementar un Diagrama Entidad-Relación (E-R).**
    *   Recuperar el Diagrama E-R creado en una clase anterior.
    *   Crear una nueva base de datos e implementar físicamente **todas las tablas** definidas en ese diagrama.
    *   **Requisito:** Cada tabla debe tener, como mínimo, **tres campos**. Se recomienda agregar más si es necesario para enriquecer el modelo.

---

#### **5. Actividad Práctica: Tablas de Hecho y Dimensionales**
*   **Página 29-33: Analizar y modelar tablas para Business Intelligence (BI).**
    *   Partiendo del ejemplo de la tabla de hecho `games_completed` (que contiene nombres de jugadores, nombres de videojuegos y cantidad completada), se debe:
        1.  Identificar las **medidas** (datos numéricos para analizar) en la tabla de hecho.
        2.  Pensar en y proponer **tablas dimensionales** que brinden contexto a esos hechos (ej: tabla de jugadores con datos demográficos, tabla de videojuegos con género y fecha de lanzamiento, tabla de tiempo).
    *   El objetivo es visualizar el **modelo en estrella**, con una tabla de hecho en el centro conectada a varias tablas dimensionales.

---

#### **6. Ejercicio sobre Claves Primarias (PK)**
*   **Páginas 35-38: Comprender y probar la unicidad de una Primary Key.**
    *   Localizar en una tabla (ej: `play` o `class`) la columna definida como `PRIMARY KEY` (usando Table Inspector en MySQL Workbench).
    *   Listar los datos de la tabla (ej: `class`).
    *   Intentar insertar un nuevo registro con un valor en la columna de la PK que **ya existe** (ej: `id = 1`).
    *   Verificar y comprender el **error de duplicado** que genera el sistema, confirmando que la PK garantiza unicidad.

---

#### **7. Actividad Integradora Final: Modificación de Estructuras y Modelo Físico**
*   **Página 40: Modificar tablas y generar el modelo relacional.**
    *   Retomar las tablas creadas en ejercicios anteriores.
    *   **Modificar su estructura** aplicando:
        *   **Claves Primarias (PK):** Asegurar que cada tabla tenga su PK definida.
        *   **Claves Foráneas (FK):** Establecer las relaciones entre las tablas utilizando `FOREIGN KEY`.
        *   **Índices:** Agregar índices a campos que se usen frecuentemente en búsquedas o filtros (WHERE).
    *   **Generar el Modelo Relacional:** Utilizar la herramienta **Reverse Engineering** de MySQL Workbench para generar automáticamente un diagrama gráfico del esquema de base de datos creado.