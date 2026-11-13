-- ============================================================
-- C23 · INNER JOIN y LEFT JOIN
-- Curso: SQL con PostgreSQL — TiendaLatam
-- ============================================================

-- INNER JOIN básico: pedidos con nombre de cliente

SELECT
    p.cliente_id, -- Me trae de la tabla p (pedidos) el "cliente_id".
    c.nombre_cliente AS nombre_cliente, -- Traemos de la tabla "clientes" el nombre.
	COUNT(*) AS pedidos_2024
FROM pedidos p -- Agregamos el alias p para la tabla pedidos. 
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
-- Tabla clientes tiene el alias de c.
-- ON significa donde coinciden estas tablas. 
GROUP BY p.cliente_id, c.nombre_cliente
-- Agregamos en GROUP BY todo lo que no es agregación en el SELECT. 
HAVING COUNT(*) > 3
ORDER BY pedidos_2024 DESC;
-- Respuesta: Tenemos 15 clientes con más de 3 pedidos en 2024. 
-- Catalina y Antonio tiene la mayor cantidad de pedidos en 2024 con 6. 

-- Agregamos el apellido. 
SELECT
    p.cliente_id,
    c.nombre_cliente AS nombre_cliente,
	c.apellido_cliente AS apellido_cliente, -- Agregamos el Apellido. 
	COUNT(*) AS pedidos_2024
FROM pedidos p  
INNER JOIN clientes c ON p.cliente_id = c.cliente_id 
GROUP BY p.cliente_id, c.nombre_cliente, c.apellido_cliente -- Agregamos el apellido.
HAVING COUNT(*) > 3
ORDER BY pedidos_2024 DESC;
-- Antonio García y Catalina Vargas tienen 6 pedidos. 


-- LEFT JOIN
-- Identificar clientes sin pedidos.
-- Existen en la tabla clientes, pero no en la tabla Pedidos. 

SELECT
    c.nombre_cliente AS cliente,
    c.email,
	p.pedido_id -- Lo agregamos para mirar si es NULL. 
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
-- Mantenemos los resultados de la tabla pedidos.
WHERE p.pedido_id IS NULL -- Condición para traer solo los clientes sin pedido.
ORDER BY c.nombre_cliente;

-- RETOS

-- Reto 1: INNER JOIN de cuatro tablas
SELECT
    p.pedido_id AS pedido,
    c.nombre_cliente AS nombre_cliente,
	c.apellido_cliente AS apellido_cliente,
    s.nombre_sucursal AS sucursal,
    pa.nombre_pais AS pais,
    p.total
FROM pedidos p
INNER JOIN clientes c
    ON p.cliente_id = c.cliente_id
INNER JOIN sucursales s
    ON p.sucursal_id = s.sucursal_id
INNER JOIN paises pa
    ON s.pais_id = pa.pais_id
ORDER BY total DESC;
-- Respuesta: Los 3 clientes con mayor total de pedido son: 
-- Verónica Torres,
-- Benjamin Reyes,
-- Claudia Rodríguez.


-- Reto 2: clientes sin pedidos y porcentaje que representan
SELECT
    COUNT(DISTINCT c.cliente_id) AS clientes_sin_pedidos,
    ROUND(
        COUNT(DISTINCT c.cliente_id) * 100.0
        / (SELECT COUNT(*) FROM clientes),
        2
    ) AS porcentaje_sin_pedidos
FROM clientes c
LEFT JOIN pedidos p
    ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IS NULL;


-- OTROS EJERCICIOS

-- INNER JOIN múltiple: pedido completo con sucursal y país
SELECT
    p.pedido_id,
    c.nombre_cliente        AS cliente,
    s.nombre_sucursal       AS sucursal,
    pa.nombre_pais       	AS pais,
    p.fecha_pedido
FROM pedidos p
INNER JOIN clientes c   ON p.cliente_id = c.cliente_id
INNER JOIN sucursales s ON p.sucursal_id = s.sucursal_id
INNER JOIN paises pa    ON s.pais_id = pa.pais_id
ORDER BY p.fecha_pedido DESC
LIMIT 10;


-- INNER JOIN con detalle: líneas de un pedido específico
SELECT
    dp.pedido_id,
    pr.nombre_producto  AS producto,
    ca.nombre_categoria AS categoria,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal
FROM detalles_pedidos dp
INNER JOIN productos pr  ON dp.producto_id = pr.producto_id
INNER JOIN categorias ca ON pr.categoria_id = ca.categoria_id
WHERE dp.pedido_id = 1;


-- LEFT JOIN: todos los clientes, hayan comprado o no
SELECT
    c.nombre_cliente 	AS cliente,
    COUNT(p.pedido_id) 	AS cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre_cliente
ORDER BY cantidad_pedidos DESC;


-- INNER JOIN con GROUP BY: resumen de ventas por categoría
SELECT
    ca.nombre_categoria AS categoria,
    COUNT(DISTINCT p.pedido_id)         	AS pedidos,
    SUM(dp.cantidad)                    	AS unidades,
    SUM(dp.cantidad * dp.precio_unitario)   AS total_ventas
FROM detalles_pedidos dp
INNER JOIN productos pr  ON dp.producto_id = pr.producto_id
INNER JOIN categorias ca ON pr.categoria_id = ca.categoria_id
INNER JOIN pedidos p     ON dp.pedido_id = p.pedido_id
GROUP BY ca.categoria_id, ca.nombre_categoria
ORDER BY total_ventas DESC;


-- Alias cortos (práctica común en equipos)
SELECT
    c.nombre_cliente     AS cliente,
    s.nombre_sucursal    AS sucursal,
    pa.nombre_pais       AS pais,
    COUNT(p.pedido_id) AS pedidos
FROM pedidos p
JOIN clientes c   ON p.cliente_id   = c.cliente_id
JOIN sucursales s ON p.sucursal_id  = s.sucursal_id
JOIN paises pa    ON s.pais_id      = pa.pais_id
WHERE c.activo = TRUE
GROUP BY c.cliente_id, c.nombre_cliente, s.nombre_sucursal, pa.nombre_pais
ORDER BY pedidos DESC
LIMIT 10;





