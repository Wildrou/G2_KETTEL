DROP DATABASE IF EXISTS aero;
CREATE DATABASE aero;
USE aero;

CREATE TABLE PERSONA
(
    dni	    VARCHAR(9) NOT NULL,
    nombre	VARCHAR(75) NOT NULL,
    fecha_nacimiento   DATE NOT NULL,
    edad INT NOT NULL,
    estado_civil ENUM('CASADO','SOLTERO','UNION DE HECHO','SEPARADO','VIUDO','DIVORCIADO') NOT NULL,
    ocupacion VARCHAR(50) NOT NULL,
    hijos INT NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    pais_origen VARCHAR(30) NOT NULL,
    pais_residencia VARCHAR(30) NOT NULL,
    estudios VARCHAR(50) NOT NULL,
    genero ENUM('HOMBRE', 'MUJER','OTRO') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni)

);



CREATE TABLE TRANSPORTE
(
    idtransporte VARCHAR(6) NOT NULL,
    compania VARCHAR(10) NOT NULL,
    PRIMARY KEY (idtransporte)
);


CREATE TABLE TAXI
(
    numlicencia VARCHAR(6) NOT NULL,
    idtransporte_taxi VARCHAR(6) NOT NULL,
    PRIMARY KEY (numlicencia),
    CONSTRAINT tax_fk FOREIGN KEY (idtransporte_taxi) REFERENCES TRANSPORTE (idtransporte) ON DELETE CASCADE
);


CREATE TABLE AUTOBUS
(
    matricula VARCHAR(7) NOT NULL,
    lineabus VARCHAR(3) NOT NULL,
    idtransporte_autobus VARCHAR(6) NOT NULL,
    PRIMARY KEY (matricula),
    CONSTRAINT autob_fk FOREIGN KEY (idtransporte_autobus) REFERENCES TRANSPORTE (idtransporte) ON DELETE CASCADE
);

CREATE TABLE CLIENTE
(
    dni_cliente VARCHAR(9) UNIQUE NOT NULL,
    npasaporte VARCHAR (9) UNIQUE NOT NULL,
    vip BOOLEAN NOT NULL,
    preferencia_clase ENUM('TURISTA','BUSINESS','PREFERENTE') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_cliente),
    CONSTRAINT fkcliente_dni  FOREIGN KEY (dni_cliente) REFERENCES PERSONA (dni) ON DELETE CASCADE
);

CREATE TABLE EMPLEADO
(
	dni_empleado VARCHAR (9) UNIQUE NOT NULL,
    nss VARCHAR (13) UNIQUE NOT NULL,
    sueldo DOUBLE NOT NULL,
    turno VARCHAR (11) NOT NULL,
    PRIMARY KEY (dni_empleado),
    CONSTRAINT fkdni_empleado FOREIGN KEY (dni_empleado) REFERENCES PERSONA (dni) ON DELETE CASCADE
        
);

ALTER TABLE EMPLEADO ADD dni_supervisor VARCHAR (9) REFERENCES EMPLEADO(dni_empleado);


CREATE TABLE TRIPULANTE
(   
    dni_tripulante VARCHAR(9) UNIQUE NOT NULL,
    horas_vuelo DOUBLE NOT NULL,
    PRIMARY KEY (dni_tripulante),
    CONSTRAINT fkdni_tripulante FOREIGN KEY (dni_tripulante) REFERENCES PERSONA(dni) ON DELETE CASCADE
);




CREATE TABLE CABINAMANDO
(  
    dni_cabinamando VARCHAR(9) UNIQUE NOT NULL,
    numlicencia VARCHAR (10) UNIQUE NOT NULL,
    puesto VARCHAR(8) NOT NULL,
    PRIMARY KEY (dni_cabinamando),
    CONSTRAINT fk_cabinamando FOREIGN KEY (dni_cabinamando) REFERENCES TRIPULANTE (dni_tripulante) ON DELETE CASCADE
);

CREATE TABLE CABINAPASAJERO
(
    dni_cabinapasajero VARCHAR(9) UNIQUE NOT NULL,
    clase VARCHAR(15) NOT NULL,
    PRIMARY KEY (dni_cabinapasajero),
    CONSTRAINT fk_cabinapasajero FOREIGN KEY (dni_cabinapasajero) REFERENCES TRIPULANTE (dni_tripulante) ON DELETE CASCADE
    
);

CREATE TABLE AZAFATA 
(
    dni_azafata VARCHAR(9) UNIQUE NOT NULL,
	impventa DOUBLE NOT NULL,
    PRIMARY KEY (dni_azafata),
    CONSTRAINT fk_azafata FOREIGN KEY (dni_azafata) REFERENCES CABINAPASAJERO (dni_cabinapasajero) ON DELETE CASCADE

);

CREATE TABLE SOBRECARGO 
(
	dni_sobrecargo VARCHAR(9) UNIQUE NOT NULL,
    horas_sobrecargo DOUBLE NOT NULL,
    PRIMARY KEY (dni_sobrecargo),
    CONSTRAINT fk_sobrecargo FOREIGN KEY (dni_sobrecargo) REFERENCES CABINAPASAJERO (dni_cabinapasajero) ON DELETE CASCADE
);

CREATE TABLE PISTA
(
    numpista DOUBLE UNIQUE NOT NULL,
	longitud DOUBLE NOT NULL,
    PRIMARY KEY (numpista)
  
);

CREATE TABLE AVION
(
    idavion VARCHAR(6) UNIQUE NOT NULL,
    modelo VARCHAR(10) NOT NULL,
    cargamax DECIMAL (5,2) NOT NULL,
    numplazas DOUBLE NOT NULL,
    PRIMARY KEY (idavion)
);

CREATE TABLE RECORRIDO
(
    idrecorrido VARCHAR(10) UNIQUE NOT NULL,
	aero_destino VARCHAR(50) NOT NULL,
    destino VARCHAR(30) NOT NULL,
    aero_origen VARCHAR(50) NOT NULL,
    origen VARCHAR(30) NOT NULL,
    tipo ENUM('NACIONAL','INTERNACIONAL') NOT NULL,
    duracion_minutos INT NOT NULL,
    PRIMARY KEY (idrecorrido)
);

CREATE TABLE PUERTAEMBARQUE
(
    codpuerta VARCHAR(4) UNIQUE NOT NULL,
    terminal VARCHAR(2)  NOT NULL,
    PRIMARY KEY (codpuerta)
);

CREATE TABLE AEROLINEA
(
	idaerolinea VARCHAR(8) UNIQUE NOT NULL,
	nombre VARCHAR(12) NOT NULL,
	PRIMARY KEY (idaerolinea)
);

CREATE TABLE VUELO
(
    idvuelo VARCHAR(6),
    idavion VARCHAR(6),
    idrecorrido VARCHAR(10),
    idaerolinea varchar(8),
    fecha_salida DATETIME NOT NULL,
    numpista DOUBLE,
    codpuerta VARCHAR(4),
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT vuelp_pk PRIMARY KEY (idvuelo),
    CONSTRAINT unique_vuelo UNIQUE (idavion, idrecorrido, fecha_salida),
    CONSTRAINT fkvuelo_pista FOREIGN KEY (numpista) REFERENCES PISTA (numpista) ON DELETE SET NULL,
    CONSTRAINT fkvuelo_puerta FOREIGN KEY (codpuerta) REFERENCES PUERTAEMBARQUE(codpuerta) ON DELETE SET NULL,
    CONSTRAINT fkvuelo_aerolinea FOREIGN KEY (idaerolinea) REFERENCES AEROLINEA(idaerolinea) ON DELETE SET NULL,
    CONSTRAINT fkvuelo_avion FOREIGN KEY (idavion) REFERENCES AVION(idavion) ON DELETE SET NULL,
    CONSTRAINT fkvuelo_recorrido FOREIGN KEY (idrecorrido) REFERENCES RECORRIDO(idrecorrido) ON DELETE SET NULL

);

CREATE TABLE TRABAJA_EN
(
    idvuelo VARCHAR(6),
    dni_tripulante VARCHAR(9),
    CONSTRAINT pk_trabajaen PRIMARY KEY (idvuelo, dni_tripulante),
    CONSTRAINT fk_trabajeen FOREIGN KEY (idvuelo) REFERENCES VUELO(idvuelo) ON DELETE CASCADE,
    CONSTRAINT fk_trabaja_dni FOREIGN KEY (dni_tripulante) REFERENCES TRIPULANTE(dni_tripulante) ON DELETE CASCADE
);

CREATE TABLE BILLETE(
    idbillete VARCHAR (15) UNIQUE NOT NULL,
	idvuelo VARCHAR(6) NOT NULL,
    motivo ENUM('OCIO','TRABAJO','ESTUDIOS') NOT NULL,
    descuento DECIMAL(4,2) NOT NULL,
    fecha_compra DATETIME NOT NULL,
    precio DECIMAL(8,2) NOT NULL,
    formato ENUM('FISICO','DIGITAL') NOT NULL,
    lugar_compra VARCHAR(70) NOT NULL,
    clase ENUM('TURISTA','BUSINESS','PREFERENTE') NOT NULL,
    plaza VARCHAR(3) NOT NULL,
    dni_cliente VARCHAR(9) NOT NULL,
	ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idbillete),
    CONSTRAINT fkbillete_cliente FOREIGN KEY (dni_cliente) REFERENCES CLIENTE (dni_cliente) ON DELETE CASCADE,
    CONSTRAINT fkbillete_vuelo FOREIGN KEY (idvuelo) REFERENCES VUELO(idvuelo) ON DELETE CASCADE
  
);

CREATE TABLE EQUIPAJE
(
    idequipaje VARCHAR(8) UNIQUE NOT NULL,
    peso DECIMAL(4,2) NOT NULL,
    dimensiones VARCHAR(11) NOT NULL,
    dni_cliente VARCHAR(9) NOT NULL,	
    idbillete VARCHAR(15) NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idequipaje),
    CONSTRAINT dniequ_fk FOREIGN KEY (dni_cliente) REFERENCES CLIENTE(dni_cliente) ON DELETE CASCADE,
    CONSTRAINT equ_billete_fk FOREIGN KEY (idbillete) REFERENCES BILLETE(idbillete) ON DELETE CASCADE
);

CREATE TABLE INCIDENCIA
(
	idvuelo VARCHAR(6),
    numincidencia INT NOT NULL,
 	descripcion VARCHAR(240) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    tipo ENUM('GRAVE','LEVE','MODERADA') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	CONSTRAINT fkincidencia FOREIGN KEY (idvuelo) REFERENCES VUELO(idvuelo) ON DELETE CASCADE,
	CONSTRAINT pk_incidencia PRIMARY KEY (idvuelo,numincidencia)
);




CREATE TABLE TELEFONO
(
    dni_cliente VARCHAR(9) UNIQUE NOT NULL,
    telefono DOUBLE UNIQUE NOT NULL,
    CONSTRAINT fkdni_cliente FOREIGN KEY (dni_cliente) REFERENCES CLIENTE(dni_cliente),
    CONSTRAINT pk_telefono PRIMARY KEY(dni_cliente,telefono)
);

insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('07055242C', 'Veronika O''Dwyer', '1963-12-30', 57, 'SEPARADO', 'Librarian', 4, 'Pohang', 'Gyeongbuk', 'Namibia', 'Korea, South', 'Amirkabir University of Technology', 'HOMBRE', '2019-01-31 19:18:20');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('56904806S', 'Catha Seymark', '1972-04-08', 48, 'UNION DE HECHO', 'Programmer Analyst III', 0, 'Tunuyán', 'Mendoza', 'United States', 'Argentina', 'Claflin College', 'OTRO', '2020-04-13 17:19:06');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('38280831H', 'Gian Bartusek', '1988-05-31', 32, 'SOLTERO', 'Senior Editor', 12, 'Lillehammer', 'Oppland', 'Pakistan', 'Norway', 'Pacific Union College', 'OTRO', '2019-09-26 07:02:37');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('86687145N', 'Jobey Huntley', '1943-06-09', 77, 'SOLTERO', 'Research Associate', 0, 'Lufkin', 'Texas', 'India', 'United States', 'Instituto Nacional de Educación Física "General Manuel Belgrano"', 'OTRO', '2020-11-22 19:51:31');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('84848139W', 'Jo Fenge', '1955-01-27', 66, 'DIVORCIADO', 'Associate Professor', 3, 'Ealing', 'Ealing', 'United Kingdom', 'United Kingdom', 'Emmanuel College', 'HOMBRE', '2020-11-04 12:35:54');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('70878793O', 'Allx Krzysztofiak', '1955-05-30', 65, 'CASADO', 'Software Test Engineer IV', 11, 'Navasota', 'Texas', 'United States', 'United States', 'Vassar College', 'OTRO', '2019-10-06 10:42:48');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('20185493S', 'Benedick Rivelon', '1944-07-20', 76, 'UNION DE HECHO', 'Accounting Assistant II', 10, 'Brewer', 'Maine', 'Brazil', 'United States', 'Technological University (Pyay)', 'HOMBRE', '2019-12-30 17:30:47');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('00665573L', 'Curcio Dunnan', '1948-09-23', 72, 'UNION DE HECHO', 'Administrative Assistant II', 9, 'South Milwaukee', 'Wisconsin', 'United States', 'United States', 'Hokkaido University of Health Sciences', 'MUJER', '2020-05-27 02:22:27');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('29838624Z', 'Artemus Orcott', '1994-05-31', 26, 'VIUDO', 'Registered Nurse', 0, 'Ridgefield', 'Connecticut', 'Brazil', 'United States', 'Universitas Islam Sultan Agung', 'MUJER', '2020-02-09 18:57:03');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('78133090Z', 'Georgi Sawart', '1986-12-09', 34, 'CASADO', 'Web Developer II', 7, 'Pleasant Hill', 'Missouri', 'United States', 'United States', 'Kanagawa Dental College', 'OTRO', '2018-04-12 22:33:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('00337814K', 'Wilbur Lecky', '1994-03-30', 26, 'DIVORCIADO', 'Speech Pathologist', 1, 'Falun', 'Dalarna', 'India', 'Sweden', 'George Washington University', 'HOMBRE', '2018-05-25 01:26:17');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('75154918H', 'Marjy Nunnerley', '1950-06-04', 70, 'SEPARADO', 'Data Coordiator', 12, 'Monee', 'Illinois', 'United States', 'United States', 'Indian School of Business Management and Administration', 'MUJER', '2019-07-19 00:34:05');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('24007893U', 'Mart Ellingworth', '1955-02-24', 66, 'UNION DE HECHO', 'General Manager', 3, 'Perth', 'Perth and Kinross', 'Australia', 'Australia', 'Al Imam Al-Ouzai University', 'OTRO', '2020-03-20 23:29:29');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92140486L', 'Mignon Nutley', '1967-10-04', 53, 'SOLTERO', 'Human Resources Assistant II', 2, 'Hershey', 'Pennsylvania', 'United States', 'United States', 'Oklahoma State University Center for Health Sciences', 'HOMBRE', '2020-11-08 11:28:54');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('51788970Q', 'Kameko Billingham', '1987-07-20', 33, 'CASADO', 'Programmer IV', 12, 'Kerman', 'California', 'United States', 'United States', 'Korea University', 'OTRO', '2018-01-01 15:14:59');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92388292H', 'Mead Adelsberg', '2001-10-04', 19, 'SOLTERO', 'Clinical Specialist', 7, 'Old Town', 'Maine', 'United States', 'United States', 'Institut Prima Bestari - Pine Academy ', 'MUJER', '2020-12-06 08:15:10');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('41655520M', 'Barron Mallam', '1947-07-23', 73, 'CASADO', 'Desktop Support Technician', 6, 'Al Kharj', 'Ar Riyāḑ', 'Indonesia', 'Saudi Arabia', 'Koforidua Polytechnic ', 'OTRO', '2020-07-25 05:48:53');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('97067662H', 'Oswell Gatley', '1966-12-31', 54, 'SEPARADO', 'VP Marketing', 4, 'Ndélé', 'Bamingui-Bangoran', 'United States', 'Central African Republic', 'National Research University of Electronic Technology', 'MUJER', '2016-09-14 08:46:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('16305315P', 'Renard Eadmeades', '1961-08-17', 59, 'DIVORCIADO', 'Occupational Therapist', 11, 'Heber', 'Utah', 'United States', 'United States', 'University of Colombo', 'OTRO', '2020-01-18 15:55:30');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('43167839X', 'Phillipe Threadkell', '1951-07-06', 69, 'UNION DE HECHO', 'Payment Adjustment Coordinator', 10, 'Bowling Green', 'Missouri', 'United States', 'United States', 'New York School of Interior Design', 'HOMBRE', '2016-02-09 21:18:18');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('49741113Z', 'Edlin Sayles', '1954-08-14', 66, 'SEPARADO', 'Account Coordinator', 4, 'Valdosta', 'Georgia', 'Indonesia', 'United States', 'East Ukrainian National University', 'HOMBRE', '2017-02-10 21:32:58');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('28368887A', 'Geordie Quarrell', '1949-05-27', 71, 'VIUDO', 'Clinical Specialist', 2, 'Hazelwood', 'Missouri', 'Mexico', 'United States', 'Central Radio and TV University', 'HOMBRE', '2016-05-15 10:05:04');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('89255796Y', 'Brendan Lenin', '1997-04-23', 23, 'SOLTERO', 'Human Resources Manager', 11, 'Rio Rico', 'Arizona', 'Ecuador', 'United States', 'Alma College', 'HOMBRE', '2016-07-16 17:13:41');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58496330S', 'Alameda Landers', '2000-02-05', 21, 'SEPARADO', 'Teacher', 11, 'Greenbriar', 'Virginia', 'Korea, South', 'United States', 'Bishop''s University', 'HOMBRE', '2019-01-26 15:11:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('73630839H', 'Regina Swatman', '1965-06-25', 55, 'SEPARADO', 'Actuary', 1, 'Carrizo Springs', 'Texas', 'Venezuela', 'United States', 'Bethune-Cookman College', 'MUJER', '2019-10-04 21:23:21');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58844888I', 'Brunhilda Jobbing', '1954-01-12', 67, 'UNION DE HECHO', 'Sales Associate', 0, 'Khon Kaen', 'Khon Kaen', 'United States', 'Thailand', 'Hebrew University of Jerusalem', 'OTRO', '2018-12-12 00:44:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('57769934B', 'Davon Considine', '1981-06-23', 39, 'SOLTERO', 'Assistant Media Planner', 12, 'Tinnevelly', 'Tamil Nādu ', 'United States', 'India', 'Toyama University of International Studies', 'MUJER', '2020-09-24 11:53:47');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('29958060M', 'Rudyard MacCollom', '1944-07-07', 76, 'UNION DE HECHO', 'Senior Sales Associate', 2, 'Butare', 'Southern Province', 'United States', 'Rwanda', 'Pepperdine University', 'OTRO', '2016-05-09 17:31:39');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('57677201C', 'Spike Bote', '1983-07-24', 37, 'SEPARADO', 'Accounting Assistant I', 7, 'Chino Hills', 'California', 'China', 'United States', 'Simpson College', 'HOMBRE', '2018-03-31 21:38:17');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85654886A', 'Julie McDaid', '1959-04-30', 61, 'SOLTERO', 'Speech Pathologist', 2, 'Lakeland', 'Tennessee', 'Bolivia', 'United States', 'Clarkson College', 'HOMBRE', '2018-12-23 18:14:56');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('84087080L', 'Zaneta Gagan', '1957-11-30', 63, 'VIUDO', 'Senior Sales Associate', 10, 'Medan', 'Sumatera Utara', 'United States', 'Indonesia', 'International Business School of Scandinavia', 'MUJER', '2020-02-29 08:34:58');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('63097304T', 'Theressa McCreery', '1981-07-01', 39, 'CASADO', 'Sales Associate', 12, 'Radford', 'Virginia', 'United States', 'United States', 'Virginia College', 'HOMBRE', '2019-05-29 17:15:05');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('17736845Y', 'Luce Peek', '1991-06-02', 29, 'SEPARADO', 'Clinical Specialist', 4, 'Ratnapura', 'Sabaragamuwa', 'Uganda', 'Sri Lanka', 'Husson College', 'MUJER', '2017-05-25 17:16:25');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('35493398N', 'Tiler Brunsdon', '1943-03-21', 78, 'CASADO', 'Civil Engineer', 3, 'Madīnat ash Shamāl', 'Ash Shamāl', 'Iraq', 'Qatar', 'California State University, Channel Islands', 'OTRO', '2018-10-15 07:11:15');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('52051003V', 'Isobel Schulz', '1947-11-05', 73, 'SEPARADO', 'Human Resources Assistant II', 9, 'Hiroshima', 'Hiroshima', 'United States', 'Japan', 'Zimbabwe Ezekiel Guti University', 'HOMBRE', '2020-12-17 12:20:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('88460292P', 'Bertie Sager', '1999-11-26', 21, 'CASADO', 'VP Sales', 12, 'Amesbury Town', 'Massachusetts', 'United States', 'United States', 'Worcester Polytechnic Institute', 'HOMBRE', '2019-04-09 02:17:07');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('19424183S', 'Zared Ayars', '1952-10-06', 68, 'SOLTERO', 'General Manager', 1, 'Cheongju', 'Chungbuk', 'United States', 'Korea, South', 'Taipei Municipal Teachers College', 'OTRO', '2020-04-13 06:38:39');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58618293D', 'Conan Burniston', '2001-08-22', 19, 'CASADO', 'Safety Technician III', 12, 'Milan', 'Michigan', 'Afghanistan', 'United States', 'Katholische Stiftungsfachhochschule München', 'HOMBRE', '2017-07-10 04:00:34');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('95924257Q', 'Rance Hoggetts', '1996-06-02', 24, 'CASADO', 'Tax Accountant', 9, 'Kōbe', 'Hyōgo', 'United Kingdom', 'Japan', 'Ecole Nationale Supérieure d''Arts et Métiers de Paris', 'MUJER', '2020-07-19 10:32:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('74527513B', 'Bard Mallison', '1958-06-03', 62, 'VIUDO', 'Occupational Therapist', 2, 'Denton', 'Texas', 'United States', 'United States', 'Adeleke University', 'OTRO', '2020-07-28 17:20:37');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('83743817J', 'Arabel Matteacci', '1949-11-29', 71, 'SEPARADO', 'VP Product Management', 3, 'Rigby', 'Idaho', 'India', 'United States', 'St. Petersburg Repin State Academic Institute of Painting Sculpture and Achitecture', 'MUJER', '2018-08-22 15:35:54');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('46113088B', 'Field Justun', '1963-07-23', 57, 'SOLTERO', 'Account Representative II', 11, 'Talcahuano', 'Biobío', 'United States', 'Chile', 'Medical University of South Carolina', 'MUJER', '2017-09-29 07:20:46');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92956925I', 'Serene Kyle', '1980-09-30', 40, 'SOLTERO', 'Information Systems Manager', 10, 'Fridley', 'Minnesota', 'Serbia', 'United States', 'National University of Uzbekistan', 'HOMBRE', '2020-03-01 14:31:50');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('70464474N', 'Jolene Husher', '1969-12-11', 51, 'SOLTERO', 'GIS Technical Architect', 9, 'Decatur', 'Illinois', 'United States', 'United States', 'Universiti Sains Malaysia', 'HOMBRE', '2020-04-13 19:12:49');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('02382074A', 'Ilaire Giacopini', '1968-10-16', 52, 'SEPARADO', 'Senior Sales Associate', 0, 'Moanda', 'Haut-Ogooué', 'Portugal', 'Congo (Kinshasa)', 'Kanazawa College of Economics', 'OTRO', '2017-07-17 11:00:14');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('30537638Q', 'Reta Harrisson', '1964-07-18', 56, 'DIVORCIADO', 'Media Manager IV', 12, 'Closter', 'New Jersey', 'Peru', 'United States', 'Klaipeda University', 'HOMBRE', '2017-09-13 13:28:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('22012118W', 'Barton Stoeck', '1991-03-28', 29, 'DIVORCIADO', 'Help Desk Technician', 11, 'Isiolo', 'Isiolo', 'Yemen', 'Kenya', 'University of Performing Arts in Bratislava', 'HOMBRE', '2018-05-20 13:35:19');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('40387228S', 'Devin Doornbos', '1954-07-08', 66, 'SOLTERO', 'Biostatistician III', 1, 'Inongo', 'Mai-Ndombe', 'Kenya', 'Congo (Kinshasa)', 'Al Maarif University College', 'MUJER', '2016-03-25 23:39:03');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('98991252R', 'Robin Stonary', '1972-11-13', 48, 'SOLTERO', 'Help Desk Operator', 10, 'Catarman', 'Northern Samar', 'Mali', 'Philippines', 'Ecole Supérieure de Commerce de Paris', 'HOMBRE', '2016-03-16 18:39:51');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('80548424Q', 'Adrian Swindells', '1993-02-24', 28, 'SOLTERO', 'Design Engineer', 1, 'Lynn Lake', 'Manitoba', 'United States', 'Canada', 'Chinhoyi University of Technology', 'OTRO', '2016-01-06 15:03:48');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('26491980A', 'Veronika Archard', '1970-04-12', 50, 'SEPARADO', 'Assistant Media Planner', 12, 'Kidapawan', 'Cotabato', 'Namibia', 'Philippines', 'Université d''Alger 3', 'HOMBRE', '2020-12-25 08:56:32');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('47428291L', 'Becki Tomenson', '1977-03-15', 44, 'DIVORCIADO', 'Analyst Programmer', 2, 'Tinley Park', 'Illinois', 'Malaysia', 'United States', 'Ecole Nationale Supérieure d''Electronique et de Radioelectricite de Bordeaux', 'OTRO', '2019-07-21 17:35:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('82767796L', 'Annamarie Girkins', '1943-04-26', 77, 'UNION DE HECHO', 'Research Nurse', 4, 'Attalla', 'Alabama', 'United States', 'United States', 'University of the Thai Chamber of Commerce', 'MUJER', '2019-04-25 22:55:12');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('18861987Z', 'Patrick Barke', '1999-02-06', 22, 'SOLTERO', 'Senior Developer', 3, 'Brown Deer', 'Wisconsin', 'United States', 'United States', 'Institut Teknologi Telkom', 'OTRO', '2016-10-06 07:00:50');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('70891770A', 'Leroy Hayen', '2001-02-27', 20, 'SOLTERO', 'Pharmacist', 7, 'Grand Rapids', 'Minnesota', 'Colombia', 'United States', 'Unity College', 'OTRO', '2018-09-17 17:58:04');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('37398296C', 'Darcey Cracknell', '1989-09-23', 31, 'UNION DE HECHO', 'Technical Writer', 1, 'Balashov', 'Saratovskaya Oblast’', 'India', 'Russia', 'Odessa State Medical University', 'OTRO', '2020-05-25 21:51:59');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('37900304M', 'Archibaldo Machen', '1976-12-24', 44, 'VIUDO', 'Biostatistician III', 8, 'Moshi', 'Kilimanjaro', 'United States', 'Tanzania', 'Katholieke Hogeschool Limburg', 'MUJER', '2019-06-26 09:01:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('26807992N', 'Casie Kenewell', '1999-03-30', 21, 'DIVORCIADO', 'VP Quality Control', 10, 'Buchans', 'Newfoundland and Labrador', 'Chile', 'Canada', 'Universidad Nacional del Noroeste de la Provincia de Buenos Aires', 'HOMBRE', '2017-06-10 13:08:30');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('27848391E', 'Forester Mityashev', '1974-06-16', 46, 'UNION DE HECHO', 'Environmental Specialist', 0, 'Mohale’s Hoek', 'Mohale’s Hoek', 'Uruguay', 'Lesotho', 'Tamil Nadu Dr. M.G.R. Medical University', 'OTRO', '2017-08-30 06:48:40');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('12623557E', 'Binnie Geddis', '1949-07-31', 71, 'SEPARADO', 'Data Coordiator', 6, 'Brevard', 'North Carolina', 'Russia', 'United States', 'Russian-Armenian (Slavonic) State University', 'OTRO', '2019-11-16 13:40:34');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('84780067I', 'Earlie Timperley', '1967-05-14', 53, 'CASADO', 'Associate Professor', 9, 'Brunswick', 'Georgia', 'United States', 'United States', 'University of the Visayas', 'OTRO', '2016-09-16 03:31:38');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('73301916I', 'Morlee Alcido', '1951-12-23', 69, 'DIVORCIADO', 'Research Assistant I', 2, 'Kirkland', 'New York', 'United States', 'United States', 'Fundación Universitaria del Area Andina. Sede Pereira', 'HOMBRE', '2020-11-07 16:59:58');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('38013653B', 'Avivah Travis', '1992-08-11', 28, 'VIUDO', 'Recruiting Manager', 1, 'Marksville', 'Louisiana', 'United States', 'United States', 'Université Laval', 'MUJER', '2016-08-31 21:33:28');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('79839942M', 'Doro Godsal', '1973-11-21', 47, 'CASADO', 'Project Manager', 3, 'Glens Falls', 'New York', 'Gabon', 'United States', 'University of Development Alternative', 'HOMBRE', '2020-06-15 14:36:49');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('70716796H', 'Ashby Arsnell', '1992-10-22', 28, 'DIVORCIADO', 'Analog Circuit Design manager', 5, 'Wadsworth', 'Ohio', 'United States', 'United States', 'Hachinohe Institute of Technology', 'HOMBRE', '2017-12-26 13:12:04');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58982427V', 'Eula Ablitt', '1945-09-30', 75, 'CASADO', 'Design Engineer', 2, 'Naugatuck', 'Connecticut', 'United States', 'United States', 'Universidad La Salle', 'OTRO', '2018-02-17 02:45:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('36802529Q', 'Cooper Kaes', '1978-12-18', 42, 'DIVORCIADO', 'Food Chemist', 2, 'Lawrenceburg', 'Indiana', 'Zambia', 'United States', 'Universidad Nacional Experimental "Rafael Maria Baralt"', 'HOMBRE', '2018-05-15 05:56:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85659619A', 'Lotty FitzGeorge', '1976-10-26', 44, 'CASADO', 'Financial Analyst', 6, 'Melissa', 'Texas', 'Serbia', 'United States', 'Mandalay Technological University', 'OTRO', '2016-11-07 11:04:08');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('67716684G', 'Ernestine Krzysztofiak', '1992-11-20', 28, 'DIVORCIADO', 'Senior Editor', 2, 'Lota', 'Biobío', 'Australia', 'Chile', 'Universidade de Uberaba', 'OTRO', '2020-04-05 23:22:33');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('31370859H', 'Esther Schurcke', '1970-08-15', 50, 'SEPARADO', 'Professor', 5, 'Waterford', 'Wisconsin', 'United States', 'United States', 'University of Social Welfare and Rehabilitation Scinences', 'HOMBRE', '2020-01-19 07:18:47');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('55237927E', 'Anetta Jacklin', '1991-12-11', 29, 'SOLTERO', 'Software Consultant', 3, 'Lighthouse Point', 'Florida', 'Chile', 'United States', 'Indian Agricultural Research Institute', 'MUJER', '2019-08-01 06:51:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('07558371D', 'Wilona Howles', '1999-04-09', 21, 'CASADO', 'Electrical Engineer', 7, 'Suai', 'Cova Lima', 'United States', 'Timor-Leste', 'Marcus Oldham College', 'HOMBRE', '2018-06-07 23:25:01');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('69360637Z', 'Gabriele Quinsee', '1995-06-02', 25, 'DIVORCIADO', 'Cost Accountant', 11, 'Plano', 'Texas', 'United States', 'United States', 'Kookmin University', 'OTRO', '2019-08-30 17:36:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('17576951C', 'Aleksandr Giacovetti', '1976-12-25', 44, 'VIUDO', 'Recruiting Manager', 10, 'Mati', 'Davao Oriental', 'Latvia', 'Philippines', 'Universidad Centroamericana de Ciencias Empresariales (UCEM)', 'MUJER', '2019-03-05 15:08:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('00247726I', 'Anabella Juanico', '1972-03-19', 49, 'SOLTERO', 'Systems Administrator III', 9, 'New Bedford', 'Massachusetts', 'United States', 'United States', 'Eberhard-Karls-Universität Tübingen', 'OTRO', '2019-07-28 05:53:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('65736826L', 'Erik Pauleau', '2001-03-05', 20, 'UNION DE HECHO', 'Operator', 1, 'Le Ray', 'New York', 'Mexico', 'United States', 'Hoseo University', 'MUJER', '2018-12-16 21:14:08');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('43914194N', 'Uriah Summerlad', '1996-11-23', 24, 'UNION DE HECHO', 'Analyst Programmer', 7, 'Maiduguri', 'Borno', 'Mexico', 'Nigeria', 'Saigon University', 'MUJER', '2020-01-04 10:21:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('27278555E', 'Colette Horrell', '2001-06-15', 19, 'UNION DE HECHO', 'Financial Advisor', 10, 'Pagosa Springs', 'Colorado', 'Malta', 'United States', 'Universidad Miguel de Cervantes', 'OTRO', '2017-07-04 01:12:46');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('19767799D', 'Dela Upfold', '1993-03-19', 28, 'DIVORCIADO', 'Human Resources Assistant III', 2, 'Fort-Shevchenko', 'Mangghystaū', 'Saudi Arabia', 'Kazakhstan', 'Daido Institute of Technology', 'OTRO', '2017-10-31 06:35:44');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('59643079M', 'Cullin Coppard', '1977-10-24', 43, 'VIUDO', 'Safety Technician I', 7, 'Tlaxcala', 'Tlaxcala', 'Russia', 'Mexico', 'Northwestern University of the Philippines', 'HOMBRE', '2016-08-08 19:58:51');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('94489726X', 'Aindrea Stonhard', '1944-06-22', 76, 'UNION DE HECHO', 'Food Chemist', 6, 'Vecumnieki', 'Vecumnieku Novads', 'Colombia', 'Latvia', 'Universitas Kristen Duta Wacana', 'OTRO', '2016-12-18 10:46:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('88975906N', 'Honey McWilliams', '1965-07-20', 55, 'CASADO', 'Human Resources Assistant III', 12, 'Dal’negorsk', 'Primorskiy Kray', 'United States', 'Russia', 'Baki Business University', 'OTRO', '2019-10-09 10:01:22');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('73494812M', 'Georgi Van Haeften', '1944-07-17', 76, 'DIVORCIADO', 'Help Desk Technician', 9, 'Codó', 'Maranhão', 'China', 'Brazil', 'National University of Ireland, Maynooth', 'OTRO', '2016-02-27 22:31:29');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('53961118L', 'Morena Ruddock', '1956-05-04', 64, 'UNION DE HECHO', 'VP Accounting', 3, 'Roseburg North', 'Oregon', 'Brazil', 'United States', 'Universidad la Concordia', 'OTRO', '2019-12-05 15:17:25');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('47938670T', 'Burl Michiel', '1961-01-12', 60, 'UNION DE HECHO', 'Legal Assistant', 11, 'Wuxi', 'Jiangsu', 'Chile', 'China', 'Krasnoyarsk State Technical University', 'OTRO', '2017-01-05 17:58:49');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('90909458T', 'Dov Thorlby', '1970-02-05', 51, 'UNION DE HECHO', 'Technical Writer', 11, 'Spartanburg', 'South Carolina', 'United States', 'United States', 'University of Islamic Studies', 'OTRO', '2019-10-09 09:48:34');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58435558H', 'Wakefield O''Cannan', '1974-09-21', 46, 'SEPARADO', 'Assistant Professor', 3, 'Adrian', 'Michigan', 'Serbia', 'United States', 'Universidade Atlântica', 'MUJER', '2019-10-17 19:11:53');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('50150286R', 'Christean Varran', '1976-08-12', 44, 'VIUDO', 'Assistant Manager', 3, 'Villavicencio', 'Meta', 'Slovakia', 'Colombia', 'Ecole Superieure Robert de Sorbon', 'HOMBRE', '2019-11-02 13:22:04');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('94675329B', 'Roman Hadland', '2002-02-14', 19, 'SOLTERO', 'Accounting Assistant II', 2, 'Sebastopol', 'California', 'Canada', 'United States', 'Dubai Pharmacy College', 'OTRO', '2017-07-25 09:39:08');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('38234174I', 'Wake Bunford', '1981-08-29', 39, 'DIVORCIADO', 'Programmer I', 0, 'Musoma', 'Mara', 'Afghanistan', 'Tanzania', 'EUCLID University', 'MUJER', '2019-03-26 08:46:33');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('97814136Q', 'Bron Ossenna', '1964-07-14', 56, 'DIVORCIADO', 'Quality Control Specialist', 6, 'Wilbraham', 'Massachusetts', 'Hungary', 'United States', 'Nanjing University', 'OTRO', '2018-02-20 05:49:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('99613595U', 'Elisabet MacAdam', '1983-03-02', 38, 'DIVORCIADO', 'Human Resources Manager', 12, 'Pottsville', 'Pennsylvania', 'Brazil', 'United States', 'University of East Asia', 'OTRO', '2020-05-23 23:29:35');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('06780561G', 'Benedetto McLaine', '1957-10-01', 63, 'CASADO', 'Web Designer II', 10, 'Hackettstown', 'New Jersey', 'China', 'United States', 'Ferris State University', 'MUJER', '2020-07-12 01:12:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('48758609Z', 'Prinz Lamberth', '1985-03-02', 36, 'DIVORCIADO', 'Recruiting Manager', 2, 'Channel-Port aux Basques', 'Newfoundland and Labrador', 'Mali', 'Canada', 'Christian Theological Academy in Warszaw', 'HOMBRE', '2016-07-15 20:11:02');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('93990482O', 'Leif Primo', '1981-09-19', 39, 'SOLTERO', 'Account Coordinator', 2, 'Assen', 'Drenthe', 'United States', 'Netherlands', 'Mesa State College', 'HOMBRE', '2016-02-24 00:17:24');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('19328559L', 'Yorker Howland', '1994-11-14', 26, 'DIVORCIADO', 'Account Executive', 10, 'Buenos Aires', 'Buenos Aires, Ciudad Autónoma de', 'Congo (Kinshasa)', 'Argentina', 'Bartlesville Wesleyan College', 'HOMBRE', '2019-04-21 18:12:25');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92382459A', 'Enoch Itzkovitch', '1997-05-10', 23, 'SOLTERO', 'Actuary', 3, 'Devine', 'Texas', 'Guatemala', 'United States', 'Advance Tertiary College', 'MUJER', '2016-04-18 00:13:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('03583687M', 'Lazar Lermouth', '2001-06-24', 19, 'CASADO', 'Research Nurse', 2, 'Pingyi', 'Shandong', 'Romania', 'China', 'Ege University', 'MUJER', '2020-12-18 17:04:30');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('88413344X', 'Francisca Whales', '1960-03-24', 61, 'SEPARADO', 'Assistant Professor', 12, 'Laguna Hills', 'California', 'United States', 'United States', 'Angkor University', 'HOMBRE', '2016-11-12 07:39:14');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58407974X', 'Marja Wilcock', '1982-09-08', 38, 'VIUDO', 'Budget/Accounting Analyst IV', 7, 'Pljevlja', 'Pljevlja', 'Peru', 'Montenegro', 'Palestine Technical College-Dier Elbalah', 'MUJER', '2020-04-11 05:40:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('73763582N', 'Magdalena Thunnercliffe', '1945-09-18', 75, 'DIVORCIADO', 'Professor', 0, 'Mollendo', 'Arequipa', 'Slovenia', 'Peru', 'Centennial College', 'MUJER', '2019-02-11 02:10:19');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('55581377B', 'Jock Videan', '1974-03-09', 47, 'VIUDO', 'Chemical Engineer', 1, 'University City', 'Missouri', 'United States', 'United States', 'Dai Ichi University, College of Technology', 'HOMBRE', '2020-03-30 17:06:15');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('43807742M', 'Morganne Trenoweth', '1971-10-27', 49, 'VIUDO', 'Operator', 5, 'Walker', 'Louisiana', 'United States', 'United States', 'Gorgan University of Agricultural Sciences and Natural Resources', 'MUJER', '2018-12-15 15:19:45');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('40208744O', 'Elise Hazeltine', '1962-11-05', 58, 'SOLTERO', 'Information Systems Manager', 2, 'Tongren', 'Guizhou', 'Brazil', 'China', 'National College of Ireland', 'HOMBRE', '2016-09-28 07:50:20');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('43216152P', 'Inness Diplock', '1985-12-29', 35, 'DIVORCIADO', 'Civil Engineer', 3, 'Foothill Farms', 'California', 'Ukraine', 'United States', 'Krishna University', 'OTRO', '2020-05-26 13:52:33');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('61436494H', 'Torie Kimber', '1968-07-22', 52, 'VIUDO', 'Geological Engineer', 7, 'Fish Hawk', 'Florida', 'United States', 'United States', 'University of Northern Iowa', 'OTRO', '2017-05-12 20:05:46');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('21597780C', 'Maurise Playford', '1995-01-19', 26, 'DIVORCIADO', 'Programmer Analyst II', 4, 'Barcelona', 'Anzoátegui', 'Libya', 'Spain', 'Université d''Orléans', 'MUJER', '2017-07-31 07:36:34');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('41349385O', 'Jenelle Bernocchi', '1956-04-06', 64, 'SOLTERO', 'Software Test Engineer II', 2, 'Kotlas', 'Arkhangel’skaya Oblast’', 'United States', 'Russia', 'Ecole Nationale d''Ingénieurs des Techniques des Industries Agricoles et Alimentaires', 'HOMBRE', '2020-06-16 13:06:08');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92932216M', 'Twyla Hourihan', '1989-05-12', 31, 'SOLTERO', 'Librarian', 4, 'East Riverdale', 'Maryland', 'India', 'United States', 'Notre Dame of Marbel University', 'MUJER', '2019-12-30 05:22:19');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('15425036J', 'Lucy Maughan', '1971-12-25', 49, 'CASADO', 'Research Nurse', 10, 'Aarau', 'Aargau', 'United States', 'Switzerland', 'Rajamangala University of Technology, Lanna Nan', 'OTRO', '2020-12-04 15:49:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('31649376I', 'Queenie Kershow', '1986-01-09', 35, 'CASADO', 'Business Systems Development Analyst', 3, 'Polokwane', 'Limpopo', 'Australia', 'South Africa', 'Universitas Islam Sumatera Utara', 'MUJER', '2020-08-05 21:30:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('91981768G', 'Amabel Jerzyk', '1973-10-19', 47, 'CASADO', 'Environmental Specialist', 11, 'Xiamen', 'Fujian', 'Guatemala', 'China', 'Institute of Management and Technical Studies ', 'HOMBRE', '2017-06-21 22:52:30');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85342697Z', 'Liliane Pittendreigh', '1964-10-29', 56, 'SEPARADO', 'Senior Quality Engineer', 5, 'Guadalajara', 'Jalisco', 'Brazil', 'Spain', 'Duke University', 'HOMBRE', '2018-03-23 22:56:33');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('20923495U', 'Jock Ivakhnov', '1985-11-09', 35, 'CASADO', 'Senior Developer', 3, 'Lugano', 'Ticino', 'Venezuela', 'Switzerland', 'American University College of Technology', 'OTRO', '2018-04-01 00:22:17');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('05413503F', 'Zachariah Agdahl', '2002-01-25', 19, 'VIUDO', 'Staff Accountant I', 1, 'Colts Neck', 'New Jersey', 'Serbia', 'United States', 'American University of the Caribbean, Sint Maarten', 'HOMBRE', '2016-06-13 15:37:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85328000E', 'Xerxes Shutt', '1982-07-04', 38, 'SEPARADO', 'VP Marketing', 2, 'Söke', 'Aydın', 'United States', 'Turkey', 'Universidad Autonoma Monterrey', 'MUJER', '2020-05-31 21:26:14');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('95501108I', 'Job Garbutt', '1987-04-30', 33, 'SOLTERO', 'Software Test Engineer III', 10, 'Nazca', 'Ica', 'Russia', 'Peru', 'Kagoshima Immaculate Heart University', 'OTRO', '2019-05-19 01:28:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('31238243H', 'Marietta Nowak', '1972-03-27', 49, 'UNION DE HECHO', 'Business Systems Development Analyst', 4, 'Vilyuysk', 'Sakha (Yakutiya)', 'Canada', 'Russia', 'Cheljabinsk State University', 'OTRO', '2018-08-05 17:08:18');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('05694407T', 'Yance Mullally', '1990-02-21', 31, 'VIUDO', 'Community Outreach Specialist', 7, 'Carver', 'Massachusetts', 'Argentina', 'United States', 'University of Palermo', 'HOMBRE', '2019-06-28 21:15:30');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('40035120C', 'Juan Itzkov', '1986-03-24', 35, 'SOLTERO', 'Registered Nurse', 3, 'Bengkulu', 'Bengkulu', 'Peru', 'Indonesia', 'Göteborg University', 'HOMBRE', '2018-01-07 22:54:58');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('30744361T', 'Sula Cristoforetti', '1963-09-05', 57, 'SOLTERO', 'Speech Pathologist', 4, 'Gander', 'Newfoundland and Labrador', 'United States', 'Canada', 'Pontifcia Universitas a S.Thomas Aquinate in Urbe', 'HOMBRE', '2018-01-08 01:40:41');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('28928594D', 'Boonie Tunney', '1986-10-21', 34, 'DIVORCIADO', 'Assistant Manager', 6, 'Ismailia', 'Al Ismā‘īlīyah', 'United States', 'Egypt', 'Lake Erie College', 'OTRO', '2020-12-14 00:13:03');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('25886038L', 'Aubert Turnor', '1943-01-17', 78, 'DIVORCIADO', 'Senior Quality Engineer', 4, 'Innsbruck', 'Tirol', 'Albania', 'Austria', 'National University of Music', 'HOMBRE', '2016-08-04 17:43:02');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('01729342J', 'Sunny Phear', '1974-03-03', 47, 'VIUDO', 'Programmer Analyst I', 11, 'Desaguadero', 'Puno', 'Brazil', 'Peru', 'Physical Education Academy "Jedrzej Sniadecki" in Gdansk', 'HOMBRE', '2020-07-26 17:24:47');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('45199729Q', 'Leif Canadine', '1982-09-13', 38, 'UNION DE HECHO', 'Junior Executive', 8, 'Burlington', 'Vermont', 'Brazil', 'United States', 'Far Eastern State Technical Fisheries University', 'HOMBRE', '2020-08-12 09:21:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('30737589B', 'Lethia Whithalgh', '1978-09-26', 42, 'UNION DE HECHO', 'Web Developer II', 2, 'Lochearn', 'Maryland', 'United States', 'United States', 'Samchok National University', 'OTRO', '2018-07-19 11:05:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85673820A', 'Nisse Hansen', '1966-03-03', 55, 'VIUDO', 'Graphic Designer', 1, 'Bururi', 'Bururi', 'United States', 'Burundi', 'The CTL Eurocollege', 'MUJER', '2018-04-13 16:48:00');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('49455567O', 'Opal Lafontaine', '1998-09-23', 22, 'DIVORCIADO', 'Assistant Professor', 1, 'Bərdə', 'Bərdə', 'Bhutan', 'Azerbaijan', 'Guangzhou University of Traditional Chinese Medicine', 'OTRO', '2017-11-02 22:07:02');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('69239536K', 'Frazier Fletcher', '1961-02-13', 60, 'DIVORCIADO', 'Cost Accountant', 0, 'Karungu', 'Migori', 'United States', 'Kenya', 'International People''s College', 'MUJER', '2019-02-13 15:43:29');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('18188016E', 'Michaelina Clint', '1953-05-21', 67, 'CASADO', 'Professor', 6, 'Chai Nat', 'Chai Nat', 'Honduras', 'Thailand', 'Franklin University', 'MUJER', '2019-01-21 13:26:50');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('53937246W', 'Adrian Postan', '1992-03-18', 29, 'VIUDO', 'Dental Hygienist', 9, 'Huancayo', 'Junín', 'United States', 'Peru', 'University of Hartford', 'OTRO', '2017-02-07 12:17:27');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('74256620Q', 'Vevay Sambals', '1983-02-05', 38, 'SOLTERO', 'Biostatistician IV', 1, 'Tahoua', 'Tahoua', 'Azerbaijan', 'Niger', 'Raffles University', 'MUJER', '2019-09-20 02:12:44');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('85668345F', 'Laverna Pharro', '1999-02-01', 22, 'VIUDO', 'Product Engineer', 2, 'Watsa', 'Haut-Uélé', 'United States', 'Congo (Kinshasa)', 'University of Tennessee - Knoxville', 'HOMBRE', '2017-09-30 01:12:50');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('88822417J', 'Lilyan Ackland', '1953-11-02', 67, 'CASADO', 'Electrical Engineer', 9, 'Darwin', 'Northern Territory', 'Congo (Brazzaville)', 'Australia', 'Mahatma Jyotiba Phule Rohilkhand University Bareilly ', 'MUJER', '2016-08-07 10:22:23');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('92799068T', 'Carlota Penny', '1979-05-02', 41, 'SOLTERO', 'Administrative Officer', 7, 'Florence', 'Oregon', 'Côte D’Ivoire', 'Italy', 'Technological University (Monywa)', 'OTRO', '2018-04-03 10:05:01');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('30430995N', 'Mart Mullard', '1972-05-12', 48, 'SOLTERO', 'Software Test Engineer II', 8, 'Pohang', 'Gyeongbuk', 'Finland', 'Korea, South', 'Duksung Women''s University', 'HOMBRE', '2019-05-30 23:55:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('54888895T', 'Lauretta Toffetto', '1991-09-23', 29, 'CASADO', 'General Manager', 5, 'Evergreen Park', 'Illinois', 'United States', 'United States', 'Oberlin College', 'OTRO', '2018-08-26 04:53:59');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('16615308B', 'Calypso Puve', '1957-08-13', 63, 'SEPARADO', 'Web Developer III', 4, 'Konče', 'Konče', 'United States', 'Macedonia', 'Universitas Negeri Malang', 'HOMBRE', '2017-02-26 11:42:12');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('20273199J', 'Helyn Wasling', '1969-05-05', 51, 'SEPARADO', 'Analyst Programmer', 10, 'Orange', 'Texas', 'United States', 'United States', 'East Tennessee State University', 'HOMBRE', '2018-08-17 19:33:51');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('03399464U', 'Maribel Kieran', '1943-12-18', 77, 'SOLTERO', 'VP Marketing', 4, 'Fort Portal', 'Kabarole', 'India', 'Uganda', 'Saigon University', 'MUJER', '2018-08-08 22:12:42');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('46885767Y', 'Duffy Manon', '1981-03-20', 40, 'UNION DE HECHO', 'Chemical Engineer', 4, 'Estes Park', 'Colorado', 'Mexico', 'United States', 'Aegean University', 'MUJER', '2020-10-12 22:12:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('09904890A', 'Revkah Gleadle', '1956-04-29', 64, 'DIVORCIADO', 'Executive Secretary', 10, 'Canela', 'Rio Grande do Sul', 'United States', 'Brazil', 'Effat College', 'OTRO', '2017-03-15 00:24:52');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('03665031G', 'Desirae Blankley', '1965-11-25', 55, 'SEPARADO', 'Teacher', 10, 'Shippensburg', 'Pennsylvania', 'Chad', 'United States', 'Indiana University at Bloomington', 'MUJER', '2020-11-30 23:01:56');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('04955523F', 'Crawford Caldecott', '1972-02-18', 49, 'DIVORCIADO', 'Electrical Engineer', 11, 'Loudoun Valley Estates', 'Virginia', 'United States', 'United States', 'ITT Technical Institute Maitland', 'HOMBRE', '2018-11-16 12:17:21');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('56443612Q', 'Kathye Duffan', '1993-04-17', 27, 'UNION DE HECHO', 'Nurse', 12, 'Matara', 'Southern', 'Kazakhstan', 'Sri Lanka', 'City University of New York, Lehman College', 'MUJER', '2020-12-29 16:47:06');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('05016607S', 'Emelyne Mongeot', '2002-02-10', 19, 'VIUDO', 'Recruiting Manager', 5, 'Byron', 'Minnesota', 'United States', 'United States', 'Bluefield College', 'HOMBRE', '2018-02-14 14:17:02');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('99591663Y', 'Massimo Filinkov', '1982-10-17', 38, 'UNION DE HECHO', 'Quality Control Specialist', 11, 'Warwick', 'Rhode Island', 'United States', 'United States', 'University of the South Pacific School of Agriculture', 'OTRO', '2020-09-11 04:16:28');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('05014779K', 'Prent Aaronsohn', '1961-11-06', 59, 'VIUDO', 'Programmer Analyst II', 9, 'Snowflake', 'Arizona', 'China', 'United States', 'College of New Caledonia', 'MUJER', '2018-02-14 05:50:40');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('29703831K', 'Elnora Cleef', '1999-10-30', 21, 'SOLTERO', 'VP Marketing', 9, 'Burlington', 'New Jersey', 'Estonia', 'United States', 'Texas A&M University', 'OTRO', '2019-03-08 11:14:37');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('06553546P', 'Oran Bellocht', '1969-08-10', 51, 'DIVORCIADO', 'Design Engineer', 12, 'Januária', 'Minas Gerais', 'San Marino', 'Brazil', 'Maine Maritime Academy', 'HOMBRE', '2016-10-16 16:48:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('20877233F', 'Eduino Clampton', '1977-05-19', 43, 'UNION DE HECHO', 'Web Designer IV', 4, 'Keokuk', 'Iowa', 'United States', 'United States', 'Tamagawa University', 'HOMBRE', '2018-03-18 15:57:31');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('89045590L', 'Kaylyn Gammell', '1969-03-26', 52, 'SOLTERO', 'Web Developer II', 1, 'Nassau Village-Ratliff', 'Florida', 'United States', 'United States', 'Universidad Laica "Vicente Rocafuerte" de Guayaquil', 'OTRO', '2019-07-12 06:45:15');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('67934179B', 'Diahann Schoular', '1992-05-01', 28, 'VIUDO', 'Analog Circuit Design manager', 12, 'Verkhoyansk', 'Sakha (Yakutiya)', 'United States', 'Russia', 'Universidade Lusíada de Angola', 'HOMBRE', '2017-12-28 13:37:21');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('80902946P', 'Charlena Rowles', '1950-06-01', 70, 'CASADO', 'Quality Control Specialist', 12, 'Bovec', 'Bovec', 'India', 'Slovenia', 'Universidade Federal do Pará', 'OTRO', '2016-11-05 08:07:38');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('22463253I', 'Agace Letchford', '1974-09-10', 46, 'SEPARADO', 'Human Resources Assistant IV', 6, 'Odessa', 'Florida', 'Australia', 'United States', 'Manuel L. Quezon University', 'HOMBRE', '2016-02-04 01:58:48');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('11375516I', 'West Gansbuhler', '1953-09-18', 67, 'DIVORCIADO', 'Software Consultant', 7, 'Lakes of the Four Seasons', 'Indiana', 'Russia', 'United States', 'University of Toledo', 'MUJER', '2018-01-14 05:23:58');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('94342268B', 'Corny Menis', '1989-09-06', 31, 'VIUDO', 'Recruiter', 6, 'Gowanda', 'New York', 'United States', 'United States', 'DEI Bachelor & Master Degrees', 'OTRO', '2018-09-21 21:08:41');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('99220378I', 'Charlotta Carlesi', '1957-04-08', 63, 'CASADO', 'Database Administrator III', 1, 'Blida', 'Blida', 'United Kingdom', 'Algeria', 'University of Cincinnati', 'HOMBRE', '2016-12-01 03:37:43');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('20250544Z', 'Franz McKimmie', '1967-01-05', 54, 'VIUDO', 'Civil Engineer', 2, 'Gainesville', 'Georgia', 'United States', 'United States', 'Dalarna University College', 'OTRO', '2019-04-27 02:05:06');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('13195673E', 'Thomasine Liebmann', '1956-01-26', 65, 'SEPARADO', 'Registered Nurse', 0, 'Ashino', 'Hokkaidō', 'United States', 'Japan', 'Deccan College Postgraduate and Research Institute', 'HOMBRE', '2020-05-09 17:47:54');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('98654381E', 'Dal Dudek', '1969-07-24', 51, 'UNION DE HECHO', 'Software Consultant', 8, 'Charleville', 'Queensland', 'Mauritania', 'Australia', 'Scandinavian Art and Business Institute', 'HOMBRE', '2017-01-31 04:18:42');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('44546083M', 'Claudine McKeighan', '1957-03-02', 64, 'VIUDO', 'Pharmacist', 6, 'Lillehammer', 'Oppland', 'Lithuania', 'Norway', 'Universidad Popular Autonóma del Estado de Puebla', 'MUJER', '2018-06-06 08:48:07');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('13640802Z', 'Florencia Scotchmor', '1990-07-02', 30, 'DIVORCIADO', 'Dental Hygienist', 5, 'Şanlıurfa', 'Şanlıurfa', 'United States', 'Turkey', 'Raghebe Esfahani University', 'HOMBRE', '2020-08-10 20:10:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('57403366Q', 'Marcela Rapsey', '1978-09-21', 42, 'VIUDO', 'Data Coordiator', 10, 'Monrovia', 'Montserrado', 'United States', 'United States', 'Georgia State University', 'MUJER', '2020-10-02 12:36:11');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('53712077K', 'Christin Sturt', '1963-12-27', 57, 'SOLTERO', 'Statistician III', 11, 'Nueva Loja', 'Sucumbíos', 'Brazil', 'Ecuador', 'Open University of the Netherlands', 'MUJER', '2016-09-03 22:52:15');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('47946012S', 'Noami Klinck', '1982-08-05', 38, 'SOLTERO', 'Professor', 8, 'Wyoming', 'Minnesota', 'United States', 'United States', 'Technical University of Iasi', 'MUJER', '2018-04-01 00:10:35');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('69536241W', 'Hugo Seatter', '1992-08-20', 28, 'UNION DE HECHO', 'Professor', 4, 'Richmond', 'California', 'San Marino', 'United States', 'Universidad Latinoamericana de Ciencia y Tecnología', 'MUJER', '2017-10-20 19:10:20');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('86657526U', 'Ignacio Manderson', '1951-08-08', 69, 'SEPARADO', 'Help Desk Operator', 12, 'Eagle Point', 'Oregon', 'Norway', 'United States', 'Feng Chia University', 'HOMBRE', '2018-07-13 00:27:01');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('03709449R', 'Ignaz Steckings', '1994-08-09', 26, 'SOLTERO', 'Staff Scientist', 8, 'Bīdar', 'Karnātaka', 'United States', 'India', 'Benedictine University, Springfield College in Illinois', 'MUJER', '2017-12-07 00:13:42');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('98147633H', 'Ingrim Park', '1984-12-06', 36, 'VIUDO', 'Quality Control Specialist', 0, 'Valley Center', 'California', 'United States', 'United States', 'École Polytechnique de Montréal, Université de Montréal', 'MUJER', '2017-07-10 17:14:56');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('80131381X', 'Vanni Edmans', '1969-07-08', 51, 'UNION DE HECHO', 'Librarian', 7, 'Cerkvenjak', 'Cerkvenjak', 'Slovenia', 'Slovenia', 'Salisbury State University', 'HOMBRE', '2016-04-22 09:41:56');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('41173696K', 'Pen Bineham', '1994-12-28', 26, 'UNION DE HECHO', 'Assistant Manager', 2, 'Duncanville', 'Texas', 'United States', 'United States', 'Universidad Argentina de la Empresa', 'MUJER', '2020-12-09 19:16:40');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('05413206A', 'Quinta Curnokk', '1965-10-14', 55, 'VIUDO', 'Cost Accountant', 12, 'Houma', 'Louisiana', 'United States', 'United States', 'Dnepropetrovsk National University', 'OTRO', '2016-05-04 12:46:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('74018986T', 'Michel Pennuzzi', '1970-06-27', 50, 'CASADO', 'Executive Secretary', 11, 'Al Khawr', 'Al Khawr wa adh Dhakhīrah', 'United States', 'Qatar', 'Shanxi University', 'MUJER', '2017-11-07 18:09:13');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('68643919X', 'Viviene Behne', '1963-01-14', 58, 'CASADO', 'Software Engineer I', 12, 'East San Gabriel', 'California', 'Central African Republic', 'United States', 'International University in Germany', 'MUJER', '2018-09-16 23:18:11');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('88353701Y', 'Maryanne Crack', '2002-06-04', 18, 'DIVORCIADO', 'Information Systems Manager', 6, 'Chŏngju', 'P’yŏngbuk', 'Russia', 'Korea, North', 'Universidad del Pacifico', 'MUJER', '2017-10-13 03:13:09');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('90924101M', 'Martie Steanyng', '2001-03-06', 20, 'DIVORCIADO', 'Nuclear Power Engineer', 7, 'Cantemir', 'Cantemir', 'Congo (Kinshasa)', 'Moldova', 'Université de Ngaoundéré', 'HOMBRE', '2017-01-09 10:01:21');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('31358662D', 'Isidora Warlowe', '1982-09-13', 38, 'SOLTERO', 'Computer Systems Analyst IV', 6, 'Collegeville', 'Pennsylvania', 'Russia', 'United States', 'Universität des Saarlandes', 'OTRO', '2016-09-25 23:54:34');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('79962229X', 'Doy Attrie', '1982-08-02', 38, 'SEPARADO', 'Sales Representative', 1, 'Kankakee', 'Illinois', 'China', 'United States', 'Universidade de Coimbra', 'MUJER', '2019-03-13 01:06:35');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('96797810K', 'Nettie Tomaskunas', '1967-02-25', 54, 'DIVORCIADO', 'Project Manager', 10, 'Chilca', 'Lima', 'United States', 'Peru', 'Covenant University', 'MUJER', '2017-02-27 06:35:23');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('18993101I', 'Sandie Dalgarnowch', '1951-07-31', 69, 'SEPARADO', 'Actuary', 11, 'Coroico', 'La Paz', 'United States', 'Bolivia', 'Dhurakijpundit University', 'OTRO', '2017-03-01 22:59:10');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('18260942C', 'Elsey Chittem', '1991-06-25', 29, 'SOLTERO', 'Occupational Therapist', 12, 'Sitalpur', 'Uttar Pradesh', 'Korea, South', 'India', 'University of Peradeniya', 'OTRO', '2019-03-25 20:04:21');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('82222322K', 'Aldon Fischer', '1993-10-22', 27, 'UNION DE HECHO', 'Biostatistician I', 0, 'North Plainfield', 'New Jersey', 'Nigeria', 'United States', 'Mondragon Univertsitatea', 'HOMBRE', '2020-09-10 07:22:33');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('45137271Y', 'Babbie Tuson', '1962-05-09', 58, 'DIVORCIADO', 'Health Coach III', 3, 'Petatlán', 'Guerrero', 'Turkey', 'Mexico', 'University for Peace', 'HOMBRE', '2016-05-27 12:57:38');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('31592071S', 'Bastian Trench', '1991-09-06', 29, 'UNION DE HECHO', 'Analog Circuit Design manager', 2, 'Westwego', 'Louisiana', 'United States', 'United States', 'University of Media Arts', 'MUJER', '2019-01-14 10:46:43');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('03438149Y', 'Emmaline McHan', '1943-08-25', 77, 'SEPARADO', 'VP Marketing', 5, 'Clyde', 'Ohio', 'United States', 'United States', 'Université de Buéa', 'HOMBRE', '2017-01-17 18:33:05');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('58580149U', 'Nataline Sibbet', '1975-06-18', 45, 'CASADO', 'Account Executive', 7, 'Detroit', 'Michigan', 'United States', 'United States', 'Universidad José Maria Vargas', 'HOMBRE', '2020-09-08 16:33:26');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('84661096R', 'Heywood Preto', '1951-04-30', 69, 'DIVORCIADO', 'Safety Technician III', 10, 'Egypt Lake-Leto', 'Florida', 'Mexico', 'United States', 'University of the Air', 'MUJER', '2019-03-19 11:13:08');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('57621195S', 'Krispin Abelevitz', '1990-10-05', 30, 'SEPARADO', 'VP Accounting', 0, 'Millville', 'New Jersey', 'Ecuador', 'United States', 'Université Michel de Montaigne (Bordeaux III )', 'OTRO', '2020-10-30 09:45:22');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('49247296N', 'Burton Ferry', '1995-01-27', 26, 'CASADO', 'Developer II', 8, 'Xuanzhou', 'Anhui', 'Brazil', 'China', 'University of Divinity', 'OTRO', '2019-10-25 17:26:16');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('23206970X', 'Josey Farndale', '1945-10-18', 75, 'SOLTERO', 'Librarian', 8, 'Itabuna', 'Bahia', 'Brunei', 'Brazil', 'Music Academy "Fryderyk Chopin" in Warszaw', 'HOMBRE', '2018-03-18 02:46:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('93205706M', 'Brittaney Bretton', '1954-11-26', 66, 'SOLTERO', 'Systems Administrator IV', 9, 'London', 'Ohio', 'France', 'United States', 'Berhampur University', 'MUJER', '2019-03-06 01:40:43');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('79146442D', 'Bryan Pye', '2001-10-14', 19, 'VIUDO', 'Recruiting Manager', 10, 'Saidu Sharif', 'Khyber Pakhtunkhwa', 'Greece', 'Pakistan', 'Simpson College Iowa', 'MUJER', '2020-10-28 17:45:18');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('42954838B', 'Cathee Scole', '1997-03-09', 24, 'SEPARADO', 'Web Developer IV', 1, 'The Villages', 'Florida', 'United States', 'United States', 'East-Siberian State Institute of Culture', 'MUJER', '2019-10-08 15:44:55');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('52839438O', 'Joyous Ruddick', '1996-02-20', 25, 'DIVORCIADO', 'Analyst Programmer', 8, 'Manatuto', 'Manatuto', 'United States', 'Timor-Leste', 'Politeknik Negeri Bandung', 'MUJER', '2016-12-04 06:06:04');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('51977060S', 'Noam Woodburn', '1978-02-07', 43, 'SOLTERO', 'Desktop Support Technician', 5, 'Bindura', 'Mashonaland Central', 'Uganda', 'Zimbabwe', 'Indian Institute of Technology, Kanpur', 'MUJER', '2018-06-19 16:21:57');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('72816443M', 'Nap Wotherspoon', '1952-06-09', 68, 'VIUDO', 'Research Nurse', 10, 'East Stroudsburg', 'Pennsylvania', 'United States', 'United States', 'Universidade dos Acores', 'OTRO', '2016-08-30 11:46:42');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('41791106A', 'Ruthann Farrance', '1998-12-23', 22, 'VIUDO', 'Executive Secretary', 3, 'La Riviera', 'California', 'United States', 'United States', 'Kokushikan University', 'HOMBRE', '2017-11-21 06:17:37');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('14970824X', 'Tessa Angerstein', '1973-01-17', 48, 'DIVORCIADO', 'Software Consultant', 5, 'Christchurch', 'Canterbury', 'South Sudan', 'New Zealand', 'North South University', 'MUJER', '2019-04-15 21:26:39');
insert into PERSONA (dni, nombre, fecha_nacimiento, edad, estado_civil, ocupacion, hijos, localidad, provincia, pais_origen, pais_residencia, estudios, genero, ultima_actualizacion) values ('96575776M', 'Kaitlyn Bracknell', '1956-03-01', 65, 'VIUDO', 'Executive Secretary', 11, 'Point Pleasant', 'West Virginia', 'United States', 'United States', 'Minneapolis College of Art and Design', 'HOMBRE', '2016-12-15 08:52:46');

insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('07055242C', '176387CCC', false, 'PREFERENTE', '2017-09-20 02:30:47');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('56904806S', '208732KWT', true, 'BUSINESS', '2019-10-14 20:32:17');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('38280831H', '624461DNU', false, 'TURISTA', '2017-09-28 01:19:14');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('86687145N', '273239VFY', false, 'PREFERENTE', '2019-06-05 22:35:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('84848139W', '738062DOE', false, 'PREFERENTE', '2020-02-15 03:36:38');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('70878793O', '171657EVL', false, 'TURISTA', '2016-06-17 03:28:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('20185493S', '662545EBK', true, 'BUSINESS', '2018-10-16 04:03:14');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('00665573L', '897536WVQ', true, 'TURISTA', '2016-05-08 04:06:12');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('29838624Z', '787160CCG', true, 'TURISTA', '2017-06-01 06:02:21');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('78133090Z', '110395LHV', false, 'PREFERENTE', '2016-07-15 10:39:23');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('00337814K', '257134HVP', false, 'TURISTA', '2019-05-20 05:50:51');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('75154918H', '312198ZYW', true, 'PREFERENTE', '2020-01-14 16:21:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('24007893U', '684091HSS', true, 'TURISTA', '2016-08-31 11:20:45');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92140486L', '690296FJL', false, 'PREFERENTE', '2016-03-07 04:14:04');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('51788970Q', '091297WBY', false, 'BUSINESS', '2018-07-02 19:18:02');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92388292H', '736452TSU', true, 'BUSINESS', '2020-08-04 01:52:53');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('41655520M', '413692HSU', true, 'TURISTA', '2019-03-01 13:22:38');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('97067662H', '249596NYV', true, 'TURISTA', '2019-04-11 14:55:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('16305315P', '191803LYF', false, 'PREFERENTE', '2019-10-01 23:57:26');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('43167839X', '820090HNH', false, 'BUSINESS', '2016-11-10 10:38:56');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('49741113Z', '075355CHK', true, 'TURISTA', '2019-03-12 12:58:37');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('28368887A', '702599SZH', true, 'BUSINESS', '2016-11-11 18:23:31');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('89255796Y', '750212QMM', true, 'BUSINESS', '2016-07-02 03:26:47');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58496330S', '694573JNZ', true, 'PREFERENTE', '2017-04-28 18:31:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('73630839H', '038329EBH', true, 'PREFERENTE', '2019-08-13 15:44:59');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58844888I', '382995XMW', true, 'PREFERENTE', '2017-02-03 02:25:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('57769934B', '951300PYI', true, 'TURISTA', '2019-10-14 08:39:11');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('29958060M', '888683PHL', false, 'PREFERENTE', '2017-07-18 16:52:00');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('57677201C', '637909JCA', true, 'TURISTA', '2018-05-11 16:46:07');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85654886A', '019528YEX', false, 'PREFERENTE', '2020-09-24 19:41:29');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('84087080L', '762029JVG', true, 'TURISTA', '2019-04-27 19:06:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('63097304T', '272122SBY', true, 'BUSINESS', '2019-12-15 14:07:18');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('17736845Y', '750803ZHC', true, 'PREFERENTE', '2016-03-18 10:06:00');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('35493398N', '355879GTO', true, 'BUSINESS', '2018-07-23 14:19:27');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('52051003V', '403268BGK', true, 'TURISTA', '2017-11-20 14:32:10');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('88460292P', '932322LQW', true, 'TURISTA', '2017-04-16 15:05:18');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('19424183S', '773326FYV', true, 'TURISTA', '2016-02-09 22:32:02');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58618293D', '405478TTH', false, 'TURISTA', '2018-09-10 16:58:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('95924257Q', '318402HTS', false, 'PREFERENTE', '2020-06-20 13:12:19');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('74527513B', '225832BPF', false, 'PREFERENTE', '2018-02-25 17:10:41');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('83743817J', '308625NEU', true, 'PREFERENTE', '2016-12-20 10:24:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('46113088B', '482075SWX', false, 'TURISTA', '2019-01-23 07:14:23');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92956925I', '624809RDF', false, 'PREFERENTE', '2019-09-28 14:09:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('70464474N', '145868AYJ', true, 'PREFERENTE', '2018-03-31 09:56:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('02382074A', '139779FZL', false, 'BUSINESS', '2016-10-18 05:23:54');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('30537638Q', '853139FVI', false, 'PREFERENTE', '2020-03-06 06:14:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('22012118W', '565085HMS', true, 'BUSINESS', '2020-06-16 13:54:02');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('40387228S', '501590WHP', false, 'PREFERENTE', '2020-09-29 22:31:25');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('98991252R', '493770UVK', false, 'BUSINESS', '2020-11-15 22:19:50');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('80548424Q', '048835UNS', true, 'TURISTA', '2017-02-02 14:23:20');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('26491980A', '482010LHU', false, 'TURISTA', '2019-07-21 12:54:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('47428291L', '750334UKQ', true, 'BUSINESS', '2019-11-21 05:05:36');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('82767796L', '823751CUI', true, 'TURISTA', '2017-09-15 05:52:39');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('18861987Z', '244163HIM', true, 'BUSINESS', '2020-02-05 01:44:20');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('70891770A', '000958WEM', true, 'BUSINESS', '2016-08-13 12:11:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('37398296C', '345162IPV', false, 'TURISTA', '2019-05-30 00:10:33');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('37900304M', '446944VPZ', false, 'BUSINESS', '2020-07-04 21:36:54');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('26807992N', '227087GCE', false, 'BUSINESS', '2020-12-15 00:28:50');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('27848391E', '775402GJH', true, 'BUSINESS', '2018-05-05 13:20:33');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('12623557E', '485640MOF', false, 'BUSINESS', '2017-01-14 09:42:39');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('84780067I', '135254UHE', false, 'TURISTA', '2019-06-19 20:14:39');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('73301916I', '736408BAM', false, 'BUSINESS', '2020-08-18 18:44:55');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('38013653B', '291083WCK', true, 'TURISTA', '2019-05-30 07:49:36');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('79839942M', '393417UVJ', true, 'BUSINESS', '2020-09-17 04:55:57');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('70716796H', '859249HSF', false, 'PREFERENTE', '2017-01-07 01:24:19');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58982427V', '677005LZP', false, 'PREFERENTE', '2018-09-05 17:38:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('36802529Q', '478627RJP', true, 'BUSINESS', '2020-06-29 03:15:50');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85659619A', '482630FVE', false, 'BUSINESS', '2020-04-04 20:43:09');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('67716684G', '867755APB', true, 'PREFERENTE', '2016-09-17 07:04:04');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('31370859H', '720886ZRG', false, 'BUSINESS', '2020-03-06 21:42:26');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('55237927E', '762861LKN', true, 'TURISTA', '2017-01-16 14:03:50');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('07558371D', '267699GGP', false, 'TURISTA', '2019-10-08 02:35:43');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('69360637Z', '293199TZS', true, 'BUSINESS', '2019-03-17 09:25:45');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('17576951C', '832110HDU', true, 'BUSINESS', '2020-05-18 11:59:08');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('00247726I', '718501ZNY', true, 'TURISTA', '2016-03-06 19:08:59');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('65736826L', '965080MUE', true, 'TURISTA', '2018-04-08 12:23:02');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('43914194N', '547652NPO', false, 'BUSINESS', '2017-08-15 16:39:21');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('27278555E', '985050WNU', true, 'PREFERENTE', '2016-01-29 16:27:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('19767799D', '055976NWL', false, 'BUSINESS', '2016-07-18 16:59:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('59643079M', '807898OBG', true, 'TURISTA', '2017-08-09 19:47:04');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('94489726X', '855512NNZ', false, 'BUSINESS', '2019-04-11 08:47:35');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('88975906N', '655953PND', true, 'PREFERENTE', '2019-10-10 11:42:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('73494812M', '973623XGW', true, 'PREFERENTE', '2019-12-17 19:29:47');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('53961118L', '152196NSY', true, 'BUSINESS', '2020-02-13 08:32:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('47938670T', '509092CVB', false, 'TURISTA', '2017-02-13 13:13:47');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('90909458T', '003696VMI', false, 'BUSINESS', '2018-06-30 21:16:24');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58435558H', '552451MPH', true, 'TURISTA', '2020-06-12 01:34:38');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('50150286R', '422037MKM', false, 'BUSINESS', '2019-02-10 15:45:59');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('94675329B', '731930FWA', false, 'PREFERENTE', '2020-05-15 18:11:17');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('38234174I', '150502TDW', false, 'TURISTA', '2016-06-25 23:41:29');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('97814136Q', '780903JQO', false, 'BUSINESS', '2019-11-13 19:07:28');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('99613595U', '910598RJG', true, 'PREFERENTE', '2020-11-27 09:53:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('06780561G', '858429SNV', true, 'PREFERENTE', '2018-06-09 17:59:51');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('48758609Z', '612180HDH', false, 'TURISTA', '2019-04-17 10:48:32');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('93990482O', '319018FEM', true, 'TURISTA', '2017-05-25 14:20:15');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('19328559L', '838169DQZ', false, 'PREFERENTE', '2017-04-21 05:38:16');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92382459A', '857235XBM', true, 'PREFERENTE', '2020-08-25 11:30:31');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('03583687M', '040309WRC', false, 'TURISTA', '2017-08-19 03:01:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('88413344X', '020004GVP', true, 'PREFERENTE', '2018-03-20 13:54:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58407974X', '123459JVQ', false, 'BUSINESS', '2016-03-14 16:56:10');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('73763582N', '001048ZTH', true, 'PREFERENTE', '2019-02-13 18:27:41');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('55581377B', '262783WVH', false, 'TURISTA', '2016-12-24 02:19:05');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('43807742M', '491034ICW', false, 'PREFERENTE', '2020-03-07 02:07:12');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('40208744O', '462727OYR', false, 'BUSINESS', '2020-05-29 18:47:09');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('43216152P', '318785NUP', false, 'TURISTA', '2017-01-25 02:24:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('61436494H', '993683WTW', true, 'BUSINESS', '2020-10-22 13:46:34');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('21597780C', '745743WLR', false, 'BUSINESS', '2020-06-07 14:54:04');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('41349385O', '217713MXE', false, 'PREFERENTE', '2018-10-08 13:26:32');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92932216M', '430070TKM', false, 'TURISTA', '2020-04-20 06:06:46');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('15425036J', '086825YSV', true, 'BUSINESS', '2016-07-05 19:54:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('31649376I', '379114KOE', true, 'PREFERENTE', '2020-04-04 04:36:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('91981768G', '942623VJB', true, 'PREFERENTE', '2018-07-13 00:35:25');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85342697Z', '915698DRW', false, 'BUSINESS', '2017-06-09 00:09:19');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('20923495U', '247717NSA', false, 'TURISTA', '2018-05-24 01:40:20');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('05413503F', '387140ZYS', true, 'BUSINESS', '2018-08-17 04:46:10');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85328000E', '253944QNK', false, 'BUSINESS', '2018-03-30 14:43:38');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('95501108I', '257875AWO', false, 'TURISTA', '2016-09-08 09:52:15');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('31238243H', '894474KHC', true, 'PREFERENTE', '2020-08-29 12:21:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('05694407T', '428897WGK', true, 'TURISTA', '2017-03-14 20:35:59');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('40035120C', '765005UST', false, 'PREFERENTE', '2017-05-19 16:24:09');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('30744361T', '514178QES', true, 'BUSINESS', '2017-06-05 17:00:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('28928594D', '758126DKR', true, 'PREFERENTE', '2016-06-19 06:23:08');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('25886038L', '971821XVW', false, 'TURISTA', '2017-12-09 21:01:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('01729342J', '577208HYE', true, 'BUSINESS', '2016-12-19 23:48:14');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('45199729Q', '731538VGA', true, 'TURISTA', '2017-11-26 05:21:53');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('30737589B', '933228DHS', false, 'BUSINESS', '2020-04-02 16:59:17');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85673820A', '063256ABF', true, 'BUSINESS', '2017-04-04 21:07:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('49455567O', '409780FGF', true, 'BUSINESS', '2016-06-03 07:55:34');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('69239536K', '111266AYR', false, 'PREFERENTE', '2020-05-08 14:06:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('18188016E', '314151QLT', false, 'TURISTA', '2020-09-16 21:39:45');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('53937246W', '724859YUJ', false, 'TURISTA', '2020-05-03 03:25:42');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('74256620Q', '048826UOI', true, 'TURISTA', '2017-06-26 01:04:38');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('85668345F', '934786GTF', false, 'TURISTA', '2020-08-23 11:51:47');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('88822417J', '406021NYM', true, 'PREFERENTE', '2018-04-25 18:38:33');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('92799068T', '000455ZYX', true, 'PREFERENTE', '2018-01-27 03:56:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('30430995N', '434396SQC', false, 'PREFERENTE', '2019-03-09 22:22:23');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('54888895T', '819245HFT', false, 'BUSINESS', '2019-02-23 08:50:25');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('16615308B', '113150YGN', true, 'PREFERENTE', '2016-10-31 18:24:57');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('20273199J', '881103QAK', false, 'PREFERENTE', '2016-10-01 21:30:54');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('03399464U', '589611MWC', true, 'BUSINESS', '2017-09-15 08:07:17');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('46885767Y', '093225MSN', false, 'TURISTA', '2020-07-22 16:13:58');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('09904890A', '959340UPP', true, 'BUSINESS', '2017-05-18 03:56:25');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('03665031G', '836282EVP', true, 'PREFERENTE', '2019-12-14 07:50:29');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('04955523F', '160344BGO', true, 'TURISTA', '2018-09-27 18:38:23');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('56443612Q', '834672YIZ', true, 'BUSINESS', '2019-10-31 14:11:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('05016607S', '441369XRG', true, 'BUSINESS', '2016-05-09 14:38:37');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('99591663Y', '408587DET', true, 'TURISTA', '2017-08-26 02:52:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('05014779K', '947827IGT', true, 'BUSINESS', '2020-06-13 02:14:51');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('29703831K', '452943CAS', false, 'PREFERENTE', '2017-06-09 04:19:40');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('06553546P', '223825PZP', true, 'PREFERENTE', '2017-09-02 18:36:27');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('20877233F', '532630YGE', false, 'PREFERENTE', '2020-08-27 03:07:31');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('89045590L', '951712CNZ', true, 'BUSINESS', '2018-04-28 08:10:07');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('67934179B', '215058VES', false, 'TURISTA', '2020-07-28 20:43:46');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('80902946P', '681235HBJ', true, 'PREFERENTE', '2018-07-12 01:20:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('22463253I', '046743EHY', true, 'PREFERENTE', '2019-08-04 04:32:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('11375516I', '370995GNH', true, 'BUSINESS', '2016-11-19 12:52:43');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('94342268B', '718678TKL', true, 'PREFERENTE', '2019-01-26 03:50:26');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('99220378I', '668366EIG', false, 'TURISTA', '2016-01-04 19:29:43');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('20250544Z', '634063ZWT', true, 'PREFERENTE', '2016-09-08 12:26:17');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('13195673E', '242560RBG', false, 'PREFERENTE', '2016-08-18 05:00:34');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('98654381E', '573969WDE', true, 'BUSINESS', '2019-08-17 21:39:43');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('44546083M', '020062YIW', true, 'PREFERENTE', '2019-11-22 02:49:33');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('13640802Z', '931377PKD', false, 'BUSINESS', '2016-02-08 23:53:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('57403366Q', '548186HWR', false, 'TURISTA', '2016-06-05 08:11:07');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('53712077K', '993567AAD', false, 'BUSINESS', '2016-02-18 07:18:01');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('47946012S', '041267CFD', true, 'BUSINESS', '2017-07-16 10:23:24');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('69536241W', '941224YGO', true, 'BUSINESS', '2016-11-18 08:02:50');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('86657526U', '194047FMU', false, 'TURISTA', '2017-06-10 17:43:10');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('03709449R', '176145NAU', false, 'BUSINESS', '2020-03-10 13:57:10');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('98147633H', '512681EJR', false, 'TURISTA', '2018-06-14 01:35:42');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('80131381X', '983162CPQ', true, 'BUSINESS', '2020-12-03 03:18:27');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('41173696K', '348688QEV', false, 'TURISTA', '2018-04-05 22:35:31');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('05413206A', '544949LRX', false, 'TURISTA', '2017-08-14 02:03:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('74018986T', '104536ILH', false, 'PREFERENTE', '2019-06-13 04:18:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('68643919X', '753558VFO', true, 'TURISTA', '2019-11-02 17:32:12');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('88353701Y', '653554QAF', true, 'BUSINESS', '2016-03-28 00:54:23');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('90924101M', '965491WTE', true, 'BUSINESS', '2016-07-09 03:08:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('31358662D', '794125SUS', true, 'BUSINESS', '2016-07-07 02:41:12');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('79962229X', '727612ORT', true, 'PREFERENTE', '2016-03-12 18:38:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('96797810K', '355088UJN', true, 'PREFERENTE', '2016-02-08 04:45:24');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('18993101I', '113470DSH', true, 'BUSINESS', '2018-07-24 09:36:01');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('18260942C', '317028FJX', false, 'BUSINESS', '2019-10-31 19:59:04');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('82222322K', '999128QCQ', true, 'BUSINESS', '2019-11-21 15:31:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('45137271Y', '923881XUM', false, 'BUSINESS', '2016-01-14 17:11:03');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('31592071S', '959883QXZ', false, 'TURISTA', '2017-03-15 22:57:43');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('03438149Y', '551493WQA', true, 'PREFERENTE', '2018-01-01 07:05:13');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('58580149U', '041201IJE', true, 'BUSINESS', '2019-05-16 10:53:06');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('84661096R', '415894WBX', false, 'TURISTA', '2019-07-17 17:16:02');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('57621195S', '673764QQR', false, 'BUSINESS', '2017-07-29 20:57:48');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('49247296N', '505170ETL', true, 'PREFERENTE', '2017-04-16 18:38:59');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('23206970X', '631887JVM', false, 'BUSINESS', '2018-01-05 07:29:52');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('93205706M', '591551NPI', false, 'BUSINESS', '2018-05-04 06:47:30');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('79146442D', '657629FEH', true, 'PREFERENTE', '2019-01-09 09:28:01');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('42954838B', '071268VIU', true, 'BUSINESS', '2017-12-05 20:51:34');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('52839438O', '421956IPF', true, 'PREFERENTE', '2017-10-25 02:49:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('51977060S', '125875UWC', true, 'PREFERENTE', '2016-10-11 12:46:22');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('72816443M', '255044ITM', false, 'TURISTA', '2016-05-10 08:07:45');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('41791106A', '303879PDN', false, 'PREFERENTE', '2016-10-01 11:48:21');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('14970824X', '359326CTC', false, 'BUSINESS', '2016-10-26 08:01:20');
insert into CLIENTE (dni_cliente, npasaporte, vip, preferencia_clase, ultima_actualizacion) values ('96575776M', '333806QOS', false, 'PREFERENTE', '2017-11-03 21:52:59');


insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('233461298A', 'Boma', 'Congo (Kinshasa)', 'San Ignacio', 'Belize', 'INTERNACIONAL', 180);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('652255744J', 'Annandale', 'United States', 'Shashemenē', 'Ethiopia', 'INTERNACIONAL', 944);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('709247980W', 'Diamantina', 'Brazil', 'Bedourie', 'Australia', 'INTERNACIONAL', 931);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('845075649U', 'Plast', 'Russia', 'Bafatá', 'Guinea-Bissau', 'INTERNACIONAL', 90);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('478455123A', 'Holiday', 'United States', 'Morristown', 'United States', 'NACIONAL', 39);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('700224352I', 'Franklin Square', 'United States', 'St. Augustine South', 'United States', 'NACIONAL', 68);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('983554010X', 'Laghouat', 'Algeria', 'Macedon', 'United States', 'INTERNACIONAL', 532);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('654553683G', 'Beecher', 'United States', 'London', 'Canada', 'INTERNACIONAL', 108);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('804912605B', 'Lysander', 'United States', 'Laie', 'United States', 'NACIONAL', 45);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('567538877Z', 'São José do Rio Prêto', 'Brazil', 'Taunton', 'United States', 'INTERNACIONAL', 759);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('138092219R', 'Utuado', 'Puerto Rico', 'Kulusuk', 'Greenland', 'INTERNACIONAL', 905);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('063364295I', 'Seattle', 'United States', 'Puerto Carreño', 'Colombia', 'INTERNACIONAL', 599);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('133776055Y', 'Wooster', 'United States', 'Timashevsk', 'Russia', 'INTERNACIONAL', 937);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('909240077X', 'Gevgelija', 'Macedonia', 'Asbury Park', 'United States', 'INTERNACIONAL', 180);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('811893336T', 'Belo Horizonte', 'Brazil', 'Veymandoo', 'Maldives', 'INTERNACIONAL', 543);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('373040712T', 'Saransk', 'Russia', 'Macheng', 'China', 'INTERNACIONAL', 222);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('634532858H', 'Green Brook', 'United States', 'Sheffield Lake', 'United States', 'NACIONAL', 77);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('079537565Z', 'Saatlı', 'Azerbaijan', 'Kochi', 'India', 'INTERNACIONAL', 104);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('082373576M', 'Dublin', 'Ireland', 'Calgary', 'Canada', 'INTERNACIONAL', 566);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('624771266V', 'Hardeeville', 'United States', 'Zhoukou', 'China', 'INTERNACIONAL', 459);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('683971308T', 'Mission', 'United States', 'Lorain', 'United States', 'NACIONAL', 74);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('147995979M', 'Al Başrah', 'Iraq', 'Bridgewater', 'United States', 'INTERNACIONAL', 390);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('035152296U', 'Sugar Grove', 'United States', 'Wollongong', 'Australia', 'INTERNACIONAL', 936);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('440675847X', 'Winter Springs', 'United States', 'Zhangjiakou Shi Xuanhua Qu', 'China', 'INTERNACIONAL', 128);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('277376266P', 'Hapeville', 'United States', 'Ye', 'Burma', 'INTERNACIONAL', 556);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('063444692F', 'Rolling Meadows', 'United States', 'Junction City', 'United States', 'NACIONAL', 83);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('971898444G', 'Lake Carmel', 'United States', 'Middle Valley', 'United States', 'NACIONAL', 37);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('638989847D', 'Moore', 'United States', 'Danville', 'United States', 'NACIONAL', 71);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('504869441H', 'Socorro', 'United States', 'Langfang', 'China', 'INTERNACIONAL', 647);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('480133586U', 'Miass', 'Russia', 'Whyalla', 'Australia', 'INTERNACIONAL', 195);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('499777409Q', 'Spodnje Hoče', 'Slovenia', 'Caldwell', 'United States', 'INTERNACIONAL', 343);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('627260389P', 'Mohale’s Hoek', 'Lesotho', 'Cochrane', 'Chile', 'INTERNACIONAL', 668);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('623088424M', 'Ambler', 'United States', 'Kenosha', 'United States', 'NACIONAL', 40);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('202830989B', 'Middletown', 'United States', 'Ituiutaba', 'Brazil', 'INTERNACIONAL', 820);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('516219691M', 'Sarqan', 'Kazakhstan', 'Rhuthun', 'United Kingdom', 'INTERNACIONAL', 721);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('903044670E', 'Lake St. Louis', 'United States', 'South San Jose Hills', 'United States', 'NACIONAL', 80);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('781293399D', 'Mentor-on-the-Lake', 'United States', 'Puerto Berrío', 'Colombia', 'INTERNACIONAL', 953);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('183822661G', 'Pekanbaru', 'Indonesia', 'St. Anthony', 'United States', 'INTERNACIONAL', 451);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('061197808M', 'Avon Park', 'United States', 'Tipton', 'United States', 'NACIONAL', 78);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('904174108S', 'Soio', 'Angola', 'Muldrow', 'United States', 'INTERNACIONAL', 250);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('703492393T', 'Fuerte Olimpo', 'Paraguay', 'Pucallpa', 'Peru', 'INTERNACIONAL', 758);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('689216804E', 'Miami Lakes', 'United States', 'Burton', 'United States', 'NACIONAL', 77);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('693687383B', 'Roosevelt', 'United States', 'Stephenville', 'United States', 'NACIONAL', 53);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('125684064Y', 'Clearfield', 'United States', 'Van Wert', 'United States', 'NACIONAL', 55);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('906913512X', 'Lukovica pri Domžalah', 'Slovenia', 'Weirton', 'United States', 'INTERNACIONAL', 227);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('785280662Z', 'Longview', 'United States', 'The Village', 'United States', 'NACIONAL', 70);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('994877626G', 'Grand Terrace', 'United States', 'Artvin', 'Turkey', 'INTERNACIONAL', 235);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('006126532S', 'Nanyuki', 'Kenya', 'Whitefish', 'United States', 'INTERNACIONAL', 483);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('374690163D', 'Wiesbaden', 'Germany', 'Apple Valley', 'United States', 'INTERNACIONAL', 215);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('276116728D', 'Port Maria', 'Jamaica', 'Rowley', 'United States', 'INTERNACIONAL', 715);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('803158842X', 'Coburg', 'Germany', 'Ludington', 'United States', 'INTERNACIONAL', 454);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('320383285B', 'Kuujjuaq', 'Canada', 'Prien', 'United States', 'INTERNACIONAL', 665);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('062489308B', 'Cheney', 'United States', 'Mount Kisco', 'United States', 'NACIONAL', 57);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('163092377N', 'Thonotosassa', 'United States', 'Bayshore Gardens', 'United States', 'NACIONAL', 79);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('397196720Y', 'Chīrāla', 'India', 'San Carlos', 'Philippines', 'INTERNACIONAL', 293);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('576920130N', 'Prunedale', 'United States', 'Fort Chipewyan', 'Canada', 'INTERNACIONAL', 730);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('317890290F', 'Rājahmundry', 'India', 'Arcadia', 'United States', 'INTERNACIONAL', 348);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('376082483V', 'San Ramón de la Nueva Orán', 'Argentina', 'New Smyrna Beach', 'United States', 'INTERNACIONAL', 882);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('151242685J', 'Man', 'Côte D’Ivoire', 'Swissvale', 'United States', 'INTERNACIONAL', 484);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('650204365I', 'Itá', 'Paraguay', 'Chapaev', 'Kazakhstan', 'INTERNACIONAL', 491);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('163234990W', 'Jumlā', 'Nepal', 'Waunakee', 'United States', 'INTERNACIONAL', 521);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('394738372Y', 'Alwar', 'India', 'Byram', 'United States', 'INTERNACIONAL', 821);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('066306837W', 'Suzhou', 'China', 'Nizhnekamsk', 'Russia', 'INTERNACIONAL', 953);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('226836285R', 'Dakota Ridge', 'United States', 'Līgatne', 'Latvia', 'INTERNACIONAL', 756);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('675295660H', 'Balsas', 'Brazil', 'Saint-Georges', 'Canada', 'INTERNACIONAL', 510);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('393850830J', 'Cloverly', 'United States', 'Zhitiqara', 'Kazakhstan', 'INTERNACIONAL', 428);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('481885108N', 'Monroeville', 'United States', 'Vipava', 'Slovenia', 'INTERNACIONAL', 313);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('702782178D', 'Marilla', 'United States', 'Dove Valley', 'United States', 'NACIONAL', 45);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('328642831P', 'Montville', 'United States', 'Kaduna', 'Nigeria', 'INTERNACIONAL', 399);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('363383213B', 'Burrillville', 'United States', 'Babahoyo', 'Ecuador', 'INTERNACIONAL', 646);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('839939902W', 'North Druid Hills', 'United States', 'Kampong Thom', 'Cambodia', 'INTERNACIONAL', 524);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('105418638V', 'Orting', 'United States', 'Kericho', 'Kenya', 'INTERNACIONAL', 654);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('410795735E', 'Andalusia', 'United States', 'Gander', 'Canada', 'INTERNACIONAL', 953);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('068873503K', 'Győr', 'Hungary', 'Pataskala', 'United States', 'INTERNACIONAL', 694);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('185479911S', 'Moanda', 'Gabon', 'Sunrise', 'United States', 'INTERNACIONAL', 509);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('176757424T', 'Dacula', 'United States', 'Mojkovac', 'Montenegro', 'INTERNACIONAL', 830);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('290219372U', 'Cedar Hill', 'United States', 'Mulifanua', 'Samoa', 'INTERNACIONAL', 476);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('297023554G', 'Templeton', 'United States', 'LaGrange', 'United States', 'NACIONAL', 54);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('893087626P', 'Lonquimay', 'Chile', 'Kendallville', 'United States', 'INTERNACIONAL', 640);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('030222740E', 'Saint-Augustin', 'Canada', 'Tracy', 'United States', 'INTERNACIONAL', 666);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('542366704S', 'DeRidder', 'United States', 'Holt', 'United States', 'NACIONAL', 69);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('340236083A', 'Holbrook', 'United States', 'Kalmar', 'Sweden', 'INTERNACIONAL', 747);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('003471832Y', 'Canoinhas', 'Brazil', 'Davao', 'Philippines', 'INTERNACIONAL', 135);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('594455502K', 'Harvey', 'United States', 'Madison', 'United States', 'NACIONAL', 51);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('612977845G', 'Foggia', 'Italy', 'Cochrane', 'Canada', 'INTERNACIONAL', 626);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('523679322Y', 'Easton', 'United States', 'Reykjavík', 'Iceland', 'INTERNACIONAL', 490);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('300230488I', 'Arnhem', 'Netherlands', 'Sinop', 'Brazil', 'INTERNACIONAL', 412);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('723870867D', 'Radford', 'United States', 'St. Johnsbury', 'United States', 'NACIONAL', 60);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('243089355P', 'Bondo', 'Congo (Kinshasa)', 'Pontotoc', 'United States', 'INTERNACIONAL', 845);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('454406302W', 'Mishawaka', 'United States', 'Papeete', 'French Polynesia', 'INTERNACIONAL', 710);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('705365019A', 'Gharyān', 'Libya', 'Miri', 'Malaysia', 'INTERNACIONAL', 749);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('051795419G', 'Loja', 'Ecuador', 'Accokeek', 'United States', 'INTERNACIONAL', 739);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('149071155B', 'Aţ Ţā’if', 'Saudi Arabia', 'Summerville', 'United States', 'INTERNACIONAL', 187);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('956032232X', 'Juana Díaz', 'Puerto Rico', 'Shamong', 'United States', 'INTERNACIONAL', 929);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('830347082D', 'Hanover', 'United States', 'Chillán', 'Chile', 'INTERNACIONAL', 218);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('617677484Q', 'Camp Pendleton North', 'United States', 'New London', 'United States', 'NACIONAL', 71);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('170256215J', 'Bielefeld', 'Germany', 'Saint John’s', 'Antigua And Barbuda', 'INTERNACIONAL', 140);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('731482551S', 'Hardeeville', 'United States', 'Mandya', 'India', 'INTERNACIONAL', 890);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('306030369P', 'Palmetto Bay', 'United States', 'Trooper', 'United States', 'NACIONAL', 82);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('043858979X', 'Metropolis', 'United States', 'Mayflower Village', 'United States', 'NACIONAL', 82);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('551550218D', 'Paris', 'United States', 'Sukabumi', 'Indonesia', 'INTERNACIONAL', 699);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('419131040C', 'São João dos Angolares', 'Sao Tome And Principe', 'Shchëkino', 'Russia', 'INTERNACIONAL', 870);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('703482938M', 'Turpin Hills', 'United States', 'Bel Air', 'United States', 'NACIONAL', 74);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('145903714D', 'Puconci', 'Slovenia', 'Walworth', 'United States', 'INTERNACIONAL', 505);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('689737943E', 'Slinger', 'United States', 'Amahai', 'Indonesia', 'INTERNACIONAL', 345);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('438951898B', 'Anlu', 'China', 'Klagenfurt', 'Austria', 'INTERNACIONAL', 576);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('859640888S', 'Astoria', 'United States', 'Fowler', 'United States', 'NACIONAL', 46);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('508984035K', 'Žitorađa', 'Serbia', 'Rockmart', 'United States', 'INTERNACIONAL', 102);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('546836407P', 'Zheleznogorsk', 'Russia', 'Powdersville', 'United States', 'INTERNACIONAL', 795);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('551243732A', 'Dunedin', 'New Zealand', 'Southfield', 'United States', 'INTERNACIONAL', 937);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('918200695H', 'Otuke', 'Uganda', 'Bukachacha', 'Russia', 'INTERNACIONAL', 225);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('643538765O', 'New Bedford', 'United States', 'Yichun', 'China', 'INTERNACIONAL', 260);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('332548442S', 'Naval', 'Philippines', 'Russells Point', 'United States', 'INTERNACIONAL', 418);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('430772605B', 'Belpre', 'United States', 'Tarawa', 'Kiribati', 'INTERNACIONAL', 280);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('322697703G', 'Glocester', 'United States', 'Ar Ruţbah', 'Iraq', 'INTERNACIONAL', 692);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('655221458F', 'Leshan', 'China', 'Springhill', 'United States', 'INTERNACIONAL', 268);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('776085384T', 'Botoşani', 'Romania', 'Mubende', 'Uganda', 'INTERNACIONAL', 639);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('810451330U', 'Union City', 'United States', 'Beavercreek', 'United States', 'NACIONAL', 89);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('048090125S', 'Kavála', 'Greece', 'Malindi', 'Kenya', 'INTERNACIONAL', 833);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('905197247M', 'Waldorf', 'United States', 'Piedmont', 'United States', 'NACIONAL', 86);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('696567274U', 'Richland', 'United States', 'Salford', 'United Kingdom', 'INTERNACIONAL', 925);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('433217946H', 'Visalia', 'United States', 'Charlottetown', 'Canada', 'INTERNACIONAL', 780);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('942473992R', 'Mysore', 'India', 'Muş', 'Turkey', 'INTERNACIONAL', 872);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('588280500B', 'Wallingford', 'United States', 'Veinticinco de Mayo', 'Argentina', 'INTERNACIONAL', 907);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('303120368A', 'DeSoto', 'United States', 'Brownsville', 'United States', 'NACIONAL', 67);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('177510534I', 'San Juan', 'Puerto Rico', 'Calabozo', 'Venezuela', 'INTERNACIONAL', 598);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('134797672A', 'Pittsburgh', 'United States', 'East Orange', 'United States', 'NACIONAL', 83);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('321271002N', 'Griswold', 'United States', 'Red Lake', 'Canada', 'INTERNACIONAL', 419);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('179523211K', 'Atikokan', 'Canada', 'Catania', 'Italy', 'INTERNACIONAL', 235);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('302434222C', 'Puerto Vallarta', 'Mexico', 'Çeleken', 'Turkmenistan', 'INTERNACIONAL', 159);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('469624384L', 'Bothell West', 'United States', 'Oaxaca', 'Mexico', 'INTERNACIONAL', 256);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('157784697Y', 'Souderton', 'United States', 'Town ''n'' Country', 'United States', 'NACIONAL', 69);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('319107657K', 'Mtskheta', 'Georgia', 'Antigua Guatemala', 'Guatemala', 'INTERNACIONAL', 944);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('672703837G', 'South Salt Lake', 'United States', 'Lackland AFB', 'United States', 'NACIONAL', 89);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('900131706L', 'Kumi', 'Uganda', 'Novi', 'United States', 'INTERNACIONAL', 844);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('262014776Y', 'Blackwell', 'United States', 'Nam Định', 'Vietnam', 'INTERNACIONAL', 603);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('625486097D', 'Doha', 'Qatar', 'Cancún', 'Mexico', 'INTERNACIONAL', 683);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('319971554M', 'Hood River', 'United States', 'Martha Lake', 'United States', 'NACIONAL', 57);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('104581889J', 'Hotan', 'China', 'Southampton', 'United Kingdom', 'INTERNACIONAL', 502);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('614756497L', 'Obninsk', 'Russia', 'Jolo', 'Philippines', 'INTERNACIONAL', 638);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('597028905A', 'Horsham', 'Australia', 'Latrobe', 'United States', 'INTERNACIONAL', 993);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('229633655Y', 'Cedarhurst', 'United States', 'Chandler', 'United States', 'NACIONAL', 58);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('852883849N', 'Smyrna', 'United States', 'Roanoke Rapids', 'United States', 'NACIONAL', 47);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('646313702P', 'Aarau', 'Switzerland', 'Keshan', 'China', 'INTERNACIONAL', 939);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('662492405O', 'Dembī Dolo', 'Ethiopia', 'Everman', 'United States', 'INTERNACIONAL', 203);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('675554791Q', 'San Andrés', 'Colombia', 'Falls Church', 'United States', 'INTERNACIONAL', 94);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('957499350R', 'São José dos Campos', 'Brazil', 'Claverack', 'United States', 'INTERNACIONAL', 262);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('620415636C', 'Orleans', 'United States', 'Colville', 'United States', 'NACIONAL', 62);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('744180337H', 'Leicester', 'United States', 'Lindon', 'United States', 'NACIONAL', 57);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('227422941T', 'Río Cuarto', 'Argentina', 'Piatra Neamţ', 'Romania', 'INTERNACIONAL', 283);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('851881721R', 'Edwards', 'United States', 'Tumby Bay', 'Australia', 'INTERNACIONAL', 224);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('517873890E', 'Xiamen', 'China', 'Braidwood', 'United States', 'INTERNACIONAL', 518);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('241741467J', 'Elwood', 'United States', 'Tall ‘Afar', 'Iraq', 'INTERNACIONAL', 889);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('990783493P', 'Taunton', 'United States', 'Bessemer', 'United States', 'NACIONAL', 82);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('398247344W', 'Barrington', 'United States', 'Brevard', 'United States', 'NACIONAL', 79);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('460719043Q', 'Sofia', 'Bulgaria', 'Oatfield', 'United States', 'INTERNACIONAL', 470);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('270438704N', 'Clairton', 'United States', 'Richlands', 'United States', 'NACIONAL', 65);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('676522141Z', 'Dunedin', 'New Zealand', 'Randolph', 'United States', 'INTERNACIONAL', 479);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('668235461Z', 'Chittagong', 'Bangladesh', 'Sinŭiju', 'Korea, North', 'INTERNACIONAL', 407);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('252056898A', 'Normal', 'United States', 'Heathcote', 'United States', 'NACIONAL', 89);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('475428439A', 'Taungoo', 'Burma', 'Safi', 'Malta', 'INTERNACIONAL', 713);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('409687108W', 'Williamsburg', 'United States', 'Ratnapura', 'Sri Lanka', 'INTERNACIONAL', 984);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('171568970U', 'Westport', 'United States', 'Khenchela', 'Algeria', 'INTERNACIONAL', 293);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('536205627Z', 'Frisco', 'United States', 'Chanthaburi', 'Thailand', 'INTERNACIONAL', 977);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('369461984V', 'Pottstown', 'United States', 'Turbo', 'Colombia', 'INTERNACIONAL', 638);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('934567502P', 'Elk River', 'United States', 'Humboldt', 'United States', 'NACIONAL', 45);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('236097419P', 'Taranto', 'Italy', 'Naga City', 'Philippines', 'INTERNACIONAL', 217);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('890583845I', 'El Fula', 'Sudan', 'Macomb', 'United States', 'INTERNACIONAL', 364);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('483037866U', 'Woodbridge', 'United States', 'Gilmer', 'United States', 'NACIONAL', 74);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('263548523R', 'Eindhoven', 'Netherlands', 'Centerville', 'United States', 'INTERNACIONAL', 107);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('282798534O', 'Joensuu', 'Finland', 'Hāthras', 'India', 'INTERNACIONAL', 772);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('528375746S', 'Odense', 'Denmark', 'Yegor’yevsk', 'Russia', 'INTERNACIONAL', 185);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('184113114O', 'Little Falls', 'United States', 'Irati', 'Brazil', 'INTERNACIONAL', 868);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('292957593C', 'Comendador', 'Dominican Republic', 'Marília', 'Brazil', 'INTERNACIONAL', 167);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('549007318J', 'Walnut Creek', 'United States', 'Thurmont', 'United States', 'NACIONAL', 54);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('991628406D', 'Mbé', 'Cameroon', 'Potchefstroom', 'South Africa', 'INTERNACIONAL', 443);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('633157509I', 'Castillos', 'Uruguay', 'Baiquan', 'China', 'INTERNACIONAL', 752);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('964805039P', 'Ayer', 'United States', 'P’ungsan', 'Korea, North', 'INTERNACIONAL', 624);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('959017408E', 'Creve Coeur', 'United States', 'Morogoro', 'Tanzania', 'INTERNACIONAL', 788);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('222904718M', 'Fayetteville', 'United States', 'Heroica Matamoros', 'Mexico', 'INTERNACIONAL', 308);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('938839845B', 'Anápolis', 'Brazil', 'Aizkraukle', 'Latvia', 'INTERNACIONAL', 368);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('086459294O', 'Huế', 'Vietnam', 'Palmetto Estates', 'United States', 'INTERNACIONAL', 238);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('537457963M', 'Spirit Lake', 'United States', 'Timber Pines', 'United States', 'NACIONAL', 86);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('725030285D', 'Kensington', 'United States', 'Norton Shores', 'United States', 'NACIONAL', 51);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('730161442H', 'Putnam', 'United States', 'Roswell', 'United States', 'NACIONAL', 52);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('023284312M', 'Medan', 'Indonesia', 'River Park', 'United States', 'INTERNACIONAL', 434);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('789954790S', 'Aquidauana', 'Brazil', 'Burgos', 'Spain', 'INTERNACIONAL', 475);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('774287974Y', 'Neyshābūr', 'Iran', 'Braselton', 'United States', 'INTERNACIONAL', 503);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('206054009Y', 'Semera', 'Ethiopia', 'Thatcher', 'United States', 'INTERNACIONAL', 820);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('276290889A', 'Reyes', 'Bolivia', 'Zgornja Kungota', 'Slovenia', 'INTERNACIONAL', 106);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('521323832D', 'West Linn', 'United States', 'Zuni Pueblo', 'United States', 'NACIONAL', 62);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('817185530N', 'Dinuba', 'United States', 'Oak Park', 'United States', 'NACIONAL', 51);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('527676620D', 'Twin Lakes', 'United States', 'Hobart', 'United States', 'NACIONAL', 79);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('517171324K', 'Ayacucho', 'Peru', 'Spencer', 'United States', 'INTERNACIONAL', 624);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('005230863X', 'West Warwick', 'United States', 'Mexico City', 'Mexico', 'INTERNACIONAL', 597);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('173374240E', 'Phelan', 'United States', 'Valley Park', 'United States', 'NACIONAL', 71);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('182718758L', 'Heze', 'China', 'Qazvīn', 'Iran', 'INTERNACIONAL', 504);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('496672729C', 'Inkster', 'United States', 'Ossining', 'United States', 'NACIONAL', 62);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('999017599B', 'Scotchtown', 'United States', 'Butebo', 'Uganda', 'INTERNACIONAL', 451);
insert into RECORRIDO (idrecorrido, aero_destino, destino, aero_origen, origen, tipo, duracion_minutos) values ('630121462K', 'Brookhaven', 'United States', 'Dedham', 'United States', 'NACIONAL', 52);


insert into AVION (idavion, modelo, cargamax, numplazas) values ('R62EPI2', 'H33L', 5918, 135);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H50GHF0', 'E87R', 6983, 281);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q30UIG5', 'I29K', 7325, 245);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V29ZSX2', 'I36V', 8253, 191);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H13NRI2', 'Z13T', 7035, 178);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Z13BTG5', 'L00E', 7156, 89);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('N74ULY4', 'C47G', 5700, 91);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('I29MPD3', 'Q55S', 7674, 190);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W61YHV1', 'B00P', 7107, 168);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F64DNC3', 'Z17P', 5518, 181);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C97HLK7', 'P49B', 9476, 281);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B48BFZ9', 'V73C', 9464, 274);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R68LFX0', 'I11U', 9890, 224);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S91EBE7', 'A17B', 7068, 168);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Y04FBS8', 'A23N', 5338, 284);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S71WEV4', 'Q66N', 3533, 110);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W17IWD6', 'A01K', 6231, 263);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S22CUN3', 'F80N', 6758, 279);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('E64UXI3', 'T36Y', 4619, 86);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X88WMX2', 'Z16Q', 8180, 194);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K75RFW2', 'Z15M', 5031, 178);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K00DJN5', 'R42O', 3404, 97);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R68KKB0', 'K11D', 5781, 290);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H33DSI3', 'R62W', 5567, 92);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M17QYG8', 'W79I', 5809, 259);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M71LZZ0', 'W59W', 3094, 130);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('O91XPE6', 'Q88S', 6783, 249);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('E55SSY1', 'N25G', 4314, 259);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T49GOM0', 'E65H', 3144, 262);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R78FZR7', 'Q82U', 8498, 255);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F06SSJ7', 'T98O', 5617, 254);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('N58KJE9', 'K49K', 4943, 220);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W08WET4', 'S48E', 9051, 168);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F03JFC5', 'B86E', 3820, 241);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U13RYR3', 'D80N', 5390, 290);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Z81VGL7', 'V22J', 4011, 99);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G75ZOA9', 'R13J', 5974, 259);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Y95SWL3', 'T19C', 7726, 198);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T93GJM5', 'D65L', 9029, 269);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('P63QQK8', 'L61R', 3447, 247);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S61DYT2', 'L61A', 8069, 227);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T27GXO8', 'T96H', 9538, 91);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V17AZH2', 'G29B', 7015, 107);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K41BKH6', 'Q93R', 3155, 99);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H76VEO1', 'T16G', 6277, 233);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W05IFW0', 'D45Y', 4373, 263);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X11HFI9', 'L18S', 8296, 300);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H97BFG6', 'E10E', 8232, 179);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K80PBU5', 'B50G', 6219, 194);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V51VZR5', 'B63D', 4059, 204);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U54NKY1', 'Y96M', 6819, 299);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X26ACJ3', 'S35Y', 8534, 105);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R74JLT8', 'P21R', 4817, 83);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T41HPF1', 'P84X', 5988, 135);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J06SGB8', 'V67R', 8234, 164);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J04KBC6', 'M26D', 4623, 231);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S59UQF4', 'A30D', 7589, 86);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K18ETO3', 'W51G', 6233, 281);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('P45NLM6', 'W78L', 6245, 262);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Y07XOX1', 'V25J', 4182, 94);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L59AYE1', 'W12L', 6577, 95);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('A92MHZ9', 'Q54B', 7893, 122);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q05AWW6', 'S59R', 8681, 212);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R59OBH2', 'R24U', 4748, 241);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H80SLM1', 'H54C', 4505, 96);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L65GFX9', 'X17N', 4586, 154);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('O26RSR7', 'F61T', 5540, 223);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U95XJO7', 'P26K', 9512, 225);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Y96GZC0', 'W47B', 8043, 116);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V48RXY1', 'U44Z', 5394, 139);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C26RKD4', 'M68T', 6723, 186);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M44QRR6', 'M91K', 5320, 253);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J21NIJ6', 'E53D', 8410, 126);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J69UBL6', 'M39U', 4743, 141);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G41JHL2', 'I58Q', 8982, 153);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T83GMU4', 'X16C', 7849, 131);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('P36NXE7', 'Z34X', 8542, 167);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Y58SLX0', 'N18J', 4587, 183);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R02KHB7', 'P35P', 9316, 291);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X10NBN2', 'P18Z', 6556, 134);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R86LCD5', 'F96V', 6347, 84);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R84KRN5', 'M51T', 8501, 133);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K68EGA4', 'X97I', 9229, 279);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B50ATK3', 'S39L', 7259, 106);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G05GYK4', 'I73C', 4043, 110);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L93MGP1', 'J16U', 7620, 269);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H97VDX7', 'U46T', 4906, 216);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U74SXB3', 'K48U', 3384, 86);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G11VZO9', 'A32S', 7087, 134);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q67HRJ6', 'H15H', 9041, 215);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C53IZV8', 'L38L', 8082, 222);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X53GOU3', 'W92W', 8464, 195);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('E98UZQ7', 'U50B', 3473, 295);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B70VVO6', 'Q00A', 8983, 137);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K29MTU2', 'V10W', 3870, 243);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J79SKR7', 'V50W', 8457, 108);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V26SKR5', 'F80J', 3526, 244);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S23BLK1', 'F90Z', 7806, 195);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X15JBF8', 'Y86L', 8759, 170);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R55XVR4', 'D41L', 9593, 218);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F47NYN6', 'X32A', 7575, 239);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('I49SSE8', 'W81F', 3351, 145);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L84DFQ2', 'Y08X', 3027, 138);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q27IIP1', 'K50X', 6206, 227);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J39DDO0', 'O14N', 5562, 142);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F26LSK7', 'Q78Q', 3593, 286);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('S98LOC1', 'H57Y', 7296, 234);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K57JIA2', 'R86W', 5882, 125);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('D11CFY6', 'V47V', 5776, 258);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q83GRK1', 'E86H', 3252, 266);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('I13ABP5', 'V68Q', 7855, 100);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H12QIE8', 'N22Y', 4694, 232);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L20BHD1', 'T17D', 8947, 148);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C35IXL6', 'Z99I', 3473, 143);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U47UID1', 'I09D', 3855, 193);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M13XWS0', 'A97F', 8608, 153);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J64LND6', 'C01H', 5977, 139);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F30LVH8', 'J95D', 5745, 135);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('O58SIC0', 'S54D', 9748, 268);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R04EHB7', 'S64V', 8417, 209);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('O63EKD1', 'S26R', 8496, 188);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H07SZM9', 'I39G', 8667, 280);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J84FFX3', 'I39W', 8720, 192);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W92ZPS1', 'I74X', 8049, 95);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('A90LJY5', 'F73T', 8009, 158);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U92VNM2', 'B88S', 3433, 217);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U51DRU1', 'D02I', 6284, 219);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T30JSI4', 'R87C', 8456, 229);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H48XIS9', 'L20B', 4571, 174);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V43CRH5', 'Q49G', 4438, 147);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('P88AJU4', 'H95L', 4196, 179);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J98MVA2', 'A16H', 5538, 171);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H56ZWQ1', 'M52N', 7665, 298);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G68GGM7', 'D84V', 6726, 144);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('D84RNK2', 'T03E', 7085, 223);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q33KPW8', 'N93C', 6250, 206);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('E36FUS5', 'K23S', 9848, 268);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R68VCV9', 'M39U', 9008, 204);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q22BBX9', 'A87U', 9824, 131);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('A85NFC1', 'O31G', 8074, 263);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J73YVQ5', 'G68M', 3107, 208);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G82TUN9', 'U17G', 8965, 286);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('D49EVN5', 'E45C', 9815, 106);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L30OAB4', 'G50C', 8984, 249);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('E74TWS1', 'I63F', 5662, 250);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B78XYR3', 'C52X', 9723, 205);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G18RVE5', 'X49K', 4679, 114);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W11ROQ2', 'G78T', 4979, 145);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q01GWM5', 'S21Z', 6571, 242);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X17HYT2', 'T40X', 7654, 94);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T18MKW5', 'F39M', 5236, 143);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B48CCB9', 'E83G', 7912, 269);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M25DVJ4', 'L31R', 8346, 273);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H55ZCC0', 'L29V', 5978, 122);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X82IBB5', 'J94A', 6908, 222);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V73RWY0', 'Z83X', 8381, 270);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K95TNO6', 'Q86E', 7907, 245);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('O52YXS5', 'Y45P', 7998, 156);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('N82VEQ5', 'W46L', 9198, 215);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('U41WPL6', 'T75Q', 4474, 149);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T45TCO4', 'D64I', 9518, 236);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R80VKR0', 'L94S', 4829, 179);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B82TEX9', 'X02J', 3801, 255);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R16EBM0', 'H29J', 5238, 233);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('L24TWE0', 'S29T', 3182, 264);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F31IAA6', 'Q35V', 6830, 100);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M85CGE5', 'C20P', 5180, 111);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V12MBR7', 'J16B', 6269, 225);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('B34NUZ0', 'L17E', 8448, 295);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X55TYZ6', 'J40Q', 4872, 195);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q17IUA0', 'M62Y', 3313, 271);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F12JVM8', 'W88G', 8017, 240);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W32SEA4', 'N61O', 6984, 111);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W07UPL6', 'J62D', 6971, 253);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H78UJL2', 'O05J', 9858, 127);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H67LUX8', 'M80Q', 5416, 279);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('J77MLD0', 'P23A', 3768, 116);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K00LZJ6', 'E69M', 3101, 164);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('R34WVX1', 'K10U', 9907, 163);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q96BEG8', 'J89R', 4908, 127);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('M16EYB7', 'O75O', 5576, 162);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('K64UFS0', 'C00N', 6418, 282);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('D64YVD5', 'F97K', 4285, 221);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('D87CPL0', 'S15D', 3571, 290);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('F91IJK8', 'G81E', 9793, 91);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G05ZCQ0', 'U72U', 9157, 245);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('V76FXO4', 'V48O', 5200, 87);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C05QDP0', 'O21O', 9570, 122);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W51OFC9', 'N55N', 7410, 237);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('N76TFG7', 'I90G', 6651, 265);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q30PKY8', 'G98U', 3930, 143);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X31HJI1', 'M14M', 4322, 295);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C10FWL0', 'M78T', 5497, 81);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('C04CPQ3', 'G68A', 9121, 113);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('G61HNN8', 'J56Z', 5083, 184);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('T96YGJ0', 'O49K', 8336, 106);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('H20KLJ7', 'M46H', 6231, 152);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('Q38TUZ6', 'O88O', 6906, 248);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('W21BWK4', 'P36M', 6780, 137);
insert into AVION (idavion, modelo, cargamax, numplazas) values ('X57HOA7', 'A08N', 9852, 101);


insert into AEROLINEA (idaerolinea, nombre) values ('714865CS', 'Titan Airways');
insert into AEROLINEA (idaerolinea, nombre) values ('589150XS', 'Tradewind Aviation');
insert into AEROLINEA (idaerolinea, nombre) values ('119580OE', 'Comlux Aviation, AG');
insert into AEROLINEA (idaerolinea, nombre) values ('547200VZ', 'Master Top Linhas Aereas Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('010971CX', 'Flair Airlines Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('102094JX', 'Swift Air, LLC');
insert into AEROLINEA (idaerolinea, nombre) values ('354442ZT', 'DCA');
insert into AEROLINEA (idaerolinea, nombre) values ('339196KC', 'ACM AIR CHARTER GmbH');
insert into AEROLINEA (idaerolinea, nombre) values ('546015WF', 'Inter Island Airways, d/b/a Inter Island Air');
insert into AEROLINEA (idaerolinea, nombre) values ('219644RI', 'Polar Airlines de Mexico d/b/a Nova Air');
insert into AEROLINEA (idaerolinea, nombre) values ('779122PO', 'JetClub AG');
insert into AEROLINEA (idaerolinea, nombre) values ('363449XI', 'Vision Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('487198JH', 'Metropix UK, LLP.');
insert into AEROLINEA (idaerolinea, nombre) values ('563885ZU', 'Multi-Aero, Inc. d/b/a Air Choice One');
insert into AEROLINEA (idaerolinea, nombre) values ('600128KO', 'Open Skies');
insert into AEROLINEA (idaerolinea, nombre) values ('928416XS', 'Flying Service N.V.');
insert into AEROLINEA (idaerolinea, nombre) values ('239642CD', 'TAG Aviation (UK) Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('879368RO', 'TAG Aviation Espana S.L.');
insert into AEROLINEA (idaerolinea, nombre) values ('987736SZ', 'Corporatejets, XXI');
insert into AEROLINEA (idaerolinea, nombre) values ('000084VF', 'Comlux Malta, Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('772649NE', 'Ocean Sky (UK) Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('796356CT', 'Avjet Corporation');
insert into AEROLINEA (idaerolinea, nombre) values ('710901RB', 'Comlux Malta Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('303407PW', 'Swiss Air Ambulance');
insert into AEROLINEA (idaerolinea, nombre) values ('560227DX', 'Unijet');
insert into AEROLINEA (idaerolinea, nombre) values ('914945PH', 'Chartright Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('635301DN', 'London Air Services Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('878357UM', 'Air Alsie A/S');
insert into AEROLINEA (idaerolinea, nombre) values ('867551UX', 'PSA Airlines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('806868HF', 'Piedmont Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('513577KN', 'Albinati Aeronautics SA');
insert into AEROLINEA (idaerolinea, nombre) values ('275811UE', 'Charter Air Transport, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('689920JG', 'Dynamic Airways, LLC');
insert into AEROLINEA (idaerolinea, nombre) values ('022668HB', 'Island Airlines LLC');
insert into AEROLINEA (idaerolinea, nombre) values ('835232XV', 'KaiserAir, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('499965AZ', 'Alsek Air');
insert into AEROLINEA (idaerolinea, nombre) values ('971221TV', 'International Jet Management GmbH');
insert into AEROLINEA (idaerolinea, nombre) values ('002540TX', 'Sky Trek International Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('520392WQ', 'Jet link AG');
insert into AEROLINEA (idaerolinea, nombre) values ('602847ZC', 'Exec Direct Aviation Services Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('016703PP', 'Bertelsmann Aviation GmbH');
insert into AEROLINEA (idaerolinea, nombre) values ('598007JL', 'Twin Cities Air Service LLC');
insert into AEROLINEA (idaerolinea, nombre) values ('220757HI', 'JSC The 224th Flight Unit State Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('953797GS', 'Makani Kai Air Charters');
insert into AEROLINEA (idaerolinea, nombre) values ('476861WC', 'City Wings Inc dba Seaflight');
insert into AEROLINEA (idaerolinea, nombre) values ('795320MM', 'Sun Air Express LLC dba Sun Air International');
insert into AEROLINEA (idaerolinea, nombre) values ('574306YW', 'Star Marianas Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('743508AR', 'Rhoades Aviation dba Transair');
insert into AEROLINEA (idaerolinea, nombre) values ('923205VG', 'Gainjet Aviation SA');
insert into AEROLINEA (idaerolinea, nombre) values ('313618HP', 'Scott Air LLC dba Island Air Express');
insert into AEROLINEA (idaerolinea, nombre) values ('776292ZE', 'Ultimate JetCharters LLC dba Ultimate Air Shuttle');
insert into AEROLINEA (idaerolinea, nombre) values ('009830VM', 'Dassault Falcon Service');
insert into AEROLINEA (idaerolinea, nombre) values ('018245JV', 'Smokey Bay Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('374336OU', 'Frontier Flying Service');
insert into AEROLINEA (idaerolinea, nombre) values ('942793IS', 'Aerolineas Galapagos S A Aerogal');
insert into AEROLINEA (idaerolinea, nombre) values ('866931YZ', 'Midway Express Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('035450RF', 'Island Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('688809MA', 'Regal Air');
insert into AEROLINEA (idaerolinea, nombre) values ('859629WQ', 'Canada 3000 Airlines Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('370772GJ', 'Valley Air Express Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('859412OQ', 'Zeal 320');
insert into AEROLINEA (idaerolinea, nombre) values ('750357QM', 'Regions Air, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('154046AU', 'Pacific Airways, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('053435VB', 'Silver Airways');
insert into AEROLINEA (idaerolinea, nombre) values ('273833PZ', 'AeroLogic GmbH');
insert into AEROLINEA (idaerolinea, nombre) values ('185764FY', 'Sichuan Airlines Co Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('629765JD', 'Boutique Air');
insert into AEROLINEA (idaerolinea, nombre) values ('194723PN', 'Olson Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('022480GF', 'Aerovias de Intergracian Regional');
insert into AEROLINEA (idaerolinea, nombre) values ('594043US', 'Tanana Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('204291DT', 'British Airtours Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('030828ET', 'Belize Trans Air');
insert into AEROLINEA (idaerolinea, nombre) values ('899781CS', 'LAN Argentina');
insert into AEROLINEA (idaerolinea, nombre) values ('079607IP', 'Lan Dominica');
insert into AEROLINEA (idaerolinea, nombre) values ('356775OU', 'Air North');
insert into AEROLINEA (idaerolinea, nombre) values ('758792MS', 'ABC Aerolineas SA de CV dba Interjet');
insert into AEROLINEA (idaerolinea, nombre) values ('299171RZ', 'Regent Air Corporation');
insert into AEROLINEA (idaerolinea, nombre) values ('552824UW', 'Sol Air (Aero Hunduras)');
insert into AEROLINEA (idaerolinea, nombre) values ('464684AY', 'Conner Air Lines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('291542XG', 'Belair Airlines Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('712452GP', 'Warbelow');
insert into AEROLINEA (idaerolinea, nombre) values ('464653IR', 'Yute Air Aka Flight Alaska');
insert into AEROLINEA (idaerolinea, nombre) values ('959088YH', 'Bellair Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('965932UQ', 'C.A.L Cargo Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('048580VQ', 'Aerolitoral');
insert into AEROLINEA (idaerolinea, nombre) values ('025761EB', 'Arctic Circle Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('077098AD', 'Skyservice Airlines, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('959904UU', 'Queen Air');
insert into AEROLINEA (idaerolinea, nombre) values ('312045UV', 'Private Jet Expeditions');
insert into AEROLINEA (idaerolinea, nombre) values ('042776KQ', 'Aerosur');
insert into AEROLINEA (idaerolinea, nombre) values ('863901QK', 'Tatonduk Outfitters Limited d/b/a Everts Air Alaska and Everts Air Cargo');
insert into AEROLINEA (idaerolinea, nombre) values ('550362DS', 'United Parcel Service');
insert into AEROLINEA (idaerolinea, nombre) values ('163470EV', 'Atlas Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('910580WQ', 'Aviacsa Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('739401AE', 'TUIfly Nordic A.B.');
insert into AEROLINEA (idaerolinea, nombre) values ('125847VQ', 'Cape Smythe Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('520451SX', 'Laker Airways Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('665913WM', 'Israir Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('736639DX', 'Pacific East Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('676821LN', 'Aerounion Aerotransporte de Carga Union SA de CV');
insert into AEROLINEA (idaerolinea, nombre) values ('157632ZH', 'Air Ukraine');
insert into AEROLINEA (idaerolinea, nombre) values ('618368PU', 'Nicaraguense De Aviacion Sa');
insert into AEROLINEA (idaerolinea, nombre) values ('020332BL', 'Krasair');
insert into AEROLINEA (idaerolinea, nombre) values ('858858RY', 'Jeju Air Co Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('126325AB', 'First Air');
insert into AEROLINEA (idaerolinea, nombre) values ('542354MN', 'MK Airlines Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('483813MB', 'Bellair Inc. (1)');
insert into AEROLINEA (idaerolinea, nombre) values ('008348BE', 'Era Aviation');
insert into AEROLINEA (idaerolinea, nombre) values ('682061KM', 'Insel Air International B V');
insert into AEROLINEA (idaerolinea, nombre) values ('495365PE', 'Aeromonterrey S.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('796989PJ', 'Inland Aviation Services');
insert into AEROLINEA (idaerolinea, nombre) values ('720698EK', 'Apa International Air S.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('920101ZR', 'Pan American World Airways Dominicana');
insert into AEROLINEA (idaerolinea, nombre) values ('420191XF', 'Arctic Transportation');
insert into AEROLINEA (idaerolinea, nombre) values ('066084LH', 'Skystar International Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('792946FE', 'Lb Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('553124PW', 'Air Transport International');
insert into AEROLINEA (idaerolinea, nombre) values ('282668IB', 'Servant Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('529891ZW', 'Bering Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('274588DV', 'Wilburs Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('465887VX', 'Jetall Airways');
insert into AEROLINEA (idaerolinea, nombre) values ('492828IH', 'Servicio Aereo Leo Lopez');
insert into AEROLINEA (idaerolinea, nombre) values ('672876CP', 'Flagship Airlines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('364595KW', 'Baker Aviation Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('497344UK', 'Edelweiss Air Ag');
insert into AEROLINEA (idaerolinea, nombre) values ('774177ZB', 'Wright Air Service');
insert into AEROLINEA (idaerolinea, nombre) values ('248505WE', 'Endeavor Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('258449QS', 'Pacific Island Aviation');
insert into AEROLINEA (idaerolinea, nombre) values ('263717CV', 'Cape Air');
insert into AEROLINEA (idaerolinea, nombre) values ('344494RZ', 'Colgan Air');
insert into AEROLINEA (idaerolinea, nombre) values ('075996AE', 'Central Mountain Air');
insert into AEROLINEA (idaerolinea, nombre) values ('368503AB', 'ANA & JP Express Co. Ltd.');
insert into AEROLINEA (idaerolinea, nombre) values ('273143QN', 'Flagship Express Services');
insert into AEROLINEA (idaerolinea, nombre) values ('494055WE', 'Southern Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('819685IH', 'TravelspanGT, Inc. S.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('546564OU', 'Avior Airlines, C.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('450839JZ', 'Jet Airways (India) Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('406210HE', 'Elysair d/b/a L''Avion');
insert into AEROLINEA (idaerolinea, nombre) values ('692308PP', 'Cielos De Peru');
insert into AEROLINEA (idaerolinea, nombre) values ('277156EI', 'Southern Wind Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('699036TZ', 'Air Comet S.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('871709HX', 'Air 21');
insert into AEROLINEA (idaerolinea, nombre) values ('080131CS', 'American Airlines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('945383RK', 'Associated Aviation Act.');
insert into AEROLINEA (idaerolinea, nombre) values ('141207TH', 'Antilles Air Boats Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('816069KH', 'AAA Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('135662ZD', 'Audi Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('385720VY', 'Argosy Air Lines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('065620QO', 'Armstrong Air Service Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('280958MN', 'Advance Air Charters');
insert into AEROLINEA (idaerolinea, nombre) values ('718362IS', 'Altair Airlines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('240418QS', 'Air Sunshine Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('092546ZI', 'Alpine Air');
insert into AEROLINEA (idaerolinea, nombre) values ('860365NF', 'Alaska Aeronautical Indust.');
insert into AEROLINEA (idaerolinea, nombre) values ('651369JK', 'Air Berlin PLC and CO');
insert into AEROLINEA (idaerolinea, nombre) values ('222409UH', 'Air Bahia');
insert into AEROLINEA (idaerolinea, nombre) values ('709709IU', 'Airbama Incorporated');
insert into AEROLINEA (idaerolinea, nombre) values ('181086QG', 'Aeronaves Boringuena Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('068849AS', 'ABX Air, Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('277173IO', 'Air Canada');
insert into AEROLINEA (idaerolinea, nombre) values ('967969NP', 'Alaska Central Airways Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('194104GZ', 'Academy Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('530977FV', 'Air Cargo Express Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('386008HE', 'Island Airlines Hawaii Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('621095AU', 'AAA-Action Air Carrier Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('624081LW', 'Atlantic Coast Jet Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('637556BG', 'Air Central Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('153553II', 'Check-Air Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('330180LF', 'Alliance Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('861404GP', 'Air Cargo Enterprises Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('705089WW', 'Air Chaparral Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('979059OQ', 'Aeronautica De Cancun');
insert into AEROLINEA (idaerolinea, nombre) values ('158864AA', 'Alamo Commuter Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('480033CB', 'Air Central Inc. (1)');
insert into AEROLINEA (idaerolinea, nombre) values ('987997SY', 'Transwest Air Express');
insert into AEROLINEA (idaerolinea, nombre) values ('714264ZT', 'Avia Leasing Company');
insert into AEROLINEA (idaerolinea, nombre) values ('895484KK', 'Antonov Company');
insert into AEROLINEA (idaerolinea, nombre) values ('177659BU', 'Aeronaves Del Peru');
insert into AEROLINEA (idaerolinea, nombre) values ('137458NF', 'Adirondack Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('110666YH', 'Advantage Airlines');
insert into AEROLINEA (idaerolinea, nombre) values ('742840AD', 'Air Europe Limited');
insert into AEROLINEA (idaerolinea, nombre) values ('466764DM', 'Astec Air East Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('409490EP', 'Air East Of Delaware Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('113465RL', 'Aero Freight');
insert into AEROLINEA (idaerolinea, nombre) values ('862738YY', 'Aero Coach');
insert into AEROLINEA (idaerolinea, nombre) values ('422708HC', 'Air Caravane Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('632789HO', 'Air Excursions LLC (1)');
insert into AEROLINEA (idaerolinea, nombre) values ('442699XU', 'Compagnie Natl Air France');
insert into AEROLINEA (idaerolinea, nombre) values ('866452YW', 'American Flag Airlines Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('188566ZL', 'Air Florida Express');
insert into AEROLINEA (idaerolinea, nombre) values ('588695MA', 'American Flight Group');
insert into AEROLINEA (idaerolinea, nombre) values ('867895XE', 'Aero B Venezuela C.A.');
insert into AEROLINEA (idaerolinea, nombre) values ('371254UZ', 'Arcata Flying Service');
insert into AEROLINEA (idaerolinea, nombre) values ('308844BC', 'Air Cargo America Inc.');
insert into AEROLINEA (idaerolinea, nombre) values ('865182CT', 'Argo S. A.');
insert into AEROLINEA (idaerolinea, nombre) values ('842521PL', 'Air Alpha');
insert into AEROLINEA (idaerolinea, nombre) values ('853591LN', 'Air Hawaii');
insert into AEROLINEA (idaerolinea, nombre) values ('903609RC', 'Air National');
insert into AEROLINEA (idaerolinea, nombre) values ('829960JO', 'National Aviation Company of India Limited d/b/a Air India');
insert into AEROLINEA (idaerolinea, nombre) values ('903097DQ', 'All Island Air');


insert into PISTA (numpista, longitud) values (1, 143);
insert into PISTA (numpista, longitud) values (2, 397);
insert into PISTA (numpista, longitud) values (3, 505);
insert into PISTA (numpista, longitud) values (4, 443);
insert into PISTA (numpista, longitud) values (5, 14);
insert into PISTA (numpista, longitud) values (6, 223);
insert into PISTA (numpista, longitud) values (7, 372);
insert into PISTA (numpista, longitud) values (8, 449);
insert into PISTA (numpista, longitud) values (9, 250);
insert into PISTA (numpista, longitud) values (10, 335);
insert into PISTA (numpista, longitud) values (11, 384);
insert into PISTA (numpista, longitud) values (12, 277);


insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TRQ5', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NWM2', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('IJD4', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZAK1', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EAN0', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XQY7', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CNL0', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CRE6', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LCJ6', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RHH0', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WZY0', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JFZ9', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('APZ4', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VBN6', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('BEK0', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('AYB3', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VPL8', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LMI3', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SJY5', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UVC1', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UEW1', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CDH7', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UNZ5', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZVM4', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WMZ0', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CUZ8', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('PRJ3', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MVL0', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RCZ5', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RIX2', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TAC7', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NZI6', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QCF2', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZCB8', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UFM4', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('AVG2', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VYS6', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('PGO5', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HMR7', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XGF5', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WYD5', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JBY9', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HGQ8', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EEF2', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UYZ2', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SOE0', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ETF8', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NEJ5', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XVQ4', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MPR3', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KYZ5', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KNN9', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OBM3', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OAJ0', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MBC7', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QNF7', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZJZ2', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EQZ0', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DOQ7', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('PGX1', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HAY6', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HQC8', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KAQ1', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DOI3', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('GCT5', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WHM7', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ODD6', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LQQ7', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TAE5', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XKX3', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EJB0', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OTQ6', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TFF0', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DWP7', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('GZX9', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UCZ4', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MQX6', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HSS3', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EXR2', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TWT6', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JKU9', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('GAO6', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZCX8', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EBD6', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XNI4', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QHY4', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MGF7', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CTF6', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JJM5', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MII2', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SUE8', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('FED7', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XRZ4', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HVU9', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('COR7', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZJN3', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UDO7', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RVP0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YRG3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('BVR6', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MGO1', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZRO2', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('AYP2', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VFJ8', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KOD4', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SGV3', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YYQ9', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VDI3', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CME9', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SQD0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MJU8', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MQW6', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LVW9', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('IFD9', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LEA3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DQJ0', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WRJ3', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LXB6', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ARA0', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NVJ2', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LHE0', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VNJ4', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DJL8', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EWK2', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OOE1', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HJK6', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QDV1', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TAH6', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XES2', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NSH9', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YUD3', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HEB0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XHE0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('GWD5', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TMT0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('FDI9', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JOA4', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MGV4', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UCF1', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OTN3', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RZB9', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('MSJ5', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XFP5', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TPO0', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YFV8', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VOB5', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KIA3', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZJC5', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WDS6', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OEE3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('BRJ8', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YNF4', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OFI8', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('PXN7', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZHT6', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZPS8', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SCA4', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QPN3', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('CGB3', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SOL2', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QDB6', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RML7', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LHD3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('VXQ3', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UPN7', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QON8', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HUM1', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('KCL0', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NLK7', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HHK5', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('HMJ4', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UFI0', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('JOL2', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZAW5', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('NFB1', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('IWB5', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('OLW0', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LML8', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QBE9', 'T-0');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZZQ8', 'T-3');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('IID4', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('GWH7', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SWB8', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QBF8', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('SSB4', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LNC0', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('XYH4', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('LRF3', 'T-5');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EDA3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ZTJ9', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('QXQ2', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('TME1', 'T-2');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('WEV5', 'T-7');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('YPX0', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('RRR3', 'T-1');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('ARR5', 'T-4');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('EUX1', 'T-9');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('DYB4', 'T-8');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('UGC3', 'T-6');
insert into PUERTAEMBARQUE (codpuerta, terminal) values ('BFY2', 'T-1');



insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ATYF08', 'M13XWS0', '440675847X', '113465RL', '2018-08-09 12:20:49', 6, 'WEV5', '2018-08-12 11:20:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DYZX90', 'X15JBF8', '652255744J', '499965AZ', '2019-09-09 10:49:04', 4, 'LVW9', '2019-09-11 15:49:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VJPN65', 'S23BLK1', '328642831P', '466764DM', '2019-11-21 00:14:00', 1, 'APZ4', '2019-11-24 03:14:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OHPA97', 'H13NRI2', '730161442H', '075996AE', '2019-05-02 18:33:03', 12, 'LCJ6', '2019-05-05 03:33:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RAGZ69', 'O58SIC0', '496672729C', '313618HP', '2019-08-11 19:20:00', 1, 'BEK0', '2019-08-12 22:20:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ENBH08', 'H55ZCC0', '523679322Y', '194104GZ', '2020-05-12 15:12:26', 12, 'QXQ2', '2020-05-15 23:12:26');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LIVI96', 'C05QDP0', '655221458F', '313618HP', '2016-09-16 18:16:01', 5, 'HGQ8', '2016-09-20 12:16:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YDUS17', 'E55SSY1', '035152296U', '239642CD', '2019-03-20 10:27:50', 12, 'MBC7', '2019-03-23 18:27:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SYFL31', 'H97BFG6', '983554010X', '867551UX', '2020-12-14 23:40:30', 3, 'TMT0', '2020-12-17 16:40:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NHFN54', 'V17AZH2', '594455502K', '796356CT', '2017-08-19 19:18:53', 12, 'XYH4', '2017-08-24 02:18:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WIBT45', 'J21NIJ6', '918200695H', '163470EV', '2018-02-02 05:57:13', 9, 'MGO1', '2018-02-05 10:57:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LQER89', 'U47UID1', '276116728D', '600128KO', '2020-07-11 05:27:22', 9, 'TAH6', '2020-07-15 17:27:22');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RCTR34', 'J73YVQ5', '521323832D', '621095AU', '2019-09-11 00:35:40', 10, 'UEW1', '2019-09-14 02:35:40');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DFRY94', 'W92ZPS1', '322697703G', '042776KQ', '2020-05-19 14:09:51', 3, 'WDS6', '2020-05-22 12:09:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QPOI93', 'O91XPE6', '990783493P', '743508AR', '2017-04-22 10:06:58', 3, 'JBY9', '2017-04-26 13:06:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CHRA62', 'C97HLK7', '151242685J', '959088YH', '2016-07-20 03:52:21', 1, 'QPN3', '2016-07-24 13:52:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YFZL10', 'H80SLM1', '290219372U', '547200VZ', '2020-10-04 05:11:26', 9, 'WYD5', '2020-10-08 03:11:26');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LXAJ19', 'L59AYE1', '576920130N', '194723PN', '2018-10-12 09:30:39', 5, 'MSJ5', '2018-10-14 10:30:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XJIJ86', 'Q17IUA0', '957499350R', '240418QS', '2016-08-07 11:02:01', 3, 'MQX6', '2016-08-11 04:02:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UOVP34', 'K95TNO6', '964805039P', '356775OU', '2019-06-23 17:00:53', 10, 'NVJ2', '2019-06-24 21:00:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JBRQ29', 'R16EBM0', '576920130N', '965932UQ', '2018-02-15 18:37:56', 9, 'EBD6', '2018-02-19 18:37:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DKYT41', 'H13NRI2', '163092377N', '312045UV', '2016-01-04 20:52:18', 1, 'ZHT6', '2016-01-06 21:52:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EQYL80', 'X11HFI9', '957499350R', '520451SX', '2019-01-15 21:33:44', 8, 'UPN7', '2019-01-18 13:33:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VMWP80', 'W92ZPS1', '171568970U', '676821LN', '2018-10-12 04:19:21', 9, 'SQD0', '2018-10-15 10:19:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MYOS45', 'K41BKH6', '303120368A', '739401AE', '2017-04-02 22:11:55', 8, 'ZPS8', '2017-04-07 19:11:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RBOW00', 'K95TNO6', '277376266P', '866452YW', '2019-03-29 00:21:50', 7, 'EEF2', '2019-03-31 21:21:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MSOL82', 'I13ABP5', '233461298A', '025761EB', '2018-06-01 10:35:15', 12, 'MVL0', '2018-06-06 03:35:15');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MSAG13', 'G05ZCQ0', '184113114O', '829960JO', '2018-04-18 02:01:37', 6, 'TWT6', '2018-04-19 07:01:37');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CFDY17', 'X57HOA7', '229633655Y', '520451SX', '2019-11-01 02:54:09', 10, 'BVR6', '2019-11-06 00:54:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RZZR30', 'F47NYN6', '079537565Z', '025761EB', '2017-08-22 17:19:08', 7, 'MPR3', '2017-08-25 06:19:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UBSH06', 'K68EGA4', '163092377N', '141207TH', '2016-09-12 01:57:41', 2, 'BEK0', '2016-09-15 01:57:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GKLW48', 'H97VDX7', '903044670E', '796356CT', '2019-05-03 22:22:28', 4, 'DJL8', '2019-05-07 04:22:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CRFX33', 'N74ULY4', '206054009Y', '920101ZR', '2018-02-19 05:53:55', 7, 'ZRO2', '2018-02-20 07:53:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OGQI63', 'T30JSI4', '634532858H', '248505WE', '2017-07-31 10:28:45', 10, 'QON8', '2017-08-03 20:28:45');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TFYD64', 'H20KLJ7', '523679322Y', '867551UX', '2017-03-08 07:41:06', 1, 'SSB4', '2017-03-10 17:41:06');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EPDS39', 'H67LUX8', '086459294O', '520451SX', '2020-09-19 15:49:23', 10, 'RHH0', '2020-09-23 11:49:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QRFV95', 'H56ZWQ1', '810451330U', '273143QN', '2017-07-14 18:19:35', 11, 'CNL0', '2017-07-17 02:19:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FEWP24', 'A85NFC1', '675554791Q', '282668IB', '2020-03-28 07:23:58', 9, 'VFJ8', '2020-03-29 14:23:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HYKO22', 'M17QYG8', '048090125S', '406210HE', '2018-02-14 20:27:39', 11, 'SGV3', '2018-02-19 05:27:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JMJW04', 'G11VZO9', '696567274U', '866931YZ', '2019-01-16 22:16:02', 5, 'GZX9', '2019-01-21 18:16:02');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FSIO41', 'M85CGE5', '588280500B', '867895XE', '2018-05-16 01:03:32', 9, 'VFJ8', '2018-05-20 01:03:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ORZZ26', 'T41HPF1', '810451330U', '942793IS', '2020-05-01 21:38:24', 6, 'LEA3', '2020-05-05 09:38:24');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AGLS23', 'M85CGE5', '623088424M', '866931YZ', '2016-07-16 22:50:35', 7, 'EBD6', '2016-07-20 02:50:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QMES51', 'G68GGM7', '839939902W', '487198JH', '2019-04-16 10:59:29', 3, 'NFB1', '2019-04-20 00:59:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZXWK14', 'U51DRU1', '270438704N', '258449QS', '2018-06-26 10:21:35', 5, 'TMT0', '2018-06-28 04:21:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZXOY75', 'O63EKD1', '086459294O', '971221TV', '2017-06-15 19:02:15', 4, 'ZAK1', '2017-06-20 15:02:15');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BJFP92', 'L20BHD1', '328642831P', '871709HX', '2017-08-05 20:07:09', 5, 'XGF5', '2017-08-07 01:07:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RJDX79', 'W61YHV1', '322697703G', '299171RZ', '2020-08-29 22:32:07', 2, 'RVP0', '2020-09-01 02:32:07');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ACRF16', 'A90LJY5', '398247344W', '181086QG', '2016-04-18 23:08:14', 8, 'WZY0', '2016-04-23 17:08:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IDBR63', 'K29MTU2', '551550218D', '092546ZI', '2019-01-18 18:05:46', 4, 'OBM3', '2019-01-22 13:05:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EZOD19', 'X31HJI1', '774287974Y', '672876CP', '2018-08-19 20:27:15', 12, 'QPN3', '2018-08-23 03:27:15');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FFDL03', 'V17AZH2', '263548523R', '624081LW', '2020-12-06 11:54:33', 3, 'IID4', '2020-12-08 19:54:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NTQK27', 'E98UZQ7', '177510534I', '480033CB', '2017-11-01 00:36:06', 7, 'BEK0', '2017-11-05 15:36:06');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BBKM54', 'R16EBM0', '731482551S', '065620QO', '2019-11-23 01:49:48', 9, 'TAE5', '2019-11-27 12:49:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VYZZ71', 'H12QIE8', '202830989B', '025761EB', '2018-08-17 14:28:42', 11, 'KOD4', '2018-08-19 10:28:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FMIM89', 'M85CGE5', '082373576M', '368503AB', '2016-02-09 19:46:35', 8, 'ARR5', '2016-02-10 21:46:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YUBX74', 'E64UXI3', '994877626G', '859629WQ', '2016-09-21 21:39:46', 4, 'LVW9', '2016-09-26 20:39:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YNOG42', 'C35IXL6', '227422941T', '689920JG', '2018-09-30 22:07:27', 10, 'XQY7', '2018-10-01 23:07:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LEJC58', 'G82TUN9', '409687108W', '480033CB', '2017-06-25 20:08:54', 11, 'MQW6', '2017-06-30 08:08:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZFUA60', 'X82IBB5', '999017599B', '185764FY', '2020-05-16 09:45:33', 2, 'LCJ6', '2020-05-20 13:45:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WGSB43', 'J06SGB8', '597028905A', '945383RK', '2018-07-07 14:38:38', 8, 'OTQ6', '2018-07-08 14:38:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SJHN46', 'H12QIE8', '398247344W', '710901RB', '2017-01-17 03:55:29', 12, 'TRQ5', '2017-01-20 21:55:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ADXQ41', 'L65GFX9', '803158842X', '158864AA', '2017-04-19 22:50:57', 1, 'BRJ8', '2017-04-24 15:50:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CWUO79', 'J06SGB8', '504869441H', '239642CD', '2017-02-07 20:46:23', 5, 'KCL0', '2017-02-09 13:46:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BKMQ49', 'H48XIS9', '263548523R', '530977FV', '2016-12-15 17:26:41', 10, 'ZVM4', '2016-12-16 19:26:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VKVA87', 'U95XJO7', '542366704S', '895484KK', '2018-08-23 04:39:47', 12, 'ZRO2', '2018-08-25 03:39:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BIII35', 'G68GGM7', '934567502P', '053435VB', '2019-07-18 11:53:37', 3, 'QBF8', '2019-07-22 20:53:37');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EIJM45', 'G18RVE5', '480133586U', '560227DX', '2020-04-30 11:58:30', 10, 'HEB0', '2020-05-04 13:58:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UGLJ78', 'Y58SLX0', '134797672A', '386008HE', '2019-02-13 08:33:09', 5, 'GWH7', '2019-02-15 23:33:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VGTY59', 'M13XWS0', '499777409Q', '743508AR', '2018-05-04 17:11:44', 6, 'RHH0', '2018-05-09 17:11:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WFEB86', 'F47NYN6', '171568970U', '239642CD', '2019-05-23 02:55:35', 12, 'OEE3', '2019-05-26 11:55:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HVKH04', 'A85NFC1', '900131706L', '280958MN', '2016-10-30 09:17:00', 5, 'GAO6', '2016-11-02 23:17:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DIGA57', 'G68GGM7', '145903714D', '806868HF', '2018-09-01 00:15:44', 4, 'CGB3', '2018-09-04 17:15:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MXFT47', 'F64DNC3', '643538765O', '720698EK', '2020-10-31 21:29:20', 8, 'UGC3', '2020-11-02 06:29:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UHQY43', 'S61DYT2', '627260389P', '720698EK', '2016-07-22 03:31:18', 12, 'DOQ7', '2016-07-23 08:31:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YLLK55', 'U92VNM2', '991628406D', '967969NP', '2017-12-15 11:14:59', 1, 'DOI3', '2017-12-19 23:14:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GEPY67', 'H67LUX8', '319107657K', '092546ZI', '2017-09-23 19:16:38', 12, 'EJB0', '2017-09-28 16:16:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZYDW53', 'J77MLD0', '536205627Z', '835232XV', '2020-06-21 19:11:29', 2, 'JFZ9', '2020-06-25 19:11:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KKXL78', 'Y96GZC0', '811893336T', '553124PW', '2016-01-06 14:08:20', 8, 'MGF7', '2016-01-10 06:08:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QEHU12', 'U95XJO7', '934567502P', '497344UK', '2016-09-09 21:04:51', 12, 'ZAK1', '2016-09-14 10:04:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ADSV74', 'R68VCV9', '675554791Q', '742840AD', '2019-12-22 23:49:03', 6, 'OLW0', '2019-12-26 03:49:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UZVS70', 'Q22BBX9', '394738372Y', '008348BE', '2017-06-27 13:59:48', 8, 'VYS6', '2017-06-29 23:59:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JKUJ49', 'K18ETO3', '689737943E', '903609RC', '2019-04-29 02:53:13', 8, 'WMZ0', '2019-05-02 15:53:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OANP50', 'S91EBE7', '516219691M', '928416XS', '2016-02-24 00:50:18', 9, 'ZZQ8', '2016-02-29 00:50:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TDQR49', 'O91XPE6', '627260389P', '553124PW', '2016-03-16 12:42:35', 12, 'SCA4', '2016-03-19 03:42:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YOSP56', 'C26RKD4', '202830989B', '053435VB', '2017-12-03 15:34:34', 5, 'MSJ5', '2017-12-06 19:34:34');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MXKY03', 'R34WVX1', '999017599B', '618368PU', '2017-04-14 12:27:49', 10, 'UVC1', '2017-04-18 21:27:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DCRU94', 'H97BFG6', '811893336T', '971221TV', '2016-06-15 11:38:26', 12, 'BFY2', '2016-06-16 14:38:26');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EPFP33', 'F12JVM8', '373040712T', '330180LF', '2018-02-24 10:01:00', 12, 'XVQ4', '2018-02-26 02:01:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KATU27', 'B34NUZ0', '918200695H', '339196KC', '2018-10-03 07:45:27', 7, 'HUM1', '2018-10-05 20:45:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BZUM50', 'A92MHZ9', '317890290F', '487198JH', '2019-02-01 17:54:33', 12, 'OFI8', '2019-02-03 01:54:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QWTL72', 'R04EHB7', '363383213B', '965932UQ', '2018-04-29 10:10:20', 4, 'UEW1', '2018-04-30 21:10:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IFFE27', 'C97HLK7', '317890290F', '356775OU', '2016-06-20 10:45:54', 6, 'QXQ2', '2016-06-25 05:45:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OSZA17', 'A90LJY5', '226836285R', '157632ZH', '2017-11-20 18:30:21', 7, 'SUE8', '2017-11-24 10:30:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PAYG85', 'L65GFX9', '023284312M', '220757HI', '2018-05-11 22:29:10', 1, 'EQZ0', '2018-05-14 21:29:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ODUX87', 'B48BFZ9', '480133586U', '009830VM', '2016-01-17 05:34:13', 1, 'RIX2', '2016-01-21 10:34:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HMXJ20', 'W21BWK4', '163092377N', '177659BU', '2018-02-16 17:52:19', 7, 'FED7', '2018-02-20 06:52:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DHGQ82', 'D84RNK2', '964805039P', '312045UV', '2019-12-11 16:40:59', 11, 'EJB0', '2019-12-15 04:40:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IQZV46', 'Q38TUZ6', '270438704N', '141207TH', '2018-09-14 01:27:02', 7, 'WEV5', '2018-09-16 21:27:02');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HBAO45', 'U92VNM2', '851881721R', '282668IB', '2020-09-26 17:20:01', 4, 'YUD3', '2020-09-30 14:20:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VYSI09', 'U13RYR3', '292957593C', '194104GZ', '2020-01-17 06:54:00', 9, 'ZHT6', '2020-01-22 04:54:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AYWO22', 'G05ZCQ0', '536205627Z', '860365NF', '2020-04-30 04:33:34', 12, 'UEW1', '2020-05-01 19:33:34');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UHOJ14', 'M13XWS0', '319971554M', '776292ZE', '2019-04-23 08:07:22', 10, 'DWP7', '2019-04-26 22:07:22');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WQZN84', 'W05IFW0', '597028905A', '487198JH', '2016-06-23 09:21:49', 1, 'XVQ4', '2016-06-25 13:21:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WQEE03', 'F91IJK8', '504869441H', '154046AU', '2016-12-30 04:01:21', 6, 'XYH4', '2017-01-01 13:01:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XWIE41', 'T41HPF1', '504869441H', '871709HX', '2017-05-23 09:52:16', 11, 'YNF4', '2017-05-25 15:52:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MKEG41', 'K18ETO3', '689737943E', '529891ZW', '2020-05-02 18:48:29', 11, 'DOQ7', '2020-05-05 08:48:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NUKL03', 'G68GGM7', '634532858H', '971221TV', '2018-10-10 21:47:42', 5, 'MQW6', '2018-10-14 00:47:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LVSK61', 'T96YGJ0', '440675847X', '077098AD', '2020-10-27 00:58:18', 6, 'SCA4', '2020-10-31 22:58:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FTQT44', 'T93GJM5', '430772605B', '022480GF', '2020-03-13 22:48:04', 5, 'JOL2', '2020-03-17 09:48:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EXBI05', 'Q01GWM5', '006126532S', '546564OU', '2020-09-08 12:05:57', 12, 'PGX1', '2020-09-13 00:05:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MHVY57', 'L84DFQ2', '938839845B', '600128KO', '2017-04-06 03:39:03', 10, 'PRJ3', '2017-04-10 02:39:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BWWZ38', 'R78FZR7', '277376266P', '629765JD', '2019-08-12 19:15:44', 3, 'OBM3', '2019-08-15 21:15:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JPKD62', 'T49GOM0', '182718758L', '008348BE', '2019-10-18 18:01:45', 2, 'HHK5', '2019-10-22 02:01:45');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AZRE73', 'R55XVR4', '460719043Q', '899781CS', '2019-04-14 07:49:05', 3, 'ZCB8', '2019-04-16 12:49:05');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IKYG17', 'W21BWK4', '643538765O', '409490EP', '2020-06-15 01:06:20', 12, 'UFI0', '2020-06-19 22:06:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XSCK30', 'K41BKH6', '781293399D', '450839JZ', '2018-06-18 00:37:56', 2, 'CRE6', '2018-06-19 15:37:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BITY64', 'K18ETO3', '994877626G', '092546ZI', '2016-11-24 19:30:42', 8, 'QPN3', '2016-11-26 03:30:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JMOK23', 'C97HLK7', '397196720Y', '080131CS', '2019-06-12 13:12:52', 4, 'SWB8', '2019-06-17 08:12:52');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JPPX34', 'S91EBE7', '588280500B', '113465RL', '2020-02-17 23:28:47', 3, 'ZJN3', '2020-02-21 12:28:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IHMK38', 'G18RVE5', '527676620D', '020332BL', '2016-10-28 20:39:55', 1, 'NLK7', '2016-10-30 02:39:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AWNI10', 'W07UPL6', '320383285B', '406210HE', '2017-07-09 17:21:13', 9, 'HEB0', '2017-07-14 04:21:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DOAW38', 'W05IFW0', '705365019A', '867895XE', '2017-09-01 02:53:04', 8, 'TAH6', '2017-09-04 15:53:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SIQG29', 'X82IBB5', '480133586U', '835232XV', '2017-05-06 18:20:12', 2, 'YNF4', '2017-05-10 11:20:12');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZSFI22', 'Y95SWL3', '845075649U', '494055WE', '2020-03-02 07:13:55', 11, 'YPX0', '2020-03-07 06:13:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QVYE27', 'I49SSE8', '696567274U', '308844BC', '2019-03-13 19:16:24', 1, 'UPN7', '2019-03-15 00:16:24');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GLRK17', 'U74SXB3', '594455502K', '010971CX', '2017-11-06 11:44:30', 8, 'PXN7', '2017-11-07 22:44:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KMPT60', 'M71LZZ0', '134797672A', '053435VB', '2019-02-23 07:42:43', 6, 'ZVM4', '2019-02-26 01:42:43');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JKRA16', 'Q30UIG5', '730161442H', '598007JL', '2017-01-17 09:16:37', 8, 'EAN0', '2017-01-19 14:16:37');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZKUR76', 'R04EHB7', '956032232X', '282668IB', '2017-04-08 17:36:19', 3, 'FED7', '2017-04-13 07:36:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EIUE54', 'J73YVQ5', '409687108W', '714865CS', '2020-07-10 19:21:17', 11, 'CDH7', '2020-07-14 00:21:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RRIU06', 'K57JIA2', '460719043Q', '530977FV', '2016-11-15 05:00:53', 5, 'HHK5', '2016-11-16 17:00:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ARMZ49', 'N58KJE9', '300230488I', '866931YZ', '2017-03-28 15:38:52', 7, 'MII2', '2017-03-30 02:38:52');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ITZR09', 'L20BHD1', '576920130N', '718362IS', '2016-11-15 19:52:55', 11, 'ARA0', '2016-11-17 03:52:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WOYO27', 'H13NRI2', '725030285D', '772649NE', '2016-03-16 06:36:20', 6, 'CME9', '2016-03-20 21:36:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IAOP75', 'B78XYR3', '229633655Y', '563885ZU', '2018-04-25 10:33:46', 1, 'LHD3', '2018-04-27 12:33:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LRNB26', 'R86LCD5', '104581889J', '464684AY', '2016-06-07 20:47:24', 8, 'CTF6', '2016-06-12 04:47:24');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GMLK60', 'Y04FBS8', '270438704N', '689920JG', '2018-02-17 08:04:47', 2, 'LVW9', '2018-02-19 07:04:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DEUU68', 'G68GGM7', '542366704S', '188566ZL', '2017-02-27 10:26:56', 9, 'UCZ4', '2017-03-03 12:26:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NNTL45', 'H56ZWQ1', '134797672A', '835232XV', '2020-10-19 21:52:48', 10, 'IWB5', '2020-10-22 22:52:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZBZL28', 'X26ACJ3', '138092219R', '672876CP', '2020-02-11 19:19:56', 1, 'XFP5', '2020-02-13 11:19:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LTNR44', 'T18MKW5', '177510534I', '239642CD', '2019-07-21 18:22:56', 5, 'GAO6', '2019-07-25 14:22:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TVCQ23', 'L30OAB4', '909240077X', '356775OU', '2019-08-20 02:07:57', 7, 'CUZ8', '2019-08-21 05:07:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SRFF00', 'J39DDO0', '612977845G', '866452YW', '2017-12-28 21:18:41', 10, 'ZCX8', '2017-12-31 20:18:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HRQP99', 'I49SSE8', '971898444G', '409490EP', '2020-06-25 14:05:41', 10, 'MQX6', '2020-06-29 16:05:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CTUZ33', 'R84KRN5', '723870867D', '553124PW', '2018-07-04 00:46:20', 2, 'CRE6', '2018-07-05 22:46:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OKVX23', 'S23BLK1', '104581889J', '363449XI', '2017-02-14 15:48:27', 1, 'ZAW5', '2017-02-16 02:48:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EAWB19', 'X11HFI9', '851881721R', '602847ZC', '2019-04-11 13:25:06', 11, 'COR7', '2019-04-13 21:25:06');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MXMN93', 'X26ACJ3', '430772605B', '016703PP', '2018-09-15 18:39:55', 3, 'ZRO2', '2018-09-18 13:39:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YMZO63', 'V12MBR7', '227422941T', '274588DV', '2020-03-28 22:52:15', 6, 'VNJ4', '2020-04-01 13:52:15');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EHKQ48', 'Y07XOX1', '811893336T', '277173IO', '2019-04-13 15:25:33', 8, 'SCA4', '2019-04-17 05:25:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XOLB07', 'H13NRI2', '043858979X', '476861WC', '2017-06-26 15:43:49', 11, 'PXN7', '2017-06-29 07:43:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NRDY70', 'E64UXI3', '675554791Q', '450839JZ', '2019-02-21 23:51:20', 11, 'WEV5', '2019-02-24 17:51:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JGGE03', 'U92VNM2', '290219372U', '137458NF', '2018-06-27 21:04:30', 1, 'SJY5', '2018-06-28 21:04:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VUTE09', 'J73YVQ5', '138092219R', '979059OQ', '2020-06-30 20:01:13', 12, 'ZHT6', '2020-07-04 17:01:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GESN89', 'R55XVR4', '731482551S', '574306YW', '2017-08-16 17:43:53', 3, 'FED7', '2017-08-21 07:43:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HYDE22', 'I49SSE8', '252056898A', '275811UE', '2018-10-31 16:37:39', 12, 'PGX1', '2018-11-05 03:37:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MFIK33', 'B34NUZ0', '233461298A', '119580OE', '2019-07-20 14:58:23', 7, 'VOB5', '2019-07-24 23:58:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YLXK34', 'X15JBF8', '173374240E', '053435VB', '2019-10-30 00:40:38', 11, 'CDH7', '2019-11-02 14:40:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GLGF25', 'P45NLM6', '646313702P', '871709HX', '2020-06-07 07:48:14', 11, 'KYZ5', '2020-06-08 22:48:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JCYH85', 'F06SSJ7', '149071155B', '113465RL', '2018-01-22 09:47:59', 11, 'ZAK1', '2018-01-26 10:47:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MJZB56', 'Q01GWM5', '817185530N', '739401AE', '2016-06-22 19:37:47', 8, 'ZCX8', '2016-06-26 15:37:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YLNP53', 'I13ABP5', '226836285R', '709709IU', '2018-05-27 10:40:14', 7, 'OTN3', '2018-06-01 08:40:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UABQ51', 'R55XVR4', '964805039P', '923205VG', '2016-04-19 08:57:01', 3, 'HJK6', '2016-04-22 11:57:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SYCX21', 'N76TFG7', '725030285D', '240418QS', '2019-01-27 23:19:12', 6, 'SWB8', '2019-01-29 10:19:12');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RAWG18', 'K68EGA4', '617677484Q', '546015WF', '2017-02-02 14:52:48', 6, 'WZY0', '2017-02-07 08:52:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EMOF11', 'S59UQF4', '241741467J', '867551UX', '2019-04-17 17:40:32', 4, 'MSJ5', '2019-04-18 23:40:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GGFX19', 'U74SXB3', '398247344W', '560227DX', '2020-09-23 18:13:53', 1, 'TRQ5', '2020-09-28 07:13:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FBBQ63', 'I49SSE8', '125684064Y', '795320MM', '2020-08-11 04:19:29', 10, 'VDI3', '2020-08-14 02:19:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VJZY24', 'L30OAB4', '290219372U', '220757HI', '2020-01-26 16:22:19', 11, 'VBN6', '2020-01-28 05:22:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RPAY32', 'U74SXB3', '332548442S', '020332BL', '2016-10-26 09:38:39', 3, 'TWT6', '2016-10-27 18:38:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OLXL90', 'T41HPF1', '938839845B', '239642CD', '2017-12-26 02:24:29', 7, 'HAY6', '2017-12-30 21:24:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WBKB29', 'Q67HRJ6', '030222740E', '464653IR', '2019-10-14 12:15:35', 10, 'TFF0', '2019-10-19 03:15:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NBFY27', 'T18MKW5', '322697703G', '598007JL', '2018-03-16 03:20:51', 6, 'QNF7', '2018-03-19 01:20:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OCOL03', 'O52YXS5', '183822661G', '239642CD', '2018-08-01 23:09:45', 6, 'VPL8', '2018-08-04 07:09:45');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GOWS75', 'T49GOM0', '023284312M', '863901QK', '2016-01-11 03:39:50', 1, 'MBC7', '2016-01-13 17:39:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MBZT21', 'S71WEV4', '675554791Q', '942793IS', '2016-09-19 15:30:22', 8, 'FED7', '2016-09-22 14:30:22');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HBLX99', 'S98LOC1', '597028905A', '867895XE', '2019-08-03 06:56:51', 7, 'NLK7', '2019-08-08 01:56:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EIPH16', 'J69UBL6', '302434222C', '860365NF', '2018-04-01 23:16:16', 11, 'LQQ7', '2018-04-03 01:16:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BKGW49', 'U54NKY1', '105418638V', '102094JX', '2020-09-28 14:00:58', 2, 'QCF2', '2020-10-01 04:00:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OVGL24', 'D84RNK2', '061197808M', '546564OU', '2019-08-12 01:05:15', 4, 'CTF6', '2019-08-14 03:05:15');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YDPO33', 'F12JVM8', '551550218D', '899781CS', '2018-06-25 16:43:08', 5, 'HUM1', '2018-06-28 22:43:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WEGG85', 'F47NYN6', '676522141Z', '546015WF', '2018-11-17 12:36:52', 5, 'WDS6', '2018-11-20 20:36:52');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DLIC43', 'S71WEV4', '440675847X', '368503AB', '2017-01-24 22:02:08', 2, 'ZCB8', '2017-01-29 11:02:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CRGU23', 'Y95SWL3', '297023554G', '552824UW', '2018-04-04 00:13:54', 8, 'CDH7', '2018-04-07 15:13:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CXGG00', 'P88AJU4', '528375746S', '739401AE', '2017-11-11 15:52:58', 9, 'TPO0', '2017-11-15 09:52:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MQYZ25', 'G11VZO9', '634532858H', '487198JH', '2017-07-30 20:49:40', 10, 'HMR7', '2017-08-02 06:49:40');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ORBN65', 'H20KLJ7', '956032232X', '602847ZC', '2016-04-04 12:50:21', 9, 'ZTJ9', '2016-04-08 15:50:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NTCB47', 'X31HJI1', '723870867D', '125847VQ', '2020-02-18 11:40:18', 7, 'CNL0', '2020-02-20 03:40:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JOPH74', 'L93MGP1', '811893336T', '637556BG', '2017-07-18 18:46:28', 7, 'GZX9', '2017-07-19 19:46:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OGPE49', 'F12JVM8', '104581889J', '499965AZ', '2017-10-31 23:25:57', 3, 'LHD3', '2017-11-03 12:25:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ERUX27', 'L65GFX9', '542366704S', '476861WC', '2016-09-02 20:33:10', 4, 'GZX9', '2016-09-06 04:33:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DUYK89', 'G18RVE5', '328642831P', '075996AE', '2017-03-02 10:53:59', 7, 'ARR5', '2017-03-06 16:53:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ORQA55', 'H78UJL2', '086459294O', '967969NP', '2019-08-17 00:49:18', 11, 'UGC3', '2019-08-21 16:49:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FZPT82', 'Y96GZC0', '276290889A', '574306YW', '2016-04-05 09:02:50', 10, 'XRZ4', '2016-04-08 15:02:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZBBC98', 'Z81VGL7', '226836285R', '239642CD', '2018-03-05 07:01:59', 8, 'HEB0', '2018-03-08 05:01:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SSBC99', 'H55ZCC0', '934567502P', '819685IH', '2017-06-10 12:00:56', 1, 'UFI0', '2017-06-12 11:00:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BJPM03', 'K41BKH6', '469624384L', '480033CB', '2020-09-13 23:58:01', 10, 'OEE3', '2020-09-15 17:58:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZNDU93', 'K64UFS0', '321271002N', '464684AY', '2019-12-21 09:30:34', 9, 'JJM5', '2019-12-25 23:30:34');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OBIK89', 'V73RWY0', '282798534O', '204291DT', '2017-09-06 04:15:36', 6, 'QHY4', '2017-09-08 18:15:36');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OMQC41', 'B48BFZ9', '785280662Z', '530977FV', '2020-02-02 22:31:37', 8, 'HHK5', '2020-02-07 02:31:37');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MLKS67', 'A90LJY5', '803158842X', '248505WE', '2019-05-20 19:51:43', 12, 'MII2', '2019-05-23 05:51:43');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FMMO08', 'V26SKR5', '536205627Z', '308844BC', '2018-06-17 09:06:47', 8, 'GWH7', '2018-06-21 02:06:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KEFK08', 'O91XPE6', '063444692F', '153553II', '2018-01-17 19:30:27', 5, 'CGB3', '2018-01-22 04:30:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QIMW93', 'C53IZV8', '068873503K', '048580VQ', '2016-06-27 02:37:24', 2, 'UCZ4', '2016-07-02 02:37:24');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OHAQ81', 'E36FUS5', '672703837G', '313618HP', '2018-06-22 11:25:29', 7, 'RIX2', '2018-06-25 08:25:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DXSW04', 'T45TCO4', '151242685J', '720698EK', '2017-02-24 05:31:41', 7, 'ZAW5', '2017-02-25 12:31:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XCAF34', 'F31IAA6', '409687108W', '867551UX', '2017-12-26 02:04:10', 4, 'GZX9', '2017-12-28 19:04:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IRXQ32', 'T49GOM0', '903044670E', '422708HC', '2019-02-02 14:08:36', 1, 'OAJ0', '2019-02-05 16:08:36');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UHBN56', 'U92VNM2', '469624384L', '077098AD', '2016-07-06 22:56:32', 12, 'QXQ2', '2016-07-11 14:56:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KQIR04', 'F30LVH8', '830347082D', '282668IB', '2017-02-23 00:06:31', 1, 'MBC7', '2017-02-24 11:06:31');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SFPK12', 'Q30UIG5', '003471832Y', '895484KK', '2018-08-24 01:33:33', 9, 'ZHT6', '2018-08-25 04:33:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('GXKL04', 'M85CGE5', '624771266V', '635301DN', '2019-06-08 17:03:48', 11, 'SCA4', '2019-06-10 12:03:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZSLM04', 'Y58SLX0', '409687108W', '277173IO', '2019-07-14 20:47:29', 2, 'UNZ5', '2019-07-19 15:47:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UZOM42', 'J98MVA2', '319107657K', '712452GP', '2016-01-31 15:55:59', 2, 'WDS6', '2016-02-02 23:55:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WLCL47', 'J69UBL6', '157784697Y', '066084LH', '2019-12-07 01:49:33', 7, 'MQW6', '2019-12-10 23:49:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CFOT07', 'Y07XOX1', '430772605B', '154046AU', '2018-08-31 03:05:27', 4, 'HHK5', '2018-09-04 03:05:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HOQA34', 'M13XWS0', '163092377N', '368503AB', '2016-09-25 15:38:31', 6, 'RZB9', '2016-09-29 03:38:31');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IPXR55', 'H07SZM9', '475428439A', '709709IU', '2020-04-21 14:17:01', 8, 'QNF7', '2020-04-25 21:17:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XPEY48', 'H67LUX8', '588280500B', '092546ZI', '2018-04-23 07:21:46', 3, 'ZRO2', '2018-04-26 22:21:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZCWT38', 'W17IWD6', '652255744J', '676821LN', '2017-06-05 19:08:10', 11, 'VPL8', '2017-06-09 20:08:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TIOU71', 'H20KLJ7', '398247344W', '010971CX', '2019-07-05 19:51:18', 7, 'IID4', '2019-07-09 01:51:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QQSF49', 'N82VEQ5', '340236083A', '899781CS', '2019-10-15 04:50:59', 2, 'ZTJ9', '2019-10-18 15:50:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LXQS91', 'T27GXO8', '624771266V', '928416XS', '2018-01-06 22:03:47', 9, 'QHY4', '2018-01-11 14:03:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IFDQ08', 'G61HNN8', '051795419G', '513577KN', '2018-10-26 09:51:57', 9, 'RVP0', '2018-10-29 08:51:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AVWK23', 'B34NUZ0', '956032232X', '258449QS', '2017-12-07 22:20:51', 1, 'MVL0', '2017-12-10 11:20:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MWNE39', 'C26RKD4', '376082483V', '194104GZ', '2018-11-03 04:41:22', 2, 'YUD3', '2018-11-04 14:41:22');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MITB38', 'O58SIC0', '398247344W', '710901RB', '2018-08-27 20:47:38', 5, 'SUE8', '2018-08-29 02:47:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RMFE37', 'C53IZV8', '043858979X', '600128KO', '2016-11-26 12:01:51', 12, 'NEJ5', '2016-12-01 00:01:51');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VHLA57', 'P63QQK8', '549007318J', '859629WQ', '2017-01-28 14:48:30', 11, 'GWD5', '2017-02-01 16:48:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VCJZ68', 'F31IAA6', '744180337H', '942793IS', '2016-03-02 01:17:25', 2, 'KNN9', '2016-03-04 12:17:25');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LWAF61', 'H56ZWQ1', '959017408E', '409490EP', '2016-07-06 11:33:29', 7, 'PXN7', '2016-07-10 04:33:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JFPO00', 'K41BKH6', '277376266P', '409490EP', '2016-01-14 20:32:41', 3, 'SWB8', '2016-01-17 07:32:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EXUZ88', 'T45TCO4', '693687383B', '618368PU', '2016-05-05 05:24:20', 6, 'HQC8', '2016-05-09 12:24:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JNXW98', 'X82IBB5', '460719043Q', '910580WQ', '2019-12-28 01:38:48', 2, 'PGX1', '2019-12-31 23:38:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AVAF45', 'Q05AWW6', '999017599B', '181086QG', '2016-05-18 05:09:02', 10, 'RVP0', '2016-05-19 18:09:02');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IFJY90', 'Q67HRJ6', '241741467J', '020332BL', '2017-04-26 21:05:23', 3, 'VNJ4', '2017-05-01 15:05:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TEGJ22', 'G11VZO9', '614756497L', '736639DX', '2018-12-23 07:36:17', 8, 'GWD5', '2018-12-25 07:36:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZIHC06', 'C35IXL6', '845075649U', '689920JG', '2017-08-21 17:30:36', 7, 'COR7', '2017-08-24 18:30:36');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NUQQ26', 'X10NBN2', '061197808M', '859629WQ', '2018-07-01 07:15:52', 1, 'EJB0', '2018-07-04 09:15:52');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PIJJ68', 'E36FUS5', '023284312M', '923205VG', '2016-10-31 06:39:25', 6, 'QDV1', '2016-11-02 19:39:25');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XXPS22', 'B48BFZ9', '612977845G', '588695MA', '2018-10-20 09:37:03', 5, 'RHH0', '2018-10-25 00:37:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DTER96', 'E55SSY1', '983554010X', '959088YH', '2016-05-22 05:22:54', 9, 'EDA3', '2016-05-24 15:22:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IGFW90', 'V73RWY0', '549007318J', '374336OU', '2019-07-13 05:32:01', 2, 'JOA4', '2019-07-17 23:32:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HBYV64', 'R16EBM0', '634532858H', '959904UU', '2017-12-28 07:51:55', 1, 'EJB0', '2017-12-29 19:51:55');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DKRG87', 'C10FWL0', '521323832D', '483813MB', '2018-10-24 00:55:21', 1, 'WMZ0', '2018-10-28 10:55:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BYGH67', 'D84RNK2', '173374240E', '602847ZC', '2017-10-01 19:59:49', 9, 'YNF4', '2017-10-03 12:59:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PKRT88', 'O52YXS5', '517171324K', '480033CB', '2018-07-04 01:34:28', 11, 'EEF2', '2018-07-06 23:34:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CASD85', 'Q30PKY8', '398247344W', '275811UE', '2019-07-29 23:37:54', 10, 'RVP0', '2019-08-03 07:37:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ASDD87', 'B78XYR3', '151242685J', '563885ZU', '2019-09-03 17:49:27', 10, 'HQC8', '2019-09-08 04:49:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EYNG60', 'W61YHV1', '959017408E', '672876CP', '2017-07-13 20:03:25', 2, 'NVJ2', '2017-07-17 12:03:25');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('URUX26', 'Y04FBS8', '893087626P', '772649NE', '2016-01-30 08:52:01', 1, 'WDS6', '2016-02-04 05:52:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UBQU45', 'R68LFX0', '082373576M', '865182CT', '2018-02-07 20:53:39', 1, 'VDI3', '2018-02-12 15:53:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('COFA89', 'Q38TUZ6', '035152296U', '222409UH', '2019-01-29 22:51:12', 1, 'RRR3', '2019-01-31 08:51:12');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WOVX85', 'O58SIC0', '183822661G', '141207TH', '2020-04-22 16:03:34', 1, 'LXB6', '2020-04-25 10:03:34');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TMZG07', 'R84KRN5', '030222740E', '354442ZT', '2016-04-07 11:21:12', 3, 'SCA4', '2016-04-09 13:21:12');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LRMA21', 'L24TWE0', '983554010X', '867895XE', '2016-08-02 13:00:20', 11, 'KIA3', '2016-08-03 14:00:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QEGF93', 'W51OFC9', '151242685J', '863901QK', '2016-02-27 19:19:11', 2, 'XKX3', '2016-03-03 18:19:11');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BAHO29', 'N74ULY4', '229633655Y', '035450RF', '2020-10-27 15:54:39', 8, 'HQC8', '2020-10-31 18:54:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ABJW97', 'Q38TUZ6', '369461984V', '422708HC', '2020-11-04 23:56:00', 5, 'WZY0', '2020-11-06 19:56:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KGXI36', 'F31IAA6', '163234990W', '077098AD', '2018-05-21 03:01:19', 11, 'ZRO2', '2018-05-23 10:01:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VAZI05', 'Q17IUA0', '683971308T', '273833PZ', '2018-11-17 00:40:22', 4, 'SWB8', '2018-11-20 09:40:22');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VZSE08', 'P88AJU4', '206054009Y', '370772GJ', '2020-04-19 07:37:30', 4, 'WMZ0', '2020-04-20 11:37:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EITC23', 'Q96BEG8', '517171324K', '866452YW', '2020-09-24 23:30:18', 7, 'CGB3', '2020-09-29 08:30:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EUGI56', 'W21BWK4', '789954790S', '280958MN', '2020-09-04 14:18:17', 6, 'SQD0', '2020-09-06 07:18:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LICT28', 'K95TNO6', '306030369P', '386008HE', '2020-01-07 23:45:04', 9, 'AYB3', '2020-01-10 15:45:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FVRQ54', 'W21BWK4', '363383213B', '356775OU', '2019-05-14 06:00:44', 5, 'NZI6', '2019-05-17 22:00:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HFNH23', 'S59UQF4', '934567502P', '942793IS', '2019-05-03 08:01:47', 8, 'UGC3', '2019-05-06 04:01:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VENK46', 'W07UPL6', '373040712T', '910580WQ', '2018-03-24 11:57:29', 6, 'DQJ0', '2018-03-27 04:57:29');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XMTV73', 'Q33KPW8', '157784697Y', '371254UZ', '2017-07-11 17:24:39', 10, 'HSS3', '2017-07-13 03:24:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AJXU05', 'N76TFG7', '393850830J', '796989PJ', '2017-09-10 23:25:54', 2, 'ZCB8', '2017-09-14 00:25:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZWDJ62', 'W32SEA4', '689737943E', '299171RZ', '2018-05-20 07:14:13', 2, 'XRZ4', '2018-05-21 16:14:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PFXI95', 'H55ZCC0', '999017599B', '274588DV', '2019-05-16 16:16:21', 11, 'JOL2', '2019-05-20 20:16:21');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SSZE98', 'C05QDP0', '702782178D', '546015WF', '2018-02-03 01:38:54', 6, 'HGQ8', '2018-02-06 15:38:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ATWW63', 'E36FUS5', '369461984V', '385720VY', '2017-03-15 08:21:19', 7, 'NSH9', '2017-03-16 17:21:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BHNN00', 'P36NXE7', '702782178D', '520392WQ', '2017-08-24 14:08:17', 10, 'ZCX8', '2017-08-29 11:08:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WLDA27', 'W32SEA4', '810451330U', '945383RK', '2020-02-23 20:57:06', 10, 'EWK2', '2020-02-26 06:57:06');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HWJT73', 'Y96GZC0', '725030285D', '710901RB', '2020-10-11 06:26:05', 7, 'JFZ9', '2020-10-14 06:26:05');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SBOT11', 'V76FXO4', '576920130N', '363449XI', '2017-11-11 18:05:47', 1, 'VNJ4', '2017-11-12 21:05:47');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TNCD90', 'K68EGA4', '909240077X', '363449XI', '2019-05-02 07:49:59', 12, 'LML8', '2019-05-06 10:49:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PFWH88', 'H07SZM9', '703492393T', '476861WC', '2019-12-14 06:20:56', 9, 'QDB6', '2019-12-17 17:20:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YAWG91', 'P45NLM6', '475428439A', '119580OE', '2016-06-06 13:02:50', 5, 'DWP7', '2016-06-08 05:02:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VYDF62', 'Y96GZC0', '322697703G', '370772GJ', '2017-02-07 10:54:41', 12, 'JOL2', '2017-02-12 08:54:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EDZM72', 'X82IBB5', '675295660H', '009830VM', '2020-03-02 21:29:18', 2, 'ARR5', '2020-03-06 01:29:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MYRS60', 'S61DYT2', '934567502P', '048580VQ', '2019-04-20 02:45:18', 5, 'XVQ4', '2019-04-22 20:45:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WLQD61', 'S22CUN3', '243089355P', '866931YZ', '2016-11-11 07:09:53', 2, 'MBC7', '2016-11-15 05:09:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZVRX24', 'R34WVX1', '170256215J', '273833PZ', '2016-07-10 09:21:04', 11, 'OTQ6', '2016-07-13 15:21:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TZOP68', 'J79SKR7', '905197247M', '442699XU', '2020-02-26 18:57:10', 5, 'KNN9', '2020-03-01 22:57:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QCYE85', 'O58SIC0', '646313702P', '699036TZ', '2017-02-19 22:01:18', 12, 'ZCX8', '2017-02-21 20:01:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VJYM37', 'R02KHB7', '149071155B', '153553II', '2019-09-07 07:58:38', 10, 'KNN9', '2019-09-09 19:58:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JAFF49', 'C04CPQ3', '817185530N', '240418QS', '2017-05-12 00:27:25', 6, 'HMJ4', '2017-05-13 06:27:25');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CLGH30', 'A85NFC1', '817185530N', '563885ZU', '2016-09-14 16:43:05', 8, 'JOA4', '2016-09-16 21:43:05');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EKHB83', 'C97HLK7', '481885108N', '665913WM', '2016-12-27 10:01:50', 1, 'XHE0', '2016-12-30 09:01:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RODE77', 'X88WMX2', '376082483V', '987997SY', '2020-12-23 14:22:45', 8, 'BEK0', '2020-12-28 11:22:45');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CMCE18', 'G75ZOA9', '900131706L', '806868HF', '2017-07-15 16:16:10', 1, 'ZTJ9', '2017-07-19 23:16:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PFVI63', 'V48RXY1', '410795735E', '042776KQ', '2016-07-18 15:47:25', 3, 'QHY4', '2016-07-23 14:47:25');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DYJL03', 'K95TNO6', '328642831P', '816069KH', '2017-09-15 02:57:32', 1, 'SUE8', '2017-09-16 17:57:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CGAE78', 'R86LCD5', '499777409Q', '758792MS', '2020-02-24 10:47:56', 5, 'UFI0', '2020-02-27 22:47:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DSVY91', 'M13XWS0', '527676620D', '409490EP', '2018-07-30 05:53:56', 6, 'XRZ4', '2018-08-01 17:53:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TVMP66', 'V43CRH5', '133776055Y', '530977FV', '2016-11-09 14:24:57', 9, 'XQY7', '2016-11-13 07:24:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NLCP49', 'G11VZO9', '481885108N', '065620QO', '2017-11-08 04:02:32', 1, 'JFZ9', '2017-11-12 15:02:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EYSE02', 'M85CGE5', '147995979M', '795320MM', '2019-06-17 14:12:16', 11, 'QNF7', '2019-06-21 04:12:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('VPQI64', 'V29ZSX2', '321271002N', '651369JK', '2018-08-31 14:34:50', 9, 'BVR6', '2018-09-02 13:34:50');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MNOA43', 'R59OBH2', '689216804E', '080131CS', '2018-04-22 05:35:28', 2, 'EJB0', '2018-04-26 12:35:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MBZM22', 'C10FWL0', '469624384L', '371254UZ', '2018-12-02 03:16:16', 6, 'JFZ9', '2018-12-03 10:16:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MWES29', 'H56ZWQ1', '620415636C', '240418QS', '2017-12-09 05:16:16', 3, 'XVQ4', '2017-12-13 03:16:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CIRH41', 'A92MHZ9', '233461298A', '910580WQ', '2018-07-08 16:29:30', 12, 'LRF3', '2018-07-12 08:29:30');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XFOB38', 'Y96GZC0', '909240077X', '588695MA', '2018-03-03 17:15:09', 11, 'KAQ1', '2018-03-06 00:15:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IVOX53', 'X53GOU3', '282798534O', '154046AU', '2020-09-24 22:03:23', 3, 'QHY4', '2020-09-27 08:03:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZEHV55', 'J84FFX3', '709247980W', '476861WC', '2016-07-27 02:57:39', 6, 'KYZ5', '2016-07-31 21:57:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZQDM59', 'S98LOC1', '394738372Y', '000084VF', '2020-04-26 10:20:45', 10, 'LML8', '2020-04-28 14:20:45');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NMEZ13', 'M13XWS0', '900131706L', '248505WE', '2016-06-30 12:09:07', 4, 'KOD4', '2016-07-02 14:09:07');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LAKY81', 'G75ZOA9', '551550218D', '092546ZI', '2016-02-13 17:48:07', 10, 'HAY6', '2016-02-18 11:48:07');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LEGL45', 'S71WEV4', '066306837W', '385720VY', '2017-08-20 07:30:33', 4, 'MGV4', '2017-08-21 20:30:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SPMO59', 'L30OAB4', '319107657K', '547200VZ', '2020-11-15 19:32:48', 11, 'CNL0', '2020-11-19 14:32:48');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YEJT71', 'K29MTU2', '063364295I', '862738YY', '2019-10-17 17:27:35', 1, 'TAC7', '2019-10-21 15:27:35');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TPPH81', 'H20KLJ7', '551550218D', '853591LN', '2020-12-11 17:03:14', 7, 'SOE0', '2020-12-14 13:03:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WXJA72', 'R68LFX0', '654553683G', '158864AA', '2020-08-25 21:42:53', 5, 'TPO0', '2020-08-30 21:42:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XJKP61', 'Q22BBX9', '229633655Y', '692308PP', '2017-06-28 11:38:13', 1, 'QXQ2', '2017-07-02 19:38:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KONT44', 'F12JVM8', '374690163D', '363449XI', '2020-03-01 08:47:54', 4, 'VOB5', '2020-03-03 02:47:54');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OTEP64', 'M16EYB7', '438951898B', '157632ZH', '2018-06-07 06:32:32', 10, 'QDB6', '2018-06-09 04:32:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BMGX81', 'I13ABP5', '226836285R', '277173IO', '2020-06-05 06:05:28', 2, 'UNZ5', '2020-06-08 23:05:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IHEZ97', 'B78XYR3', '170256215J', '651369JK', '2017-05-11 05:17:56', 11, 'BVR6', '2017-05-15 22:17:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TVHD90', 'N74ULY4', '276290889A', '712452GP', '2017-09-18 12:00:38', 4, 'LML8', '2017-09-21 14:00:38');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MYEI41', 'T49GOM0', '340236083A', '092546ZI', '2019-10-24 13:50:46', 11, 'TFF0', '2019-10-29 08:50:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QLUX47', 'L93MGP1', '703492393T', '239642CD', '2018-03-11 12:13:01', 1, 'NLK7', '2018-03-15 00:13:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YRKT59', 'C26RKD4', '612977845G', '386008HE', '2018-10-01 20:16:42', 7, 'KNN9', '2018-10-05 00:16:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TPTJ79', 'J64LND6', '567538877Z', '923205VG', '2019-06-12 08:44:58', 3, 'HMR7', '2019-06-15 21:44:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FZIF20', 'J84FFX3', '774287974Y', '779122PO', '2017-12-11 02:36:04', 9, 'EEF2', '2017-12-14 11:36:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AGIX19', 'U74SXB3', '675554791Q', '092546ZI', '2016-09-27 17:19:09', 11, 'ZZQ8', '2016-10-01 18:19:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NKJM16', 'G75ZOA9', '811893336T', '589150XS', '2017-07-10 07:42:18', 5, 'XYH4', '2017-07-12 07:42:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DRSJ42', 'R59OBH2', '536205627Z', '774177ZB', '2016-10-22 12:32:36', 6, 'YYQ9', '2016-10-25 20:32:36');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YXKY51', 'X82IBB5', '290219372U', '385720VY', '2018-09-10 02:39:28', 11, 'LML8', '2018-09-14 21:39:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PLFX61', 'E98UZQ7', '145903714D', '466764DM', '2017-07-28 07:46:41', 3, 'MQW6', '2017-07-29 12:46:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SCWO70', 'B48BFZ9', '006126532S', '542354MN', '2018-06-02 11:59:59', 4, 'LHD3', '2018-06-07 03:59:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NYIX63', 'E36FUS5', '709247980W', '409490EP', '2017-03-18 13:52:28', 12, 'JOA4', '2017-03-21 11:52:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WDXB61', 'C05QDP0', '909240077X', '816069KH', '2018-12-04 06:04:17', 12, 'RRR3', '2018-12-09 02:04:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WEIJ40', 'V51VZR5', '623088424M', '016703PP', '2019-01-09 20:02:40', 8, 'UVC1', '2019-01-13 15:02:40');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NKWB45', 'C26RKD4', '499777409Q', '689920JG', '2019-07-05 00:40:33', 7, 'LHD3', '2019-07-09 14:40:33');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ERIC29', 'T41HPF1', '454406302W', '776292ZE', '2018-02-14 01:30:41', 12, 'EQZ0', '2018-02-17 08:30:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UEEN55', 'Q27IIP1', '774287974Y', '588695MA', '2019-08-17 07:40:03', 5, 'UYZ2', '2019-08-19 06:40:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MIOD72', 'R74JLT8', '785280662Z', '022668HB', '2020-11-05 07:49:11', 8, 'SGV3', '2020-11-06 19:49:11');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LFQF32', 'O58SIC0', '683971308T', '796989PJ', '2016-01-26 08:02:39', 7, 'WMZ0', '2016-01-30 17:02:39');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TTCD02', 'J04KBC6', '149071155B', '792946FE', '2018-01-27 08:02:10', 5, 'GAO6', '2018-01-30 06:02:10');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RQKC37', 'F06SSJ7', '918200695H', '497344UK', '2018-02-04 15:13:17', 1, 'MGF7', '2018-02-07 06:13:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('IEZB16', 'Q01GWM5', '668235461Z', '194723PN', '2018-09-28 21:35:02', 1, 'ZPS8', '2018-10-03 12:35:02');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HYAU76', 'J98MVA2', '852883849N', '313618HP', '2019-07-02 00:22:11', 12, 'YRG3', '2019-07-03 14:22:11');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SRRK50', 'E36FUS5', '705365019A', '312045UV', '2016-01-08 08:11:32', 6, 'DYB4', '2016-01-13 05:11:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('UVLM71', 'U54NKY1', '263548523R', '879368RO', '2019-04-16 17:04:03', 3, 'PXN7', '2019-04-19 06:04:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XXNO51', 'H97VDX7', '523679322Y', '861404GP', '2019-04-03 13:13:18', 2, 'ZZQ8', '2019-04-05 20:13:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SSWP01', 'N82VEQ5', '440675847X', '895484KK', '2016-06-12 20:54:19', 2, 'LHD3', '2016-06-16 03:54:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ONZM25', 'Y58SLX0', '617677484Q', '308844BC', '2020-05-23 11:02:42', 3, 'UCZ4', '2020-05-26 21:02:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BLBJ49', 'S61DYT2', '134797672A', '965932UQ', '2019-04-21 20:40:41', 2, 'JOA4', '2019-04-24 04:40:41');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KUZU94', 'D64YVD5', '810451330U', '110666YH', '2019-05-01 00:27:53', 6, 'UCF1', '2019-05-02 12:27:53');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('HHYG24', 'E55SSY1', '481885108N', '371254UZ', '2020-01-11 18:20:36', 6, 'WYD5', '2020-01-16 16:20:36');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OFZE14', 'Z81VGL7', '499777409Q', '776292ZE', '2019-11-14 11:47:11', 11, 'GCT5', '2019-11-18 09:47:11');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('QLQW53', 'V12MBR7', '696567274U', '860365NF', '2017-12-23 14:49:26', 4, 'FED7', '2017-12-24 20:49:26');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YOAF98', 'F03JFC5', '983554010X', '772649NE', '2019-03-14 21:40:08', 2, 'SOL2', '2019-03-17 23:40:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PDOC41', 'O58SIC0', '810451330U', '119580OE', '2016-04-15 00:41:08', 12, 'ZAK1', '2016-04-19 04:41:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('MKSS58', 'R84KRN5', '990783493P', '308844BC', '2017-06-05 08:51:59', 5, 'SOE0', '2017-06-07 22:51:59');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OPCW01', 'Q33KPW8', '051795419G', '878357UM', '2016-01-16 21:27:05', 12, 'EBD6', '2016-01-18 02:27:05');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EEFV55', 'B50ATK3', '184113114O', '594043US', '2017-07-18 16:42:58', 9, 'QDB6', '2017-07-20 03:42:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AMKG63', 'B82TEX9', '003471832Y', '303407PW', '2019-07-21 17:50:00', 10, 'OOE1', '2019-07-25 15:50:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('YXRH79', 'S23BLK1', '173374240E', '520392WQ', '2018-04-22 17:28:02', 2, 'ARR5', '2018-04-24 18:28:02');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('FULU38', 'C04CPQ3', '508984035K', '291542XG', '2020-10-07 14:21:27', 2, 'SJY5', '2020-10-12 11:21:27');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('BFZC92', 'O63EKD1', '397196720Y', '016703PP', '2017-01-30 02:43:20', 5, 'WEV5', '2017-02-03 11:43:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CEAO80', 'W17IWD6', '634532858H', '589150XS', '2016-10-04 01:02:37', 1, 'HJK6', '2016-10-07 01:02:37');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NSBC87', 'G68GGM7', '438951898B', '291542XG', '2020-06-03 01:01:57', 3, 'MQX6', '2020-06-06 00:01:57');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XSWN54', 'X26ACJ3', '270438704N', '945383RK', '2019-05-17 19:31:09', 8, 'IJD4', '2019-05-19 20:31:09');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('OTCB86', 'H97VDX7', '048090125S', '699036TZ', '2020-05-09 18:07:34', 2, 'JOA4', '2020-05-11 11:07:34');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CFMX91', 'M85CGE5', '233461298A', '053435VB', '2018-05-25 17:28:19', 1, 'NSH9', '2018-05-27 08:28:19');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NODV38', 'E64UXI3', '317890290F', '859412OQ', '2017-03-05 20:22:00', 2, 'MPR3', '2017-03-07 11:22:00');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('KBGG79', 'P45NLM6', '709247980W', '385720VY', '2016-03-18 12:35:28', 10, 'AYP2', '2016-03-22 02:35:28');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('XSTZ86', 'K18ETO3', '243089355P', '220757HI', '2016-01-20 07:21:14', 5, 'DWP7', '2016-01-25 06:21:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SPZZ25', 'F64DNC3', '957499350R', '563885ZU', '2019-06-10 19:43:01', 8, 'EXR2', '2019-06-13 04:43:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CIJM40', 'V51VZR5', '082373576M', '177659BU', '2019-09-11 07:19:18', 2, 'EQZ0', '2019-09-12 18:19:18');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('SHDB17', 'Q67HRJ6', '508984035K', '450839JZ', '2019-01-16 05:30:49', 8, 'ZJZ2', '2019-01-19 01:30:49');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CSFK29', 'E74TWS1', '229633655Y', '065620QO', '2019-05-16 20:47:16', 1, 'MJU8', '2019-05-20 11:47:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NHKX50', 'W21BWK4', '306030369P', '600128KO', '2017-06-04 17:50:05', 8, 'UYZ2', '2017-06-06 01:50:05');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('NPUV61', 'N58KJE9', '138092219R', '928416XS', '2017-11-04 06:30:06', 4, 'MII2', '2017-11-06 18:30:06');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JWJK12', 'U47UID1', '184113114O', '371254UZ', '2016-04-12 06:04:32', 5, 'UDO7', '2016-04-15 17:04:32');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ACRV19', 'R68VCV9', '066306837W', '371254UZ', '2019-04-25 15:09:13', 9, 'YPX0', '2019-04-28 04:09:13');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZFIC49', 'Y95SWL3', '229633655Y', '529891ZW', '2017-02-11 21:16:46', 5, 'COR7', '2017-02-14 09:16:46');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PLQL85', 'W07UPL6', '830347082D', '022480GF', '2019-05-16 09:14:44', 9, 'SOE0', '2019-05-18 16:14:44');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('ZUUK25', 'J64LND6', '617677484Q', '858858RY', '2018-11-10 23:25:20', 9, 'KYZ5', '2018-11-12 14:25:20');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JRXU57', 'R84KRN5', '398247344W', '910580WQ', '2020-01-01 04:04:58', 1, 'TAH6', '2020-01-05 02:04:58');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('CTAQ19', 'I13ABP5', '551243732A', '066084LH', '2019-10-25 04:09:16', 11, 'EDA3', '2019-10-27 06:09:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('TKUR44', 'C10FWL0', '785280662Z', '113465RL', '2016-11-06 21:36:31', 5, 'DWP7', '2016-11-09 00:36:31');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PJQX48', 'X15JBF8', '277376266P', '513577KN', '2020-12-31 13:49:52', 5, 'UCF1', '2021-01-04 03:49:52');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WCUU03', 'F31IAA6', '290219372U', '495365PE', '2019-09-24 23:56:04', 3, 'ZZQ8', '2019-09-27 17:56:04');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('JIMU85', 'G61HNN8', '086459294O', '859412OQ', '2017-12-19 10:08:03', 11, 'EQZ0', '2017-12-23 18:08:03');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('WOOH07', 'P45NLM6', '410795735E', '263717CV', '2019-07-31 03:02:17', 5, 'KAQ1', '2019-08-02 18:02:17');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RYFZ39', 'T49GOM0', '147995979M', '879368RO', '2018-07-27 21:18:08', 7, 'IJD4', '2018-08-01 06:18:08');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('PHJF98', 'O26RSR7', '789954790S', '910580WQ', '2019-08-23 06:51:23', 12, 'HHK5', '2019-08-26 07:51:23');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EBEL90', 'Y95SWL3', '964805039P', '928416XS', '2017-11-24 09:27:14', 12, 'LQQ7', '2017-11-27 23:27:14');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('DCVW95', 'H56ZWQ1', '567538877Z', '772649NE', '2017-08-23 00:11:01', 2, 'NSH9', '2017-08-27 12:11:01');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('AYCB92', 'G41JHL2', '182718758L', '967969NP', '2016-05-21 07:17:56', 3, 'OLW0', '2016-05-25 17:17:56');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('EXAR20', 'B70VVO6', '082373576M', '025761EB', '2019-05-24 15:40:42', 11, 'DYB4', '2019-05-28 03:40:42');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('LAXW57', 'P36NXE7', '730161442H', '016703PP', '2020-01-28 12:03:16', 11, 'DOQ7', '2020-02-02 05:03:16');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta, ultima_actualizacion) values ('RVMV64', 'H33DSI3', '971898444G', '020332BL', '2019-06-19 19:29:53', 7, 'MPR3', '2019-06-20 20:29:53');


insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9706RV1229VQ711', 'KKXL78', 'TRABAJO', 0.37, '2018-05-03 06:37:12', 2837.91, 'DIGITAL', 'Pegasus', 'BUSINESS', '46G', '31370859H', '2018-05-03 14:37:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6143XH3579HW748', 'LIVI96', 'ESTUDIOS', 0.63, '2018-09-06 21:55:19', 3413.96, 'FISICO', 'Ultimo Confin', 'TURISTA', '7D', '41173696K', '2018-09-08 15:55:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0199HG2378HX374', 'DIGA57', 'ESTUDIOS', 0.55, '2018-10-02 23:36:11', 3739.51, 'DIGITAL', 'Travel Factory', 'PREFERENTE', '81A', '30537638Q', '2018-10-04 19:36:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1961AC2629UA875', 'AMKG63', 'ESTUDIOS', 0.14, '2019-08-19 12:59:09', 1603.93, 'FISICO', 'Rago Tours S.R.L.', 'TURISTA', '24G', '19767799D', '2019-08-20 06:59:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8658WO8112EJ230', 'JPKD62', 'OCIO', 0.04, '2020-02-09 00:04:35', 422.56, 'DIGITAL', 'All Over The World', 'TURISTA', '4F', '29958060M', '2020-02-10 16:04:35');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2363ZP5251PV965', 'MXKY03', 'ESTUDIOS', 0.11, '2018-01-16 18:44:04', 1196.07, 'DIGITAL', 'Issn Instituto De Seguridad Social Del Neuquen', 'PREFERENTE', '5G', '44546083M', '2018-01-18 21:44:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4151ES0805UN612', 'VUTE09', 'OCIO', 0.12, '2017-03-17 13:33:27', 172.85, 'DIGITAL', 'Micheletti Viajes Y Turismo', 'PREFERENTE', '1A', '20250544Z', '2017-03-18 16:33:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5882KF9048BV010', 'EIPH16', 'TRABAJO', 0.4, '2017-04-15 14:19:32', 1076.7, 'DIGITAL', 'Cabure', 'BUSINESS', '09D', '22012118W', '2017-04-16 07:19:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2911RZ7187QB207', 'CIRH41', 'OCIO', 0.56, '2020-04-17 15:13:12', 1730.85, 'FISICO', 'Othamil Viajes', 'BUSINESS', '64D', '27848391E', '2020-04-18 05:13:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4741GZ5683JO942', 'RVMV64', 'TRABAJO', 0.48, '2017-01-09 11:58:57', 1475.66, 'FISICO', 'Tours & Travel', 'BUSINESS', '12G', '14970824X', '2017-01-11 15:58:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2710AJ9347GE346', 'CSFK29', 'OCIO', 0.57, '2020-07-11 03:45:31', 1860.77, 'DIGITAL', 'Alma Calma', 'BUSINESS', '56G', '99220378I', '2020-07-13 05:45:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0464LG0550KJ183', 'BFZC92', 'ESTUDIOS', 0.08, '2018-04-23 16:46:55', 1757.03, 'FISICO', 'Ok Viajes', 'PREFERENTE', '32G', '46885767Y', '2018-04-25 18:46:55');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9264YK9381HF710', 'LAXW57', 'TRABAJO', 0.41, '2019-06-14 16:37:11', 3987.77, 'FISICO', 'Mariano Boguslavski Franquicia De Lozada Viajes', 'PREFERENTE', '0D', '20185493S', '2019-06-16 06:37:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3067ZT3814NS855', 'AYWO22', 'ESTUDIOS', 0.08, '2020-04-09 13:47:28', 1894.54, 'DIGITAL', 'Alma Viajera', 'PREFERENTE', '32F', '57677201C', '2020-04-11 07:47:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2698QU3018AE665', 'BMGX81', 'OCIO', 0.67, '2020-03-02 18:34:19', 169.31, 'FISICO', 'Secret Tur', 'PREFERENTE', '8F', '50150286R', '2020-03-03 10:34:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3236TW2901FN473', 'GEPY67', 'TRABAJO', 0.7, '2016-10-05 14:00:47', 1043.42, 'DIGITAL', 'Gondola Turismo', 'PREFERENTE', '1F', '58496330S', '2016-10-07 02:00:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6879LS0444HQ111', 'JCYH85', 'ESTUDIOS', 0.27, '2019-12-22 04:35:24', 3025.27, 'DIGITAL', 'B & P Turismo', 'BUSINESS', '01G', '89045590L', '2019-12-23 03:35:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3827KO8743ET154', 'UHOJ14', 'ESTUDIOS', 0.07, '2019-10-04 04:55:23', 529.21, 'DIGITAL', 'Glopo Viajes Y Turismo', 'BUSINESS', '4G', '88822417J', '2019-10-05 16:55:23');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8009CF3048BI825', 'NHKX50', 'OCIO', 0.34, '2020-04-20 07:57:27', 1512.27, 'FISICO', 'Turismo Saluthia', 'TURISTA', '3G', '58982427V', '2020-04-22 02:57:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9062XY8367FH565', 'SJHN46', 'TRABAJO', 0.12, '2018-04-09 23:29:03', 117.08, 'FISICO', 'Zona Horaria', 'TURISTA', '2G', '75154918H', '2018-04-10 18:29:03');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3792OM1715NS546', 'SCWO70', 'TRABAJO', 0.28, '2016-03-22 13:29:21', 2437.08, 'DIGITAL', 'Dominique', 'PREFERENTE', '10D', '92140486L', '2016-03-23 08:29:21');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2792NY7797RV228', 'BJFP92', 'ESTUDIOS', 0.03, '2016-06-17 18:56:32', 925.23, 'DIGITAL', 'Turismo Filadelfia', 'BUSINESS', '91F', '28368887A', '2016-06-18 06:56:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4338CH7456TT702', 'QEHU12', 'OCIO', 0.45, '2017-11-08 18:29:36', 1573.48, 'FISICO', 'Vöntravel', 'TURISTA', '96D', '97814136Q', '2017-11-10 22:29:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3352FI4293JJ307', 'TDQR49', 'ESTUDIOS', 0.07, '2018-07-19 08:13:29', 573.53, 'FISICO', 'Centro De Empleados De Quilmes', 'BUSINESS', '3G', '07055242C', '2018-07-20 21:13:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9400YB1045CA330', 'UGLJ78', 'TRABAJO', 0.36, '2019-01-22 17:10:29', 3923.43, 'DIGITAL', 'Marga Maggi Tours', 'TURISTA', '54C', '16305315P', '2019-01-24 04:10:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7960CT6639MH814', 'TNCD90', 'ESTUDIOS', 0.35, '2020-03-06 00:04:42', 1391.54, 'DIGITAL', 'Punto Limite', 'BUSINESS', '67D', '91981768G', '2020-03-08 08:04:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5656TB7077MO917', 'ZIHC06', 'TRABAJO', 0.33, '2020-02-27 06:51:52', 897.65, 'DIGITAL', 'Paamul Travel Service', 'BUSINESS', '58D', '58407974X', '2020-02-28 06:51:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3195WA5339JO892', 'FSIO41', 'ESTUDIOS', 0.14, '2020-11-05 23:04:42', 3215.24, 'DIGITAL', 'Emporio Consultora En Turismo', 'TURISTA', '36D', '47938670T', '2020-11-08 06:04:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0901XR6344CQ363', 'DOAW38', 'TRABAJO', 0.64, '2016-10-23 15:57:40', 1418.52, 'FISICO', 'Tinti Kay', 'BUSINESS', '7G', '05413206A', '2016-10-25 21:57:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1484NT5048LE305', 'ZFIC49', 'OCIO', 0.55, '2016-07-08 08:10:45', 3467.27, 'FISICO', 'Turismo Volts', 'TURISTA', '38G', '20923495U', '2016-07-09 13:10:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2389GP0718LP088', 'EKHB83', 'OCIO', 0.54, '2017-12-22 22:17:36', 1505.41, 'FISICO', 'Apacheta Viajes', 'PREFERENTE', '07D', '89045590L', '2017-12-25 07:17:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9621FL5033CX490', 'ZBBC98', 'OCIO', 0.06, '2018-11-04 15:52:38', 1748.95, 'DIGITAL', 'Premium Travel Service', 'BUSINESS', '8G', '70878793O', '2018-11-05 02:52:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5435GL4308AG863', 'AYCB92', 'OCIO', 0.11, '2017-06-16 11:15:32', 1735.73, 'FISICO', 'Travel Paz', 'TURISTA', '07D', '83743817J', '2017-06-18 12:15:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9522QH6939LO108', 'GESN89', 'ESTUDIOS', 0.02, '2019-10-14 18:29:10', 1511.34, 'DIGITAL', 'Delphos Tour Srl', 'BUSINESS', '9D', '03438149Y', '2019-10-16 07:29:10');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9198RE9509WK233', 'RVMV64', 'ESTUDIOS', 0.37, '2016-12-25 17:58:57', 1475.66, 'DIGITAL', 'Caracol Internacional Viajes Y Turismo', 'TURISTA', '2G', '83743817J', '2016-12-26 04:58:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2827CR1200CU342', 'OKVX23', 'OCIO', 0.69, '2017-04-30 06:21:26', 605.57, 'DIGITAL', 'Jl Serer', 'TURISTA', '81F', '19767799D', '2017-05-02 01:21:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8450JU1879NO367', 'JMOK23', 'ESTUDIOS', 0.56, '2016-07-06 13:30:10', 1498.36, 'DIGITAL', 'Buena Gente', 'BUSINESS', '2G', '94675329B', '2016-07-07 05:30:10');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5850AM2196XT692', 'CRFX33', 'ESTUDIOS', 0.14, '2018-12-05 13:12:42', 2979.23, 'FISICO', 'Catemu Viajes', 'TURISTA', '4G', '26807992N', '2018-12-06 18:12:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2086IG9867EO685', 'MBZT21', 'ESTUDIOS', 0.25, '2017-10-25 00:52:09', 3773.13, 'FISICO', 'Espinoza Travels', 'BUSINESS', '3C', '20250544Z', '2017-10-27 09:52:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7382BD9100NP810', 'MIOD72', 'ESTUDIOS', 0.22, '2016-03-26 09:42:24', 3464.71, 'FISICO', 'Turismo A.Y M. Garcia', 'BUSINESS', '9G', '51977060S', '2016-03-28 10:42:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4900DU6199VK296', 'HMXJ20', 'ESTUDIOS', 0.28, '2020-04-20 19:39:59', 2800.24, 'DIGITAL', 'Magnani Viajes', 'PREFERENTE', '66A', '06553546P', '2020-04-22 17:39:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8126JO6642FX272', 'HBAO45', 'OCIO', 0.53, '2017-05-05 21:46:20', 1026.27, 'FISICO', 'Buena Gente', 'BUSINESS', '4G', '03583687M', '2017-05-06 08:46:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1444DO3096JY735', 'BJFP92', 'OCIO', 0.21, '2016-07-11 07:56:32', 925.23, 'DIGITAL', 'Free Sky Travel', 'PREFERENTE', '34A', '84848139W', '2016-07-12 03:56:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4588PP1944WX782', 'NLCP49', 'OCIO', 0.39, '2016-04-10 02:53:53', 2347.86, 'DIGITAL', 'Babylon Express', 'PREFERENTE', '87F', '18260942C', '2016-04-10 07:53:53');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9839HT4485AO498', 'IFFE27', 'OCIO', 0.08, '2018-06-01 03:26:59', 913.85, 'FISICO', 'Open Bue', 'BUSINESS', '27F', '58407974X', '2018-06-03 00:26:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7744AG8282RB476', 'WGSB43', 'OCIO', 0.19, '2019-03-13 15:56:44', 3083.75, 'FISICO', 'Posho Quimey Tours Y Eventos', 'TURISTA', '9G', '16615308B', '2019-03-15 07:56:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6224MO5978VS016', 'IPXR55', 'OCIO', 0.54, '2020-04-13 22:30:22', 569.84, 'FISICO', 'Patricia Alejandra Villarreal Franquicia De Viajes Tdh', 'TURISTA', '6F', '16615308B', '2020-04-14 10:30:22');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1530XU2276LE722', 'YLNP53', 'ESTUDIOS', 0.47, '2019-09-19 04:11:32', 962.18, 'DIGITAL', 'Exodo Travel', 'BUSINESS', '72D', '58618293D', '2019-09-21 16:11:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6054FW2230QV467', 'ORBN65', 'TRABAJO', 0.3, '2018-11-04 20:43:29', 2236.95, 'DIGITAL', 'K-Laguaw', 'TURISTA', '53G', '89255796Y', '2018-11-06 22:43:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3318BV4808XI660', 'JGGE03', 'ESTUDIOS', 0.58, '2017-02-09 02:29:13', 2499.02, 'DIGITAL', 'Travel Car', 'PREFERENTE', '64G', '79146442D', '2017-02-11 00:29:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1722FW9758BE389', 'DKYT41', 'ESTUDIOS', 0.06, '2017-05-06 15:15:41', 670.7, 'DIGITAL', 'Fragata Viajes Y Turismo', 'TURISTA', '3G', '96575776M', '2017-05-09 02:15:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9812KH3453YS827', 'JKUJ49', 'TRABAJO', 0.32, '2016-05-02 02:51:19', 1237.43, 'FISICO', 'Originario Turismo', 'TURISTA', '43F', '61436494H', '2016-05-03 04:51:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9840CC3948AE683', 'TFYD64', 'OCIO', 0.54, '2020-09-15 22:02:54', 782.05, 'DIGITAL', 'Ayuntun', 'PREFERENTE', '48F', '38013653B', '2020-09-16 19:02:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4197DR9009AG364', 'WGSB43', 'ESTUDIOS', 0.46, '2019-02-19 00:56:44', 3083.75, 'FISICO', 'Turismo Gomez', 'PREFERENTE', '5G', '43167839X', '2019-02-20 09:56:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0204VC4009PI508', 'AVAF45', 'ESTUDIOS', 0.34, '2016-12-15 07:57:04', 1585.85, 'DIGITAL', '"Haz Que Suceda" Rueda Evans Viajes', 'BUSINESS', '0G', '68643919X', '2016-12-15 17:57:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3349JZ1734BQ067', 'SPMO59', 'TRABAJO', 0.61, '2016-07-23 00:56:12', 1422.79, 'DIGITAL', 'Abekani Viajes Y Turismo', 'PREFERENTE', '62G', '70464474N', '2016-07-24 00:56:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1600HN2360HF481', 'WCUU03', 'ESTUDIOS', 0.05, '2019-01-28 13:21:08', 3233.74, 'DIGITAL', 'Parme Turismo', 'TURISTA', '6D', '93205706M', '2019-01-29 04:21:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7513MO0605YZ741', 'JGGE03', 'TRABAJO', 0.14, '2017-04-04 17:29:13', 2499.02, 'FISICO', 'Garcia Fernandez Turismo', 'BUSINESS', '3F', '37900304M', '2017-04-05 13:29:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0810PI3538CE173', 'NLCP49', 'TRABAJO', 0.68, '2016-06-06 22:53:53', 2347.86, 'FISICO', 'Auster Dmc', 'TURISTA', '71G', '30537638Q', '2016-06-08 04:53:53');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0154FR4482ID627', 'AZRE73', 'TRABAJO', 0.32, '2020-04-09 05:55:31', 639.46, 'FISICO', 'Butertour', 'BUSINESS', '7G', '90924101M', '2020-04-09 16:55:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2728XQ0141PW744', 'BLBJ49', 'TRABAJO', 0.06, '2019-03-03 20:49:11', 3587.36, 'FISICO', 'Chipre Tour', 'PREFERENTE', '46G', '92382459A', '2019-03-04 10:49:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3523VR3836OT055', 'ATWW63', 'OCIO', 0.7, '2017-06-21 08:06:18', 2106.44, 'DIGITAL', 'Rico - Peru Travel', 'BUSINESS', '89G', '84780067I', '2017-06-23 06:06:18');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0218ZE1840YK309', 'URUX26', 'TRABAJO', 0.38, '2016-07-06 08:59:17', 2717.37, 'DIGITAL', 'Skyline', 'TURISTA', '53D', '30537638Q', '2016-07-08 05:59:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2696GG3874WK019', 'QEGF93', 'OCIO', 0.32, '2018-03-04 05:03:47', 2811.99, 'DIGITAL', 'Gamarra Viajes', 'TURISTA', '91G', '26491980A', '2018-03-04 21:03:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6437OX7013OK931', 'EIUE54', 'OCIO', 0.07, '2018-02-24 18:31:24', 3185.88, 'FISICO', 'Catemu Viajes', 'PREFERENTE', '9B', '83743817J', '2018-02-24 23:31:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8195IY7825EG315', 'BZUM50', 'TRABAJO', 0.03, '2018-08-15 10:36:42', 1622.39, 'DIGITAL', 'Valsan Tour', 'TURISTA', '56G', '31370859H', '2018-08-16 14:36:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0978SO9562TW433', 'DHGQ82', 'OCIO', 0.42, '2018-04-27 20:10:04', 2218.64, 'DIGITAL', 'Fly Travel', 'PREFERENTE', '09G', '95501108I', '2018-04-28 07:10:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7375KH4056KV023', 'FVRQ54', 'ESTUDIOS', 0.27, '2018-01-07 15:18:32', 17.21, 'DIGITAL', 'Amahuaca', 'TURISTA', '34G', '40387228S', '2018-01-07 23:18:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6455YP8587BS066', 'GLRK17', 'TRABAJO', 0.56, '2019-01-17 05:04:57', 3330.17, 'FISICO', 'Zago Tour', 'PREFERENTE', '39G', '68643919X', '2019-01-18 01:04:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0472ME5519GJ925', 'ODUX87', 'ESTUDIOS', 0.22, '2020-05-23 03:07:27', 1785.96, 'DIGITAL', 'Basa World Travel', 'PREFERENTE', '04B', '20250544Z', '2020-05-24 12:07:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6195JN0003SO152', 'FVRQ54', 'TRABAJO', 0.42, '2017-12-30 21:18:32', 17.21, 'DIGITAL', 'Elisan & Compañia', 'TURISTA', '7G', '29838624Z', '2018-01-01 00:18:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8203ZM4032QG029', 'UVLM71', 'ESTUDIOS', 0.55, '2016-08-01 14:52:02', 1546.02, 'DIGITAL', 'Ailleurs Tours', 'PREFERENTE', '6G', '27278555E', '2016-08-02 21:52:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4383MO0454DM074', 'PJQX48', 'OCIO', 0.06, '2020-03-14 23:32:17', 436.39, 'FISICO', 'Huatulco Franquicia De Almundo.Com', 'TURISTA', '50F', '99591663Y', '2020-03-15 18:32:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0861OL9805UO830', 'ACRV19', 'TRABAJO', 0.45, '2018-01-30 08:52:45', 3375.43, 'DIGITAL', 'El Charabon Turismo', 'BUSINESS', '5F', '38234174I', '2018-02-01 13:52:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1236HX6944KY923', 'KBGG79', 'ESTUDIOS', 0.53, '2017-02-25 23:59:38', 3578.7, 'FISICO', 'Argentur Viajes', 'TURISTA', '7G', '85328000E', '2017-02-26 15:59:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6556OL3939IE212', 'EZOD19', 'OCIO', 0.68, '2016-04-07 18:36:07', 3841.85, 'DIGITAL', 'D''Alessandro Turismo', 'PREFERENTE', '8C', '03438149Y', '2016-04-09 22:36:07');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6190CR7909ZL355', 'SYCX21', 'OCIO', 0.65, '2018-07-03 05:55:58', 3704.02, 'FISICO', 'Momento De Viaje', 'PREFERENTE', '67G', '05413206A', '2018-07-05 04:55:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9955XU5286OV313', 'SSBC99', 'OCIO', 0.6, '2016-12-14 18:15:41', 2652.41, 'DIGITAL', 'Mundo Joven Travel Shop', 'PREFERENTE', '47F', '02382074A', '2016-12-15 03:15:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0996WW7685FC140', 'RQKC37', 'ESTUDIOS', 0.06, '2019-08-26 08:48:59', 1341.37, 'DIGITAL', 'J Y S Viajes Y Turismo', 'BUSINESS', '4D', '61436494H', '2019-08-27 03:48:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2146PP1726FV773', 'OGQI63', 'ESTUDIOS', 0.01, '2020-02-01 20:10:40', 1510.23, 'FISICO', 'S.Novelli Viajes', 'PREFERENTE', '5C', '92140486L', '2020-02-02 11:10:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4281KD3671NO092', 'IFJY90', 'ESTUDIOS', 0.61, '2019-01-23 02:57:41', 1771.46, 'DIGITAL', 'La Cienaga E.V.T.', 'BUSINESS', '56G', '04955523F', '2019-01-23 12:57:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4399BZ6443KB742', 'KMPT60', 'OCIO', 0.14, '2020-03-26 23:38:09', 1716.27, 'DIGITAL', 'Vagary Viajes', 'TURISTA', '89F', '44546083M', '2020-03-29 10:38:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7874JN1621KB974', 'SSBC99', 'OCIO', 0.66, '2017-01-16 22:15:41', 2652.41, 'DIGITAL', 'Via Roly Turismo', 'BUSINESS', '98B', '80548424Q', '2017-01-19 02:15:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1844QR8712QX260', 'HYKO22', 'TRABAJO', 0.23, '2020-10-02 19:24:32', 3193.73, 'FISICO', 'Runacay Servicios', 'PREFERENTE', '9G', '70464474N', '2020-10-04 23:24:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2349DI6564PI301', 'WLQD61', 'OCIO', 0.57, '2020-03-02 21:20:50', 1415.57, 'DIGITAL', 'Hooda Jazbani Franquicia De Lozada Viajes', 'BUSINESS', '1G', '11375516I', '2020-03-04 05:20:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3008BO6801UQ696', 'FBBQ63', 'ESTUDIOS', 0.02, '2016-11-30 04:39:46', 1991.25, 'DIGITAL', 'Renzo Salvador De Pasquele Natel Franquicia De Babel', 'TURISTA', '08D', '80131381X', '2016-11-30 11:39:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5206HD0305WM942', 'HFNH23', 'ESTUDIOS', 0.01, '2016-08-29 15:23:54', 1068.39, 'FISICO', 'Meduni', 'TURISTA', '77B', '29703831K', '2016-08-30 20:23:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8497ET7861JL075', 'BITY64', 'TRABAJO', 0.64, '2015-11-01 03:53:00', 1347.55, 'FISICO', 'Rincon Andino', 'BUSINESS', '8G', '37398296C', '2015-11-03 06:53:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6861RW9435CT724', 'GLRK17', 'TRABAJO', 0.26, '2019-01-28 01:04:57', 3330.17, 'DIGITAL', 'Asoc. Mutual Telefonica Buenos Aires', 'PREFERENTE', '76G', '18993101I', '2019-01-28 14:04:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3888LJ2810EM750', 'SPZZ25', 'TRABAJO', 0.66, '2020-06-18 11:48:37', 1480.77, 'DIGITAL', 'Argentina Vision Servicios Turisticos', 'PREFERENTE', '67F', '02382074A', '2020-06-19 15:48:37');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9205EQ6148FG619', 'HHYG24', 'ESTUDIOS', 0.25, '2020-03-26 19:14:56', 1937.31, 'FISICO', 'Viajes Y Turismo Avenida', 'TURISTA', '6G', '20250544Z', '2020-03-27 22:14:56');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2012EH1815AE114', 'AGLS23', 'ESTUDIOS', 0.31, '2016-06-22 07:14:31', 3483.66, 'FISICO', 'Estacion Pasajes', 'TURISTA', '65D', '85659619A', '2016-06-24 15:14:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7726QJ7150BL290', 'UOVP34', 'ESTUDIOS', 0.34, '2018-07-21 09:05:52', 2566.83, 'DIGITAL', 'Andalgala Turismo', 'BUSINESS', '46G', '22012118W', '2018-07-23 10:05:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1053SS1070CX881', 'ZXWK14', 'TRABAJO', 0.24, '2019-06-03 08:01:38', 1658.12, 'DIGITAL', 'Ramon Martin Travel Service', 'TURISTA', '00G', '55581377B', '2019-06-03 18:01:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5552OE5995QN000', 'OGPE49', 'TRABAJO', 0.02, '2017-02-26 20:07:32', 3103.84, 'FISICO', 'Rigazio Viajes', 'PREFERENTE', '66G', '45199729Q', '2017-02-27 13:07:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3794RM4111BR738', 'NMEZ13', 'OCIO', 0.14, '2020-01-02 13:17:57', 3729.76, 'FISICO', 'Secon Turismo', 'TURISTA', '6D', '65736826L', '2020-01-03 14:17:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6344GV3329UB146', 'QIMW93', 'OCIO', 0.4, '2020-05-04 14:04:12', 1663.29, 'FISICO', 'Ineltur', 'BUSINESS', '9A', '99591663Y', '2020-05-05 01:04:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2820FB7244PO699', 'EXUZ88', 'OCIO', 0.56, '2017-02-23 21:02:48', 881.53, 'FISICO', 'La Cienaga E.V.T.', 'PREFERENTE', '3G', '51977060S', '2017-02-24 04:02:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4152CU6274SA912', 'CSFK29', 'OCIO', 0.27, '2020-05-13 14:45:31', 1860.77, 'FISICO', 'Torremolinos Viajes', 'TURISTA', '97G', '84661096R', '2020-05-16 02:45:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8908IV3893JU570', 'IFJY90', 'ESTUDIOS', 0.16, '2019-03-12 07:57:41', 1771.46, 'FISICO', 'Biscayne Travel', 'PREFERENTE', '3G', '05016607S', '2019-03-14 08:57:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2463HX3504DI546', 'NHFN54', 'OCIO', 0.33, '2017-11-09 05:48:50', 2631.94, 'DIGITAL', 'Bairesfun', 'TURISTA', '8G', '84661096R', '2017-11-09 15:48:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9035PH3677MC501', 'QWTL72', 'ESTUDIOS', 0.06, '2020-02-08 03:56:00', 2625.83, 'DIGITAL', 'Ichimaye Turismo Internacional', 'BUSINESS', '0G', '07558371D', '2020-02-08 11:56:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9753MT4816HX026', 'YUBX74', 'ESTUDIOS', 0.1, '2016-02-18 05:41:33', 356.45, 'DIGITAL', 'Mundigea', 'TURISTA', '79B', '19767799D', '2016-02-19 01:41:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7166JJ0925ZX558', 'WQZN84', 'TRABAJO', 0.39, '2019-09-18 04:30:07', 285.04, 'DIGITAL', 'Coach De Viajes', 'BUSINESS', '19G', '83743817J', '2019-09-20 11:30:07');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3272TQ2871SV635', 'QCYE85', 'ESTUDIOS', 0.26, '2019-10-06 23:21:27', 2857.36, 'DIGITAL', 'Terratours', 'BUSINESS', '2C', '18188016E', '2019-10-07 18:21:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8105SI9312DB928', 'AZRE73', 'OCIO', 0.28, '2020-04-02 13:55:31', 639.46, 'DIGITAL', 'Alihuen Turismo', 'BUSINESS', '5G', '90909458T', '2020-04-04 07:55:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3082VL3306GU190', 'FZIF20', 'OCIO', 0.37, '2015-11-08 00:14:53', 1342.62, 'DIGITAL', 'Club Atletico Peñarol Mutual Social Y Biblioteca', 'BUSINESS', '83G', '47938670T', '2015-11-08 22:14:53');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2637BF2585RR215', 'MWNE39', 'ESTUDIOS', 0.44, '2018-12-01 05:36:26', 1946.83, 'FISICO', 'F Y A Tour', 'PREFERENTE', '35G', '88353701Y', '2018-12-02 04:36:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7171YI1301FW674', 'LAXW57', 'OCIO', 0.5, '2019-07-06 20:37:11', 3987.77, 'DIGITAL', 'Euforia Viajes', 'BUSINESS', '83B', '57769934B', '2019-07-07 22:37:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5239NB5317VD894', 'IFFE27', 'ESTUDIOS', 0.45, '2018-04-28 08:26:59', 913.85, 'FISICO', 'Vulture Viajes Franquicia De Almundo.Com', 'BUSINESS', '3G', '74018986T', '2018-04-30 11:26:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5039YF0951YO870', 'PFWH88', 'ESTUDIOS', 0.45, '2016-12-25 08:39:14', 2717.07, 'DIGITAL', 'Incauca Turismo', 'TURISTA', '2G', '70878793O', '2016-12-25 21:39:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5874RW8052VD484', 'YNOG42', 'OCIO', 0.57, '2016-03-15 21:22:31', 2418.23, 'DIGITAL', 'Mandaí Travel', 'BUSINESS', '3G', '01729342J', '2016-03-16 12:22:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3290BW2571DV658', 'RZZR30', 'ESTUDIOS', 0.41, '2019-12-02 15:44:48', 3191.97, 'DIGITAL', 'Nativo Viajes', 'PREFERENTE', '9G', '17736845Y', '2019-12-04 23:44:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3827IO5992EM339', 'UHQY43', 'ESTUDIOS', 0.58, '2018-12-01 10:22:17', 1242.88, 'DIGITAL', 'Choike Tour', 'TURISTA', '60G', '93205706M', '2018-12-03 12:22:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6837XC9114JL313', 'PDOC41', 'OCIO', 0.29, '2016-01-06 16:10:58', 3192.94, 'FISICO', 'New Port', 'PREFERENTE', '3G', '95924257Q', '2016-01-07 10:10:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0803DX3193XY284', 'IFFE27', 'TRABAJO', 0.66, '2018-06-23 07:26:59', 913.85, 'FISICO', 'Chateaux Viajes', 'BUSINESS', '1G', '67716684G', '2018-06-24 01:26:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0649HD8433PN530', 'KQIR04', 'OCIO', 0.25, '2018-11-06 19:54:00', 1547.88, 'FISICO', 'Velazco Tur', 'PREFERENTE', '84D', '13640802Z', '2018-11-07 11:54:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2693LN9580TP312', 'RJDX79', 'TRABAJO', 0.15, '2020-07-01 05:24:21', 1684.81, 'DIGITAL', 'Battistotti Turismo', 'PREFERENTE', '09F', '18861987Z', '2020-07-03 08:24:21');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6913EZ1325FO240', 'QWTL72', 'TRABAJO', 0.38, '2020-03-14 21:56:00', 2625.83, 'FISICO', 'Look Travel', 'PREFERENTE', '78G', '17736845Y', '2020-03-15 23:56:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8948SC0360OY713', 'TKUR44', 'TRABAJO', 0.69, '2017-07-11 08:12:21', 2814.08, 'FISICO', 'Salseando', 'TURISTA', '1G', '03709449R', '2017-07-12 08:12:21');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3123QP7337EU183', 'VJZY24', 'ESTUDIOS', 0.63, '2019-11-21 19:24:14', 146.37, 'DIGITAL', 'Martin Ferro Viajes', 'BUSINESS', '1F', '57677201C', '2019-11-22 16:24:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6166ZI2102SZ876', 'ZXWK14', 'TRABAJO', 0.36, '2019-05-06 18:01:38', 1658.12, 'FISICO', 'Ro-Ca Tours', 'BUSINESS', '18G', '07558371D', '2019-05-07 21:01:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2465JM5815ET964', 'VJYM37', 'TRABAJO', 0.47, '2018-03-03 09:29:28', 3735.46, 'FISICO', 'Interlands', 'BUSINESS', '39G', '56904806S', '2018-03-04 14:29:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8683QE3104EE774', 'JKRA16', 'TRABAJO', 0.54, '2017-08-22 21:40:52', 2456.3, 'DIGITAL', 'Turismo Efectivo', 'BUSINESS', '18G', '79146442D', '2017-08-25 09:40:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4052UE1592ZC911', 'ASDD87', 'ESTUDIOS', 0.17, '2020-03-20 08:41:48', 2143.15, 'FISICO', 'Planeta Azul Viajes', 'PREFERENTE', '85G', '45137271Y', '2020-03-20 20:41:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1022TG9690CU305', 'IAOP75', 'TRABAJO', 0.6, '2016-05-02 01:34:46', 749, 'FISICO', 'Turismo Monte Maiz', 'BUSINESS', '3F', '28928594D', '2016-05-04 10:34:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1723OJ2244BW966', 'HWJT73', 'OCIO', 0.34, '2019-07-20 14:48:40', 2988.2, 'DIGITAL', 'Ruta Del Oro', 'PREFERENTE', '5G', '31358662D', '2019-07-21 02:48:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2581GO9017RB642', 'OSZA17', 'ESTUDIOS', 0.56, '2017-01-26 03:18:37', 2070.3, 'DIGITAL', 'Viaje Listo', 'BUSINESS', '43G', '46113088B', '2017-01-26 10:18:37');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5812QF4223KS782', 'PFXI95', 'TRABAJO', 0.6, '2019-02-23 18:47:02', 3546.74, 'DIGITAL', 'Ele7', 'TURISTA', '60G', '46113088B', '2019-02-25 15:47:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6750CX8958PT689', 'DCVW95', 'TRABAJO', 0.12, '2018-04-04 13:43:04', 700.44, 'FISICO', 'Interlatina Travel', 'TURISTA', '1C', '30537638Q', '2018-04-05 05:43:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2542WX6912YT978', 'DYZX90', 'ESTUDIOS', 0.0, '2016-04-13 19:17:05', 1647.02, 'DIGITAL', 'Management Of Pleasure', 'TURISTA', '9F', '14970824X', '2016-04-16 00:17:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6779LZ3052LU436', 'JCYH85', 'ESTUDIOS', 0.19, '2020-02-19 20:35:24', 3025.27, 'DIGITAL', 'Turismo Certificado', 'TURISTA', '05G', '85659619A', '2020-02-20 11:35:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0654DP5082SE618', 'IHEZ97', 'ESTUDIOS', 0.06, '2016-05-18 02:10:45', 2128.85, 'FISICO', 'Rusell Travel', 'BUSINESS', '10G', '56443612Q', '2016-05-19 03:10:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5612RY3990LX473', 'UGLJ78', 'ESTUDIOS', 0.6, '2019-02-10 21:10:29', 3923.43, 'DIGITAL', 'Record Tour Viajes', 'TURISTA', '0D', '43167839X', '2019-02-12 09:10:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5114BS3071GA857', 'RODE77', 'ESTUDIOS', 0.41, '2018-10-11 13:41:34', 1221.7, 'FISICO', 'Alma Viajera', 'BUSINESS', '5D', '21597780C', '2018-10-13 23:41:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5758PI1428FV951', 'NKJM16', 'ESTUDIOS', 0.02, '2018-12-22 15:29:38', 2638.02, 'DIGITAL', 'Asociacion Mutual Del Control Integral (Amci)', 'TURISTA', '9A', '05014779K', '2018-12-25 00:29:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9609KN1497MZ587', 'BIII35', 'TRABAJO', 0.52, '2020-01-30 16:05:08', 2595.03, 'FISICO', 'Hi Fly Travel', 'TURISTA', '90F', '43914194N', '2020-01-31 22:05:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6029WY3171BI583', 'DLIC43', 'TRABAJO', 0.16, '2017-04-06 09:44:30', 570.5, 'DIGITAL', 'El Desvio Viajes Y Turismo', 'PREFERENTE', '1F', '73301916I', '2017-04-07 19:44:30');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9737JG4515BC845', 'MYEI41', 'OCIO', 0.11, '2016-03-13 07:58:42', 3004.81, 'DIGITAL', 'Giberti Tour', 'PREFERENTE', '8G', '13195673E', '2016-03-13 11:58:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7490TH3265OM822', 'PJQX48', 'OCIO', 0.43, '2020-03-07 17:32:17', 436.39, 'DIGITAL', 'Personaliza Tu Viaje', 'TURISTA', '0G', '30430995N', '2020-03-09 21:32:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2097OG6693SN787', 'HMXJ20', 'OCIO', 0.35, '2020-04-13 01:39:59', 2800.24, 'DIGITAL', 'Equilibrio Turismo', 'PREFERENTE', '71D', '65736826L', '2020-04-14 13:39:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1239VL4529AG263', 'WEGG85', 'ESTUDIOS', 0.45, '2019-06-02 07:19:56', 2068.67, 'DIGITAL', 'Viajes Inolvidables San Luis Franquicia De Almundo.Com', 'BUSINESS', '97G', '84661096R', '2019-06-03 13:19:56');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0071QF2484EE598', 'ZUUK25', 'TRABAJO', 0.61, '2017-09-11 12:08:42', 525.64, 'DIGITAL', 'Yanasus', 'PREFERENTE', '3G', '92956925I', '2017-09-12 23:08:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2075GZ0794PN480', 'LRMA21', 'OCIO', 0.18, '2019-11-06 12:03:56', 1533.39, 'DIGITAL', 'Turismo Ma - Li - Yo', 'PREFERENTE', '6C', '53937246W', '2019-11-07 18:03:56');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2866DL0176CU534', 'WLDA27', 'ESTUDIOS', 0.23, '2018-04-10 17:35:57', 1387.98, 'DIGITAL', 'Valinor Viajes Y Turismo', 'PREFERENTE', '7G', '69536241W', '2018-04-11 00:35:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7510GJ5733KA507', 'EPDS39', 'OCIO', 0.38, '2016-03-23 00:54:49', 2591.85, 'FISICO', 'Organfur S.A.', 'TURISTA', '1F', '12623557E', '2016-03-23 14:54:49');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0097QZ8634ML244', 'DTER96', 'OCIO', 0.43, '2017-01-30 03:07:50', 2137.95, 'FISICO', 'Aventura Jungle', 'TURISTA', '23G', '43914194N', '2017-01-30 17:07:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4978DH6975EL122', 'EDZM72', 'TRABAJO', 0.18, '2020-01-02 00:13:32', 256.14, 'FISICO', 'Portobello Viajes Y Turismo', 'TURISTA', '3G', '55581377B', '2020-01-04 06:13:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9648VF3968YA280', 'XCAF34', 'OCIO', 0.47, '2017-05-10 18:29:48', 2054.93, 'DIGITAL', 'Opus Viajes', 'TURISTA', '2G', '58496330S', '2017-05-12 11:29:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1541JZ0667JC047', 'RZZR30', 'TRABAJO', 0.19, '2019-09-20 01:44:48', 3191.97, 'DIGITAL', 'Tierras Andinas', 'BUSINESS', '97C', '16615308B', '2019-09-20 23:44:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3250AY2394BG169', 'YEJT71', 'OCIO', 0.48, '2018-10-26 04:23:58', 2289.75, 'DIGITAL', 'La Perla Del Oeste Viajes', 'TURISTA', '8F', '14970824X', '2018-10-28 10:23:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6038SG2425GR090', 'FMMO08', 'OCIO', 0.49, '2020-09-14 18:34:47', 3128.53, 'FISICO', 'Swimming Actividades Recreativas', 'TURISTA', '1D', '31370859H', '2020-09-14 23:34:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5358ET6493YO297', 'TMZG07', 'TRABAJO', 0.56, '2020-05-29 01:28:36', 3064.96, 'FISICO', 'Huella De Viaje', 'PREFERENTE', '9G', '31649376I', '2020-05-30 04:28:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2255OU2179GG353', 'RAWG18', 'OCIO', 0.36, '2019-01-11 18:08:20', 2954.73, 'DIGITAL', 'Cospatur', 'BUSINESS', '1G', '24007893U', '2019-01-13 14:08:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6897CX6383LI113', 'TTCD02', 'ESTUDIOS', 0.14, '2019-04-15 02:42:33', 1516.92, 'DIGITAL', 'Nap Travel', 'BUSINESS', '5F', '93990482O', '2019-04-15 21:42:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4016LC6012NA757', 'ITZR09', 'TRABAJO', 0.07, '2016-06-14 13:06:51', 3022.27, 'FISICO', 'Gray Line Argentina', 'BUSINESS', '4G', '00247726I', '2016-06-14 22:06:51');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8773LT9163KH204', 'TVCQ23', 'TRABAJO', 0.01, '2018-04-24 00:38:26', 3379.86, 'FISICO', 'Relieve Turistico Latinoamerica', 'BUSINESS', '4F', '56904806S', '2018-04-25 03:38:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6783DQ1393YU805', 'ZIHC06', 'TRABAJO', 0.44, '2020-03-03 10:51:52', 897.65, 'DIGITAL', 'Diwali Servicios Turisticos', 'TURISTA', '59D', '74018986T', '2020-03-04 21:51:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0106DU9405PQ274', 'TZOP68', 'TRABAJO', 0.56, '2016-05-31 02:16:07', 2631.64, 'DIGITAL', 'En4D', 'TURISTA', '25G', '97814136Q', '2016-06-01 10:16:07');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7365MT6818UE215', 'BIII35', 'TRABAJO', 0.44, '2020-01-26 18:05:08', 2595.03, 'DIGITAL', 'Momento De Viaje', 'BUSINESS', '42F', '43167839X', '2020-01-29 02:05:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7526PM8350XL054', 'MKSS58', 'TRABAJO', 0.08, '2019-07-12 03:54:36', 3111.24, 'DIGITAL', 'Sold Out Travel Service', 'PREFERENTE', '0G', '58982427V', '2019-07-12 18:54:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9920RJ7364AU844', 'DOAW38', 'ESTUDIOS', 0.49, '2017-01-14 08:57:40', 1418.52, 'FISICO', 'Agencia Santa Maria - Servicio Mundial De Viajes', 'TURISTA', '90G', '27278555E', '2017-01-16 01:57:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4476BB8230SD438', 'DYJL03', 'OCIO', 0.53, '2020-04-08 22:28:31', 1873.76, 'FISICO', 'Marcela Clemente Viajes & Turismo', 'BUSINESS', '2F', '40035120C', '2020-04-09 06:28:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3610WQ0995TR121', 'QWTL72', 'ESTUDIOS', 0.59, '2020-03-18 05:56:00', 2625.83, 'DIGITAL', 'Cambio Excursiones Turismo Columbus S.A.', 'BUSINESS', '79D', '43167839X', '2020-03-18 09:56:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8397LP9370YC025', 'UHBN56', 'OCIO', 0.61, '2018-03-16 09:27:14', 2066.64, 'DIGITAL', 'Tazed Viajes', 'TURISTA', '5D', '57403366Q', '2018-03-18 09:27:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9116JL0709GG808', 'PHJF98', 'ESTUDIOS', 0.16, '2019-02-19 03:53:42', 1964.74, 'FISICO', 'Long Travel', 'PREFERENTE', '35D', '68643919X', '2019-02-20 16:53:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1399KO4749MV221', 'COFA89', 'ESTUDIOS', 0.52, '2017-12-07 19:14:48', 1995.36, 'DIGITAL', 'Arrow Tours', 'PREFERENTE', '43G', '88975906N', '2017-12-09 21:14:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2459OT5584GS204', 'FMIM89', 'ESTUDIOS', 0.67, '2017-06-30 21:14:24', 419.84, 'DIGITAL', 'Siacia Turismo', 'TURISTA', '2F', '97067662H', '2017-07-02 17:14:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5267NW5776EJ407', 'VENK46', 'TRABAJO', 0.02, '2017-08-29 04:47:44', 62.08, 'DIGITAL', 'Olas De Luna', 'PREFERENTE', '4G', '26807992N', '2017-08-31 05:47:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4659CJ2072TA672', 'LIVI96', 'TRABAJO', 0.36, '2018-07-26 20:55:19', 3413.96, 'DIGITAL', 'Portobello Viajes Y Turismo', 'TURISTA', '08G', '95924257Q', '2018-07-27 18:55:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9097XY6253YX567', 'PFWH88', 'TRABAJO', 0.25, '2017-02-25 17:39:14', 2717.07, 'DIGITAL', 'Marianela Viajes', 'PREFERENTE', '44F', '50150286R', '2017-02-26 08:39:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5110MR3802ZU750', 'VENK46', 'OCIO', 0.31, '2017-10-05 22:47:44', 62.08, 'FISICO', 'Jacaranda Viajes Y Turismo', 'PREFERENTE', '91G', '07558371D', '2017-10-08 04:47:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0688OD3482PX106', 'HYAU76', 'OCIO', 0.05, '2016-01-08 18:19:28', 2943.59, 'DIGITAL', 'Tigre Trans S.A.', 'TURISTA', '3G', '58496330S', '2016-01-10 21:19:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2722WT6390KM073', 'QPOI93', 'OCIO', 0.47, '2019-07-02 20:28:48', 1269.45, 'DIGITAL', 'Metzer Travel', 'PREFERENTE', '5G', '84848139W', '2019-07-03 15:28:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6466MS3079KS554', 'QPOI93', 'ESTUDIOS', 0.22, '2019-06-13 21:28:48', 1269.45, 'FISICO', 'C''Est La Vie', 'TURISTA', '8F', '47946012S', '2019-06-15 18:28:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8089LT0240FQ965', 'SBOT11', 'ESTUDIOS', 0.56, '2020-02-26 09:46:28', 1584.19, 'DIGITAL', 'Salamoneviajes.Com Franquicia De Reservando Viajes', 'PREFERENTE', '43F', '00665573L', '2020-02-28 12:46:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1307PP2031CJ641', 'GESN89', 'TRABAJO', 0.06, '2019-12-26 08:29:10', 1511.34, 'FISICO', 'Club Atletico Y Biblioteca Sarmiento Asoc. Mutual', 'BUSINESS', '2G', '06780561G', '2019-12-27 10:29:10');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2569QM5648YI351', 'UABQ51', 'TRABAJO', 0.01, '2019-05-27 17:40:45', 206.61, 'DIGITAL', 'Utopia Viajes & Turismo', 'PREFERENTE', '3F', '61436494H', '2019-05-30 02:40:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2731CH3224LZ549', 'FSIO41', 'ESTUDIOS', 0.06, '2020-08-30 12:04:42', 3215.24, 'FISICO', 'Testigo Viajes', 'TURISTA', '7G', '20185493S', '2020-08-30 23:04:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1202PR1652ZW358', 'EHKQ48', 'TRABAJO', 0.18, '2017-07-29 20:07:58', 2971.75, 'FISICO', 'Las Del Valle', 'TURISTA', '82F', '94342268B', '2017-07-31 07:07:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1165HL8744QS710', 'ZKUR76', 'OCIO', 0.5, '2018-11-02 22:07:13', 871.9, 'DIGITAL', 'Sin Distancias', 'TURISTA', '47G', '25886038L', '2018-11-03 14:07:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6925DF8308BJ148', 'MJZB56', 'ESTUDIOS', 0.43, '2019-06-12 01:55:41', 3055.78, 'FISICO', 'Calvete Viajes', 'BUSINESS', '98G', '74256620Q', '2019-06-13 04:55:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1259PX2279TI973', 'PFXI95', 'ESTUDIOS', 0.6, '2019-01-18 06:47:02', 3546.74, 'DIGITAL', 'Pasajes Ya', 'TURISTA', '4G', '47946012S', '2019-01-18 13:47:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0208SX8054YF544', 'VENK46', 'ESTUDIOS', 0.53, '2017-09-20 23:47:44', 62.08, 'FISICO', 'La Araucana Viajes', 'BUSINESS', '7G', '36802529Q', '2017-09-22 10:47:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1302BJ3178BC242', 'YLXK34', 'TRABAJO', 0.58, '2017-02-08 01:49:15', 1275.81, 'DIGITAL', 'Zinnia Travel Agency', 'TURISTA', '53D', '65736826L', '2017-02-09 18:49:15');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7681XM2961UK427', 'OFZE14', 'TRABAJO', 0.25, '2018-02-12 13:51:34', 3136.92, 'DIGITAL', 'El Inmigrante Viajes Y Turismo', 'BUSINESS', '0A', '14970824X', '2018-02-13 17:51:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0825VE3585VB465', 'ORQA55', 'OCIO', 0.69, '2018-11-03 15:29:01', 876.27, 'FISICO', 'Jocoli E.V.T.', 'PREFERENTE', '6G', '20273199J', '2018-11-04 16:29:01');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1957PK3299PE791', 'WEIJ40', 'TRABAJO', 0.61, '2016-06-16 03:46:19', 48.51, 'FISICO', 'Yavitours Empresa De Viajes Y Turismo', 'TURISTA', '7G', '85328000E', '2016-06-16 16:46:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3580ZS9532ED275', 'TTCD02', 'TRABAJO', 0.52, '2019-07-10 11:42:33', 1516.92, 'DIGITAL', 'Terminal Rotonda De San Justo', 'PREFERENTE', '18F', '74527513B', '2019-07-12 16:42:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9673JW9001KH151', 'ABJW97', 'OCIO', 0.66, '2017-04-18 13:33:43', 3918.23, 'FISICO', 'Blue Scarlet Travel', 'TURISTA', '39F', '43914194N', '2017-04-20 08:33:43');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6671ND7969MO468', 'VHLA57', 'TRABAJO', 0.52, '2017-10-04 12:41:04', 1004.9, 'DIGITAL', 'Gagliano Viajes', 'PREFERENTE', '8G', '12623557E', '2017-10-04 17:41:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8436BH2108HB115', 'VCJZ68', 'ESTUDIOS', 0.28, '2020-07-20 10:23:06', 3265.97, 'FISICO', 'Hunter Travel', 'BUSINESS', '1G', '82767796L', '2020-07-22 06:23:06');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9562NE5987IB262', 'XJKP61', 'ESTUDIOS', 0.28, '2017-08-09 01:25:20', 3314.13, 'DIGITAL', 'Capolinea', 'TURISTA', '18F', '58435558H', '2017-08-09 19:25:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7747SV1947ZP286', 'LEJC58', 'TRABAJO', 0.64, '2020-05-11 23:10:19', 3618.11, 'DIGITAL', 'Turismo De Castro', 'TURISTA', '5G', '93990482O', '2020-05-12 04:10:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8373MO9488OD393', 'LAXW57', 'OCIO', 0.28, '2019-06-27 13:37:11', 3987.77, 'DIGITAL', 'Live It Tours', 'BUSINESS', '20C', '58982427V', '2019-06-28 19:37:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9314YH9139JG580', 'WLQD61', 'TRABAJO', 0.4, '2020-03-08 20:20:50', 1415.57, 'DIGITAL', 'Monumental Travel', 'BUSINESS', '57D', '19767799D', '2020-03-09 10:20:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7538OA6434NB551', 'YXKY51', 'ESTUDIOS', 0.33, '2018-03-02 14:24:33', 18.55, 'FISICO', 'Tivoli Turismo', 'TURISTA', '18F', '12623557E', '2018-03-04 16:24:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9458EL2159LL562', 'GLRK17', 'TRABAJO', 0.51, '2019-01-01 12:04:57', 3330.17, 'FISICO', 'Mauro Andreoli Viajes', 'BUSINESS', '87F', '29838624Z', '2019-01-03 12:04:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3240WK5477JZ780', 'ZVRX24', 'ESTUDIOS', 0.07, '2019-07-20 13:33:00', 3305.22, 'FISICO', 'Ami Tour S.R.L.', 'TURISTA', '8A', '24007893U', '2019-07-21 20:33:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4968QG1483KY563', 'KKXL78', 'OCIO', 0.54, '2018-04-16 21:37:12', 2837.91, 'FISICO', 'Andiamo Viajes Y Turismo', 'BUSINESS', '4G', '57621195S', '2018-04-17 20:37:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0727WT2564OD325', 'SSZE98', 'TRABAJO', 0.54, '2020-02-11 07:54:54', 2948.83, 'DIGITAL', 'Vida Libre Turismo', 'PREFERENTE', '1F', '92140486L', '2020-02-11 13:54:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9187PF5217SX245', 'TPTJ79', 'OCIO', 0.61, '2016-06-18 00:13:06', 1522.83, 'FISICO', 'Atrevete Viajes', 'PREFERENTE', '7G', '80131381X', '2016-06-20 09:13:06');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5903KO8597RA429', 'QVYE27', 'TRABAJO', 0.56, '2020-05-06 02:40:54', 1528.7, 'FISICO', 'Maintravel Productora De Viajes', 'TURISTA', '1B', '45199729Q', '2020-05-08 10:40:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0579YU6892YC896', 'WGSB43', 'ESTUDIOS', 0.32, '2019-03-14 23:56:44', 3083.75, 'DIGITAL', 'Malawii', 'PREFERENTE', '8F', '35493398N', '2019-03-15 12:56:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6683UI7361DE374', 'MKSS58', 'TRABAJO', 0.49, '2019-05-03 09:54:36', 3111.24, 'DIGITAL', 'Vaya Pasajes Y Turismo', 'TURISTA', '1F', '14970824X', '2019-05-05 07:54:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6568XJ9669PF246', 'TTCD02', 'OCIO', 0.25, '2019-06-26 09:42:33', 1516.92, 'DIGITAL', 'Laboratorio De Viajes', 'TURISTA', '9G', '28928594D', '2019-06-28 12:42:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5619YS9308SG154', 'ZIHC06', 'TRABAJO', 0.26, '2020-02-27 11:51:52', 897.65, 'DIGITAL', 'Recsa Viajes Y Turismo', 'BUSINESS', '12G', '05694407T', '2020-02-29 05:51:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0216IM5496NZ457', 'QMES51', 'ESTUDIOS', 0.07, '2016-09-17 12:13:54', 2397.03, 'FISICO', 'Mojon Viajes Turismo', 'TURISTA', '9G', '07055242C', '2016-09-19 13:13:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4242ZD3143CG222', 'PFXI95', 'OCIO', 0.18, '2019-02-07 03:47:02', 3546.74, 'DIGITAL', 'Zigiotto Viajes', 'BUSINESS', '39G', '84848139W', '2019-02-09 09:47:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6605AW1150BF543', 'DCVW95', 'TRABAJO', 0.52, '2018-04-19 13:43:04', 700.44, 'DIGITAL', 'Principios Tour Operator', 'PREFERENTE', '44G', '51977060S', '2018-04-21 16:43:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5275CD8103TE983', 'QWTL72', 'OCIO', 0.15, '2020-03-22 18:56:00', 2625.83, 'DIGITAL', 'Susanj Travel', 'TURISTA', '7G', '58435558H', '2020-03-23 16:56:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7043IU2392EE805', 'QVYE27', 'OCIO', 0.55, '2020-04-22 15:40:54', 1528.7, 'DIGITAL', 'Dejate Llevar Viajes Y Turismo', 'PREFERENTE', '96G', '03399464U', '2020-04-23 20:40:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5375VC4095BJ396', 'SBOT11', 'ESTUDIOS', 0.45, '2020-03-13 18:46:28', 1584.19, 'DIGITAL', 'Veronica Rossi Tours & Travel', 'BUSINESS', '56G', '98147633H', '2020-03-14 20:46:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0972NY8209MC016', 'TIOU71', 'ESTUDIOS', 0.24, '2016-11-15 18:04:19', 1773.31, 'FISICO', 'Enio Zampieri Franquicia De Viajes Tdh', 'TURISTA', '65G', '58496330S', '2016-11-18 04:04:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6255OV2539VZ507', 'YLLK55', 'OCIO', 0.03, '2018-02-03 00:46:09', 1561.64, 'DIGITAL', 'Cratos', 'TURISTA', '5G', '82767796L', '2018-02-03 07:46:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7983KT5055LI559', 'WCUU03', 'TRABAJO', 0.04, '2018-12-09 22:21:08', 3233.74, 'FISICO', 'Asociacion Calabresa - Mutual Y Cultural', 'PREFERENTE', '12B', '38013653B', '2018-12-11 21:21:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2884XT7404DA459', 'UEEN55', 'ESTUDIOS', 0.44, '2016-01-31 20:21:24', 251.05, 'DIGITAL', 'Bairesfun', 'BUSINESS', '39F', '11375516I', '2016-02-01 22:21:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0205BA0956GD291', 'BMGX81', 'ESTUDIOS', 0.09, '2020-04-15 17:34:19', 169.31, 'DIGITAL', 'Buen Viaje', 'TURISTA', '3G', '18993101I', '2020-04-17 03:34:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3374AC7642TS500', 'ERIC29', 'OCIO', 0.53, '2019-06-08 16:58:14', 927.52, 'DIGITAL', 'De Ramona Al Mundo Viajes', 'BUSINESS', '1G', '05016607S', '2019-06-09 09:58:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3865QV5159HJ392', 'IAOP75', 'OCIO', 0.42, '2016-04-20 00:34:46', 749, 'FISICO', 'Las Canteras Turismo', 'PREFERENTE', '2G', '13195673E', '2016-04-21 12:34:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8678SN0072HK106', 'AGIX19', 'ESTUDIOS', 0.05, '2017-07-06 00:35:59', 2618.3, 'FISICO', 'Misiones Maravilla', 'TURISTA', '8G', '69239536K', '2017-07-06 21:35:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4573LB8031CR621', 'VKVA87', 'OCIO', 0.14, '2020-05-20 20:30:59', 2765.37, 'DIGITAL', 'Try By Train Franquicia De Almundo.Com', 'BUSINESS', '0B', '31370859H', '2020-05-21 17:30:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6133KJ5522TD047', 'LAXW57', 'OCIO', 0.05, '2019-07-12 14:37:11', 3987.77, 'DIGITAL', 'Kabambu', 'TURISTA', '99F', '74018986T', '2019-07-13 06:37:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4583EO6459XM811', 'ITZR09', 'OCIO', 0.35, '2016-05-09 16:06:51', 3022.27, 'DIGITAL', 'Msc Cruceros', 'BUSINESS', '3A', '67716684G', '2016-05-11 15:06:51');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4732MV8562LZ335', 'DXSW04', 'ESTUDIOS', 0.19, '2016-01-20 01:31:45', 3389.92, 'FISICO', 'Epsilon Travel', 'TURISTA', '5G', '58844888I', '2016-01-20 22:31:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0680ET9205UC808', 'GKLW48', 'TRABAJO', 0.39, '2016-07-03 04:29:55', 1375.21, 'FISICO', 'Serie 1 Viajes', 'BUSINESS', '33G', '14970824X', '2016-07-04 19:29:55');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5722EE1330OX924', 'DRSJ42', 'OCIO', 0.1, '2018-11-11 05:40:29', 3856.14, 'FISICO', 'Marrakech Travel', 'PREFERENTE', '84F', '69360637Z', '2018-11-11 19:40:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1455NY8983GP434', 'OHPA97', 'OCIO', 0.07, '2017-07-25 03:04:06', 1442.85, 'FISICO', 'Coffee & Travel', 'PREFERENTE', '7F', '40035120C', '2017-07-25 22:04:06');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1436OS1726UX929', 'ERUX27', 'TRABAJO', 0.65, '2017-09-20 18:21:50', 325.01, 'FISICO', 'Turismo Merlot', 'BUSINESS', '3G', '89255796Y', '2017-09-21 04:21:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8713PJ0329ZL210', 'ABJW97', 'ESTUDIOS', 0.25, '2017-05-22 06:33:43', 3918.23, 'FISICO', 'Moon Travel', 'PREFERENTE', '4G', '84848139W', '2017-05-24 10:33:43');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0286DJ3128EG627', 'YLNP53', 'OCIO', 0.22, '2019-09-20 00:11:32', 962.18, 'FISICO', 'Aventura & Wine Viajes', 'TURISTA', '43F', '37900304M', '2019-09-21 08:11:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2909OB0719PL196', 'OFZE14', 'TRABAJO', 0.39, '2018-01-16 16:51:34', 3136.92, 'DIGITAL', 'Ferrero Viajes', 'TURISTA', '93G', '09904890A', '2018-01-18 05:51:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3544TC4566LB031', 'BFZC92', 'TRABAJO', 0.24, '2018-05-22 04:46:55', 1757.03, 'FISICO', 'E.T.I.C.A.', 'PREFERENTE', '04F', '97067662H', '2018-05-22 14:46:55');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0306YR5951XU477', 'EXUZ88', 'ESTUDIOS', 0.43, '2017-02-01 03:02:48', 881.53, 'DIGITAL', 'Elegant Tour', 'PREFERENTE', '7G', '94489726X', '2017-02-02 01:02:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7949EM8602QZ660', 'AVWK23', 'OCIO', 0.5, '2016-12-30 12:57:05', 2569.42, 'FISICO', 'Epsilon Travel', 'BUSINESS', '76G', '79146442D', '2016-12-30 18:57:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3239RK9447EK397', 'UOVP34', 'OCIO', 0.31, '2018-07-29 16:05:52', 2566.83, 'FISICO', 'Tahiti Travel', 'PREFERENTE', '62G', '59643079M', '2018-07-31 18:05:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3688TP0386XJ926', 'VUTE09', 'OCIO', 0.1, '2017-01-31 05:33:27', 172.85, 'DIGITAL', 'Politour', 'PREFERENTE', '8G', '19767799D', '2017-02-02 17:33:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0854SD5494OG990', 'QMES51', 'ESTUDIOS', 0.58, '2016-09-25 15:13:54', 2397.03, 'DIGITAL', 'Tchau Travel', 'TURISTA', '0F', '52839438O', '2016-09-27 21:13:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4534TD5250EF423', 'ZXOY75', 'ESTUDIOS', 0.17, '2019-07-07 06:27:01', 199.62, 'FISICO', 'Spamed Travel', 'TURISTA', '31G', '30737589B', '2019-07-07 17:27:01');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0654CG8707CK746', 'SSZE98', 'ESTUDIOS', 0.4, '2020-02-21 21:54:54', 2948.83, 'FISICO', 'Harbor Trip', 'PREFERENTE', '7D', '85328000E', '2020-02-22 08:54:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5808DA5614MJ378', 'KGXI36', 'OCIO', 0.64, '2016-12-01 01:41:29', 1001.18, 'FISICO', 'Banner Turismo', 'BUSINESS', '1G', '47946012S', '2016-12-02 09:41:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5718MK9079SD631', 'ZBZL28', 'OCIO', 0.09, '2018-08-07 03:04:51', 159.19, 'FISICO', 'Inedita Servicios Turisticos', 'PREFERENTE', '28G', '90909458T', '2018-08-07 19:04:51');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0065WW1415DU363', 'RZZR30', 'OCIO', 0.1, '2019-12-11 17:44:48', 3191.97, 'FISICO', 'Delfin Viajes Y Turismo', 'BUSINESS', '58G', '51788970Q', '2019-12-12 11:44:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2180CD0404QG358', 'EITC23', 'TRABAJO', 0.17, '2020-09-14 07:33:45', 3352.28, 'DIGITAL', 'Gateways Travel', 'TURISTA', '53F', '26491980A', '2020-09-15 00:33:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8419CO1415IB227', 'ORBN65', 'ESTUDIOS', 0.49, '2018-10-11 08:43:29', 2236.95, 'FISICO', 'Kazper', 'PREFERENTE', '71G', '25886038L', '2018-10-12 01:43:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7427JW5450UQ516', 'WBKB29', 'TRABAJO', 0.59, '2016-08-16 21:50:23', 2085.44, 'DIGITAL', 'Biarritz Evt', 'TURISTA', '50F', '61436494H', '2016-08-19 03:50:23');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7369IQ9911QI309', 'TIOU71', 'OCIO', 0.6, '2017-01-05 10:04:19', 1773.31, 'DIGITAL', 'Gema Tours', 'TURISTA', '18G', '37398296C', '2017-01-06 09:04:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8897LM4636LO734', 'TPPH81', 'OCIO', 0.61, '2018-07-04 10:00:05', 2299.11, 'FISICO', 'Buena Gente', 'BUSINESS', '8G', '07055242C', '2018-07-04 21:00:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8636PK9211HD078', 'JRXU57', 'TRABAJO', 0.61, '2017-08-04 03:24:32', 3191.18, 'FISICO', 'Eje Travel', 'BUSINESS', '9D', '30744361T', '2017-08-05 03:24:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8482AR3461ER041', 'CFOT07', 'ESTUDIOS', 0.23, '2020-04-08 15:26:40', 3739.02, 'FISICO', 'Suajili', 'PREFERENTE', '91G', '72816443M', '2020-04-10 16:26:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1828LU9189WR181', 'WEGG85', 'TRABAJO', 0.1, '2019-04-26 08:19:56', 2068.67, 'FISICO', 'Mdz Wine Tours', 'PREFERENTE', '66D', '92932216M', '2019-04-28 18:19:56');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0013FT3327XD480', 'EIPH16', 'ESTUDIOS', 0.43, '2017-04-27 15:19:32', 1076.7, 'FISICO', 'Asia Travel Service', 'TURISTA', '94G', '27848391E', '2017-04-28 13:19:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9306HS2507KE818', 'VCJZ68', 'TRABAJO', 0.12, '2020-06-09 05:23:06', 3265.97, 'FISICO', 'Oti Internacional', 'TURISTA', '8G', '92382459A', '2020-06-10 21:23:06');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7918HA9875CZ498', 'PLFX61', 'OCIO', 0.64, '2018-07-07 05:50:36', 1704.4, 'FISICO', 'El Brigadier', 'TURISTA', '4A', '82767796L', '2018-07-08 22:50:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7523RZ8467BY348', 'SJHN46', 'ESTUDIOS', 0.03, '2018-05-19 03:29:03', 117.08, 'FISICO', 'Rio Grande Viajes', 'PREFERENTE', '0F', '50150286R', '2018-05-20 21:29:03');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6378TN1217MX816', 'RZZR30', 'TRABAJO', 0.51, '2019-10-27 01:44:48', 3191.97, 'FISICO', 'Yes Travel', 'BUSINESS', '07F', '94342268B', '2019-10-27 21:44:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4613IK6729TJ932', 'PFVI63', 'TRABAJO', 0.49, '2019-10-15 23:50:22', 2011.63, 'FISICO', 'Asociacion Mutual 18 De Julio', 'BUSINESS', '2D', '06780561G', '2019-10-16 21:50:22');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4161AO5669EQ922', 'ZQDM59', 'OCIO', 0.41, '2018-07-08 20:41:37', 3767.91, 'DIGITAL', 'Operadores M.A.R.', 'PREFERENTE', '84D', '99591663Y', '2018-07-11 05:41:37');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4188WU6092OZ707', 'MWES29', 'TRABAJO', 0.49, '2019-05-09 14:22:02', 3711.13, 'FISICO', 'J. P. Bossa', 'BUSINESS', '05G', '16305315P', '2019-05-11 08:22:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3417NR2738JQ214', 'RVMV64', 'OCIO', 0.2, '2016-11-27 18:58:57', 1475.66, 'DIGITAL', 'Goya Turismo', 'PREFERENTE', '30G', '18861987Z', '2016-11-28 06:58:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7428FZ9521JD704', 'PDOC41', 'TRABAJO', 0.59, '2016-02-16 08:10:58', 3192.94, 'DIGITAL', 'Business Group Travel Brokers', 'TURISTA', '04F', '28368887A', '2016-02-18 06:10:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9403VU2168MW000', 'MIOD72', 'ESTUDIOS', 0.35, '2016-03-02 01:42:24', 3464.71, 'DIGITAL', 'Altero Turismo', 'PREFERENTE', '9G', '92382459A', '2016-03-02 23:42:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4433XP2566BE882', 'AGIX19', 'OCIO', 0.17, '2017-06-09 20:35:59', 2618.3, 'DIGITAL', 'Gooshe Aike', 'PREFERENTE', '7C', '53712077K', '2017-06-10 20:35:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7611EV4319LQ721', 'UBQU45', 'TRABAJO', 0.26, '2016-05-13 03:25:42', 1088.26, 'FISICO', 'Bottino Viajes', 'TURISTA', '03F', '72816443M', '2016-05-14 06:25:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5199FN8014WS197', 'VYDF62', 'OCIO', 0.38, '2016-01-11 08:06:17', 2261.61, 'DIGITAL', 'De Arma Viajes', 'TURISTA', '68B', '47946012S', '2016-01-13 09:06:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2746ZZ3069DW215', 'MFIK33', 'TRABAJO', 0.63, '2017-03-04 01:08:36', 2621.46, 'DIGITAL', 'Quo Vadis S.R.L.', 'TURISTA', '7F', '31238243H', '2017-03-05 16:08:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4405DT7685PI226', 'YFZL10', 'OCIO', 0.44, '2019-03-17 16:24:20', 1399.25, 'FISICO', 'Quantum Tour', 'TURISTA', '89G', '31370859H', '2019-03-19 05:24:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9156AW9963FW000', 'YMZO63', 'TRABAJO', 0.02, '2019-10-30 02:20:00', 2048.47, 'FISICO', 'Viajes Y Turismo Avenida', 'BUSINESS', '74G', '29703831K', '2019-11-01 10:20:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8085ET0812TH029', 'DOAW38', 'ESTUDIOS', 0.39, '2017-01-14 17:57:40', 1418.52, 'FISICO', 'Essenya', 'PREFERENTE', '8G', '35493398N', '2017-01-17 02:57:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1663JC2782WH402', 'OANP50', 'OCIO', 0.59, '2016-04-27 01:33:21', 1248.44, 'DIGITAL', 'Super Bus Operador Mayorista De Turismo', 'PREFERENTE', '9G', '07558371D', '2016-04-28 21:33:21');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5088AS1070SE752', 'WDXB61', 'TRABAJO', 0.45, '2019-10-03 23:15:04', 3642.86, 'FISICO', 'Maria Julia Avila Franquicia De One Trip', 'BUSINESS', '28F', '31649376I', '2019-10-04 21:15:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5881NF4651BD233', 'LWAF61', 'TRABAJO', 0.52, '2017-09-17 13:26:30', 3952.46, 'FISICO', 'R Y C', 'TURISTA', '2F', '56443612Q', '2017-09-19 11:26:30');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9917RF6377NM836', 'WGSB43', 'OCIO', 0.16, '2019-02-26 22:56:44', 3083.75, 'FISICO', 'Lidam Tour', 'PREFERENTE', '0F', '17576951C', '2019-02-27 03:56:44');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7045QM7109ZT205', 'FFDL03', 'TRABAJO', 0.63, '2020-01-26 21:53:54', 3227.33, 'DIGITAL', 'Venistur Viajes Y Turismo', 'TURISTA', '03F', '05694407T', '2020-01-28 08:53:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9883NV9220VA485', 'CSFK29', 'TRABAJO', 0.19, '2020-07-24 20:45:31', 1860.77, 'FISICO', 'Modo Turista Franquicia De Almundo.Com', 'PREFERENTE', '18D', '58496330S', '2020-07-26 01:45:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5259SO1708SV799', 'CFOT07', 'ESTUDIOS', 0.65, '2020-03-24 21:26:40', 3739.02, 'DIGITAL', 'Glenda Rocha Turismo', 'TURISTA', '40G', '80902946P', '2020-03-26 18:26:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2103UO5070VL164', 'UHQY43', 'ESTUDIOS', 0.67, '2018-12-24 11:22:17', 1242.88, 'DIGITAL', 'Siga Turismo', 'TURISTA', '66G', '20923495U', '2018-12-25 07:22:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0983FS6550ZE492', 'GOWS75', 'OCIO', 0.02, '2018-01-14 04:31:13', 558.38, 'FISICO', 'Interlude', 'PREFERENTE', '3G', '98147633H', '2018-01-15 13:31:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8117NN1484NM198', 'SRFF00', 'TRABAJO', 0.37, '2019-12-16 23:57:39', 3259.69, 'DIGITAL', 'Ailleurs Tours', 'PREFERENTE', '00D', '29703831K', '2019-12-17 20:57:39');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7384JF2473IZ173', 'IQZV46', 'TRABAJO', 0.31, '2018-08-27 17:40:50', 1214.42, 'FISICO', 'Jam Travel', 'PREFERENTE', '5F', '73494812M', '2018-08-28 11:40:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9524IC7442PA072', 'UHBN56', 'OCIO', 0.38, '2018-02-16 04:27:14', 2066.64, 'DIGITAL', 'Posho Quimey Tours Y Eventos', 'PREFERENTE', '22G', '16615308B', '2018-02-18 08:27:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6049UN4314MG501', 'TTCD02', 'ESTUDIOS', 0.49, '2019-06-13 07:42:33', 1516.92, 'FISICO', 'Chiodini Viajes', 'BUSINESS', '3B', '13195673E', '2019-06-15 03:42:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3788OS5758XQ169', 'RQKC37', 'OCIO', 0.52, '2019-08-02 20:48:59', 1341.37, 'DIGITAL', 'Orantur', 'BUSINESS', '9G', '61436494H', '2019-08-03 21:48:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9788YX7682XG858', 'WOYO27', 'ESTUDIOS', 0.56, '2018-05-24 19:37:45', 1492.09, 'FISICO', 'Zona Austral Turismo', 'PREFERENTE', '3G', '85654886A', '2018-05-27 02:37:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1515TQ8743ZE214', 'MFIK33', 'ESTUDIOS', 0.31, '2017-03-19 14:08:36', 2621.46, 'DIGITAL', 'Rico - Peru Travel', 'TURISTA', '8G', '84087080L', '2017-03-21 08:08:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4339ED8008MU847', 'NKJM16', 'TRABAJO', 0.23, '2018-12-12 17:29:38', 2638.02, 'DIGITAL', 'Asoc. Mutual De Los Socios Y Adherentes Del Club Libertad Trinidad', 'PREFERENTE', '94F', '58982427V', '2018-12-14 21:29:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9244DN0457VC695', 'CFDY17', 'TRABAJO', 0.63, '2020-07-07 05:31:09', 242.31, 'FISICO', 'Sairi Viajes Y Turismo', 'PREFERENTE', '4F', '03583687M', '2020-07-09 02:31:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4289SA9276YG359', 'DKRG87', 'ESTUDIOS', 0.18, '2018-11-21 17:04:42', 3759.81, 'FISICO', 'Artesan', 'TURISTA', '45D', '67934179B', '2018-11-22 23:04:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9166JN3351KH086', 'YFZL10', 'OCIO', 0.15, '2019-05-16 17:24:20', 1399.25, 'FISICO', 'Cynsa Tour Operator', 'TURISTA', '1D', '43807742M', '2019-05-19 01:24:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6561MO4470IH634', 'TPPH81', 'TRABAJO', 0.1, '2018-06-27 11:00:05', 2299.11, 'FISICO', 'Stl', 'TURISTA', '4D', '70891770A', '2018-06-28 22:00:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1260NG1389XZ662', 'OFZE14', 'ESTUDIOS', 0.49, '2018-03-15 12:51:34', 3136.92, 'FISICO', 'Antartur', 'PREFERENTE', '9F', '92388292H', '2018-03-15 19:51:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8405XR4375WP029', 'GOWS75', 'ESTUDIOS', 0.44, '2018-02-16 13:31:13', 558.38, 'FISICO', 'Maria Del Carmen Maldonado Viajes', 'TURISTA', '72G', '69536241W', '2018-02-17 10:31:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5632MT8420ZO461', 'IPXR55', 'OCIO', 0.41, '2020-02-08 16:30:22', 569.84, 'DIGITAL', 'Huarpe Viajes Y Turismo', 'BUSINESS', '7G', '13195673E', '2020-02-10 01:30:22');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0553PS7775UI788', 'ATYF08', 'ESTUDIOS', 0.57, '2017-02-03 02:56:40', 594.72, 'FISICO', 'Atokos - Experiencias De Viaje', 'PREFERENTE', '22D', '23206970X', '2017-02-04 12:56:40');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1635OC4614JC692', 'PHJF98', 'ESTUDIOS', 0.62, '2019-02-26 05:53:42', 1964.74, 'DIGITAL', 'N. J. Turismo', 'TURISTA', '0F', '69239536K', '2019-02-27 17:53:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7335RZ1661AR868', 'WCUU03', 'OCIO', 0.49, '2018-12-28 22:21:08', 3233.74, 'FISICO', 'Obra Social Del Personal De Direccion De Sanidad Luis Pasteur', 'TURISTA', '89G', '58580149U', '2018-12-30 01:21:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5407HL4928HM052', 'AVAF45', 'ESTUDIOS', 0.04, '2016-11-03 22:57:04', 1585.85, 'DIGITAL', 'Fentana Viajes Y Turismo', 'BUSINESS', '76G', '03438149Y', '2016-11-06 03:57:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0404RV8529YR328', 'ORQA55', 'OCIO', 0.5, '2018-12-14 09:29:01', 876.27, 'FISICO', 'Wilkinson Travel', 'BUSINESS', '6G', '92956925I', '2018-12-14 19:29:01');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5615WM9139WT078', 'IKYG17', 'OCIO', 0.22, '2018-03-20 22:40:45', 2172.93, 'FISICO', 'Ernesto Viajes Y Turismo', 'TURISTA', '27G', '58844888I', '2018-03-22 15:40:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4154PP9064HH042', 'NHFN54', 'TRABAJO', 0.27, '2017-11-11 19:48:50', 2631.94, 'FISICO', 'Carlos Di Fiore Tour & Travel', 'BUSINESS', '09G', '41349385O', '2017-11-14 01:48:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4010IR7410ZJ002', 'CRGU23', 'OCIO', 0.05, '2017-08-02 00:05:17', 3286.96, 'DIGITAL', 'Blumiann Turismo', 'PREFERENTE', '7F', '43914194N', '2017-08-04 06:05:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3380JD1818LY812', 'ACRV19', 'ESTUDIOS', 0.27, '2018-02-20 05:52:45', 3375.43, 'DIGITAL', 'Access Travel Services', 'TURISTA', '8G', '53961118L', '2018-02-21 18:52:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2812HX4035MU683', 'IFJY90', 'OCIO', 0.51, '2019-03-05 23:57:41', 1771.46, 'FISICO', 'Calisto Business & Travel', 'TURISTA', '5G', '29838624Z', '2019-03-07 07:57:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0446RY5737XZ739', 'TPTJ79', 'OCIO', 0.24, '2016-06-25 19:13:06', 1522.83, 'DIGITAL', 'Transhumans', 'PREFERENTE', '8D', '93990482O', '2016-06-26 13:13:06');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3754WW8666MV078', 'MXFT47', 'ESTUDIOS', 0.62, '2017-09-08 12:15:42', 514.03, 'FISICO', 'Sundance Tours', 'TURISTA', '66G', '00337814K', '2017-09-09 12:15:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3698BO0409KG590', 'OKVX23', 'TRABAJO', 0.59, '2017-07-15 15:21:26', 605.57, 'FISICO', 'Terminal Yerba Buena', 'TURISTA', '82D', '50150286R', '2017-07-17 06:21:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4794JP0625TK190', 'OANP50', 'ESTUDIOS', 0.37, '2016-04-11 06:33:21', 1248.44, 'FISICO', 'Carolina Caimi V Y T', 'TURISTA', '8G', '84661096R', '2016-04-12 17:33:21');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1059VU5181PU218', 'GMLK60', 'ESTUDIOS', 0.03, '2019-08-27 14:22:46', 2119.06, 'FISICO', 'Micaela Rosa Franquicia De Babel', 'BUSINESS', '83D', '00665573L', '2019-08-28 07:22:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6360DC6192LZ805', 'JNXW98', 'TRABAJO', 0.31, '2016-07-21 08:36:34', 2889.43, 'FISICO', 'Santa Rosa Viajes Y Turismo', 'TURISTA', '57F', '19328559L', '2016-07-23 17:36:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5063ZP9365QL712', 'MXMN93', 'TRABAJO', 0.31, '2019-02-01 16:44:33', 2048.51, 'FISICO', 'Burgueño Travel', 'PREFERENTE', '3C', '38013653B', '2019-02-04 04:44:33');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2405BA3597FM159', 'RPAY32', 'OCIO', 0.14, '2016-10-03 11:46:46', 243.28, 'FISICO', 'Zepelin Tours', 'PREFERENTE', '28G', '11375516I', '2016-10-05 09:46:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1047VO7534YY651', 'EIJM45', 'TRABAJO', 0.52, '2016-03-14 15:49:27', 691.34, 'DIGITAL', 'Heredia Tello Agostina Franquicia De Viajes Tdh', 'TURISTA', '58D', '11375516I', '2016-03-15 09:49:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6212NY9362WJ802', 'FVRQ54', 'ESTUDIOS', 0.55, '2017-12-22 00:18:32', 17.21, 'FISICO', 'Latitud Sur', 'PREFERENTE', '93F', '67934179B', '2017-12-22 04:18:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2334IB1359BA496', 'PLFX61', 'OCIO', 0.51, '2018-08-01 02:50:36', 1704.4, 'DIGITAL', 'Gestion Turismo', 'BUSINESS', '90F', '55237927E', '2018-08-02 16:50:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6739CE0554IA911', 'TVCQ23', 'OCIO', 0.26, '2018-04-17 18:38:26', 3379.86, 'FISICO', 'Argentina Desde El Norte Travel', 'BUSINESS', '07F', '20250544Z', '2018-04-19 16:38:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5076CH7068XI464', 'IGFW90', 'TRABAJO', 0.08, '2018-12-14 10:01:13', 971.93, 'DIGITAL', 'Cormoran Turismo', 'TURISTA', '38G', '22463253I', '2018-12-15 23:01:13');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6344FJ6351EZ055', 'IFJY90', 'OCIO', 0.32, '2019-03-10 05:57:41', 1771.46, 'FISICO', 'Bon Voyage S.R.L.', 'PREFERENTE', '07D', '36802529Q', '2019-03-10 23:57:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3615FS4316DM513', 'ODUX87', 'TRABAJO', 0.66, '2020-04-26 22:07:27', 1785.96, 'DIGITAL', 'Nereidas', 'BUSINESS', '2D', '49741113Z', '2020-04-29 10:07:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9145LD2948IA377', 'GKLW48', 'OCIO', 0.06, '2016-06-29 15:29:55', 1375.21, 'DIGITAL', 'Seasons Tours', 'PREFERENTE', '30G', '53961118L', '2016-07-01 22:29:55');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9779IE6117ZF438', 'AVWK23', 'ESTUDIOS', 0.06, '2017-01-18 10:57:05', 2569.42, 'FISICO', 'Colonia Express', 'BUSINESS', '39C', '30430995N', '2017-01-20 00:57:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1516OV4795PQ382', 'RAGZ69', 'ESTUDIOS', 0.51, '2016-12-19 13:30:19', 1143.39, 'DIGITAL', 'Holyland Travel', 'PREFERENTE', '2F', '88975906N', '2016-12-22 00:30:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3995QD1377HI616', 'EHKQ48', 'OCIO', 0.12, '2017-07-31 12:07:58', 2971.75, 'DIGITAL', 'Gimatur S.R.L.', 'TURISTA', '14D', '84848139W', '2017-07-31 17:07:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7963SF5796GQ844', 'IAOP75', 'OCIO', 0.63, '2016-05-09 10:34:46', 749, 'FISICO', 'Aymoa Tours', 'PREFERENTE', '59G', '53961118L', '2016-05-10 22:34:46');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0965DC4119VQ453', 'UHBN56', 'OCIO', 0.46, '2018-05-07 11:27:14', 2066.64, 'DIGITAL', 'Lo Mejor', 'TURISTA', '89G', '40208744O', '2018-05-08 23:27:14');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5768YF0702JJ416', 'DYJL03', 'TRABAJO', 0.12, '2020-06-22 14:28:31', 1873.76, 'FISICO', 'S.U.S. Destinos', 'PREFERENTE', '6F', '67716684G', '2020-06-23 12:28:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4165SJ9543SB851', 'FFDL03', 'ESTUDIOS', 0.17, '2020-03-08 22:53:54', 3227.33, 'DIGITAL', 'Frisco Travel', 'PREFERENTE', '8G', '53712077K', '2020-03-09 10:53:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2397VD1751EI581', 'DTER96', 'OCIO', 0.02, '2016-12-24 20:07:50', 2137.95, 'DIGITAL', 'Witran Turismo', 'BUSINESS', '4A', '45137271Y', '2016-12-25 11:07:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1774UN0653EM578', 'TMZG07', 'OCIO', 0.38, '2020-06-21 05:28:36', 3064.96, 'DIGITAL', 'Loy Travel Group', 'BUSINESS', '88F', '46113088B', '2020-06-23 09:28:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2487DG5832ZI268', 'NHKX50', 'TRABAJO', 0.63, '2020-06-10 16:57:27', 1512.27, 'FISICO', 'Tiamar Travel', 'BUSINESS', '8G', '21597780C', '2020-06-12 08:57:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9178AO3418OA382', 'MBZM22', 'OCIO', 0.56, '2019-08-05 12:46:28', 1587.55, 'DIGITAL', 'Andres Acoroni Viajes Y Turismo', 'PREFERENTE', '00F', '82222322K', '2019-08-05 20:46:28');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7544DT7928RN661', 'DEUU68', 'OCIO', 0.11, '2017-03-30 21:29:07', 3647.41, 'FISICO', 'Pude Viajes', 'BUSINESS', '66F', '03438149Y', '2017-04-02 05:29:07');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3219YY3319EL301', 'DCVW95', 'ESTUDIOS', 0.28, '2018-03-10 17:43:04', 700.44, 'DIGITAL', 'Colver Tours', 'BUSINESS', '77D', '43807742M', '2018-03-12 07:43:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2091OO7273QG168', 'NMEZ13', 'OCIO', 0.04, '2020-01-23 21:17:57', 3729.76, 'FISICO', 'Vorano Viajes', 'BUSINESS', '69G', '18188016E', '2020-01-26 09:17:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2384VZ3796BH243', 'MWES29', 'ESTUDIOS', 0.26, '2019-04-04 03:22:02', 3711.13, 'FISICO', 'Maval Representaciones', 'PREFERENTE', '8G', '27278555E', '2019-04-04 11:22:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8063TU6945CA599', 'GLRK17', 'TRABAJO', 0.24, '2019-01-30 15:04:57', 3330.17, 'DIGITAL', 'Serendipia', 'PREFERENTE', '3D', '83743817J', '2019-02-01 15:04:57');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5826JM9886DC087', 'HMXJ20', 'OCIO', 0.54, '2020-05-22 04:39:59', 2800.24, 'FISICO', 'Victoria Grünig', 'TURISTA', '36F', '95924257Q', '2020-05-23 21:39:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5503DQ8455DI142', 'VYZZ71', 'TRABAJO', 0.34, '2020-02-21 14:56:32', 2129.79, 'FISICO', 'Scotland Travel', 'PREFERENTE', '0G', '05413206A', '2020-02-23 14:56:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9962HF4006JI408', 'QEHU12', 'OCIO', 0.59, '2017-10-01 10:29:36', 1573.48, 'DIGITAL', 'Interwa Turismo', 'TURISTA', '58D', '73630839H', '2017-10-02 20:29:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6815FV1571HE511', 'VJPN65', 'TRABAJO', 0.58, '2020-07-20 13:24:45', 2767.13, 'FISICO', 'Hannover Turismo', 'BUSINESS', '6C', '92388292H', '2020-07-21 03:24:45');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3756FE9307KB535', 'HVKH04', 'OCIO', 0.17, '2018-04-03 02:18:54', 3245.87, 'DIGITAL', 'Enchanting - South America', 'TURISTA', '64G', '28928594D', '2018-04-04 19:18:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1767LO8308JL432', 'MIOD72', 'ESTUDIOS', 0.54, '2016-05-01 18:42:24', 3464.71, 'FISICO', 'Hunter Travel', 'BUSINESS', '49G', '70891770A', '2016-05-03 12:42:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0928FL2428QT940', 'AYCB92', 'TRABAJO', 0.7, '2017-06-07 00:15:32', 1735.73, 'DIGITAL', 'Sorba Franquicia De One Trip', 'PREFERENTE', '6C', '72816443M', '2017-06-07 09:15:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5843UL7268PP693', 'ZSLM04', 'TRABAJO', 0.19, '2017-06-29 21:41:26', 1069.43, 'FISICO', 'Furlan Viajes', 'TURISTA', '0F', '65736826L', '2017-07-02 09:41:26');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2352HL1708JE449', 'PDOC41', 'ESTUDIOS', 0.3, '2016-02-05 17:10:58', 3192.94, 'DIGITAL', 'Martesa Tours', 'BUSINESS', '6G', '30430995N', '2016-02-07 04:10:58');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0040RT7266SL961', 'QPOI93', 'TRABAJO', 0.21, '2019-05-11 12:28:48', 1269.45, 'FISICO', 'Alexandria Viajes', 'PREFERENTE', '25F', '40208744O', '2019-05-12 12:28:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2165SB9616DP702', 'DKRG87', 'TRABAJO', 0.52, '2018-12-02 19:04:42', 3759.81, 'FISICO', 'Latina Real Tours', 'PREFERENTE', '4G', '27278555E', '2018-12-04 20:04:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8922XX7059CR957', 'VZSE08', 'TRABAJO', 0.12, '2015-11-13 01:36:48', 2533.49, 'FISICO', 'Sin Distancias', 'PREFERENTE', '76D', '30430995N', '2015-11-13 22:36:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3292ZE9311IH968', 'QIMW93', 'ESTUDIOS', 0.31, '2020-05-19 08:04:12', 1663.29, 'DIGITAL', 'Anclar Empresa De Viajes Y Turismo', 'PREFERENTE', '5G', '58435558H', '2020-05-20 21:04:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2564VL9553PX902', 'DCRU94', 'ESTUDIOS', 0.66, '2016-10-04 11:02:19', 1767.62, 'FISICO', 'Ceilán Viajes', 'BUSINESS', '27C', '85659619A', '2016-10-05 06:02:19');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5760ST5070BL933', 'FMIM89', 'OCIO', 0.1, '2017-05-20 16:14:24', 419.84, 'FISICO', 'Ketek', 'BUSINESS', '0G', '65736826L', '2017-05-21 20:14:24');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8451VA5603SO401', 'HBYV64', 'OCIO', 0.62, '2020-05-25 07:44:47', 3354.83, 'DIGITAL', 'Test Viajes Y Turismo', 'BUSINESS', '64G', '02382074A', '2020-05-25 20:44:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3468AY5629DU278', 'MWES29', 'TRABAJO', 0.18, '2019-05-27 22:22:02', 3711.13, 'DIGITAL', 'Viajes Tdh', 'BUSINESS', '3F', '27848391E', '2019-05-29 06:22:02');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7134UN1333ZI133', 'ZXWK14', 'OCIO', 0.63, '2019-04-20 12:01:38', 1658.12, 'FISICO', 'Rumel Viajes Y Turismo', 'BUSINESS', '55G', '43167839X', '2019-04-21 22:01:38');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4015UU1717MR833', 'ZUUK25', 'TRABAJO', 0.66, '2017-10-16 12:08:42', 525.64, 'FISICO', 'Enter Viajes', 'PREFERENTE', '2G', '74256620Q', '2017-10-17 01:08:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4090TD3827LK468', 'IFDQ08', 'TRABAJO', 0.45, '2015-12-31 19:48:16', 1890.33, 'DIGITAL', 'Fioretti, Franquicia De Lozada Viajes', 'BUSINESS', '57G', '26491980A', '2016-01-01 00:48:16');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5359VC5206OD249', 'UOVP34', 'ESTUDIOS', 0.59, '2018-05-28 01:05:52', 2566.83, 'FISICO', 'Viajes Oggiono', 'BUSINESS', '3G', '03399464U', '2018-05-29 11:05:52');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2209SF0819MW170', 'UBQU45', 'OCIO', 0.51, '2016-04-28 04:25:42', 1088.26, 'FISICO', 'Sentidos', 'BUSINESS', '70G', '29703831K', '2016-04-30 12:25:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5609ZD9207WC877', 'JPKD62', 'TRABAJO', 0.61, '2020-04-14 22:04:35', 422.56, 'FISICO', 'Solanas Tour & Travel', 'PREFERENTE', '39B', '43914194N', '2020-04-16 09:04:35');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4260PH1054WZ090', 'ZXOY75', 'ESTUDIOS', 0.27, '2019-05-15 22:27:01', 199.62, 'FISICO', 'Trogon Tours', 'TURISTA', '9C', '98147633H', '2019-05-18 02:27:01');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4900LU2661CY535', 'NHKX50', 'TRABAJO', 0.1, '2020-05-11 07:57:27', 1512.27, 'FISICO', 'Ochenta Mundos', 'PREFERENTE', '6G', '48758609Z', '2020-05-11 22:57:27');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0225OS7383SE237', 'DIGA57', 'TRABAJO', 0.06, '2018-08-29 04:36:11', 3739.51, 'FISICO', 'Qrd Traveller', 'TURISTA', '1B', '90909458T', '2018-08-31 01:36:11');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2550JM0518PS196', 'HMXJ20', 'TRABAJO', 0.6, '2020-03-19 14:39:59', 2800.24, 'DIGITAL', 'Mindanao', 'PREFERENTE', '37B', '29838624Z', '2020-03-19 21:39:59');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4692HA3431PU141', 'RODE77', 'ESTUDIOS', 0.54, '2018-09-05 21:41:34', 1221.7, 'FISICO', 'Testigo Viajes', 'BUSINESS', '99D', '57403366Q', '2018-09-07 21:41:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0417CW8461TA884', 'AJXU05', 'OCIO', 0.6, '2018-11-25 19:59:25', 1126.45, 'DIGITAL', 'Barcelona Tour', 'PREFERENTE', '27G', '67934179B', '2018-11-26 01:59:25');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6487XI9847BP650', 'PLFX61', 'ESTUDIOS', 0.17, '2018-05-25 20:50:36', 1704.4, 'DIGITAL', 'Avantrip.Com', 'BUSINESS', '68D', '51788970Q', '2018-05-26 19:50:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('6546OE8932CQ464', 'OFZE14', 'ESTUDIOS', 0.15, '2018-02-11 17:51:34', 3136.92, 'DIGITAL', 'Trucamjet', 'TURISTA', '92G', '46885767Y', '2018-02-12 14:51:34');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2696DX0298CC203', 'YLNP53', 'ESTUDIOS', 0.27, '2019-08-08 19:11:32', 962.18, 'DIGITAL', 'Paidon Maria Soledad Franquicia De Viajes Tdh', 'TURISTA', '22A', '16305315P', '2019-08-10 12:11:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9259YI1186FK781', 'EKHB83', 'OCIO', 0.66, '2017-12-27 08:17:36', 1505.41, 'DIGITAL', 'Piccato - Del Vado Viajes', 'BUSINESS', '40F', '44546083M', '2017-12-29 17:17:36');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5013VZ1225EO988', 'YLNP53', 'OCIO', 0.33, '2019-07-22 09:11:32', 962.18, 'FISICO', 'Cumbres Andinas', 'BUSINESS', '9F', '49741113Z', '2019-07-23 05:11:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0358OT5554RN038', 'KUZU94', 'ESTUDIOS', 0.69, '2016-04-03 03:35:53', 1369.48, 'FISICO', 'Cabure', 'BUSINESS', '90G', '55237927E', '2016-04-03 11:35:53');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2151ZL8027HI413', 'ERUX27', 'OCIO', 0.09, '2017-11-28 06:21:50', 325.01, 'FISICO', 'Kawai Turismo', 'TURISTA', '93G', '97814136Q', '2017-11-28 12:21:50');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4448NJ9313CL247', 'HOQA34', 'TRABAJO', 0.66, '2020-03-22 10:17:08', 3837.9, 'FISICO', 'Berisso Viajes', 'TURISTA', '6D', '69239536K', '2020-03-23 04:17:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('2887UH9828JC099', 'CSFK29', 'TRABAJO', 0.29, '2020-07-01 04:45:31', 1860.77, 'DIGITAL', 'Algarrobo', 'PREFERENTE', '54G', '73763582N', '2020-07-03 14:45:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8025IR3318ID054', 'SPMO59', 'OCIO', 0.29, '2016-08-18 02:56:12', 1422.79, 'FISICO', 'Kinjo Travel', 'TURISTA', '18G', '90924101M', '2016-08-20 12:56:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3999UX2132VC417', 'AVWK23', 'ESTUDIOS', 0.64, '2016-12-15 12:57:05', 2569.42, 'DIGITAL', 'Unforgettable', 'TURISTA', '9D', '29838624Z', '2016-12-16 04:57:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0212OR4642ZI600', 'KUZU94', 'TRABAJO', 0.43, '2016-01-21 02:35:53', 1369.48, 'FISICO', 'Big Apple Tours', 'BUSINESS', '5B', '23206970X', '2016-01-23 10:35:53');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9562ZE6290KF315', 'WFEB86', 'TRABAJO', 0.13, '2016-01-24 00:12:55', 3313.9, 'DIGITAL', 'Shift Travel', 'BUSINESS', '80G', '63097304T', '2016-01-24 23:12:55');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8643UP6507AN725', 'XSTZ86', 'OCIO', 0.16, '2020-03-24 19:14:09', 3544.51, 'DIGITAL', 'Bonus Track', 'BUSINESS', '8G', '94489726X', '2020-03-27 02:14:09');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0360NM9556MV595', 'LAKY81', 'OCIO', 0.34, '2016-11-09 03:45:03', 1261.74, 'DIGITAL', 'Ko´e Itu', 'BUSINESS', '4F', '41791106A', '2016-11-09 21:45:03');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7643KZ2580FR319', 'HRQP99', 'ESTUDIOS', 0.68, '2016-07-25 16:49:31', 1499.67, 'FISICO', 'Qudos Travel', 'TURISTA', '3G', '43216152P', '2016-07-26 02:49:31');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4969NX0536HO083', 'SFPK12', 'TRABAJO', 0.15, '2016-01-29 02:15:29', 3626.71, 'FISICO', 'San Miguel Pasajes', 'TURISTA', '31D', '53961118L', '2016-01-29 20:15:29');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8752RI4274RX348', 'MSOL82', 'ESTUDIOS', 0.33, '2017-07-09 19:03:47', 3671.64, 'FISICO', 'Zeal Programmes', 'TURISTA', '58F', '85654886A', '2017-07-12 06:03:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9288AE9526UE677', 'NSBC87', 'TRABAJO', 0.04, '2017-11-26 11:31:00', 2939.88, 'FISICO', 'Now Or Never Travel', 'PREFERENTE', '46G', '86657526U', '2017-11-28 19:31:00');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1771WW7623OH985', 'YFZL10', 'ESTUDIOS', 0.66, '2019-05-31 17:24:20', 1399.25, 'FISICO', 'Northnaut Adventures', 'TURISTA', '8F', '37398296C', '2019-06-01 11:24:20');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3350JG8919PV530', 'AVAF45', 'ESTUDIOS', 0.59, '2016-11-03 13:57:04', 1585.85, 'DIGITAL', 'Lucio Del Mul S.R.L. Franquicia De Viajes Tdh', 'TURISTA', '1G', '92382459A', '2016-11-06 01:57:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7603BR7614MS461', 'LRNB26', 'ESTUDIOS', 0.2, '2016-01-01 07:34:47', 1582.53, 'FISICO', 'Viaje Facil', 'TURISTA', '07G', '54888895T', '2016-01-03 12:34:47');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3905DF1150GE029', 'XSWN54', 'OCIO', 0.61, '2020-05-20 01:50:03', 168.4, 'FISICO', 'Terranova Viaggi E Turismo', 'TURISTA', '33D', '88460292P', '2020-05-20 07:50:03');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5087EV9059RV319', 'BAHO29', 'ESTUDIOS', 0.48, '2017-09-29 17:27:08', 3777.65, 'DIGITAL', 'Unser Travel.Com', 'PREFERENTE', '5G', '40387228S', '2017-09-30 00:27:08');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('1485TV9181LS869', 'QIMW93', 'ESTUDIOS', 0.07, '2020-06-27 04:04:12', 1663.29, 'DIGITAL', 'Sessarego Viajes', 'PREFERENTE', '20D', '22012118W', '2020-06-28 04:04:12');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4424SX3412BL590', 'QPOI93', 'OCIO', 0.03, '2019-07-10 19:28:48', 1269.45, 'DIGITAL', 'Arribato Viajes Y Turismo', 'TURISTA', '6G', '70878793O', '2019-07-11 00:28:48');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3866CT7492MN287', 'IEZB16', 'OCIO', 0.51, '2016-08-27 16:16:39', 2556.76, 'FISICO', 'Grupo De Inversiones Turisticas', 'PREFERENTE', '77G', '98654381E', '2016-08-29 11:16:39');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('5335GH7101EE698', 'MJZB56', 'TRABAJO', 0.26, '2019-05-12 17:55:41', 3055.78, 'FISICO', 'Travellers', 'PREFERENTE', '5D', '58618293D', '2019-05-13 02:55:41');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3498BJ4447PB473', 'EQYL80', 'OCIO', 0.02, '2020-01-14 03:49:54', 2710.76, 'DIGITAL', 'Biarritz Evt', 'TURISTA', '3B', '05413206A', '2020-01-15 00:49:54');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('3388FE7980FE469', 'LICT28', 'TRABAJO', 0.0, '2019-04-20 20:33:05', 2086.4, 'FISICO', 'D''Alessandro Turismo', 'PREFERENTE', '99F', '06780561G', '2019-04-21 18:33:05');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8772DZ7388FU641', 'XOLB07', 'ESTUDIOS', 0.45, '2017-06-20 02:21:42', 1330.89, 'FISICO', 'Karina Andrea Perez Franquicia De Babel', 'BUSINESS', '0G', '88413344X', '2017-06-21 04:21:42');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('7485FD9940QM877', 'SIQG29', 'TRABAJO', 0.59, '2019-06-21 01:57:04', 513.66, 'DIGITAL', 'Tellevodeviaje.Com', 'BUSINESS', '49G', '05694407T', '2019-06-22 14:57:04');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('8244AW0727PS350', 'OMQC41', 'ESTUDIOS', 0.22, '2017-12-13 07:14:17', 2669.46, 'FISICO', 'Glape Tur', 'PREFERENTE', '3F', '41655520M', '2017-12-13 14:14:17');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('9343RX9344IZ997', 'NRDY70', 'OCIO', 0.41, '2016-09-21 06:11:30', 3489.39, 'FISICO', 'Viajes Y Turismo El 35', 'BUSINESS', '6G', '31358662D', '2016-09-22 21:11:30');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('0043BB1755GO113', 'OGPE49', 'OCIO', 0.56, '2017-01-23 17:07:32', 3103.84, 'FISICO', 'Tim Travel', 'TURISTA', '71G', '05413206A', '2017-01-24 09:07:32');
insert into BILLETE (idbillete, idvuelo, motivo, descuento, fecha_compra, precio, formato, lugar_compra, clase, plaza, dni_cliente, ultima_actualizacion) values ('4362CP9946KH519', 'NMEZ13', 'TRABAJO', 0.1, '2020-03-21 12:17:57', 3729.76, 'FISICO', 'Rep - Tur Viajes', 'PREFERENTE', '4G', '17736845Y', '2020-03-21 17:17:57');

