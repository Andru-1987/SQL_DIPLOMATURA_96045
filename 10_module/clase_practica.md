### **Implementación con la Base de Datos `coderhouse_gamers`**

Esta sección te guiará a través de ejercicios prácticos para aplicar los conceptos teóricos utilizando la base de datos `coderhouse_gamers` del script proporcionado.

#### **Práctica 1: Control de Transacciones (TCL)**

Imaginemos que somos los encargados de la base de datos y necesitamos gestionar los pagos de los jugadores. Realizaremos una serie de inserciones y eliminaciones con la posibilidad de deshacer los cambios si algo sale mal.

**Paso 1: Preparar el entorno**
Primero, necesitas tener la base de datos `coderhouse_gamers` cargada en MySQL Workbench. Ejecuta el script `coderhouse.sql` para crearla y poblarla.

**Paso 2: Ejercicio guiado - Gestión de pagos con transacciones**

1.  **Iniciar una transacción:**
    Abre una nueva pestaña de script SQL y escribe:
    ```sql
    START TRANSACTION;
    ```

2.  **Realizar cambios (DML):**
    Eliminaremos tres pagos de la tabla `pago` para simular una limpieza de registros antiguos o erróneos.
    ```sql
    DELETE FROM pago LIMIT 3;
    ```
    *(Nota: En un entorno real, usarías una condición `WHERE` específica).*

3.  **Verificar los cambios:**
    Abre una **segunda pestaña** de script SQL y verifica que los registros hayan sido eliminados. La cantidad de filas debería ser menor.
    ```sql
    SELECT COUNT(*) FROM pago;
    ```

4.  **Deshacer los cambios (ROLLBACK):**
    Vuelve a la **primera pestaña** y ejecuta el comando `ROLLBACK` para deshacer la eliminación.
    ```sql
    ROLLBACK;
    ```

5.  **Confirmar que se deshicieron:**
    Vuelve a la **segunda pestaña** y ejecuta la consulta de nuevo. Verás que el número de registros ha vuelvo al valor original.

**Paso 3: Ejercicio autónomo - Puntos de guardado (SAVEPOINT)**

Vamos a insertar un lote de 15 nuevos pagos. Queremos establecer puntos de control para poder deshacer parte de la inserción si es necesario.

1.  **Iniciar transacción:**
    En una nueva pestaña, inicia una transacción.
    ```sql
    START TRANSACTION;
    ```

2.  **Insertar primeros 5 pagos y crear SAVEPOINT:**
    Insertamos 5 pagos y creamos un punto de guardado.
    ```sql
    -- Asumiendo que existen IDs de jugadores y formas de pago válidos (ej. jugador_id = 1, formapago_id = 1)
    INSERT INTO pago (jugador_id, formapago_id, fecha, importe) VALUES
    (1, 1, CURDATE(), 100.50),
    (1, 1, CURDATE(), 200.75),
    (2, 2, CURDATE(), 150.00),
    (2, 2, CURDATE(), 300.25),
    (3, 1, CURDATE(), 50.00);
    
    SAVEPOINT despues_de_5;
    ```

3.  **Insertar siguientes 5 pagos y crear otro SAVEPOINT:**
    Insertamos 5 pagos más y creamos otro punto de guardado.
    ```sql
    INSERT INTO pago (jugador_id, formapago_id, fecha, importe) VALUES
    (3, 1, CURDATE(), 120.00),
    (4, 3, CURDATE(), 80.50),
    (4, 3, CURDATE(), 95.00),
    (5, 2, CURDATE(), 210.30),
    (5, 2, CURDATE(), 45.60);
    
    SAVEPOINT despues_de_10;
    ```

4.  **Insertar los últimos 5 pagos:**
    Completamos el lote de 15.
    ```sql
    INSERT INTO pago (jugador_id, formapago_id, fecha, importe) VALUES
    (6, 1, CURDATE(), 300.00),
    (6, 1, CURDATE(), 75.20),
    (7, 3, CURDATE(), 180.90),
    (7, 3, CURDATE(), 60.00),
    (8, 2, CURDATE(), 110.40);
    ```

5.  **Validar los registros insertados:**
    Abre una **segunda pestaña** y verifica que los 15 registros estén en la tabla.
    ```sql
    SELECT * FROM pago ORDER BY id_pago DESC LIMIT 15;
    ```

6.  **Eliminar el segundo SAVEPOINT:**
    Vuelve a la primera pestaña. Eliminamos el `SAVEPOINT despues_de_10`. Esto no deshace los cambios, solo elimina el punto de referencia.
    ```sql
    RELEASE SAVEPOINT despues_de_10;
    ```

7.  **Confirmar la transacción:**
    Finalmente, confirma todos los cambios permanentemente.
    ```sql
    COMMIT;
    ```

8.  **Validar final:**
    Vuelve a la segunda pestaña y ejecuta la consulta de validación nuevamente. Los 15 registros deberían seguir estando presentes.

#### **Práctica 2: Backup y Restauración**

Ahora, pondremos en práctica la creación y restauración de copias de seguridad de la base de datos `coderhouse_gamers`.

**Paso 1: Realizar un Backup (Self-Contained File)**

1.  En MySQL Workbench, ve al menú **Server** > **Data Export**.
2.  En la pestaña **Object Selection**, selecciona la base de datos **`coderhouse_gamers`**.
3.  En la sección **Objects to Export**, asegúrate de marcar las opciones para incluir **Stored Procedures and Functions**, **Events** y **Triggers** si los hubiera.
4.  En **Export Options**, elige **Export to Self-Contained File**.
5.  Haz clic en el botón `...` para elegir la ruta y el nombre del archivo. Es una buena práctica incluir la fecha en el nombre, por ejemplo: `backup_coderhouse_gamers_20231027.sql`.
6.  Marca la opción **Include Create Schema** para que el backup incluya el comando `CREATE DATABASE`.
7.  Haz clic en **Start Export**. Al finalizar, verás un mensaje de confirmación en la pestaña **Export Progress**.

**Paso 2: Simular una pérdida de datos y Restaurar**

1.  Para simular un desastre, vamos a eliminar la base de datos `coderhouse_gamers`. Ve a la vista de **Administration** y ejecuta el siguiente comando SQL en una nueva pestaña (¡ten cuidado!):
    ```sql
    DROP DATABASE coderhouse_gamers;
    ```
    Ahora la base de datos ha desaparecido.

2.  Para restaurarla, ve al menú **Server** > **Data Import/Restore**.
3.  En **Import Options**, selecciona **Import from Self-Contained File** y elige el archivo `backup_coderhouse_gamers_20231027.sql` que acabas de crear.
4.  En **Default Target Schema**, selecciona la opción **New** y escribe `coderhouse_gamers` para que el proceso cree la base de datos automáticamente (esto funciona porque marcamos la opción "Include Create Schema" al exportar).
5.  En la parte inferior, asegúrate de que la opción **Dump Structure and Data** esté seleccionada.
6.  Haz clic en **Start Import**. Espera a que el proceso termine.
7.  Una vez finalizado, actualiza la vista de **Schemas**. ¡La base de datos `coderhouse_gamers` ha sido restaurada por completo con todos sus datos!