-- Verificar que estamos en la BD correcta
SELECT current_database();
-- Debe retornar: tiendalatam

-- Ver cuándo fue creada
SELECT datname,
       pg_catalog.pg_get_userbyid(datdba) AS propietario
FROM pg_catalog.pg_database
WHERE datname = 'tiendalatam';