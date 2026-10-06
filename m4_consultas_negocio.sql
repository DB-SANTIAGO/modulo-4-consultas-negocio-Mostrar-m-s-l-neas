USE Ventas_Tech_DB;
GO

-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO

-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Top 5 productos por total facturado

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO

-- CONSULTA 3 - CLIENTES RECURRENTES
-- Clientes con más de un pedido

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;
GO


-- CONSULTA 4 - MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > promedio_mensual
        THEN 'Por encima'
 
        WHEN total_facturado = promedio_mensual
        THEN 'Igual al promedio'
 
        ELSE 'Por debajo'
        END AS comparacion_promedio
FROM
(
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado,
        AVG(SUM(cantidad * precio_unitario))
            OVER () AS promedio_mensual
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS resumen_mensual
ORDER BY mes;
GO

-- HALLAZGOS

-- HALLAZGO 1:
-- El análisis de facturación mensual permite detectar variaciones en el rendimiento comercial a lo largo del período.
 
-- HALLAZGO 2:
-- La identificación de clientes recurrentes facilita el desarrollo de estrategias de fidelización.
 
-- HALLAZGO 3:
-- El análisis de productos facilita identificar cuáles generan un mayor impacto en los ingresos.
