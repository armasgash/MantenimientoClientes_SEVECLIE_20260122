/*
 Navicat Premium Data Transfer

 Source Server         : Local 2022
 Source Server Type    : SQL Server
 Source Server Version : 16001000
 Source Host           : armasgash\SQLSERVER2022:1433
 Source Catalog        : SEVECLIE
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001000
 File Encoding         : 65001

 Date: 22/01/2026 18:36:36
*/


-- ----------------------------
-- Table structure for Clientes
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND type IN ('U'))
	DROP TABLE [dbo].[Clientes]
GO

CREATE TABLE [dbo].[Clientes] (
  [id_clie] int  IDENTITY(1,1) NOT NULL,
  [cedula] nvarchar(20) COLLATE Modern_Spanish_CI_AS  NOT NULL,
  [nombre] nvarchar(100) COLLATE Modern_Spanish_CI_AS  NOT NULL,
  [genero] nvarchar(20) COLLATE Modern_Spanish_CI_AS  NULL,
  [fecha_nac] date  NULL,
  [estado_civil] nvarchar(20) COLLATE Modern_Spanish_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[Clientes] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Clientes
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Clientes] ON
GO

INSERT INTO [dbo].[Clientes] ([id_clie], [cedula], [nombre], [genero], [fecha_nac], [estado_civil]) VALUES (N'1', N'12345678', N'Juan Perez', N'M', N'1990-05-15', N'1')
GO

INSERT INTO [dbo].[Clientes] ([id_clie], [cedula], [nombre], [genero], [fecha_nac], [estado_civil]) VALUES (N'2', N'87654321', N'Maria Garcia', N'F', N'1985-10-25', N'2')
GO

INSERT INTO [dbo].[Clientes] ([id_clie], [cedula], [nombre], [genero], [fecha_nac], [estado_civil]) VALUES (N'3', N'123_456', N'Empleado de pruebas', N'M', N'1977-12-24', N'2')
GO

INSERT INTO [dbo].[Clientes] ([id_clie], [cedula], [nombre], [genero], [fecha_nac], [estado_civil]) VALUES (N'1002', N'5194872', N'Ultima Prueba', N'F', N'2010-01-22', N'3')
GO

SET IDENTITY_INSERT [dbo].[Clientes] OFF
GO


-- ----------------------------
-- Table structure for EstadoCivil
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[EstadoCivil]') AND type IN ('U'))
	DROP TABLE [dbo].[EstadoCivil]
GO

CREATE TABLE [dbo].[EstadoCivil] (
  [id_estado] int  IDENTITY(1,1) NOT NULL,
  [descripcion] nvarchar(50) COLLATE Modern_Spanish_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[EstadoCivil] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of EstadoCivil
-- ----------------------------
SET IDENTITY_INSERT [dbo].[EstadoCivil] ON
GO

INSERT INTO [dbo].[EstadoCivil] ([id_estado], [descripcion]) VALUES (N'1', N'Soltero')
GO

INSERT INTO [dbo].[EstadoCivil] ([id_estado], [descripcion]) VALUES (N'2', N'Casado')
GO

INSERT INTO [dbo].[EstadoCivil] ([id_estado], [descripcion]) VALUES (N'3', N'Divorciado')
GO

INSERT INTO [dbo].[EstadoCivil] ([id_estado], [descripcion]) VALUES (N'4', N'Viudo')
GO

SET IDENTITY_INSERT [dbo].[EstadoCivil] OFF
GO


-- ----------------------------
-- procedure structure for sp_MantenimientoCliente
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MantenimientoCliente]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_MantenimientoCliente]
GO

CREATE PROCEDURE [dbo].[sp_MantenimientoCliente]
    @id_clie INT = 0,
    @cedula NVARCHAR(20),
    @nombre NVARCHAR(100),
    @genero NVARCHAR(20),
    @fecha_nac DATE,
    @estado_civil NVARCHAR(20)
AS
BEGIN
    IF @id_clie = 0
        INSERT INTO Clientes (cedula, nombre, genero, fecha_nac, estado_civil)
        VALUES (@cedula, @nombre, @genero, @fecha_nac, @estado_civil);
    ELSE
        UPDATE Clientes SET 
            cedula=@cedula, nombre=@nombre, genero=@genero, 
            fecha_nac=@fecha_nac, estado_civil=@estado_civil
        WHERE id_clie=@id_clie;
END
GO


-- ----------------------------
-- procedure structure for sp_ConsultarClientesFiltrado
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarClientesFiltrado]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_ConsultarClientesFiltrado]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarClientesFiltrado]
    @Filtro NVARCHAR(100) = ''
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.id_clie, 
        c.cedula, 
        c.nombre, 
        -- Traducción de Género (Requisito de interfaz)
        CASE WHEN c.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END AS genero,
        c.fecha_nac, 
        -- Traducción de Estado Civil (Requisito de interfaz usando JOIN)
        e.descripcion AS estado_civil 
    FROM Clientes c
    INNER JOIN EstadoCivil e ON c.estado_civil = e.id_estado -- Asegúrate que el campo se llame id_estado en la tabla EstadoCivil
    WHERE c.nombre LIKE '%' + @Filtro + '%' 
       OR c.cedula LIKE '%' + @Filtro + '%'
    ORDER BY c.nombre ASC;
END
GO


-- ----------------------------
-- procedure structure for sp_ConsultarEstadosCiviles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarEstadosCiviles]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_ConsultarEstadosCiviles]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarEstadosCiviles]
AS
BEGIN
    SELECT id_estado, descripcion FROM EstadoCivil
END
GO


-- ----------------------------
-- procedure structure for sp_EliminarCliente
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_EliminarCliente]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_EliminarCliente]
GO

CREATE PROCEDURE [dbo].[sp_EliminarCliente]
    @id_clie INT
AS
BEGIN
    DELETE FROM Clientes WHERE id_clie = @id_clie
END
GO


-- ----------------------------
-- Auto increment value for Clientes
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[Clientes]', RESEED, 1002)
GO


-- ----------------------------
-- Uniques structure for table Clientes
-- ----------------------------
ALTER TABLE [dbo].[Clientes] ADD CONSTRAINT [UQ__Clientes__415B7BE5F4F25E37] UNIQUE NONCLUSTERED ([cedula] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table Clientes
-- ----------------------------
ALTER TABLE [dbo].[Clientes] ADD CONSTRAINT [PK__Clientes__6FA7407D581E329B] PRIMARY KEY CLUSTERED ([id_clie])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for EstadoCivil
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[EstadoCivil]', RESEED, 1001)
GO


-- ----------------------------
-- Primary Key structure for table EstadoCivil
-- ----------------------------
ALTER TABLE [dbo].[EstadoCivil] ADD CONSTRAINT [PK__EstadoCi__86989FB20E0A6F7F] PRIMARY KEY CLUSTERED ([id_estado])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

