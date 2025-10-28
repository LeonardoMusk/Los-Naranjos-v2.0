use NaranjosDos
go
--Stored procedures
--Cliente
create procedure sp_cliente_getall
as
begin
	select * from cliente
end
go
create procedure sp_cliente_getbyid
@id int
as
begin
	select * from cliente where id_cliente = @id
end
go
create procedure sp_cliente_i
@nombre nvarchar(100),
@dni nvarchar(20),
@telefono nvarchar(20),
@email nvarchar(100),
@calle nvarchar(100),
@numero int,
@id_localidad int
as
begin
	insert into cliente (nombre, dni, telefono, email, calle, numero, id_localidad)
	values (@nombre, @dni, @telefono, @email, @calle, @numero, @id_localidad)
end
go
create procedure sp_cliente_u
@id int,
@nombre nvarchar(100),
@dni nvarchar(20),
@telefono nvarchar(20),
@email nvarchar(100),
@calle nvarchar(100),
@numero int,
@id_localidad int
as
begin
	update cliente
	set nombre = @nombre,
		dni = @dni,
		telefono = @telefono,
		email = @email,
		calle = @calle,
		numero = @numero,
		id_localidad = @id_localidad
	where id_cliente = @id
end
go
create procedure sp_cliente_d
@id int
as
begin
	delete from cliente where id_cliente = @id
end
go
--Proveedor
create procedure sp_proveedor_getall
as
begin
	select * from proveedor
end
go
create procedure sp_proveedor_getbyid
@id int
as
begin
	select * from proveedor where id_proveedor = @id
end
go
create procedure sp_proveedor_i
@razon_social nvarchar(100),
@cuit nvarchar(20),
@id_rubro int,
@telefono nvarchar(20),
@email nvarchar(100),
@calle nvarchar(100),
@numero int,
@id_localidad int
as
begin
	insert into proveedor (razon_social, cuit, id_rubro, telefono, email, calle, numero, id_localidad)
	values (@razon_social, @cuit, @id_rubro, @telefono, @email, @calle, @numero, @id_localidad)
end
go
create procedure sp_proveedor_u
@id int,
@razon_social nvarchar(100),
@cuit nvarchar(20),
@id_rubro int,
@telefono nvarchar(20),
@email nvarchar(100),
@calle nvarchar(100),
@numero int,
@id_localidad int
as
begin
	update proveedor
	set razon_social = @razon_social,
		cuit = @cuit,
		id_rubro = @id_rubro,
		telefono = @telefono,
		email = @email,
		calle = @calle,
		numero = @numero,
		id_localidad = @id_localidad
	where id_proveedor = @id
end
go
create procedure sp_proveedor_d
@id int
as
begin
	delete from proveedor where id_proveedor = @id
end
go
--Producto
create procedure sp_producto_getall
as
begin
	select * from producto
end
go
create procedure sp_producto_getbyid
@id int
as
begin
	select * from producto where id_producto = @id
end
go
create procedure sp_producto_i
@nombre nvarchar(100),
@codigo nvarchar(50),
@precio decimal(10,2),
@stock int,
@descripcion nvarchar(100),
@id_categoria int,
@id_proveedor int
as
begin
	insert into producto (nombre, codigo, precio, stock, descripcion, id_categoria, id_proveedor)
	values (@nombre, @codigo, @precio, @stock, @descripcion, @id_categoria, @id_proveedor)
end
go
create procedure sp_producto_u
@id int,
@nombre nvarchar(100),
@codigo nvarchar(50),
@precio decimal(10,2),
@stock int,
@descripcion nvarchar(100),
@id_categoria int,
@id_proveedor int
as
begin
	update producto
	set nombre = @nombre,
		codigo = @codigo,
		precio = @precio,
		stock = @stock,
		descripcion = @descripcion,
		id_categoria = @id_categoria,
		id_proveedor = @id_proveedor
	where id_producto = @id
end
go
create procedure sp_producto_d
@id int
as
begin
	delete from producto where id_producto = @id
end
go
--Reserva
create procedure sp_reserva_getall
as
begin
	select * from Reserva
end
go
create procedure sp_reserva_getbyid
@id int
as
begin
	select * from Reserva where id_reserva = @id
end
go
create procedure sp_reserva_i
@id_cliente int,
@fecha_reserva datetime
as
begin
	insert into Reserva (id_cliente, fecha_reserva)
	values (@id_cliente, @fecha_reserva)
	
	select SCOPE_IDENTITY() as id_reserva
end
go
create procedure sp_reserva_u
@id int,
@id_cliente int,
@fecha_reserva datetime,
@estado nvarchar(20)
as
begin
	update Reserva
	set id_cliente = @id_cliente,
		fecha_reserva = @fecha_reserva,
		estado = @estado
	where id_reserva = @id
end
go
create procedure sp_reserva_d
@id int
as
begin
	delete from Detalle_Reserva where id_reserva = @id
	delete from Reserva where id_reserva = @id
end
go
--Detalle_Reserva
create procedure sp_detalle_reserva_getbyreserva
@id_reserva int
as
begin
	select * from Detalle_Reserva where id_reserva = @id_reserva
end
go
create procedure sp_detalle_reserva_i
@id_reserva int,
@id_producto int,
@cantidad int,
@precio_unitario decimal(10,2)
as
begin
	declare @subtotal decimal(10,2)
	set @subtotal = @cantidad * @precio_unitario
	
	insert into Detalle_Reserva (id_reserva, id_producto, cantidad, precio_unitario, subtotal)
	values (@id_reserva, @id_producto, @cantidad, @precio_unitario, @subtotal)
	
	-- Actualizar el total de la reserva
	update Reserva
	set total = (select sum(subtotal) from Detalle_Reserva where id_reserva = @id_reserva)
	where id_reserva = @id_reserva
end
go
create procedure sp_detalle_reserva_d
@id int
as
begin
	declare @id_reserva int
	select @id_reserva = id_reserva from Detalle_Reserva where id_detalle = @id
	
	delete from Detalle_Reserva where id_detalle = @id
	
	-- Actualizar el total de la reserva
	update Reserva
	set total = (select isnull(sum(subtotal), 0) from Detalle_Reserva where id_reserva = @id_reserva)
	where id_reserva = @id_reserva
end
go