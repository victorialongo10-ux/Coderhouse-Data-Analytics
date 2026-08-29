USE Ventas_Tech_DB;

--ANTES DE COMENZAR CON LA CONSULTA 1--
--AGREGO EL CAMPO SEGMENTO A LA TABLA CLIENTES--
ALTER TABLE clientes
ADD segmento VARCHAR(50);

UPDATE clientes
SET segmento = 'Retail'
WHERE id_cliente IN (1, 3, 5);

UPDATE clientes
SET segmento = 'Corporativo'
WHERE id_cliente IN (2, 4);
SELECT * FROM clientes;

--CREO LA TABLA TERRITORIOS--
CREATE TABLE territorios (
    id_territorio INT PRIMARY KEY,
    region VARCHAR(50) NOT NULL
);

INSERT INTO territorios VALUES (1, 'Norte');
INSERT INTO territorios VALUES (2, 'Centro');
INSERT INTO territorios VALUES (3, 'Sur');

SELECT * FROM territorios;

--AGREGO id_territorio a Tabla Ventas--
ALTER TABLE ventas
ADD id_territorio INT;

ALTER TABLE ventas
ADD CONSTRAINT FK_ventas_territorios
FOREIGN KEY (id_territorio)
REFERENCES territorios(id_territorio);

UPDATE ventas SET id_territorio = 1 WHERE id_venta IN (1, 4, 7);
UPDATE ventas SET id_territorio = 2 WHERE id_venta IN (2, 5, 8);
UPDATE ventas SET id_territorio = 3 WHERE id_venta IN (3, 6, 9, 10);

SELECT * FROM ventas;

--CONSULTA 1--
SELECT
    v.fecha_venta AS fecha,
    c.id_cliente,
    c.nombre AS cliente,
    c.segmento,
    t.region,
    p.id_producto,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
INNER JOIN territorios t
    ON v.id_territorio = t.id_territorio;

--CONSULTA 2--
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--CONSULTA 3--
SELECT
    p.nombre_producto,
    c.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

--CONSULTA 4--
SELECT
    canal,
    SUM(total) AS total_facturado
FROM (
    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        '05 al 10 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        '11 al 15 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'
) AS ventas_consolidadas
GROUP BY canal;





