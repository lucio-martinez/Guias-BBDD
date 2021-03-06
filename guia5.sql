-- ASUNTO: Guia 5 BBDD
-- AUTOR: Lucio Martínez
-- LICENCIA: MIT license


-- EJ 1

-- Listar Código y Nombre de cada Escuela,
-- y obtener la cantidad de Reservas realizadas con una subconsulta.

SELECT
		e.IdEscuela,
		Escuela,
		[Cantidad Reservas] = 
			(SELECT COUNT(*)
				FROM Reservas r
					WHERE r.IdEscuela = e.IdEscuela)
	FROM Escuelas e



-- EJ 2

-- Listar Código y Nombre de cada Escuela,
-- y obtener la cantidad de Reservas realizadas durante el presente año,
-- con una subconsuta. En caso de no haber realizado Reservas, mostrar el número cero.


SELECT
		e.IdEscuela,
		Escuela,
		[Cantidad Reservas] = 
			(SELECT COUNT(*)
				FROM Reservas r
					WHERE r.IdEscuela = e.IdEscuela
						AND YEAR(Fecha) = YEAR(GETDATE()))
	FROM Escuelas e



-- EJ 3


-- Para cada Tipo de Visita, listar el nombre y obtener con una subconsulta
-- como tabla derivada la cantidad de Reservas realizadas.

-- Linea x linea
SELECT
		TipoVisita,
		[Cantidad Reservas] = 
			COUNT(*)
	FROM TipoVisitas t
		INNER JOIN (SELECT IdTipoVisita FROM Visitas) v
			ON v.IdTipoVisita = t.IdTipoVisita
	GROUP BY TipoVisita

-- Usando grupos
SELECT
    t.IdTipoVisita,
    TipoVisita,
    Reservas
    FROM TipoVisitas t
    INNER JOIN (SELECT IdTipoVisita, COUNT(IdReserva) AS Reservas
                    FROM Visitas
                    GROUP BY IdTipoVisita) Visitas
        ON Visitas.IdTipoVisita = t.IdTipoVisita;



-- EJ 4

-- Para cada Guía, listar el nombre y obtener con una subconsulta
-- como tabla derivada la cantidad de Visitas en las que participó como Responsable.
-- En caso de no haber participado en ninguna, mostrar el número cero.

SELECT
		Guia,
		[Cantidad Visitas Responsable] = 
			COUNT(Responsable)
	FROM Guias g
		LEFT JOIN (SELECT Responsable FROM VisitasGuias) v 
					ON v.Responsable = g.IdGuia
	GROUP BY Guia



-- EJ 5

-- Para cada Escuela, mostrar el nombre y la cantidad de Reservas
-- realizadas el último año que visitaron el Museo.
-- Resolver con subconsulta correlacionada.

SELECT
		Escuela,
		[Reservas Ultimo Año] = 
			--COUNT(r.IdReserva)
			COUNT(*) 
	FROM Escuelas e
		INNER JOIN Reservas r ON r.IdEscuela = e.IdEscuela
	WHERE YEAR(Fecha) = (SELECT MIN(YEAR(Fecha))
							FROM Reservas r2
								WHERE r2.IdEscuela = e.IdEscuela)
	GROUP BY Escuela



-- EJ 6

-- Listar el nombre de las Escuelas que realizaron Reservas.
-- Resolver con Exists.

SELECT
        Escuela
    FROM Escuelas e
    WHERE EXISTS(SELECT DISTINCT r.IdEscuela
                    FROM Reservas r
                    WHERE r.IdEscuela = e.IdEscuela);



-- EJ 7

-- Listar el nombre de las Escuelas que realizaron Reservas.
-- Resolver con IN.

-- Forma recomendada?:
SELECT
		IdEscuela,
		Escuela
	FROM Escuelas e
	WHERE e.IdEscuela IN(SELECT DISTINCT IdEscuela
							FROM Reservas r
							WHERE r.IdEscuela = e.IdEscuela)
-- Forma + Rapida?:
SELECT
		IdEscuela,
		Escuela
	FROM Escuelas e
	WHERE e.IdEscuela IN(SELECT IdEscuela
							FROM Reservas r)





-- EJ 8


-- Escribir todas las consultas anteriores con combinación de tablas
-- y comparar el plan de ejecución.



-- EJ 8.1

-- Listar Código y Nombre de cada Escuela,
-- y obtener la cantidad de Reservas realizadas.

SELECT
		e.IdEscuela,
		Escuela,
		[Cantidad Reservas] = 
			COUNT(r.IdEscuela)
	FROM Escuelas e
	    -- Utilizar la segunda unión para obtener CEROS
		INNER JOIN Reservas r ON r.IdEscuela = e.IdEscuela
		--LEFT JOIN Reservas r ON r.IdEscuela = e.IdEscuela
	GROUP BY e.IdEscuela, Escuela



-- EJ 8.2

-- Listar Código y Nombre de cada Escuela,
-- y obtener la cantidad de Reservas realizadas durante el presente año.
-- En caso de no haber realizado Reservas, mostrar el número cero.

SELECT
		e.IdEscuela,
		Escuela,
		[Cantidad Reservas] = 
			COUNT(r.IdEscuela)
	FROM Escuelas e
		LEFT JOIN Reservas r ON r.IdEscuela = e.IdEscuela
								AND YEAR(Fecha) = YEAR(GETDATE())
	-- Quitar la sentencia AND y usar WHERE para obtener CEROS
	-- WHERE YEAR(Fecha) = YEAR(GETDATE())
	GROUP BY e.IdEscuela, Escuela



-- EJ 8.3

-- Para cada Tipo de Visita, listar el nombre y
-- obtener la cantidad de Reservas realizadas.

SELECT
    --t.IdTipoVisita,
    TipoVisita,
    COUNT(v.IdReserva) AS Reservas
    FROM TipoVisitas t
        LEFT JOIN Visitas v ON v.IdTipoVisita = t.IdTipoVisita
    GROUP BY t.IdTipoVisita, TipoVisita;



-- EJ 8.4

-- Para cada Guía, listar el nombre y obtener
-- cantidad de Visitas en las que participó como Responsable.
-- En caso de no haber participado en ninguna, mostrar el número cero.

SELECT
    --g.IdGuia,
    Guia,
    COUNT(v.IdGuia) AS 'Visitas Responsable'
    FROM Guias g
        LEFT JOIN VisitasGuias v ON v.Responsable = g.IdGuia
    GROUP BY g.IdGuia, Guia;



-- EJ 8.5

/*
-- Para cada Escuela, mostrar el nombre y la cantidad de Reservas
-- realizadas el último año que visitaron el Museo.

--TODO: DOES NOT WORK - I can not convert from the original

SELECT
    e.IdEscuela,
    Escuela,
    COUNT(r.IdReserva) AS Reservas
    FROM Escuelas e
        INNER JOIN Reservas r ON r.IdEscuela = e.IdEscuela
            --AND YEAR(r.Fecha) = MAX(YEAR(r.Fecha)) -- Año más reciente
        INNER JOIN Visitas v ON v.IdReserva = r.IdReserva
    WHERE YEAR(r.Fecha) = MAX(YEAR(r.Fecha)) -- Año más reciente
    GROUP BY e.IdEscuela, Escuela;
*/


-- EJ 8.6 && 8.7

-- Listar el nombre de las Escuelas que realizaron Reservas.

-- ...Resolver con Exists && Resolver con IN...

SELECT DISTINCT Escuela
    FROM Escuelas e
        JOIN Reservas r ON r.IdEscuela = e.IdEscuela
    ORDER BY Escuela;
