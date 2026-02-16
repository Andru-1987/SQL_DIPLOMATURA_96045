## Texto extraído del archivo

### "Unidad 7 - Importación y Gestión de Datos.pdf"

- **Página 3**: Objetivos de la clase:
  - Reconocer la integridad referencial.
  - Identificar las restricciones de integridad referencial.
  - Implementar los procesos de DELETE CASCADE y UPDATE CASCADE.

- **Página 4**: Mapa conceptual: Integridad referencial, restricciones, DELETE CASCADE, UPDATE CASCADE.

- **Página 6-7**: Definición de integridad referencial:
  - Garantiza que la clave externa de una tabla coincida siempre con una fila válida en otra tabla.
  - Asegura que la relación entre tablas se mantenga sincronizada durante operaciones UPDATE y DELETE.

- **Página 8**: Tres tipos de integridad referencial:
  - **Débil**: Si en una tupla de R, todos los valores de los atributos de K no son nulos, debe existir una tupla en S con esos mismos valores.
  - **Parcial**: Si algún atributo de K cambia a nulo, debe existir una tupla en S que tome los mismos valores que los atributos de K con valor nulo.
  - **Completa**: Todos los atributos de K deben ser nulos, o bien todos no nulos y deben existir en S.

- **Página 14-15**: Restricciones de integridad:
  - Se especifican en el esquema de la base de datos.
  - Tipos: unicidad, valor no nulo, clave primaria, integridad referencial.

- **Página 16-19**: Restricción de unicidad (ejemplo con DNI):
  - El documento de identidad debe ser único para evitar errores (ejemplo histórico de números 50 millones en Argentina).

- **Página 20-21**: Restricción de valor no nulo y clave primaria (ejemplo con empleados: nombre, DNI, legajo).

- **Página 22**: Restricción de integridad referencial (empleados asociados a un departamento).

- **Página 26-27**: Acciones con restricción de integridad en ON DELETE y ON UPDATE:
  - **CASCADE**
  - **SET NULL**
  - **NO ACTION**
  - **RESTRICT**

- **Página 28-29**: Implementación en MySQL InnoDB:
  - Se pueden especificar Foreign Key Constraints para evitar inconsistencias.
  - MySQL Workbench permite configurarlo en la pestaña Foreign Keys.

- **Página 31-37**: ON DELETE RESTRICT y NO ACTION:
  - Ejemplo con tablas `PERSONAS` y `PAIS`.
  - Si se intenta eliminar un país con personas asociadas, la operación falla (error).
  - Si el país no tiene referencias, se elimina correctamente.
  - Código:
    ```sql
    ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
    FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE RESTRICT;
    ```
    ```sql
    DELETE FROM PAIS WHERE pais_id = 3;  -- Falla si hay referencias
    ```

- **Página 38-41**: ON DELETE SET NULL:
  - Al eliminar un país, las referencias en `PERSONAS` se ponen a NULL.
  - Código:
    ```sql
    ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
    FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE SET NULL;
    ```
  - Ejemplo: eliminar Argentina (pais_id=3) pone NULL en los registros de personas con ese país.

- **Página 42**: Nota sobre diferencias en MySQL respecto al estándar SQL (consultar documentación).

- **Página 43-44**: ON UPDATE:
  - Comportamiento similar a ON DELETE (CASCADE, SET NULL, etc.).

- **Página 45**: Pregunta para pensar:
  > ¿Cómo resolver la nacionalidad de personas cuyo país cambia de nombre? ¿Y cuando un país se divide, como Serbia y Montenegro en 2006?

- **Página 48**: Resumen de la clase:
  - Integridad referencial, restricciones, ON DELETE CASCADE, ON UPDATE CASCADE.

---

## Resumen del material teórico

Este documento explica el concepto de **integridad referencial** en bases de datos relacionales y cómo gestionarla mediante restricciones y acciones en claves foráneas.

### Conceptos clave

1. **Integridad referencial**: Propiedad que asegura que las relaciones entre tablas se mantengan consistentes. Garantiza que los valores de una clave foránea en una tabla siempre correspondan a una clave primaria existente en otra tabla (o sean NULL, según el caso).

2. **Tipos de integridad referencial**:
   - **Débil**: Todos los valores de la clave foránea deben existir en la tabla referenciada (no se permiten nulos parciales).
   - **Parcial**: Se permiten nulos en algunos atributos de la clave foránea, pero los no nulos deben existir.
   - **Completa**: O todos los atributos de la clave foránea son nulos, o todos son no nulos y deben existir.

3. **Restricciones de integridad**:
   - **Unicidad**: Un atributo (o combinación) no puede tener valores duplicados (ej. DNI).
   - **Valor no nulo**: Un campo no puede quedar vacío (ej. nombre y apellido).
   - **Clave primaria**: Identifica unívocamente cada fila; implica unicidad y no nulo.
   - **Integridad referencial**: Reglas sobre claves foráneas.

4. **Acciones sobre claves foráneas (ON DELETE y ON UPDATE)**:
   - **CASCADE**: Al eliminar/actualizar el registro padre, se eliminan/actualizan automáticamente los hijos.
   - **SET NULL**: Al eliminar/actualizar el padre, la clave foránea de los hijos se establece a NULL.
   - **NO ACTION / RESTRICT**: Impide la operación si existen referencias. La diferencia es el momento de evaluación (NO ACTION se evalúa antes, RESTRICT después; en MySQL son equivalentes).
   - **SET DEFAULT**: (No mencionado explícitamente, pero existe en algunos motores) establece un valor por defecto.

5. **Implementación en MySQL**:
   - Se definen al crear o modificar tablas con `FOREIGN KEY ... REFERENCES ... ON DELETE ... ON UPDATE ...`.
   - En MySQL Workbench se configura en la pestaña "Foreign Keys".

6. **Ejemplos prácticos** con tablas `PERSONAS` y `PAIS`:
   - Con `ON DELETE RESTRICT`, no se puede eliminar un país que tenga personas asociadas.
   - Con `ON DELETE SET NULL`, al eliminar un país, las referencias quedan NULL.

7. **Reflexión final**:
   - ¿Cómo manejar cambios geopolíticos (cambios de nombre, divisiones de países) en una base de datos? Esto lleva a pensar en diseño y en el uso de ON UPDATE CASCADE o estrategias de versionado.

---

## Orden incremental de aprendizaje (postas de conocimiento)

Para que el alumno pueda avanzar de manera progresiva, se recomienda la siguiente secuencia:

| **Posta** | **Título** | **Contenido esencial** |
|-----------|------------|------------------------|
| 1 | **Concepto de integridad referencial** | Qué es, por qué es importante, ejemplos intuitivos (empleados y departamentos). |
| 2 | **Tipos de integridad referencial** | Diferencias entre débil, parcial y completa. Comprensión de cuándo aplicar cada una. |
| 3 | **Restricciones de integridad en general** | Unicidad, no nulo, clave primaria. Relación con la integridad referencial. |
| 4 | **Claves foráneas y acciones asociadas** | Introducción a `FOREIGN KEY` y las cláusulas `ON DELETE` y `ON UPDATE`. |
| 5 | **ON DELETE RESTRICT / NO ACTION** | Comportamiento, ejemplos prácticos, diferencia teórica entre ambas. |
| 6 | **ON DELETE SET NULL** | Cuándo usarlo, efectos sobre los datos, ejemplos. |
| 7 | **ON DELETE CASCADE** | Eliminación en cascada, riesgos y buenas prácticas. |
| 8 | **ON UPDATE** | Mismas opciones aplicadas a actualizaciones de la clave primaria. |
| 9 | **Casos complejos y reflexión** | Cambios de nombre de países, divisiones territoriales. ¿Cómo modelar? Estrategias: CASCADE, versionado, tablas históricas. |
| 10 | **Implementación en MySQL** | Sintaxis exacta, ejemplos en Workbench, verificación de resultados. |

---

## Ejercicios y ejemplos extraídos del material

### Ejemplos de código SQL

1. **ON DELETE RESTRICT** (pág. 33):
   ```sql
   ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
   FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE RESTRICT;
   ```

2. **ON DELETE NO ACTION** (pág. 33):
   ```sql
   ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
   FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE NO ACTION;
   ```

3. **Intento de eliminación con restricción** (pág. 34-37):
   ```sql
   DELETE FROM PAIS WHERE pais_id = 3;  -- Error si hay referencias
   DELETE FROM PAIS WHERE pais_id = 5;  -- Éxito si no hay referencias
   ```

4. **ON DELETE SET NULL** (pág. 39):
   ```sql
   ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
   FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE SET NULL;
   ```

5. **Eliminación con SET NULL** (pág. 40-41):
   ```sql
   DELETE FROM PAIS WHERE pais_id = 3;  -- Borra el país y pone NULL en personas.pais_id
   ```

### Datos de ejemplo (pág. 34, 36, 40)

**Tabla PAIS**:
| pais_id | nombre_pais |
|---------|-------------|
| 1       | España      |
| 2       | Italia      |
| 3       | Argentina   |
| 4       | Albania     |
| 5       | Brasil      |

**Tabla PERSONAS**:
| persona_id | nombre_completo   | pais_id |
|------------|-------------------|---------|
| 1          | Fernando Omar     | 3       |
| 2          | Julián Conte      | 3       |
| 3          | Nicolás Mariano   | 1       |
| 4          | Laura Grisel      | 2       |
| 5          | Constantino Pascual | 4     |

### Ejercicios para reflexión

- **Página 45**: Pregunta conceptual:
  > ¿Cómo debemos resolver la nacionalidad de personas cuyo país cambia de nombre? ¿Y cuando un país se divide, como sucedió con Serbia y Montenegro en 2006?

  Este ejercicio invita a pensar en:
  - Usar `ON UPDATE CASCADE` si el cambio es simple (ej.改名).
  - En casos de división, quizás sea necesario un rediseño (tablas históricas, fechas de vigencia, o asignación manual con nuevos IDs).

### Nota técnica

- **Página 42**: Se recomienda consultar la documentación oficial de MySQL para entender diferencias con el estándar SQL, especialmente en claves foráneas y columnas generadas.

Estos ejemplos y reflexiones permiten al alumno comprender la importancia de la integridad referencial y practicar su implementación en situaciones reales y complejas.