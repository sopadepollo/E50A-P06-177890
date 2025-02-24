
-- create
CREATE TABLE Clientes (
  cliente_id SERIAL PRIMARY KEY,
  nombre VARCHAR(25) NOT NULL,
  email VARCHAR(30) NOT NULL
);

CREATE TABLE Pedidos (
  pedido_id SERIAL PRIMARY KEY,
  cliente_id INTEGER,
  FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
  fecha DATE,
  total FLOAT NOT NULL
);

CREATE TABLE Productos (
  producto_id SERIAL PRIMARY KEY,
  nombre VARCHAR(25) NOT NULL,
  precio FLOAT NOT NULL
);

CREATE TABLE Detalles_Pedido (
  detalle_id SERIAL PRIMARY KEY,
  pedido_id INTEGER,
  FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
  producto_id INTEGER,
  FOREIGN KEY (producto_id) REFERENCES Productos(producto_id), 
  cantidad INTEGER NOT NULL
);



-- insert
INSERT INTO Clientes (cliente_id, nombre, email) VALUES
(1, 'Ana Pérez', 'ana.perez@gmail.com'),
(2, 'Carlos López', 'carlos.lopez@yahoo.com'),
(3, 'María García', 'maria.garcia@hotmail.com'),
(4, 'Juan Martínez', 'juan.martinez@gmail.com'),
(5, 'Laura Fernández', 'laura.fernandez@outlook.com');

INSERT INTO Pedidos (pedido_id, cliente_id, fecha, total) VALUES
(1, 1, '2025-01-15', 150.75),
(2, 2, '2025-01-20', 200.50),
(3, 3, '2025-01-25', 300.00),
(4, 4, '2025-02-01', 450.25),
(5, 5, '2025-02-10', 120.00);

INSERT INTO Productos (producto_id, nombre, precio) VALUES
(1, 'Laptop', 1000.00),
(2, 'Smartphone', 750.00),
(3, 'Tablet', 500.00),
(4, 'Monitor', 300.00),
(5, 'Teclado', 50.00);

INSERT INTO Detalles_Pedido (detalle_id, pedido_id, producto_id, cantidad) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 1),
(4, 4, 4, 3),
(5, 5, 5, 4);

INSERT INTO Clientes (cliente_id, nombre, email) VALUES
(6, 'Pedro Sánchez', 'pedro.sanchez@example.com');

INSERT INTO Pedidos (pedido_id, cliente_id, fecha, total) VALUES
(6, 6, '2025-02-15', 1000.00),
(7, 6, '2025-02-16', 750.00),
(8, 6, '2025-02-17', 500.00),
(9, 6, '2025-02-18', 300.00),
(10, 6, '2025-02-19', 50.00);

INSERT INTO Detalles_Pedido (detalle_id, pedido_id, producto_id, cantidad) VALUES
(6, 6, 1, 1),
(7, 7, 2, 1),
(8, 8, 3, 1),
(9, 9, 4, 1),
(10, 10, 5, 1);


-- fetch 
--Selección: Obtén todos los clientes cuyo nombre empieza con 'A'
SELECT * FROM Clientes WHERE nombre LIKE 'A%';
--Proyección: Muestra solo los nombres y correos electrónicos de los clientes.
SELECT nombre, email FROM Clientes;
--Unión: Encuentra todos los productos que han sido pedidos.
SELECT p.producto_id, p.nombre, p.precio FROM Productos p
UNION 
SELECT dp.producto_id, p.nombre, p.precio FROM Detalles_Pedido dp JOIN Productos p ON dp.producto_id = p.producto_id;
--Intersección: Encuentra los clientes que han realizado pedidos y aquellos que tienen un correo electronico que contiene gmail
SELECT c.cliente_id, c.nombre, c.email FROM Clientes c WHERE c.email LIKE '%gmail%'
INTERSECT
SELECT DISTINCT p.cliente_id, c.nombre, c.email FROM Pedidos p JOIN Clientes c ON p.cliente_id = c.cliente_id;
--Diferencia: Encuentra los productos que no han sido pedidos.
SELECT * FROM Productos
WHERE producto_id NOT IN (SELECT producto_id FROM Detalles_Pedido);
--Producto Cartesiano: Muestra todas las combinaciones posibles de clientes y productos.
SELECT * FROM Clientes, Productos;
--Join Natural: Muestra los detalles de los pedidos junto con la información del cliente.
SELECT c.nombre, p.fecha, dp.producto_id, dp.cantidad
FROM Clientes c
NATURAL JOIN Pedidos p
NATURAL JOIN Detalles_Pedido dp;
--División: Encuentra los clientes que han pedido todos los productos disponibles.
SELECT c.cliente_id, c.nombre
FROM Clientes c
WHERE NOT EXISTS(
    SELECT p.producto_id FROM Productos p
    EXCEPT SELECT dp.producto_id FROM Detalles_Pedido dp JOIN Pedidos pe ON pe.pedido_id = dp.pedido_id
    WHERE pe.cliente_id = c.cliente_id
);


