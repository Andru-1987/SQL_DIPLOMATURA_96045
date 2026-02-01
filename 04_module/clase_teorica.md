## Repaso del material on demand

**4.1 Objetos de la Base de Datos**
*   **Tablas:** Estructuras fundamentales que almacenan datos en filas (registros) y columnas (campos). Son la base de las bases de datos relacionales.
*   **Vistas:** Tablas virtuales generadas por consultas. Simplifican consultas complejas y ofrecen una capa de seguridad y abstracción.
*   **Procedimientos Almacenados:** Conjuntos de instrucciones SQL precompilados que se ejecutan en el servidor. Encapsulan lógica de negocio para mayor eficiencia y seguridad.
*   **Funciones:** Bloque de código SQL que retorna un valor (escalar o un conjunto). Se pueden usar dentro de consultas para cálculos y transformaciones.
*   **Triggers:** Código que se ejecuta automáticamente ante eventos (INSERT, UPDATE, DELETE). Sirven para auditoría, validaciones y mantener la integridad.
*   **Claves:**
    *   **Primaria (PK):** Identifica de manera única cada registro en una tabla.
    *   **Foránea (FK):** Establece y mantiene la integridad referencial entre tablas.

**4.2 Tablas en SQL**
*   **Estructura:** Compuestas por columnas (con tipos de datos definidos) y filas.
*   **Tipos Comunes de Tablas:**
    *   **Transaccionales:** Priorizan integridad y consistencia para operaciones diarias (ej. InnoDB).
    *   **De Hechos:** Almacenan eventos o transacciones medibles para BI/Data Warehousing. Sus columnas pueden ser aditivas, semi-aditivas o no aditivas.
*   **Relaciones entre Tablas:**
    *   **Uno a Uno**
    *   **Uno a Muchos**
    *   **Muchos a Muchos** (requiere una tabla intermedia/puente).

**4.3 Diseño y Normalización**
*   **Normalización:** Proceso para organizar datos minimizando la redundancia y evitando anomalías, a través de formas normales.
*   **Formas Normales Principales:**
    *   **1NF:** Valores atómicos y registros únicos.
    *   **2NF:** Cumple 1NF y elimina dependencias parciales de la PK.
    *   **3NF:** Cumple 2NF y elimina dependencias transitivas.
*   **Objetivos de un Buen Diseño:** Reducir redundancia, aumentar la integridad, mejorar el rendimiento y facilitar el mantenimiento y escalabilidad.

**4.4 Claves y Optimización**
*   **Tipos de Claves:**
    *   **Primaria (PK):** Campo(s) único y no nulo que identifica cada registro.
    *   **Foránea (FK):** Campo que referencia la PK de otra tabla para mantener relaciones.
    *   **Candidata:** Campo o conjunto de campos que podrían actuar como PK por su unicidad.
    *   **Compuesta (Concatenada):** PK formada por la combinación de dos o más columnas.
*   **Índices:** Estructuras que mejoran la velocidad de las consultas. Los índices únicos pueden actuar como claves candidatas.

--- 

# **Objetos y Tablas en SQL**


#### **Posta 1: Los Objetos Fundamentales de una Base de Datos**
Una base de datos relacional está compuesta por objetos que sirven para almacenar, organizar, gestionar y proteger los datos.

*   **Tablas:** Son el objeto central. Estructuran los datos en filas (registros) y columnas (campos). Cada tabla puede relacionarse con otras.
*   **Vistas:** Son "tablas virtuales" resultado de una consulta. No almacenan datos físicamente, sino que muestran datos de una o más tablas de forma simplificada o segura.
*   **Funciones:** Bloques de código SQL que **devuelven un único valor**. Se utilizan para encapsular lógica reutilizable (como cálculos) y pueden usarse dentro de consultas.
*   **Procedimientos Almacenados (Stored Procedures):** Conjuntos de instrucciones SQL que **ejecutan una tarea** (simple o compleja). No retornan un valor directamente como las funciones, sino que se ejecutan por su lógica (inserciones, actualizaciones, etc.).
*   **Triggers (Disparadores):** Bloques de código que se **ejecutan automáticamente** en respuesta a un evento (INSERT, UPDATE, DELETE) sobre una tabla. Sirven para mantener la integridad, auditar cambios o calcular datos derivados.

---

#### **Posta 2: Profundizando en las Tablas y sus Tipos**

Las tablas no son todas iguales. Su estructura y propósito pueden variar según el modelo de datos.

*   **Estructura y Propiedades:**
    *   Se definen con columnas (nombre y tipo de dato: INT, VARCHAR, DATE, etc.).
    *   Se gestionan y exploran fácilmente en entornos como **MySQL Workbench**, usando el **Table Inspector** o el árbol de **Schemas** para ver Columnas, Índices, Claves Foráneas y Triggers.
*   **Tablas Transaccionales:**
    *   Son el núcleo de los sistemas operativos (ej.: sistemas bancarios, de ventas).
    *   Priorizan la **integridad y consistencia** inmediata de los datos.
    *   En MySQL, el motor **InnoDB** es el estándar para este tipo, ya que soporta transacciones (COMMIT, ROLLBACK) y bloqueo a nivel de fila.
*   **Tablas para Análisis (Modelo Dimensional):**
    *   **Tablas de Hecho:** Contienen las **medidas o métricas** del negocio (ej.: cantidad vendida, monto total). Sus columnas pueden ser:
        *   **Aditivas:** Se pueden sumar en cualquier dimensión (ej.: ventas).
        *   **Semi-aditivas:** Se suman solo en algunas dimensiones (ej.: saldo bancario).
        *   **No aditivas:** No se suman (ej.: un porcentaje).
    *   **Tablas Dimensionales:** Contienen los **atributos descriptivos** que contextualizan los hechos (ej.: datos del cliente, producto, tiempo). Nutren de detalle a las tablas de hecho.

---

#### **Posta 3: Las Claves e Índices: El Esqueleto de la Integridad y Velocidad**
Las claves e índices son cruciales para la precisión y el rendimiento de las consultas.

*   **Clave Primaria (Primary Key - PK):**
    *   Identifica **de forma única** cada registro en una tabla (no se repite, no es NULL).
    *   Se suele usar con `AUTO_INCREMENT` para generar valores automáticamente.
    *   En las herramientas, se identifica con `PRI` en la columna `Key` del comando `DESCRIBE`.
*   **Clave Foránea (Foreign Key - FK):**
    *   Establece una **relación** entre dos tablas.
    *   Apunta a la Clave Primaria de otra tabla, garantizando la **integridad referencial** (no se pueden eliminar registros principales si hay dependientes).
*   **Clave Candidata y Compuesta:**
    *   **Candidata:** Es cualquier campo o conjunto de campos que **podría** actuar como PK por su unicidad.
    *   **Compuesta (Concatenada):** Una PK formada por **dos o más columnas** cuando una sola no garantiza unicidad.
*   **Índices:**
    *   Estructuras que **aceleran** las consultas de búsqueda y filtrado.
    *   Se identifican como `UNI` (único) o `MUL` (puede repetirse) en `DESCRIBE`.
    *   Es óptimo definirlos desde el diseño de la tabla.

---

#### **Posta 4: Buenas Prácticas y Herramientas para el Diseño**
El diseño y la administración efectiva requieren de metodología y el uso correcto de las herramientas.

*   **Administración Segura con Vistas:**
    *   Es una **buena práctica** crear Vistas para que los equipos de desarrollo accedan a los datos, en lugar de dar acceso directo a las tablas base. Esto proporciona una capa de control y simplificación.
*   **Control de Ejecución con Procedimientos:**
    *   La ejecución de un **Stored Procedure** requiere un permiso específico (`EXECUTE`) para el usuario, lo que añade una capa de seguridad.
*   **Normalización y Modelo Estrella:**
    *   Organizar los datos en **Tablas de Hecho** (métricas) y **Tablas Dimensionales** (descripciones) crea un **modelo en estrella**, que es eficiente para entornos de Business Intelligence (BI) y favorece la normalización de los datos.