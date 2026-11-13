-- ============================================================
-- C24 · Proyecto Integrador: Reporte de ventas por país
-- Curso: SQL con PostgreSQL — TiendaLatam
-- ============================================================

-- ============================================================
-- PASO 1: Explorar los datos disponibles
-- ============================================================
SELECT COUNT(*) AS total_pedidos    FROM pedidos; -- 200
SELECT COUNT(*) AS total_clientes   FROM clientes; -- 100
SELECT COUNT(*) AS total_productos  FROM productos; -- 39
SELECT COUNT(*) AS total_detalle    FROM detalles_pedidos; -- 597


-- ============================================================
-- PASO 2: Construir el reporte de ventas por país
-- ============================================================

SELECT
    pa.nombre_pais                          AS pais,
    COUNT(DISTINCT p.pedido_id)             AS total_pedidos,
    COUNT(DISTINCT p.cliente_id)            AS clientes_unicos,
    SUM(dp.cantidad * dp.precio_unitario)   AS monto_total,
    AVG(dp.cantidad * dp.precio_unitario)   AS ticket_promedio
FROM pedidos p
JOIN sucursales s        ON p.sucursal_id  = s.sucursal_id
JOIN paises pa           ON s.pais_id      = pa.pais_id
JOIN detalles_pedidos dp  ON p.pedido_id   = dp.pedido_id
GROUP BY pa.pais_id, pa.nombre_pais
ORDER BY monto_total DESC;


-- ============================================================
-- PASO 3: Agregar formato a los números
-- ============================================================

-- Ordenado por monto_total
SELECT
    pa.nombre_pais                                      AS pais,
    COUNT(DISTINCT p.pedido_id)                         AS total_pedidos,
    COUNT(DISTINCT p.cliente_id)                        AS clientes_unicos,
    TO_CHAR(SUM(dp.cantidad * dp.precio_unitario),
            'FM$999,999,999.00')                        AS monto_total,
    TO_CHAR(AVG(dp.cantidad * dp.precio_unitario),
            'FM$999,999.00')                            AS ticket_promedio
FROM pedidos p
JOIN sucursales s        ON p.sucursal_id  = s.sucursal_id
JOIN paises pa           ON s.pais_id      = pa.pais_id
JOIN detalles_pedidos dp  ON p.pedido_id    = dp.pedido_id
GROUP BY pa.pais_id, pa.nombre_pais
ORDER BY SUM(dp.cantidad * dp.precio_unitario) DESC;

-- Respuesta: el país con mayor monto_total es Argentina seguido de Perú. 


-- Ordenado por Ticket Promedio.
SELECT
    pa.nombre_pais                                      AS pais,
    COUNT(DISTINCT p.pedido_id)                         AS total_pedidos,
    COUNT(DISTINCT p.cliente_id)                        AS clientes_unicos,
    TO_CHAR(SUM(dp.cantidad * dp.precio_unitario),
            'FM$999,999,999.00')                        AS monto_total,
    TO_CHAR(AVG(dp.cantidad * dp.precio_unitario),
            'FM$999,999.00')                            AS ticket_promedio
FROM pedidos p
JOIN sucursales s        ON p.sucursal_id  = s.sucursal_id
JOIN paises pa           ON s.pais_id      = pa.pais_id
JOIN detalles_pedidos dp  ON p.pedido_id    = dp.pedido_id
GROUP BY pa.pais_id, pa.nombre_pais
ORDER BY ticket_promedio DESC;

-- Respuesta: el país con ticket promedio más alto es Paraguay seguido de Ecuador.

-- ============================================================
-- VARIANTE 1: Reporte por mes (top 12 meses)
-- ============================================================

-- Ordenado por periodo de diciembre a enero. 
SELECT
    TO_CHAR(p.fecha_pedido, 'YYYY-MM') 					AS periodo,
    COUNT(DISTINCT p.pedido_id)           				AS pedidos,
    TO_CHAR(SUM(dp.cantidad * dp.precio_unitario),
            'FM$999,999,999.00')                        AS monto_total
FROM pedidos p
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
GROUP BY TO_CHAR(p.fecha_pedido, 'YYYY-MM')
ORDER BY periodo DESC
LIMIT 12;
-- Respuesta: observando la gráfica, los 3 meses con más pedidos son diciembre, julio, febrero y enero. 


-- Ordenado por monto total
SELECT
    TO_CHAR(p.fecha_pedido, 'YYYY-MM') 					AS periodo,
    COUNT(DISTINCT p.pedido_id)           				AS pedidos,
    TO_CHAR(SUM(dp.cantidad * dp.precio_unitario),
            'FM$999,999,999.00')                        AS monto_total
FROM pedidos p
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
GROUP BY TO_CHAR(p.fecha_pedido, 'YYYY-MM')
ORDER BY SUM(dp.cantidad * dp.precio_unitario) DESC
LIMIT 12;

-- Respuesta: Los 3 periodos con mayor monto_total son 2024-02, 2023-11 y 2024-10.



-- ============================================================
-- VARIANTE 2: Top 10 productos más vendidos
-- ============================================================

SELECT
    pr.nombre_producto                  			AS producto,
    ca.nombre_categoria                 			AS categoria,
    SUM(dp.cantidad)                    			AS unidades_vendidas,
    TO_CHAR(SUM(dp.cantidad * dp.precio_unitario),
			'FM$999,999,999.00')					AS ingreso_total
FROM detalles_pedidos dp
JOIN productos pr  ON dp.producto_id = pr.producto_id
JOIN categorias ca ON pr.categoria_id = ca.categoria_id
GROUP BY pr.producto_id, pr.nombre_producto, ca.nombre_categoria
ORDER BY SUM(dp.cantidad * dp.precio_unitario) DESC
LIMIT 10;

-- Respuesta: Los 3 productos que representan más ingreso son: 
-- "Laptop HP ProBook 450".
-- "Tablet iPad Air 10.9".
-- "Bicicleta MTB Specialized"



-- ============================================================
-- VARIANTE 3: Reporte por categoría con HAVING
-- ============================================================

-- Categorías que superen $10.000 en monto_total
SELECT
    ca.nombre_categoria                           	AS categoria,
    COUNT(DISTINCT p.pedido_id)         			AS pedidos,
    SUM(dp.cantidad)                    			AS unidades,
    TO_CHAR (SUM(dp.cantidad * dp.precio_unitario),
			 'FM$999,999,999.00')					AS monto_total
FROM detalles_pedidos dp
JOIN productos pr  ON dp.producto_id = pr.producto_id
JOIN categorias ca ON pr.categoria_id = ca.categoria_id
JOIN pedidos p     ON dp.pedido_id    = p.pedido_id
GROUP BY ca.categoria_id, ca.nombre_categoria
HAVING SUM(dp.cantidad * dp.precio_unitario) > 10000
ORDER BY SUM(dp.cantidad * dp.precio_unitario) DESC;
-- Respuesta: Las categorías son:
-- Electrónica: tiene la mayor cantidad de pedidos con 87 y 303 unidades.
-- Hogar y Decoración.
-- Deportes y Outdoors.
-- Ropa y Calzado.


-- ============================================================
-- CONSULTA FINAL: Dashboard completo de TiendaLatam
-- ============================================================

SELECT
    'Países activos'    AS indicador, COUNT(DISTINCT pais_id)::TEXT    AS valor FROM sucursales
UNION ALL
SELECT 'Sucursales',    COUNT(*)::TEXT FROM sucursales
UNION ALL
SELECT 'Empleados',     COUNT(*)::TEXT FROM empleados
UNION ALL
SELECT 'Clientes activos', COUNT(*)::TEXT FROM clientes WHERE activo = TRUE
UNION ALL
SELECT 'Productos',     COUNT(*)::TEXT FROM productos
UNION ALL
SELECT 'Pedidos totales', COUNT(*)::TEXT FROM pedidos
UNION ALL
SELECT 'Líneas de detalle', COUNT(*)::TEXT FROM detalles_pedidos;



-- ============================================================
-- RETO
-- ============================================================

-- 1. Filtrar con HAVING solo países con más de diez mil en ventas totales, formatear con TO_CHAR incluyendo signo de pesos.

SELECT
    pa.nombre_pais 									AS pais,
    COUNT (DISTINCT p.pedido_id) 					AS total_pedidos,
    COUNT (DISTINCT p.cliente_id) 					AS clientes_unicos,
    TO_CHAR (SUM(dp.cantidad * dp.precio_unitario), 
				'FM$999,999,999.00') 				AS monto_total,
    TO_CHAR (AVG(dp.cantidad * dp.precio_unitario), 
				'FM$999,999,999.00') 				AS ticket_promedio
FROM pedidos p
INNER JOIN sucursales s          ON p.sucursal_id = s.sucursal_id
INNER JOIN paises pa             ON s.pais_id = pa.pais_id
INNER JOIN detalles_pedidos dp     ON p.pedido_id = dp.pedido_id
GROUP BY pa.pais_id, pa.nombre_pais
HAVING SUM ((dp.cantidad * dp.precio_unitario)) > 10000
ORDER BY SUM(dp.cantidad * dp.precio_unitario) DESC;


-- 2. Crear una variante agrupada por categoría de producto.

SELECT
	ca.nombre_categoria 							AS "Categoría",
	TO_CHAR(SUM(dp.cantidad * dp.precio_unitario), 
			'$999,999,990.00') 						AS "Ventas totales"
FROM detalles_pedidos dp
INNER JOIN productos pr ON pr.producto_id = dp.producto_id
INNER JOIN categorias ca ON ca.categoria_id = pr.categoria_id
GROUP BY ca.nombre_categoria
HAVING SUM(dp.cantidad * dp.precio_unitario) > 10000
ORDER BY "Ventas totales" DESC;

