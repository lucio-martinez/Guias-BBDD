-- ASUNTO: Guia 4 BBDD
-- AUTOR: Lucio Martínez
-- LICENSE: MIT license



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
    COUNT(IdReserva) AS Reservas
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    WHERE YEAR(Fecha) = YEAR(GetDate())
    GROUP BY Escuela;



-- EJ 3

-- Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año,
-- en caso de no haber realizado Reservas mostrar el número cero.

SELECT
    Escuela,
    COUNT(IdReserva) AS Reservas
    FROM Escuelas e
        LEFT JOIN Reservas r ON r.IdEscuela = e.IdEscuela
    WHERE
        YEAR(Fecha) = YEAR(GetDate())
        OR YEAR(Fecha) IS NULL -- Quitar esta linea para no mostrar ceros
    GROUP BY Escuela;


-- EJ 4

-- Listar el nombre de los Guías que participaron en las Visitas,
-- pero no como Responsable.


-- Retorna guias que tuvieron visitas pero no estuvieron responsables en *alguna* guia
/*
SELECT
    g.IdGuia,
    Guia
    FROM Guias g
    JOIN VisitasGuias v
        ON g.IdGuia = v.IdGuia
    WHERE Responsable != g.IdGuia
        --AND (Responsable != g.IdGuia
        OR Responsable IS NULL;
*/
-- Retorna Guias que estuvieron en visitas pero *nunca* Responsables

--TODO: hacerlo andar en caso de NULL
/*
SELECT
    g.IdGuia,
    Guia
    FROM Guias g
    JOIN VisitasGuias v
        ON g.IdGuia = v.IdGuia
            AND (Responsable IS NULL OR g.IdGuia != Responsable)
    WHERE
        g.IdGuia NOT IN (
                        --ISNULL((
                            SELECT Responsable
                                FROM VisitasGuias
                                WHERE Responsable IS NOT NULL)
                            --, g.IdGuia+1))
;
*/


-- EJ 5

-- Listar el nombre de los Guías que no participaron de ninguna Visita.

SELECT
    IdGuia,
    Guia
    FROM Guias g
    -- Activate this first query if you want to get Responsables case
    --WHERE IdGuia NOT IN (SELECT IdGuia FROM VisitasGuias);
    -- Activate this second query if you DO NOT want to get Responsables case
    WHERE NOT EXISTS (SELECT DISTINCT IdGuia, Responsable
                        FROM VisitasGuias v
                        WHERE g.IdGuia = v.IdGuia OR
                            g.IdGuia = Responsable);



-- EJ 6

-- Listar para cada Visita, el nombre de Escuela, el nombre del Guía responsable,
-- la cantidad de alumnos que concurrieron y la fecha en que se llevó a cabo.
-- NOTA: no muestra reservas sin visitas!! (bien?)

SELECT
    --r.IdReserva,
    --e.IdEscuela,
    Escuela,
    --g.IdGuia,
    Guia,
    CantidadRealAlumnos,
    Fecha
    FROM Visitas v
        JOIN VisitasGuias vg ON v.IdReserva = vg.IdReserva
        JOIN Reservas r ON v.IdReserva = r.IdReserva
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
        JOIN Guias g ON vg.IdGuia = g.IdGuia;



-- EJ 7

-- Listar el nombre de cada Escuela y su localidad.
-- También deben aparecer las Localidades que no tienen Escuelas,
-- indicando Sin Escuelas. Algunas Escuelas no tienen cargada la Localidad,
-- debe indicar Sin Localidad.

-- NOTA: los siguientes 2 queries logran el objectivo si se unen en 1 tabla temporal,
-- TODO: usar UNION ALL para hacerlo andar en 1 query ;)

-- Muestra Escuelas y su localidad, Sin Localidad si no tiene
SELECT
    Escuela,
    ISNULL(Localidad, 'Sin Localidad') AS Localidad
/*
    CASE
        WHEN e.IdLocalidad IS NULL THEN 'Sin Localidad'
        ELSE Localidad
    END AS Localidad
*/
    FROM Escuelas e
        LEFT JOIN Localidades l ON e.IdLocalidad = l.IdLocalidad
    ORDER BY Escuela DESC;

-- Muestra todas las Localidades y su(s) escuela(s),
-- si hay CERO escuelas en la localidad muestra 'Sin Escuela'
SELECT
    Localidad,
    ISNULL(Escuela, 'Sin Escuela') AS Escuela
    -- Use the previous ISNULL function is the same
    -- that using this sub-query:
    /*
    ISNULL((SELECT TOP 1 Escuela
                FROM Escuelas e2
                WHERE e2.IdLocalidad = l.IdLocalidad AND
                    e2.IdEscuela = e.IdEscuela), 'Sin Escuela') AS Escuelas
    */
    FROM Localidades l
        LEFT JOIN Escuelas e ON l.IdLocalidad = e.IdLocalidad
    ORDER BY Localidad;



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
    Guia AS Persona
    FROM Guias
    UNION ALL
        SELECT Director AS Persona
            FROM Escuelas e
                INNER JOIN Localidades l ON e.IdLocalidad = l.IdLocalidad
            --WHERE l.IdLocalidad = 1000
            WHERE Localidad = 'Mar del Plata'
    ORDER BY Persona;



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
    ISNULL(Localidad, 'Sin Localidad') AS Localidad
    FROM Escuelas e
        LEFT JOIN Localidades l ON e.IdLocalidad = l.IdLocalidad
    WHERE EXISTS(SELECT DISTINCT r.IdEscuela
                    FROM Reservas r
                    WHERE r.IdEscuela = e.IdEscuela);
