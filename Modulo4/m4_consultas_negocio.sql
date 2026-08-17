USE Ventas_Tech_DB;

--CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL--
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

--CONSULTA 2 - RANKING DE PRODUCTOS--
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--CONSULTA 3 - CLIENTES RECURRENTES--
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1

--CONSULTA 4 - MESES POR ENCIMA/POR DEBAJO DEL PROMEDIO--
WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_mensuales)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_mensuales;

--HALLAZGOS--
-- 1. La Consulta 4 no es útil, ya que solo existen registros correspondientes al mes de marzo y no es posible comparar su desempeño con otros meses.--
-- 2. El producto con ID_producto = 1 es el que presenta la mayor facturación, con un total de $3.600.--
-- 3. El cliente con ID_cliente = 1 es el que presenta el mayor gasto total, con $2.640.--

