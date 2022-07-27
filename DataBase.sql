create database DB_CARRITO
GO
USE DB_CARRITO
GO

CREATE TABLE CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)

go

CREATE TABLE MARCA(
IdMarca int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)

go

CREATE TABLE PRODUCTO(
IdProducto int primary key identity,
Nombre varchar(500),
Descripcion varchar(500),
IdMarca int references Marca(IdMarca),
IdCategoria int references Categoria(IdCategoria),
Precio decimal(10,2) default 0,
Stock int,
RutaImagen varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)

go

CREATE TABLE USUARIO(
IdUsuario int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Contrasena varchar(100),
EsAdministrador bit,
Activo bit default 1,
FechaRegistro datetime default getdate()
)

go


CREATE TABLE CARRITO(
IdCarrito int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
IdProducto int references PRODUCTO(IdProducto)
)

go



create table COMPRA(
IdCompra int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
TotalProducto int,
Total decimal(10,2),
Contacto varchar(50),
Telefono varchar(50),
Direccion varchar(500),
IdDistrito varchar(10),
FechaCompra datetime default getdate()
)

go

create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity,
IdCompra int references Compra(IdCompra),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int,
Total decimal(10,2)
)

go

CREATE TABLE DEPARTAMENTO (
  IdDepartamento varchar(2) NOT NULL,
  Descripcion varchar(45) NOT NULL
) 

go

CREATE TABLE CIUDAD (
  IdCiudad varchar(4) NOT NULL,
  Descripcion varchar(45) NOT NULL,
  IdDepartamento varchar(2) NOT NULL
) 

go

CREATE TABLE Barrio (
  IdBarrio varchar(6) NOT NULL,
  Descripcion varchar(45) NOT NULL,
  IdCiudad varchar(4) NOT NULL,
  IdDepartamento varchar(2) NOT NULL
)



-- Procedimientos almacenados

create proc sp_obtenerCategoria
as
begin
 select * from CATEGORIA
end


go


--PROCEDIMIENTO PARA GUARDAR CATEGORIA
CREATE PROC sp_RegistrarCategoria(
@Descripcion varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)

		insert into CATEGORIA(Descripcion) values (
		@Descripcion
		)
	ELSE
		SET @Resultado = 0
	
end

go

--PROCEDIMIENTO PARA MODIFICAR CATEGORIA
create procedure sp_ModificarCategoria(
@IdCategoria int,
@Descripcion varchar(60),
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion =@Descripcion and IdCategoria != @IdCategoria)
		
		update CATEGORIA set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria
	ELSE
		SET @Resultado = 0

end


GO
create proc sp_obtenerMarca
as
begin
 select * from MARCA
end

go

--PROCEDIMIENTO PARA GUARDAR MARCA
CREATE PROC sp_RegistrarMarca(
@Descripcion varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion)

		insert into MARCA(Descripcion) values (
		@Descripcion
		)
	ELSE
		SET @Resultado = 0
	
end

go

--PROCEDIMIENTO PARA MODIFICAR MARCA
create procedure sp_ModificarMarca(
@IdMarca int,
@Descripcion varchar(60),
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion =@Descripcion and IdMarca != @IdMarca)
		
		update MARCA set 
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca
	ELSE
		SET @Resultado = 0

end

GO
create proc sp_obtenerProducto
as
begin
 select p.*,m.Descripcion[DescripcionMarca],c.Descripcion[DescripcionCategoria] from PRODUCTO p
 inner join marca m on m.IdMarca = p.IdMarca
 inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

end

go

create proc sp_registrarProducto(
@Nombre varchar(500),
@Descripcion varchar(500),
@IdMarca int,
@IdCategoria int,
@Precio decimal(10,2),
@Stock int,
@RutaImagen varchar(500),
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Descripcion = @Descripcion)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values (
		@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@RutaImagen)

		SET @Resultado = scope_identity()
	end
end

go

create proc sp_editarProducto(
@IdProducto int,
@Nombre varchar(500),
@Descripcion varchar(500),
@IdMarca int,
@IdCategoria int,
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Descripcion = @Descripcion and IdProducto != @IdProducto)
	begin
		update PRODUCTO set 
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio =@Precio ,
		Stock =@Stock ,
		Activo = @Activo where IdProducto = @IdProducto

		SET @Resultado =1
	end
end

go
create proc sp_actualizarRutaImagen(
@IdProducto int,
@RutaImagen varchar(500)
)
as
begin
	update PRODUCTO set RutaImagen = @RutaImagen where IdProducto = @IdProducto
end

go

create proc sp_obtenerUsuario(
@Correo varchar(100),
@Contrasena varchar(100)
)
as
begin
	IF EXISTS (SELECT * FROM usuario WHERE correo = @Correo and contrasena = @Contrasena)
	begin
		SELECT IdUsuario,Nombres,Apellidos,Correo,Contrasena,EsAdministrador FROM usuario WHERE correo = @Correo and contrasena = @Contrasena
	end
end


go

create proc sp_registrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Contrasena varchar(100),
@EsAdministrador bit,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	begin
		insert into USUARIO(Nombres,Apellidos,Correo,Contrasena,EsAdministrador) values
		(@Nombres,@Apellidos,@Correo,@Contrasena,@EsAdministrador)

		SET @Resultado = scope_identity()
	end
end
go

create proc sp_InsertarCarrito(
@IdUsuario int,
@IdProducto int,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists (select * from CARRITO where IdProducto = @IdProducto and IdUsuario = @IdUsuario)
	begin
		update PRODUCTO set Stock = Stock -1 where IdProducto = @IdProducto
		insert into CARRITO(IdUsuario,IdProducto) values ( @IdUsuario,@IdProducto)
		set @Resultado = 1
	end
	
end

go

create proc sp_ObtenerCarrito(
@IdUsuario int
)
as
begin
	select c.IdCarrito, p.IdProducto,m.Descripcion,p.Nombre,p.Precio,p.RutaImagen from carrito c
	inner join PRODUCTO p on p.IdProducto = c.IdProducto
	inner join MARCA m on m.IdMarca = p.IdMarca
	where c.IdUsuario = @IdUsuario
end

go


create proc sp_registrarCompra(
@IdUsuario int,
@TotalProducto int,
@Total decimal(10,2),
@Contacto varchar(100),
@Telefono varchar(100),
@Direccion varchar(100),
@IdDistrito varchar(10),
@QueryDetalleCompra nvarchar(max),
@Resultado bit output
)
as
begin
	begin try
		SET @Resultado = 0
		begin transaction
		
		declare @idcompra int = 0
		insert into COMPRA(IdUsuario,TotalProducto,Total,Contacto,Telefono,Direccion,IdDistrito) values
		(@IdUsuario,@TotalProducto,@Total,@Contacto,@Telefono,@Direccion,@IdDistrito)

		set @idcompra = scope_identity()

		set @QueryDetalleCompra = replace(@QueryDetalleCompra,'�idcompra!',@idcompra)

		EXECUTE sp_executesql @QueryDetalleCompra

		delete from CARRITO where IdUsuario = @IdUsuario

		SET @Resultado = 1

		commit
	end try
	begin catch
		rollback
		SET @Resultado = 0
	end catch
end

go

create proc sp_ObtenerCompra(
@IdUsuario int)
as
begin
select c.Total,convert(char(10),c.FechaCompra,103)[Fecha],

(select m.Descripcion, p.Nombre,p.RutaImagen,dc.Total,dc.Cantidad from DETALLE_COMPRA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
inner join MARCA m on m.IdMarca = p.IdMarca
where dc.IdCompra = c.IdCompra
FOR XML PATH ('PRODUCTO'),TYPE) AS 'DETALLE_PRODUCTO'

from compra c
where c.IdUsuario = @IdUsuario
FOR XML PATH('COMPRA'), ROOT('DATA') 
end

exec sp_ObtenerCompra 2


-- Insertar datos


insert into USUARIO(Nombres,Apellidos,Correo,Contrasena,EsAdministrador) values ('test','user','admin@example.com','admin123',1)

GO
insert into CATEGORIA(Descripcion) values
('Tecnolog�a'),
('Muebles'),
('Dormitorio'),
('Deportes'),
('Zapatos'),
('Accesorios'),
('Jugueter�a'),
('Electrohogar')

GO

insert into MARCA(Descripcion) values
('SONY'),
('HP'),
('LG'),
('HYUNDAI'),
('CANON'),
('ROBERTA ALLEN'),
('MICA'),
('FORLI'),
('BE CRAFTY'),
('ADIDAS'),
('BEST'),
('REEBOK'),
('FOSSIL'),
('BILLABONG'),
('POWCO'),
('HOT WHEELS'),
('LEGO'),
('SAMSUNG'),
('RECCO'),
('INDURAMA'),
('ALFANO'),
('MABE'),
('ELECTROLUX')


GO



insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Consola de PS4 Pro 1TB Negro','Tipo: PS4
Procesador: AMD
Entradas USB: 3
Entradas HDMI: 1
Conectividad: WiFi',1,1,'2000','50','~/Imagenes/Productos/1.jpg')



insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('HP Laptop 15-EF1019LA','Procesador: AMD RYZEN R5
Modelo tarjeta de video: Gr�ficos AMD Radeon
Tama�o de la pantalla: 15.6 pulgadas
Disco duro s�lido: 512GB
N�cleos del procesador: Hexa Core',2,1,'2500','60','~/Imagenes/Productos/2.jpg')


insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Televisor 65 4K Ultra HD Smart TV 65UN7100PSA.AWF','Tama�o de la pantalla: 65 pulgadas
Resoluci�n: 4K Ultra HD
Tecnolog�a: LED
Conexi�n Bluetooth: S�
Entradas USB: 2',3,1,'3000','120','~/Imagenes/Productos/3.jpg')

insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Televisor 50 4K Ultra HD Smart Android','Tama�o de la pantalla: 50 pulgadas
Resoluci�n: 4K Ultra HD
Tecnolog�a: LED
Conexi�n Bluetooth: S�
Entradas USB: 2',4,1,'3200','70','~/Imagenes/Productos/4.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('C�mara Reflex EOS Rebel T100','',5,1,'1560','90','~/Imagenes/Productos/5.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Aparador Surat','Marca: Roberta Allen
Modelo: SURAT
Tipo: Buffets
Alto: 86 cm
Ancho: 85 cm',6,2,'500','60','~/Imagenes/Productos/6.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Mesa de Comedor Donatello','Ancho/Di�metro: 90 cm
Largo: 150 cm
Alto: 75 cm
N�mero de puestos: 6
Material de la base: Madera',7,2,'400','90','~/Imagenes/Productos/7.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Colch�n Polaris 1 Plz + 1 Almohada + Protector','Nivel de confort: Intermedio
Tama�o: 1 plz
Tipo de estructura: Acero
Relleno del colch�n: Resortes
Material del tapiz: Jacquard',8,3,'500','120','~/Imagenes/Productos/8.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Juegos de S�banas 180 Hilos Solid','1.5 PLAZAS',6,3,'200','130','~/Imagenes/Productos/9.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Tocador Franca','Marca: Mica
Tipo: Tocadores
Modelo: Franca
Material de la estructura: Aglomerado MDP
Espesor: 15 mm',7,3,'450','60','~/Imagenes/Productos/10.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Alfombra Infantil de Osa Melange Medio','Marca: Be Crafty
Modelo: Osa
Tipo: Alfombras
Tipo de tejido: A mano
Tama�o: Peque�a',9,3,'120','50','~/Imagenes/Productos/11.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Mochila Unisex Deportivo Classic','NINGUNO',10,4,'220','45','~/Imagenes/Productos/12.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Bicicleta Monta�era Best Inka Aro 29 Roja','NINGUNO',11,4,'890','75','~/Imagenes/Productos/13.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Zapatillas Urbanas Mujer adidas Team Court','TALLA: 4
TALLA:4.5',10,5,'260','80','~/Imagenes/Productos/14.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Zapatillas Training Hombre Rebook Dart TR 2','TALLA: 4
TALLA:4.5',12,5,'230','38','~/Imagenes/Productos/15.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Reloj','NINGUNO',13,6,'300','20','~/Imagenes/Productos/16.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Billetera Hombre','NINGUNO',14,6,'87','88','~/Imagenes/Productos/17.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Auto Deportivo 45 cm Naranja','COLOR: NARANJA',15,7,'90','55','~/Imagenes/Productos/18.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Set de Juego Hot Wheels Robo Tibur�n','NINGUNO',16,7,'130','70','~/Imagenes/Productos/19.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Lego 10713 Set Classic: Malet�n Creativo','NINGUNO',17,7,'110','60','~/Imagenes/Productos/20.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Refrigerador Samsung RT29K571JS8 295 litros','Modelo: RT29K571JS8/PE
Capacidad total �til: 295 lt
Dispensador de agua: S�
Ice maker interior: S�
Material de las bandejas: Vidrio templado',18,8,'2100','90','~/Imagenes/Productos/21.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Ventilador 3 En 1 16 50W','Marca: RECCO
Modelo: RD-40G-3
Tipo: Ventiladores 3 en 1
N�mero de velocidades: 4
Potencia: 50',19,8,'1100','56','~/Imagenes/Productos/22.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Frigobar RI-100BL 92 Lt Blanco','Marca: Indurama
Modelo: RI-100BL
Tipo: Frigobar
Eficiencia energ�tica: A
Capacidad total �til: 92 lt',20,8,'940','78','~/Imagenes/Productos/23.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Aire Acondicionado 12,000 BTU/h Split','Marca: ALFANO
Modelo: 12000 BTU
Tipo: Aires acondicionados Split
Capacidad de enfriamiento: 12000 BTU
Modo: Fr�o',21,8,'1700','56','~/Imagenes/Productos/24.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Lavadora Mabe 16kg','Capacidad de carga: 16KG
Tipo de carga: Superior
Material del tambor: Acero inoxidable
Tecnolog�a: No inverter
Dimensiones (AltoxAnchoxProfundidad): 100cmx62cmx61cm',22,8,'2800','48','~/Imagenes/Productos/25.jpg')
insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,RutaImagen) values('Campana Extractora EJSE202TBJS','Retr�ctil: No
Iluminaci�n: S�
Modelo: EJSE202TBJS
Tipo: Campanas cl�sicas
Alto: 14 cm',23,8,'1500','56','~/Imagenes/Productos/26.jpg')


go



INSERT INTO DEPARTAMENTO(IdDepartamento, Descripcion) VALUES
('01', 'Cundinamarca')


go


INSERT INTO CIUDAD(IdCiudad, Descripcion, IdDepartamento) VALUES
('0101', 'Bogotá', '01')

go



INSERT INTO BARRIO (IdBarrio, Descripcion, IdCiudad, IdDepartamento) VALUES
('010101', 'Chapinero', '0101', '01')