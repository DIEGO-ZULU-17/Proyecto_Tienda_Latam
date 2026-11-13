-- ============================================================
-- C21 · GROUP BY y funciones de agregación
-- Curso: SQL con PostgreSQL — TiendaLatam
-- ============================================================

-- COUNT básico: cuántos clientes hay
-- Función de conteo
SELECT COUNT(*) AS total_clientes FROM clientes;
-- Resultado: 100 clientes.


-- COUNT filtrando NULLs
SELECT
    COUNT(*) AS total_clientes,
    COUNT(telefono) AS con_telefono
FROM clientes;
-- Resultado: para el total de clientes, 100 tienen teléfono.



-- GROUP BY básico: pedidos por cliente
SELECT cliente_id, 
COUNT(*) AS cantidad_pedidos
FROM pedidos
GROUP BY cliente_id -- Si está en el SELECT, debe estar en el GROUP BY.  
ORDER BY cantidad_pedidos DESC
LIMIT 10; -- Top 10 de pedidos por cliente.
-- Resultado: el cliente 81 y 100 tienen 6 pedidos.



-- GROUP BY con fechas: pedidos por mes
SELECT
    EXTRACT(YEAR  FROM fecha_pedido) AS anio,
    EXTRACT(MONTH FROM fecha_pedido) AS mes,
    COUNT(*) AS pedidos_en_mes
FROM pedidos
GROUP BY EXTRACT(YEAR FROM fecha_pedido), EXTRACT(MONTH FROM fecha_pedido)
ORDER BY anio, mes;
-- Resultado: cantidad de pedidos por año y por mes.



-- GROUP BY con fechas: pedidos por mes
SELECT
    EXTRACT(YEAR  FROM fecha_pedido) AS anio,
    EXTRACT(MONTH FROM fecha_pedido) AS mes,
    COUNT(*) AS pedidos_en_mes,
	SUM(total) AS total_pedid
FROM pedidos
GROUP BY EXTRACT(YEAR FROM fecha_pedido), EXTRACT(MONTH FROM fecha_pedido)
ORDER BY anio, mes;






