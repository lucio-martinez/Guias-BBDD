-- ASUNTO: Guia 6 BBDD
-- AUTOR: Lucio Martínez
-- LICENSE: MIT license



-- EJ 1

-- Listar la cantidad de Reservas realizadas para cada Escuela,
-- ordenar el resultado por identificador de Escuela

SELECT
    r.IdEscuela,
    e.Escuela,
    COUNT(*) AS 'Reservas'
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    GROUP BY r.IdEscuela, e.Escuela
    ORDER BY r.IdEscuela;



-- EJ 2

-- listar la cantidad de Reservas realizadas
-- para cada Escuela, en cada mes

SELECT
    r.IdEscuela,
    e.Escuela,
    MONTH(Fecha) as 'Numero del Mes',
    COUNT(*) AS 'Reservas'
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    GROUP BY r.IdEscuela, MONTH(Fecha), e.Escuela
    ORDER BY IdEscuela;



-- EJ 3

-- Listar para cada Reserva, la cantidad total de Alumnos
-- para los que se reservó y la cantidad total de Alumnos
-- que concurrieron en realidad.

SELECT
    r.IdReserva,
    CantidadAlumnos,
    CantidadRealAlumnos
    FROM Reservas r
        JOIN Visitas v ON r.IdReserva = v.IdReserva
    GROUP BY r.IdReserva, CantidadAlumnos, CantidadRealAlumnos;



-- EJ 4

-- Listar para cada Escuela, la primera y la última fecha de Reserva,
-- ordenar el resultado por identificador de Escuela en forma descendente.

SELECT
    r.IdEscuela,
    e.Escuela,
    CONVERT(varchar(10), MIN( Fecha ), 120) AS 'Fecha de Primer Reserva',
    CONVERT(varchar(10), MAX( Fecha ), 120) AS 'Fecha de Última Reserva'
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    GROUP BY r.IdEscuela, Escuela
    ORDER BY IdEscuela DESC;



-- EJ 5

-- Listar para cada Guía, la cantidad de reservas en las que participó.

SELECT
    v.IdGuia,
    g.Guia,
    COUNT(IdReserva) AS Reservas
    FROM VisitasGuias v
        JOIN Guias g ON v.IdGuia = g.IdGuia
    GROUP BY v.IdGuia, g.Guia;



-- EJ 6

-- Listar para cada Guía, la cantidad de reservas
-- de día completo en las que participó.

SELECT
    v.IdGuia,
    g.Guia,
    COUNT(IdReserva) AS Reservas
    FROM VisitasGuias v
        JOIN Guias g ON v.IdGuia = g.IdGuia
    WHERE IdTipoVisita = 1
    GROUP BY v.IdGuia, g.Guia;



-- EJ 7

-- Listar para cada Guía, la cantidad de reservas de día completo
-- en las que participó, cuando haya superado las 5 participaciones.

SELECT
    v.IdGuia,
    g.Guia,
    COUNT(IdReserva) AS Reservas
    FROM VisitasGuias v
        JOIN Guias g ON v.IdGuia = g.IdGuia
    WHERE IdTipoVisita = 1
    GROUP BY v.IdGuia, g.Guia
    HAVING COUNT(IdReserva) > 5; -- Cambiar a un numero menor para probar



-- EJ 8

-- Listar el Guía que haya participado en mayor cantidad de reservas.

SELECT TOP 1
    v.IdGuia,
    g.Guia,
    COUNT(IdReserva) AS Reservas
    FROM VisitasGuias v
        JOIN Guias g ON v.IdGuia = g.IdGuia
    GROUP BY v.IdGuia, g.Guia
    ORDER BY COUNT(IdReserva) DESC;



-- EJ 9

-- Listar las Escuelas que hayan hecho reservas en el mes de agosto de 2012.
-- Tener en cuenta que las Escuelas pueden realizar más de una reserva mensual.

SELECT
    r.IdEscuela,
    e.Escuela,
    COUNT(IdReserva) AS 'Reservas en Agosto'
    FROM Reservas r
        JOIN Escuelas e ON r.IdEscuela = e.IdEscuela
    WHERE MONTH(Fecha) = 8
    GROUP BY r.IdEscuela, e.Escuela;
