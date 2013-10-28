-- ASUNTO: Guia 2 BBDD
-- AUTOR: Lucio Martínez
-- LICENSE: MIT license



-- EJ 1

-- Mostrar Escuelas ordenadas por nombre

SELECT *
    FROM Escuelas
    ORDER BY Escuela;



-- EJ 2

-- Mostrar Reservas ordenadas por Fecha y Escuela.

SELECT
    IdReserva, Escuela, Fecha
    FROM Reservas r
    INNER JOIN Escuelas e
        ON r.IdEscuela = e.IdEscuela
    ORDER BY Fecha, e.Escuela;



-- EJ 3

-- Mostrar Visitas por Tipo y Cantidad de Alumnos descendente

SELECT
    IdReserva, Grado, CantidadAlumnos, CantidadRealAlumnos, v.Arancel, TipoVisita
    FROM Visitas v
        JOIN TipoVisitas t ON v.IdTipoVisita = t.IdTipoVisita
    ORDER BY t.TipoVisita ASC, v.CantidadAlumnos;



-- EJ 4

-- Idem previo y '-' si Alumnos Reales es menor que Alumnos

SELECT
    IdReserva,
    t.IdTipoVisita,
    CantidadAlumnos,
    CASE WHEN CantidadRealAlumnos < CantidadAlumnos
        THEN '-'
        ELSE '='
    END AS 'Cantidad Real'
    FROM Visitas v
        JOIN TipoVisitas t ON v.IdTipoVisita = t.IdTipoVisita;



-- EJ 5

-- Mostrar Reservas y 'Año Actual' o 'Año Proximo' segun la Fecha

SELECT
    IdReserva,
    IdEscuela,
    CASE
        -- WHEN YEAR(Fecha) = YEAR(GetDate())-1 THEN 'Año Previo'
        WHEN YEAR(Fecha) = YEAR(GetDate()) THEN 'Año Actual'
        WHEN YEAR(Fecha) = YEAR(GetDate())+1 THEN 'Año Proximo'
        ELSE CONVERT(varchar, Fecha)
    END AS Año
    FROM Reservas;



-- EJ 6


-- [Pre-ejercicio] (opcionalmente) agregar las Visitas Guiadas:
/*
INSERT INTO VisitasGuias (IdReserva, IdTipoVisita, IdGuia, Responsable)
    SELECT 2, 1, 1, 5 UNION ALL
    SELECT 1, 2, 3, 1 UNION ALL
    SELECT 3, 3, 1, 1 UNION ALL
    SELECT 5, 3, 2, NULL;
GO
*/
-- Mostrar Visitas, si no hay Responsable mostrar 'Sin Datos'

SELECT
    Visitas.IdReserva,
    Visitas.IdTipoVisita,
    IdGuia,
    CASE
        WHEN Responsable IS NULL THEN 'Sin Datos'
        ELSE CONVERT(varchar, Responsable)
    END AS Responsable
    FROM Visitas
        JOIN VisitasGuias guias ON Visitas.IdReserva = guias.IdReserva;


