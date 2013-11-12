-- ASUNTO: Guia 4 BBDD
-- AUTOR: Lucio Martínez
-- LICENCIA: MIT license



-- EJ 1

-- Listar nombre y teléfonos de cada escuela.

SELECT
        Escuela,
        Telefono
    FROM EscuelasTelefonos t
        JOIN Escuelas e ON t.IdEscuela = e.IdEscuela;



-- EJ 2

-- Listar Nombre y cantidad de Reservas realizadas
-- para cada Escuela durante el presente año.

SELECT
        Escuela,
        [Reservas] = COUNT(IdReserva)
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    WHERE YEAR(Fecha) = YEAR(GETDATE())
    GROUP BY Escuela;



-- EJ 3

-- Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año,
-- en caso de no haber realizado Reservas mostrar el número cero.


SELECT
		Escuela,
		[Reservas Actual Año] = 
			COUNT(r.IdEscuela)
	FROM [Escuelas] e
		LEFT JOIN [Reservas] r ON r.IdEscuela = e.IdEscuela
								AND YEAR(Fecha) = YEAR(GETDATE())
	GROUP BY Escuela
	ORDER BY Escuela DESC;


-- EJ 4

-- Listar el nombre de los Guías que participaron en las Visitas,
-- pero no como Responsable.

-- Retorna Guias que estuvieron en visitas pero *nunca* Responsables
SELECT
		g.IdGuia,
		Guia
	FROM Guias g
		INNER JOIN VisitasGuias v ON v.IdGuia = g.IdGuia
	WHERE g.IdGuia NOT IN(SELECT DISTINCT v2.IdGuia
								FROM VisitasGuias v2
								WHERE v2.Responsable = g.IdGuia)
	GROUP BY g.IdGuia, Guia 
	
-- Retorna guias que tuvieron visitas pero no estuvieron responsables en *alguna* guia
/*
SELECT
        g.IdGuia,
        Guia
    FROM Guias g
        JOIN VisitasGuias v ON g.IdGuia = v.IdGuia
    WHERE Responsable != g.IdGuia
        OR Responsable IS NULL;
*/


-- EJ 5

-- Listar el nombre de los Guías que no participaron de ninguna Visita.

SELECT
		g.IdGuia
	FROM Guias g
		LEFT JOIN VisitasGuias v ON v.IdGuia = g.IdGuia
									-- Comenta la siguiente linea para
									-- obtener los guías que hallan estado 
									-- como Responsables *al menos una vez*.
									OR Responsable = g.IdGuia
	WHERE v.IdGuia IS NULL -- Obtiene los guías que no estuvieron
	GROUP BY g.IdGuia
	ORDER BY g.IdGuia



-- EJ 6

-- Listar para cada Visita, el nombre de Escuela, el nombre del Guía responsable,
-- la cantidad de alumnos que concurrieron y la fecha en que se llevó a cabo.
-- NOTA: no muestra reservas sin visitas!! (bien?)

SELECT
		Escuela,
		Guia,
		CantidadRealAlumnos,
		Fecha
	FROM Visitas v
		INNER JOIN Reservas r      ON  r.IdReserva =  v.IdReserva
		INNER JOIN VisitasGuias vg ON vg.IdReserva =  r.IdReserva
		INNER JOIN Guias g         ON  g.IdGuia    = vg.IdGuia
		INNER JOIN Escuelas e      ON  e.IdEscuela =  r.IdEscuela



-- EJ 7

-- Listar el nombre de cada Escuela y su localidad.
-- También deben aparecer las Localidades que no tienen Escuelas,
-- indicando Sin Escuelas. Algunas Escuelas no tienen cargada la Localidad,
-- debe indicar Sin Localidad.

SELECT
		[Escuelas] =
			ISNULL(Escuela, 'Sin Escuelas'),
		[Localidades] =
			ISNULL(Localidad, 'Sin Localidad')
	FROM Escuelas e
		FULL JOIN Localidades l ON l.IdLocalidad = e.IdLocalidad



-- EJ 8

-- Listar el nombre de los Directores  y el de los Guías,
-- juntos, ordenados alfabéticamente.

SELECT
    Guia AS Persona
    FROM Guias UNION ALL
        SELECT
            Director AS Persona
            FROM Escuelas
            ORDER BY Persona ASC;

/* -- Use this as a sub-query:
SELECT
    Persona
    FROM (SELECT Guia AS Persona
                FROM Guias UNION ALL
                    SELECT Director AS Persona
                        FROM Escuelas) AS newTable
    ORDER BY Persona ASC;
*/



-- EJ 9

-- Listar el nombre de los Directores de las escuelas de Mar del Plata,
-- y el de todos los Guías, juntos, ordenados alfabéticamente.

SELECT
	[Persona] = Director
	FROM Escuelas 
	WHERE IdLocalidad = 1000 UNION ALL -- Localidad '1000' es Mar del Plata
		SELECT 
			[Persona] = Guia
			FROM Guias
	ORDER BY Persona



-- EJ 10

-- Listar para las Escuelas que tienen Reservas,
-- el nombre y la Localidad, teniendo en cuenta que
-- algunas Escuelas no tienen Localidad.


-- [Pre-ejercicio] (opcionalmente) quitar la localidad de una escuela:

-- [Estado Previo] Escuela: 4 Localidad: 1006
-- [Estado Posterior] Escuela: 4 Localidad: null
/*
UPDATE Escuelas
    SET IdLocalidad = null
    WHERE IdEscuela = 4;
*/

SELECT
		Escuela,
		[Localidad] = ISNULL(Localidad, 'Sin localidad')
	FROM Escuelas e
		INNER JOIN Reservas r ON r.IdEscuela = e.IdEscuela
		LEFT JOIN Localidades l ON l.IdLocalidad = e.IdLocalidad
