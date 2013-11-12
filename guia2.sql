-- ASUNTO: Guia 2 BBDD
-- AUTOR: Lucio Martínez
-- LICENCIA: MIT license



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
        INNER JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    ORDER BY Fecha, e.Escuela;



-- EJ 3

-- Mostrar Visitas por Tipo y Cantidad de Alumnos descendente

SELECT
        IdReserva, Grado, CantidadAlumnos, 
        CantidadRealAlumnos, v.Arancel, TipoVisita
    FROM Visitas v
        JOIN TipoVisitas t ON v.IdTipoVisita = t.IdTipoVisita
    ORDER BY t.TipoVisita ASC, v.CantidadAlumnos;



-- EJ 4

-- Idem previo y '-' si Alumnos Reales es menor que Alumnos

SELECT 
		IdReserva,
		IdTipoVisita,
		CantidadAlumnos, 
		[Expression] = 
			CASE CantidadRealAlumnos 
				WHEN CantidadAlumnos THEN '=' ELSE '-'
			END
	FROM Visitas
	ORDER BY IdTipoVisita Asc, CantidadAlumnos Desc;



-- EJ 5

-- Mostrar Reservas y 'Año Actual' o 'Año Proximo' segun la Fecha

SELECT 
		[IdReserva],
		[IdEscuela],
		[Fecha] = 
			CASE YEAR(Fecha)
				WHEN YEAR(GETDATE())-1 THEN 'Año Pasado'
				WHEN YEAR(GETDATE())   THEN 'Año Actual'
			END
	FROM [Reservas] as r



-- EJ 6


-- [Pre-ejercicio] (opcionalmente) agregar las Visitas Guiadas:
/*
INSERT INTO VisitasGuias (IdReserva, IdTipoVisita, IdGuia, Responsable)
    SELECT 2, 1, 1, 5 UNION ALL
    SELECT 1, 2, 3, 1 UNION ALL
    SELECT 3, 3, 1, 1 UNION ALL
    SELECT 4, 3, 5, 2 UNION ALL
    SELECT 5, 3, 2, NULL;
GO
*/
-- Mostrar Visitas, si no hay Responsable mostrar 'Sin Datos'

SELECT
		v.[IdReserva],
		v.[IdTipoVisita],
		vg.[IdGuia],
		Responsable = 
			CASE
				WHEN Responsable IS NULL THEN 'Sin Datos' ELSE g.Guia
			END
	FROM [Visitas] v
		INNER JOIN [VisitasGuias] vg ON vg.IdReserva = v.IdReserva
		LEFT JOIN [Guias] g ON g.IdGuia = vg.Responsable;
