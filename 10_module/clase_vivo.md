### **Transacciones y Backup**

---

### **Parte Teórica: Conceptos Fundamentales**

Esta sección cubre los conceptos esenciales para entender y planificar la estrategia de copias de seguridad y el control de transacciones en MySQL.

#### **1. Transaction Control Language (TCL)**
El TCL es un subconjunto del lenguaje SQL que permite gestionar los cambios realizados por las sentencias DML (Data Manipulation Language), como `INSERT`, `UPDATE` y `DELETE`. Su objetivo principal es mantener la consistencia e integridad de los datos.

*   **START TRANSACTION:** Marca el inicio de una transacción. A partir de este punto, todas las operaciones DML que se ejecuten son parte de una unidad de trabajo que puede ser confirmada o deshecha en su totalidad. Por defecto, MySQL opera en modo `autocommit`, donde cada sentencia DML es una transacción en sí misma.
*   **COMMIT:** Confirma todos los cambios realizados desde el `START TRANSACTION` de manera permanente en la base de datos. Una vez ejecutado, los cambios son visibles para otras conexiones y no se pueden deshacer con un `ROLLBACK`.
*   **ROLLBACK:** Deshace todos los cambios realizados desde el último `START TRANSACTION` o desde un punto de guardado (`SAVEPOINT`) específico, devolviendo los datos a su estado anterior.
*   **SAVEPOINT:** Crea un punto intermedio dentro de una transacción. Permite deshacer solo una parte de la transacción hasta ese punto específico con `ROLLBACK TO SAVEPOINT`, sin afectar el resto de las operaciones.

#### **2. Fundamentos de las Copias de Seguridad (Backup)**
El backup es el proceso de crear una copia de seguridad de los datos y la estructura de una base de datos para poder restaurarlos en caso de pérdida, corrupción o error.

*   **Tipos de Backup según la información:**
    *   **Backup Completo (Dump data and structure):** Guarda tanto la estructura de los objetos (tablas, vistas, procedimientos) como todos los datos. Es el más lento y pesado, recomendado para bases de datos de prueba o con poca interacción.
    *   **Backup de Datos (Dump data only):** Guarda únicamente la información contenida en las tablas. Es útil cuando la estructura de la base de datos es estable y se realizan cambios frecuentes en los datos.
    *   **Backup de Estructura (Dump structure only):** Guarda la definición de los objetos de la base de datos sin los datos. Se utiliza cuando se implementan nuevos objetos o se modifica la estructura existente.
*   **Formatos de Backup en MySQL Workbench:**
    *   **Export to Self-Contained File:** Genera un único archivo con extensión `.sql` que contiene todas las sentencias necesarias para recrear la base de datos (CREATE TABLE, INSERT, etc.). Es útil para compartir o versionar.
    *   **Export to Dump Project Folder:** Crea una carpeta que contiene archivos separados, uno por cada tabla u objeto exportado. Esto facilita la restauración selectiva de tablas individuales.

#### **3. Restauración (Restore)**
Es el proceso inverso al backup, que consiste en recuperar una base de datos a partir de una copia de seguridad previamente realizada.

*   **Recomendaciones:** Para una restauración más rápida, es aconsejable que el servidor de bases de datos esté dedicado a este proceso, evitando el acceso de otros usuarios.
*   **Importación desde archivo .sql (Self-Contained):** Se ejecuta el archivo `.sql` para recrear la base de datos y volcar los datos.
*   **Importación desde carpeta de proyecto (Dump Project Folder):** Se selecciona la carpeta y se pueden elegir tablas específicas para restaurar.
