/*
Created     10/22/2013
Modified        10/22/2013
Project     Museo
Model
Company     UTN
Author      Lucio Martínez
Version     1.2
Database        MS SQL 2005
*/



-- Crea todas las tablas necesarias para la implementación de las guías









Create table [Escuelas]
(
    [IdEscuela] Integer Identity(1,1) NOT NULL,
    [Escuela] Varchar(50) NOT NULL, UNIQUE ([Escuela]),
    [Domicilio] Varchar(50) NULL,
    [IdLocalidad] Integer NOT NULL,
Primary Key ([IdEscuela])
)
go

Create table [Localidades]
(
    [IdLocalidad] Integer Identity(1000,1) NOT NULL Check ([IdLocalidad] >= 1000 AND [IdLocalidad] <= 9999),
    [Localidad] Varchar(50) NOT NULL, UNIQUE ([Localidad]),
    [CodigoPostal] Char(4) NULL Check ([CodigoPostal] >= '0000' AND [CodigoPostal] <= '9999'),
Primary Key ([IdLocalidad])
)
go

Create table [EscuelasTelefonos]
(
    [Telefono] Varchar(20) NOT NULL, UNIQUE ([Telefono]),
    [IdEscuela] Integer NOT NULL,
Primary Key ([Telefono],[IdEscuela])
)
go

Create table [Reservas]
(
    [IdReserva] Integer Identity(1,1) NOT NULL,
    [Fecha] Datetime Default GETDATE() NULL,
    [IdEscuela] Integer NOT NULL,
Primary Key ([IdReserva])
)
go

Create table [TipoVisitas]
(
    [IdTipoVisita] Integer Identity(1,1) NOT NULL,
    [TipoVisita] Varchar(20) NULL,
    [Arancel] Money Default 0 NULL,
Primary Key ([IdTipoVisita])
)
go

Create table [Guias]
(
    [IdGuia] Integer Identity(1,1) NOT NULL,
    [Guia] Varchar(50) NOT NULL, UNIQUE ([Guia]),
Primary Key ([IdGuia])
)
go

Create table [Visitas]
(
    [Grado] Tinyint NULL Check ([Grado] >= 1 AND [Grado] <= 15),
    [IdReserva] Integer NOT NULL,
    [IdTipoVisita] Integer NOT NULL,
    [CantidadAlumnos] Integer Default 0 NOT NULL,
    -- [CantidadRealAlumnos] Integer Default CantidadAlumnos NOT NULL Check ([CantidadRealAlumnos] >= 0 AND [CantidadRealAlumnos] <= CantidadAlumnos),
    [CantidadRealAlumnos] Integer Default 0 NOT NULL Check ([CantidadRealAlumnos] >= 0),
    [Arancel] Money NOT NULL Default 0,
Primary Key ([IdReserva],[IdTipoVisita])
)
go

Create table [VisitasGuias]
(
    [Responsable] Integer Default NULL NULL,
    [IdGuia] Integer NOT NULL,
    [IdReserva] Integer NOT NULL,
    [IdTipoVisita] Integer NOT NULL,
Primary Key ([IdGuia],[IdReserva],[IdTipoVisita])
)
go












Alter table [EscuelasTelefonos] add  foreign key([IdEscuela]) references [Escuelas] ([IdEscuela])  on update no action on delete no action
go
Alter table [Reservas] add  foreign key([IdEscuela]) references [Escuelas] ([IdEscuela])  on update no action on delete no action
go
Alter table [Escuelas] add  foreign key([IdLocalidad]) references [Localidades] ([IdLocalidad])  on update no action on delete no action
go
Alter table [Visitas] add  foreign key([IdReserva]) references [Reservas] ([IdReserva])  on update no action on delete no action
go
Alter table [Visitas] add  foreign key([IdTipoVisita]) references [TipoVisitas] ([IdTipoVisita])  on update no action on delete no action
go
Alter table [VisitasGuias] add  foreign key([IdGuia]) references [Guias] ([IdGuia])  on update no action on delete no action
go
--Alter table [VisitasGuias] add  foreign key([IdReserva],[IdTipoVisita]) references [Visitas] ([IdReserva],[IdTipoVisita])  on update no action on delete no action
Alter table [VisitasGuias] add  foreign key([IdReserva]) references [Reservas] ([IdReserva])  on update no action on delete no action
go


Set quoted_identifier on
go









Set quoted_identifier off
go




