﻿
--TELEFONO
CREATE DOMAIN
    t_telefono char(9) not null
    constraint CHK_telefono
    check (value similar to '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');

--CORREO
CREATE DOMAIN
    t_correo varchar(50) not null
    constraint CHK_correo
    check (value similar to '[A-z]%@[A-z]%.[A-z]%');

--GENERO
CREATE DOMAIN
    t_genero boolean not null;

--CEDULA
CREATE DOMAIN
    t_cedula char(11) not null
    constraint CHK_cedula
    check (value similar to '[0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');

--PLACA DE LOS VEHICULOS
CREATE DOMAIN
    t_placa char(7) not null
    constraint CHK_placaFormato
    check (value similar to '[B-Z][B-Z][B-Z]-[0-9][0-9][0-9]' and value not in ('A','E','I','O','U'));

--DESCRIPCIONES
CREATE DOMAIN
    t_nombre varchar(20) ;
CREATE DOMAIN
    t_descripcion varchar(100);

-- TIO
CREATE DOMAIN
    t_tipo_pago
    varchar(15) not null
    constraint CHK_estadoCivil
    check(value in ('Cheque','Efectivo','Tarjeta','Transferencia'));

CREATE DOMAIN 
    t_tipo 
    varchar(2) not null 
    constraint CHK_tipoPersona 
    check(value in ('A','AA', 'C', 'E'));





-- Tablas
create table provincias
(
    id serial not null,
    nombre t_nombre not null,
    constraint  PK_id_provincias primary key(id),
    constraint UNQ_nombre_provincias UNIQUE (nombre)
);


create table personas
(
    cedula t_cedula not null,
    nombre t_nombre not null,
    apellido1 t_nombre  not null,
    apellido2 t_nombre  not null,
    genero t_genero not null,
    tipo t_tipo, 
    constraint PK_cedulaEmpleado_empleados primary key(cedula)
);


create table camiones
(
    placa t_placa not null,
    capacidad int not null CHECK (capacidad > 0),
    descripcion t_descripcion,
    tipo_conbustible varchar(10),
    constraint PK_placa_camion primary key(placa)
);


create table familias
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen  t_nombre not null,
    descripcion t_descripcion not null,
    constraint PK_codigoFamilia_familias primary key (id)
);







--

create table cantones
(
    id  serial not null,
    nombre t_nombre not null,
    id_provincia int not null,
    constraint  PK_id_cantones primary key(id),
    constraint FK_id_provincia_cantones_provincias foreign key(id_provincia) references provincias
);


create table telefonos
(
    cedula t_cedula not null,
    numero t_telefono not null,
    tipo boolean not null,
    constraint PK_cedula_numero_telefono primary key (cedula,numero),
    constraint FK_cedula_telefono_personas foreign key(cedula) references personas on delete cascade on update cascade
);


create table correos
(
    cedula  t_cedula not null,
    correo  t_correo not null,
    constraint PK_cedula_correo_personas primary key (cedula, correo),
    constraint FK_cedula_correos_personas foreign key(cedula) references personas on delete cascade on update cascade
);



create table facturas
(
    id serial not null,
    cedula t_cedula not null,
    tipo_pago t_tipo_pago,
    fecha date not null default now(),
    tipo boolean not null,
    total money not null default 0,
    constraint PK_id_facturas primary key(id)    
);

create table loginInformation
(
    cedula t_cedula ,  
    lg_info varchar not null,
    constraint UNQ_cedula_loginInformation UNIQUE (cedula), 
    constraint FK_cedula_login_information foreign key (cedula) references personas
);



--

create table productos
(
    id int not null,
    nombre t_nombre not null,
    precio int not null,
    descripcion t_descripcion not null,
    id_familia  int not null,
    constraint PK_id_producto_nombre_productos primary key (id),
    constraint FK_id_familia_productos_familias foreign key (id_familia) references familias on delete cascade on update cascade
);



create table distritos
(
    id serial not null,
    nombre t_nombre not null,
    id_canton int not null,
    constraint  PK_idDistrito_distritos primary key(id),
    constraint Fk_id_canton_distritos_cantones foreign key (id_canton) references cantones
);


create table bodegas
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen varchar not null,
    capacidad int not null,
    id_distrito int not null,
    direccion_exacta t_descripcion,
    constraint  PK_id_bodegas primary key(id),
    constraint FK_id_distrito_bodegas foreign key (id_distrito) references distritos
);


create table productos_bodegas
(
    id_bodega int not null,
    id_producto int not null,
    cantidad_producto int not null,
    constraint FK_id_bodega_bodegas_productos foreign key (id_bodega) references bodegas,
    constraint FK_id_producto_bodegas_productos foreign key (id_producto) references productos
);

create table productos_facturas
(
    id_factura int not null,
    id_producto int not null,
    cantidad int not null,
    precio_unitario money not null,
    precio_parcial money not null,
    constraint FK_id_factura_productos_facturas foreign key (id_factura) references facturas,
    constraint FK_id_producto_productos_facturas foreign key (id_producto) references productos
);



--

create table envios
(
    id serial not null,
    id_factura int not null,
    cedula t_cedula not null,
    placa t_placa not null,
    fecha date not null default now(),
    constraint FK_id_factura_envios foreign key (id_factura) references facturas,    
    constraint FK_cedula_envios foreign key (cedula) references personas,
    constraint FK_placa_envios foreign key (placa) references camiones 
    
);


create table direcciones
(
    id serial not null,
    id_distrito int not null,
    cedula t_cedula not null,
    direccion_exacta t_descripcion,
    
    constraint PK_id_direcciones primary key(id),
    constraint FK_cedula_direcciones foreign key (cedula) references personas,
    constraint FK_id_distrito_direcciones foreign key (id_distrito) references distritos
);







--   Prueba inserciones nivel 1

-- provincias
insert into provincias (nombre) values ('Alajuela');
-- personas
insert into personas values ('9-0130-0731', 'Julio Adan', 'Montano', 'Hernandez', false, 'A');
-- camiones 
insert into camiones values('NDR-123',2400,'Camion color blanco', 'Diesel');
-- familias 
insert into familias(nombre, tipo_almacen, descripcion) values ('llantas', 'Bodega para llantas', 'Aqui van todas las llantas');


--   Prueba inserciones nivel 2

-- cantones
insert into cantones (nombre, id_provincia) values ('Upala', 1);
-- telefonos 
insert into telefonos values ('9-0130-0731', '8721-9049', true);
-- correos 
insert into correos values('9-0130-0731', 'Juliomontano008@gmail.com');
-- facturas 
insert into facturas (cedula, tipo_pago, fecha, tipo, total) values ('9-0130-0731', 'Tarjeta', '4/11/2017', true, 30030);
-- logins 
insert into loginInformation values('9-0130-0731',md5 ('pg2017' || '9-0130-0731' || '008'));

















--   Pruebas eliminaciones













--insertando 
--insert into usuarios (id,login,password) values (nextval('secuencia'),  login  ,md5 ('password' || 'login' || currval('secuencia')|| 'tuvalorfijo' ) );

-- Autenticar al usuario:

--select id from usuarios where password = md5('password_insertado' || 'login_insertado' || id || 'tuvalorfijo' ) and login = 'login_insertado';




