-- ASUNTO: Guia 3 BBDD
-- AUTOR: Lucio Martínez
-- LICENCIA: MIT license



-- EJ 1

-- Listar la cantidad de Reservas realizadas para cada Escuela,
-- ordenar el resultado por identificador de Escuela

SELECT 
		e.IdEscuela,
		[Cantidad Reservas] = 
			--SUM(CASE e.IdEscuela WHEN r.IdEscuela THEN 1 ELSE 0 END)
			COUNT(r.IdEscuela)
	FROM Escuelas e
		LEFT JOIN Reservas r ON r.IdEscuela = e.IdEscuela
	GROUP BY e.IdEscuela
	ORDER BY e.IdEscuela;



-- EJ 2

-- listar la cantidad de Reservas realizadas
-- para cada Escuela, en cada mes

SELECT
    e.IdEscuela,
    Escuela,
	[Numero del Mes] =
		CASE
			WHEN MONTH(Fecha) IS NULL THEN 0 ELSE MONTH(Fecha)
		END,
	[Cantidad Reservas] = 
		--SUM(CASE e.IdEscuela WHEN r.IdEscuela THEN 1 ELSE 0 END)
		COUNT(r.IdEscuela)
    FROM Escuelas e
		LEFT JOIN Reservas r ON r.IdEscuela = e.IdEscuela
    GROUP BY e.IdEscuela, MONTH(Fecha), Escuela
    ORDER BY e.IdEscuela;



-- EJ 3

-- Listar para cada Reserva, la cantidad total de Alumnos
-- para los que se reservó y la cantidad total de Alumnos
-- que concurrieron en realidad.

SELECT 
		r.IdReserva,
		[Cantidad Total Alumnos] = SUM(CantidadAlumnos),
		[Cantidad Total Real Alumnos] = SUM(CantidadRealAlumnos)
	FROM Reservas r
		INNER JOIN Visitas v ON v.IdReserva = r.IdReserva
	GROUP BY r.IdReserva



-- EJ 4

-- Listar para cada Escuela, la primera y la última fecha de Reserva,
-- ordenar el resultado por identificador de Escuela en forma descendente.

SELECT
		e.IdEscuela,
		[Primer Reserva] = MIN(Fecha),
		[Última Reserva] = MAX(Fecha)
	FROM [Escuelas] e
		INNER JOIN [Reservas] r ON r.IdEscuela = e.IdEscuela
	GROUP BY e.IdEscuela
	ORDER BY e.IdEscuela Desc



-- EJ 5

-- Listar para cada Guía, la cantidad de reservas en las que participó.

SELECT
		g.IdGuia,
		[Reservas] = 
			--SUM(CASE g.IdGuia WHEN v.IdGuia THEN 1 ELSE 0 END)
			COUNT(v.IdGuia)
	FROM [Guias] g
		LEFT JOIN [VisitasGuias] v ON v.IdGuia = g.IdGuia
	GROUP BY g.IdGuia



-- EJ 6

-- Listar para cada Guía, la cantidad de reservas
-- de día completo en las que participó.

SELECT
		g.IdGuia,
		[Reservas] = 
			--SUM(CASE g.IdGuia WHEN v.IdGuia THEN 1 ELSE 0 END)
			COUNT(v.IdGuia)
	FROM [Guias] g
		LEFT JOIN [VisitasGuias] v ON v.IdGuia = g.IdGuia 
									AND IdTipoVisita = 1
	GROUP BY g.IdGuia



-- EJ 7

-- Listar para cada Guía, la cantidad de reservas de día completo
-- en las que participó, cuando haya superado las 5 participaciones.

SELECT
		g.IdGuia,
		[Reservas] = 
			COUNT(v.IdGuia)
	FROM [Guias] g
		LEFT JOIN [VisitasGuias] v ON v.IdGuia = g.IdGuia 
									AND IdTipoVisita = 1
	GROUP BY g.IdGuia
	HAVING COUNT(v.IdGuia) > 1



-- EJ 8

-- Listar el Guía que haya participado en mayor cantidad de reservas.

SELECT TOP 1
		g.IdGuia
		--[Cantidad Reservas] = COUNT(*)
	FROM Guias g
		INNER JOIN [VisitasGuias] v ON v.IdGuia = g.IdGuia
	GROUP BY g.IdGuia
	ORDER BY COUNT(*) DESC;



-- EJ 9

-- Listar las Escuelas que hayan hecho reservas en el mes de agosto de 2012.
-- Tener en cuenta que las Escuelas pueden realizar más de una reserva mensual.

SELECT
		e.IdEscuela,
		Escuela
	FROM Reservas r
		INNER JOIN Escuelas e ON e.IdEscuela = r.IdEscuela
	WHERE YEAR(Fecha) = 2012 AND MONTH(Fecha) = 8 
	GROUP BY e.IdEscuela, Escuela
