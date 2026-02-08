**Manejo de Vistas SQL**

[_Material de clase_](https://docs.google.com/presentation/d/1lHXxtivJB9apjOyJqXIFLN_uzhuzZtZR7cnEFHbWQuw/edit?slide=id.g11dba82048b_0_74#slide=id.g11dba82048b_0_74)

**Concepto Central:**  
Una vista SQL es una tabla virtual generada a partir de una consulta SQL sobre una o más tablas. Se almacena en la base de datos como un objeto y puede ser reutilizada.

**Objetivos de la clase:**
- Crear, actualizar y eliminar vistas.
- Identificar ventajas y desventajas de los diferentes tipos de vistas.

**Sintaxis básica:**
```sql
CREATE VIEW nombre_vista [(columnas)] AS consulta_sql;
```
**Modificador útil:**
```sql
CREATE OR REPLACE VIEW nombre_vista [(columnas)] AS consulta_sql;
```

**Beneficios principales:**
- **Seguridad:** Restringe el acceso a columnas o filas sensibles.
- **Rendimiento:** Simplifica consultas complejas.
- **Protección de datos:** Evita operaciones directas sobre tablas base en entornos no preparados.

**Tipos de vistas mostradas:**
- Vistas simples (una tabla, columnas seleccionadas).
- Vistas filtradas (con WHERE).
- Vistas multi-tabla (JOIN entre tablas).

**Operaciones permitidas sobre vistas:**
- SELECT con filtros (WHERE, ORDER BY).
- Modificación mediante ALTER VIEW o CREATE OR REPLACE VIEW.
- Eliminación con DROP VIEW.

**Reflexión planteada:**  
Las vistas pueden utilizarse para insertar datos en tablas base en ciertos casos, dependiendo de su definición y permisos, lo cual requiere manejo cuidadoso.

---
**Postas de Conocimiento Recomendadas para el Aprendizaje Progresivo**

---

**Posta 1: Fundamentos de Vistas**
- Qué es una vista y cómo se diferencia de una tabla.
- Sintaxis básica de CREATE VIEW.
- Ejercicio: crear una vista a partir de una tabla sencilla.

**Material adicional sugerido:**
- Documentación oficial: [SQL Views - W3Schools](https://www.w3schools.com/sql/sql_view.asp)
- Lectura: “Views as a Security Mechanism” (IBM DB2 Documentation).

---

**Posta 2: Tipos y Usos Comunes**
- Vistas de columnas específicas.
- Vistas con filtros (WHERE).
- Vistas de múltiples tablas (JOIN).
- Ejercicio: crear una vista que muestre datos combinados de dos tablas.

**Material adicional sugerido:**
- Libro: “SQL Cookbook” (O’Reilly) - Capítulo sobre vistas.
- Artículo: “Using Views to Simplify Complex Queries” (SQL Server Central).

---

**Posta 3: Administración de Vistas**
- Modificar vistas existentes (CREATE OR REPLACE, ALTER VIEW).
- Eliminar vistas (DROP VIEW).
- Buenas prácticas: nomenclatura, documentación.
- Ejercicio: modificar una vista para agregar una columna calculada.

**Material adicional sugerido:**
- Documentación: [MySQL VIEW Syntax](https://dev.mysql.com/doc/refman/8.0/en/create-view.html)
- Lectura: “View Updatability in Relational Databases” (ACM SIGMOD Record).

---

**Posta 4: Ventajas, Limitaciones y Consideraciones Avanzadas**
- Cuándo usar vistas vs. tablas temporales.
- Impacto en el rendimiento.
- Vistas indexadas (SQL Server) / Vistas materializadas (Oracle, PostgreSQL).
- Ejercicio: analizar el plan de ejecución de una consulta sobre una vista.

**Material adicional sugerido:**
- Libro: “Database System Concepts” (Silberschatz) - Capítulo sobre vistas y seguridad.
- Artículo: “Materialized Views: A Practical Guide” (Towards Data Science).

---

**Recursos Generales de Consulta:**
1. Microsoft Learn: [Crear vistas en SQL Server](https://learn.microsoft.com/es-es/sql/relational-databases/views/create-views)
2. PostgreSQL Tutorial: [Views](https://www.postgresqltutorial.com/postgresql-views/)
3. Oracle Base: [Materialized Views](https://oracle-base.com/articles/misc/materialized-views)
