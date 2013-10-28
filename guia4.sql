-- ASUNTO: Guia 4 BBDD
-- AUTOR: Lucio Martínez
-- LICENSE: MIT license


-- EJ 1

-- Insertar 10 localidades

INSERT INTO Localidades (Localidad)
    SELECT ('Mar del Plata') UNION ALL
    SELECT ('Batan') UNION ALL
    SELECT ('Miramar') UNION ALL
    SELECT ('Centenario') UNION ALL
    SELECT ('La Plata') UNION ALL
    SELECT ('Bahia Blanca') UNION ALL
    SELECT ('Necochea') UNION ALL
    SELECT ('Constitución') UNION ALL
    SELECT ('Balcarce') UNION ALL
    SELECT ('Santa Clara');
GO



-- EJ 2

-- Insertar tres Tipos de Visita: Dia completo, $10, Medio dia, $6, Dos horas $3

INSERT INTO TipoVisitas (TipoVisita, Arancel)
    SELECT 'Día completo', '10' UNION ALL
    SELECT 'Medio día', '6' UNION ALL
    SELECT 'Dos horas', '3';
GO



-- EJ 3

-- Insertar 5 guias

INSERT INTO Guias
    SELECT 'Julio' UNION ALL
    SELECT 'Pedro' UNION ALL
    SELECT 'Jose' UNION ALL
    SELECT 'Carlos' UNION ALL
    SELECT 'Cesar';
GO


-- EJ 4

-- Insert 10 Escuelas

INSERT INTO Escuelas
    SELECT 'Nro 6', 'Luro 1800', 1000 UNION ALL
    SELECT 'Nro 13', 'San Martin 800', 1000 UNION ALL
    SELECT 'Nro 31', 'San Martin 4000', 1000 UNION ALL
    SELECT 'Nro 23', 'Independencia 300', 1000 UNION ALL
    SELECT 'Nro 331', 'Teniente Miguel 0', 1006 UNION ALL
    SELECT 'Nro 143', 'Luro 8000', 1000 UNION ALL
    SELECT 'Nro 43', 'San Lorenzo 234', 1003 UNION ALL
    SELECT 'Nro 65', 'Independencia 8300', 1000 UNION ALL
    SELECT 'Nro 56', 'Sargento Garcia 10', 1007 UNION ALL
    SELECT 'Nro 1', 'Luro 1600', 1000;
GO

-- Agregar dos telefonos a 3 escuela

INSERT INTO EscuelasTelefonos (IdEscuela, Telefono)
    SELECT 1, '230-4235' UNION ALL
    SELECT 1, '230-4239' UNION ALL
    SELECT 3, '331-2349' UNION ALL
    SELECT 3, '231-4533' UNION ALL
    SELECT 8, '230-1000' UNION ALL
    SELECT 8, '230-1001';
GO




-- EJ 5

-- Agregar campo (obligatorio) Director a tabla Escuela

ALTER TABLE Escuelas
    ADD Director
        varchar(50) NOT NULL DEFAULT '';
GO



-- EJ 6

-- Actualizar Escuelas agregando Directores

UPDATE Escuelas
    SET Director = 'Jose Maria';
GO



-- EJ 7

-- Agregar Reservas

INSERT INTO Reservas (IdEscuela, Fecha)
    SELECT 1, '20-08-2012' UNION ALL
    SELECT 1, '21-08-2012' UNION ALL
    SELECT 4, '20-08-2013' UNION ALL
    SELECT 7, '20-10-2012' UNION ALL
    SELECT 5, '24-09-2012';
GO


-- EJ 8

-- Insertar Visitas para todas las Reservas,
-- NOTA: cada Reserva puede tener varios Tipos de Visita.

INSERT INTO Visitas (IdReserva, IdTipoVisita, Grado, CantidadAlumnos, CantidadRealAlumnos, Arancel)
    SELECT 1, 3, 10, 24, 12, 100 UNION ALL
    SELECT 2, 1,  8, 30, 24, 400 UNION ALL
    SELECT 2, 2,  5, 30, 24, 200 UNION ALL
    SELECT 3, 3, 12, 41, 40, 123 UNION ALL
    SELECT 4, 1,  6, 28, 22, 480 UNION ALL
    SELECT 5, 2,  6, 35, 32, 333 UNION ALL
    SELECT 5, 1,  7, 54, 52, 809;
GO


-- EJ 9

-- Modificar el campo Guia de la tabla Guias, dando 10 chars más a la columna del nombre

ALTER TABLE Guias
    ALTER COLUMN Guia varchar(60) NOT NULL;
GO


-- EJ 10

-- Mostrar Escuelas

SELECT * FROM Escuelas;



-- EJ 11

-- Mostrar Escuelas con Domicilio específico

SELECT * FROM Escuelas
    WHERE Domicilio LIKE '%Luro%';



-- EJ 12

-- Mostrar Guias cuyo nombre empiece con una letra entre A y G

SELECT *
    FROM Guias
    WHERE Guia BETWEEN 'A' AND 'G';
GO


-- EJ 13

-- Mostrar Reservas en mes específico

SELECT *
    FROM Reservas
    WHERE Fecha BETWEEN '01-08-2012' AND '31-08-2012';
GO


-- EJ 14

-- Mostrar Reservas que no sean de una Escuela específica

SELECT *
    FROM Escuelas
    --WHERE IdEscuela != 4
    WHERE Escuela != 'Nro 23';
GO


-- EJ 15

-- Eliminar Guias con nombre específico

DELETE Guias
    WHERE Guia = 'Garcia';
GO


-- EJ 16

-- Actualizar Arancel en Visitas sumando $1

UPDATE Visitas
    SET Arancel = Arancel + 1;
GO


-- EJ 17

-- Actualizar una Reserva para adelantar la Fecha

UPDATE Reservas
    SET Fecha = '01-10-2012'
    WHERE Fecha = '24-09-2012';
GO
