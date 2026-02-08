**Manejo de Vistas SQL**

[_Material de clase_](https://docs.google.com/presentation/d/1y_MaAuqNNqm4QDFA57ubteguMgsIzaHNE7Ji3go4M20/edit?slide=id.g11dba82048b_0_0#slide=id.g11dba82048b_0_0)

**Concepto Central:**  
Una vista es una tabla virtual generada mediante una consulta SQL sobre una o más tablas. Se almacena en la base de datos como un objeto reutilizable.

**Objetivos de la clase:**
- Crear, actualizar y eliminar vistas.
- Identificar ventajas y desventajas de cada tipo de vista.

**Sintaxis básica:**
```sql
CREATE VIEW nombre_vista [(columnas)] AS consulta_sql;
```
**Modificador útil:**
```sql
CREATE OR REPLACE VIEW nombre_vista [(columnas)] AS consulta_sql;
```

**Beneficios principales:**
- **Seguridad:** Control de acceso a datos sensibles.
- **Rendimiento:** Simplificación de consultas complejas.
- **Protección:** Evita operaciones directas sobre tablas base.

**Operaciones cubiertas:**
- Creación de vistas simples, filtradas y multi-tabla.
- Modificación con `ALTER VIEW` o `CREATE OR REPLACE VIEW`.
- Eliminación con `DROP VIEW`.

**Punto de reflexión:**  
Las vistas pueden permitir la inserción de datos en tablas base bajo ciertas condiciones, lo que debe manejarse con criterio.

---
**Postas de Conocimiento Recomendadas para el Aprendizaje Progresivo**

---

**Posta 1: Fundamentos de Vistas**
- Definición y analogía: "ventana" a los datos.
- Creación de una vista simple a partir de una tabla.
- Ejercicio guiado con la tabla `GAME`.

**Material adicional sugerido:**
- Documentación oficial: [SQL Views - W3Schools](https://www.w3schools.com/sql/sql_view.asp)
- Capítulo 5: “Views”, *SQL in 10 Minutes*, Ben Forta.

---

**Posta 2: Tipos y Filtros en Vistas**
- Vistas de columnas específicas.
- Vistas con cláusulas `WHERE` y `ORDER BY`.
- Ejercicio: crear una vista filtrada por nivel de juego.

**Material adicional sugerido:**
- Artículo: “Using Views to Implement Row and Column Level Security”, Microsoft Docs.
- Video tutorial: “SQL Views with Filters”, freeCodeCamp.

---

**Posta 3: Vistas Multi-Tabla y Modificación**
- Vistas con `JOIN` (ej: `GAME`, `PLAY`, `SYSTEM_USER`).
- Modificación de vistas existentes.
- Uso de `CREATE OR REPLACE VIEW`.
- Ejercicio: crear una vista que una juegos con votaciones.

**Material adicional sugerido:**
- Libro: *SQL Cookbook*, O’Reilly – Capítulo “Working with Views”.
- Documentación: [CREATE VIEW – MySQL](https://dev.mysql.com/doc/refman/8.0/en/create-view.html).

---

**Posta 4: Administración y Buenas Prácticas**
- Eliminación de vistas (`DROP VIEW`).
- Ventajas vs. desventajas (rendimiento, mantenibilidad).
- Ejercicio: analizar el plan de ejecución de una vista compleja.

**Material adicional sugerido:**
- Lectura: “Materialized Views vs. Regular Views”, PostgreSQL官方文档.
- Foro: Stack Overflow – Etiqueta `sql-view`.

---
**Ejercicios Prácticos sobre la Base `coderhouse_gamers`**

### Ejercicios Extraídos del Documento:
1. **Vista de usuarios con dominio específico:**  
   Crear una vista que muestre el `first_name` y `last_name` de los usuarios cuyo email contenga `'webnode.com'`.
   ```sql
   CREATE OR REPLACE VIEW v_usuarios_webnode AS
   SELECT first_name, last_name
   FROM SYSTEM_USER
   WHERE email LIKE '%webnode.com';
   ```

2. **Vista de juegos completados:**  
   Crear una vista que muestre todos los datos de los juegos que han sido marcados como completados (`completed = true`) en la tabla `PLAY`.
   ```sql
   CREATE OR REPLACE VIEW v_juegos_completados AS
   SELECT g.*
   FROM GAME g
   JOIN PLAY p ON g.id_game = p.id_game
   WHERE p.completed = true;
   ```

3. **Vista de juegos con votación alta:**  
   Crear una vista que muestre los nombres de los juegos que tengan una votación (`value`) mayor a 9.
   ```sql
   CREATE OR REPLACE VIEW v_juegos_altamente_votados AS
   SELECT DISTINCT g.name
   FROM GAME g
   JOIN VOTE v ON g.id_game = v.id_game
   WHERE v.value > 9;
   ```

4. **Vista de jugadores de un juego específico:**  
   Crear una vista que muestre el `first_name`, `last_name` y `email` de los usuarios que juegan al juego `'FIFA 22'`.
   ```sql
   CREATE OR REPLACE VIEW v_jugadores_fifa22 AS
   SELECT u.first_name, u.last_name, u.email
   FROM SYSTEM_USER u
   JOIN PLAY p ON u.id_system_user = p.id_system_user
   JOIN GAME g ON p.id_game = g.id_game
   WHERE g.name = 'FIFA 22';
   ```

### Ejercicios Adicionales Recomendados:
5. **Vista de comentarios recientes:**  
   Crear una vista que muestre el nombre del juego, el comentario y la fecha del comentario de los comentarios realizados en el último mes (usar `CURDATE()` e `INTERVAL`).
   ```sql
   CREATE OR REPLACE VIEW v_comentarios_recientes AS
   SELECT g.name, c.commentary, c.comment_date
   FROM GAME g
   JOIN COMMENTARY c ON g.id_game = c.id_game
   WHERE c.comment_date >= CURDATE() - INTERVAL 1 MONTH;
   ```

6. **Vista de progreso de usuarios:**  
   Crear una vista que muestre el nombre completo del usuario, el nombre del juego y si lo ha completado, ordenado por usuario.
   ```sql
   CREATE OR REPLACE VIEW v_progreso_usuarios AS
   SELECT 
        CONCAT(u.first_name, ' ', u.last_name) AS usuario,
        g.name AS juego,
        CASE 
            WHEN p.completed = true THEN 'Completado' 
            ELSE 'En progreso' 
        END AS estado
   FROM SYSTEM_USER u
   JOIN PLAY p ON u.id_system_user = p.id_system_user
   JOIN GAME g ON p.id_game = g.id_game
   ORDER BY usuario;
   ```

7. **Vista de resumen de votaciones por juego:**  
   Crear una vista que muestre el nombre del juego y el promedio de sus votaciones, solo para juegos con más de 5 votos.
   ```sql
   CREATE OR REPLACE VIEW v_resumen_votaciones AS
   SELECT 
        g.name AS juego,
        AVG(v.value) AS promedio_votacion,
        COUNT(v.id_vote) AS total_votos
   FROM GAME g
   JOIN VOTE v ON g.id_game = v.id_game
   GROUP BY g.id_game
   HAVING total_votos > 5;
   ```

---
**Instrucciones para la Práctica:**
1. Ejecutar el script de creación de la base de datos `coderhouse_gamers`.
2. Resolver cada ejercicio en orden, verificando la sintaxis.
3. Probar las vistas con consultas `SELECT * FROM nombre_vista;`.
4. Documentar cualquier error o duda para revisión en clase.

---
**Recursos Adicionales para el Proyecto Final:**
- **Diagrama ER:** Usar herramientas como Draw.io, Lucidchart o MySQL Workbench.
- **Control de versiones:** Subir el archivo `.sql` a un repositorio GitHub y compartir el enlace.
- **Documentación:** Incluir comentarios en SQL (`--` o `/* */`) explicando cada paso.
