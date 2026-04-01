/*
====================================================
- Crear objetos requeridos por la consigna
- 5+ vistas
- 2+ funciones
- 2+ stored procedures
- 2+ triggers

====================================================

DOCUMENTACIÓN FUNCIONAL DE OBJETOS
====================================================

VISTAS
-------
1) vw_active_profiles
Motivo:
Consultar rápidamente los perfiles activos visibles en plataforma.

Objetivo:
Facilitar reporting comercial y operativo.

2) vw_featured_projects
Motivo:
Obtener proyectos destacados para landing pages.

Objetivo:
Mostrar portfolios más relevantes.

3) vw_profile_visits_summary
Motivo:
Medir tráfico por perfil.

Objetivo:
Analítica de uso y engagement.

4) vw_monthly_revenue
Motivo:
Conocer ingresos mensuales SaaS.

Objetivo:
KPIs financieros.

5) vw_subscription_details
Motivo:
Relacionar usuario + plan + estado.

Objetivo:
Soporte comercial y administración.

FUNCIONES
----------
1) fn_total_visits_by_profile
Motivo:
Calcular visitas totales de un portfolio.

Objetivo:
Reutilización en reportes y dashboards.

2) fn_monthly_revenue
Motivo:
Calcular revenue mensual.

Objetivo:
Análisis financiero.

STORED PROCEDURES
-----------------
1) sp_create_profile_transactional
Motivo:
Alta segura de usuario + perfil.

Objetivo:
Uso de TCL con ROLLBACK ante error.

2) sp_register_visit
Motivo:
Registrar visita.

Objetivo:
Automatizar carga transaccional.

TRIGGERS
--------
1) trg_validate_subscription_dates
Motivo:
Evitar inconsistencias de fechas.

Objetivo:
Integridad de datos.

2) trg_payment_notification
Motivo:
Crear notificación automática al registrar pago.

Objetivo:
Automatización operativa.
====================================================
*/

USE portfolio_saas;

-- ==========================================
-- VISTAS
-- ==========================================

CREATE OR REPLACE VIEW vw_active_profiles AS
SELECT
    p.profile_id,
    p.full_name,
    p.title,
    p.subdomain,
    u.email,
    u.status
FROM profiles p
JOIN users u
    ON p.user_id = u.user_id
WHERE u.status = 'active';


CREATE OR REPLACE VIEW vw_featured_projects AS
SELECT
    p.full_name,
    pr.title,
    pr.description,
    pr.url
FROM projects pr
JOIN profiles p
    ON pr.profile_id = p.profile_id
WHERE pr.featured = TRUE;


CREATE OR REPLACE VIEW vw_profile_visits_summary AS
SELECT
    p.profile_id,
    p.full_name,
    COUNT(v.visit_id) AS total_visits,
    AVG(v.duration_seconds) AS avg_duration
FROM profiles p
LEFT JOIN visits v
    ON p.profile_id = v.profile_id
GROUP BY p.profile_id, p.full_name;


CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    YEAR(payment_date) AS year_payment,
    MONTH(payment_date) AS month_payment,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'paid'
GROUP BY YEAR(payment_date), MONTH(payment_date);


CREATE OR REPLACE VIEW vw_subscription_details AS
SELECT
    u.email,
    pl.name AS plan_name,
    s.start_date,
    s.end_date,
    s.status
FROM subscriptions s
JOIN users u
    ON s.user_id = u.user_id
JOIN plans pl
    ON s.plan_id = pl.plan_id;

-- ==========================================
-- FUNCIONES
-- ==========================================

DELIMITER $$

CREATE FUNCTION fn_total_visits_by_profile(p_profile_id BIGINT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM visits
    WHERE profile_id = p_profile_id;

    RETURN total;
END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION fn_monthly_revenue(p_year INT, p_month INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT IFNULL(SUM(amount), 0)
    INTO total
    FROM payments
    WHERE YEAR(payment_date) = p_year
      AND MONTH(payment_date) = p_month
      AND payment_status = 'paid';

    RETURN total;
END$$

DELIMITER ;

-- ==========================================
-- STORED PROCEDURES
-- ==========================================

/*
SP CON TCL Y MANEJO DE ERROR
Este es ideal para la consigna
usa START TRANSACTION + COMMIT + ROLLBACK
*/

DELIMITER $$

CREATE PROCEDURE sp_create_profile_transactional(
    IN p_email VARCHAR(200),
    IN p_password_hash VARCHAR(200),
    IN p_status VARCHAR(200),
    IN p_full_name VARCHAR(200),
    IN p_title VARCHAR(200),
    IN p_bio VARCHAR(200),
    IN p_subdomain VARCHAR(200),
    IN p_theme_id BIGINT
)
BEGIN
    DECLARE v_user_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error al crear usuario y perfil. Transacción revertida.';
    END;

    START TRANSACTION;

    INSERT INTO users (
        email,
        password_hash,
        status
    )
    VALUES (
        p_email,
        p_password_hash,
        p_status
    );

    SET v_user_id = LAST_INSERT_ID();

    INSERT INTO profiles (
        user_id,
        full_name,
        title,
        bio,
        subdomain,
        theme_id
    )
    VALUES (
        v_user_id,
        p_full_name,
        p_title,
        p_bio,
        p_subdomain,
        p_theme_id
    );

    COMMIT;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_register_visit(
    IN p_profile_id BIGINT,
    IN p_country VARCHAR(200),
    IN p_device VARCHAR(200),
    IN p_referrer VARCHAR(200),
    IN p_duration INT
)
BEGIN
    INSERT INTO visits (
        profile_id,
        visit_date,
        visitor_country,
        device_type,
        referrer,
        duration_seconds
    )
    VALUES (
        p_profile_id,
        CURDATE(),
        p_country,
        p_device,
        p_referrer,
        p_duration
    );
END$$

DELIMITER ;

-- ==========================================
-- TRIGGERS
-- ==========================================

DELIMITER $$

CREATE TRIGGER trg_validate_subscription_dates
BEFORE INSERT ON subscriptions
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL
       AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de fin no puede ser menor a la fecha de inicio';
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_payment_notification
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_user_id BIGINT;

    SELECT user_id
    INTO v_user_id
    FROM subscriptions
    WHERE subscription_id = NEW.subscription_id;

    INSERT INTO notifications (
        user_id,
        message,
        is_read
    )
    VALUES (
        v_user_id,
        CONCAT('Pago registrado por ', NEW.amount, ' ', NEW.currency),
        FALSE
    );
END$$

DELIMITER ;
