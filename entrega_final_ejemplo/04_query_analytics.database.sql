/*
====================================================
OBJETIVO:
Definir consultas SQL orientadas a KPIs clave del negocio
para la aplicación SaaS de portfolios profesionales.
====================================================

KPI 1 — MONTHLY RECURRING REVENUE (MRR)
----------------------------------------------------
MOTIVO:
Este KPI permite medir los ingresos recurrentes mensuales
generados por las suscripciones activas del SaaS.

OBJETIVO:
Evaluar crecimiento financiero, estabilidad del modelo
de negocio y evolución mensual de facturación.

USO:
Ideal para dashboards ejecutivos y reportes financieros.
====================================================
*/

SELECT
    YEAR(payment_date) AS anio,
    MONTH(payment_date) AS mes,
    SUM(amount) AS mrr
FROM payments
WHERE payment_status = 'paid'
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY anio, mes;


/*
====================================================
KPI 2 — USUARIOS ACTIVOS
----------------------------------------------------
MOTIVO:
Permite conocer la cantidad de usuarios que actualmente
se encuentran utilizando la plataforma.

OBJETIVO:
Medir adopción del producto, base activa de clientes y
retención operativa del SaaS.

USO:
Indicador clave para crecimiento de usuarios.
====================================================
*/

SELECT
    COUNT(*) AS usuarios_activos
FROM users
WHERE status = 'active';


/*
====================================================
KPI 3 — TOP PORTFOLIOS MÁS VISITADOS
----------------------------------------------------
MOTIVO:
Mide el nivel de tráfico e interacción que reciben los
portfolios publicados en la plataforma.

OBJETIVO:
Analizar engagement, detectar perfiles destacados y
evaluar el valor generado para los usuarios.

USO:
Muy útil para analítica de producto y reporting.
====================================================
*/

SELECT
    p.full_name,
    COUNT(v.visit_id) AS total_visitas,
    AVG(v.duration_seconds) AS tiempo_promedio_segundos
FROM profiles p
LEFT JOIN visits v
    ON p.profile_id = v.profile_id
GROUP BY p.profile_id, p.full_name
ORDER BY total_visitas DESC
LIMIT 5;
