-- ============================================================
-- C22 · HAVING: filtrar grupos
-- Curso: SQL con PostgreSQL — TiendaLatam
-- ============================================================

-- HAVING básico: categorías con más de 5 productos

SELECT 
	categoria_id, 
	COUNT(*) AS cantidad_productos
FROM productos
GROUP BY categoria_id
-- Sin HAVING trae 8 resultados con la cantidad_productos por ID.
-- Usamos HAVING para filtrar el anterior resultado y solo
-- obtener los id con más de 5 productos. 
HAVING COUNT(*) > 5;

-- Categorías con 5 o más productos.
SELECT 
	categoria_id, 
	COUNT(*) AS cantidad_productos
FROM productos
GROUP BY categoria_id
HAVING COUNT(*) >= 5;



-- WHERE + HAVING: solo pedidos de 2024, grupos con más de 3 pedidos
SELECT
    cliente_id,
    COUNT(*) AS pedidos_2024
FROM pedidos
WHERE EXTRACT(YEAR FROM fecha_pedido) = 2024
GROUP BY cliente_id
HAVING COUNT(*) > 3
ORDER BY pedidos_2024 DESC;


-- RETO

-- 1. Categorías con más de 5 productos.
SELECT 
	categoria_id,
	COUNT(*) as cantidad_productos
FROM productos
GROUP BY categoria_id
HAVING COUNT(*) > 5
ORDER BY cantidad_productos;
-- Resultado: las categorías 1 y 2 tienen más de 5 productos.
-- El máximo de productos es 8.

-- 2. Países con más de 10 clientes.
SELECT 
	pais_id,
	COUNT(*) as total_clientes
FROM clientes
GROUP BY pais_id
HAVING COUNT(*) > 10
ORDER BY total_clientes DESC;
-- Resultado: los países 1 y 8 tienen el máximo de 11 clientes.

-- 3. Clientes con más de tres pedidos.
SELECT 
	cliente_id,
	COUNT(*) AS pedidos_por_cliente
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 3
ORDER BY pedidos_por_cliente DESC;
-- Resultado: 15 clientes tienen más de 3 pedidos. 
-- Los clientes 81 y 100 tienen el máximo de 6 pedidos. 


-- OTROS EJERCICIOS

-- HAVING básico: categorías (con nombre) con más de 5 productos
SELECT
    c.nombre_categoria AS categoria,
    COUNT(*) AS cantidad_productos
FROM productos p
JOIN categorias c ON p.categoria_id = c.categoria_id
GROUP BY c.categoria_id, c.nombre_categoria
HAVING COUNT(*) > 5
ORDER BY cantidad_productos DESC;


-- HAVING con SUM: países con más de $50,000 en ventas
SELECT
    pa.nombre_pais AS pais,
    SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
FROM pedidos p
JOIN sucursales s       ON p.sucursal_id = s.sucursal_id
JOIN paises pa          ON s.pais_id = pa.pais_id
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
GROUP BY pa.pais_id, pa.nombre_pais
HAVING SUM(dp.cantidad * dp.precio_unitario) > 50000
ORDER BY total_ventas DESC;



-- HAVING con AVG: clientes con ticket promedio alto (>1000)
SELECT
    c.nombre_cliente AS cliente,
    COUNT(p.pedido_id) AS pedidos,
    AVG(dp.cantidad * dp.precio_unitario) AS ticket_promedio
FROM clientes c
JOIN pedidos p          ON c.cliente_id = p.cliente_id
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
GROUP BY c.cliente_id, c.nombre_cliente
HAVING AVG(dp.cantidad * dp.precio_unitario) > 1000
ORDER BY ticket_promedio DESC;


-- Nombre de categorías con más de 3 productos
SELECT
    c.nombre_categoria AS categoria,
    COUNT(*) AS total_productos
FROM productos p
JOIN categorias c ON p.categoria_id = c.categoria_id
GROUP BY c.categoria_id, c.nombre_categoria
HAVING COUNT(*) > 3
ORDER BY total_productos DESC;










