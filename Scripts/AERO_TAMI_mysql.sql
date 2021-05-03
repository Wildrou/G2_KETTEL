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
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idtransporte)
);


CREATE TABLE TAXI
(
    numlicencia VARCHAR(6) NOT NULL,
    idtransporte_taxi VARCHAR(6) NOT NULL,
    PRIMARY KEY (numlicencia),
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT tax_fk FOREIGN KEY (idtransporte_taxi) REFERENCES TRANSPORTE (idtransporte) ON DELETE CASCADE
);


CREATE TABLE AUTOBUS
(
    matricula VARCHAR(7) NOT NULL,
    lineabus VARCHAR(3) NOT NULL,
    idtransporte_autobus VARCHAR(6) NOT NULL,
    PRIMARY KEY (matricula),
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_empleado),
    CONSTRAINT fkdni_empleado FOREIGN KEY (dni_empleado) REFERENCES PERSONA (dni) ON DELETE CASCADE
        
);

ALTER TABLE EMPLEADO ADD dni_supervisor VARCHAR (9) REFERENCES EMPLEADO(dni_empleado);


CREATE TABLE TRIPULANTE
(   
    dni_tripulante VARCHAR(9) UNIQUE NOT NULL,
    horas_vuelo DOUBLE NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_tripulante),
    CONSTRAINT fkdni_tripulante FOREIGN KEY (dni_tripulante) REFERENCES PERSONA(dni) ON DELETE CASCADE
);




CREATE TABLE CABINAMANDO
(  
    dni_cabinamando VARCHAR(9) UNIQUE NOT NULL,
    numlicencia VARCHAR (10) UNIQUE NOT NULL,
    puesto VARCHAR(8) NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_cabinamando),
    CONSTRAINT fk_cabinamando FOREIGN KEY (dni_cabinamando) REFERENCES TRIPULANTE (dni_tripulante) ON DELETE CASCADE
);

CREATE TABLE CABINAPASAJERO
(
    dni_cabinapasajero VARCHAR(9) UNIQUE NOT NULL,
    clase VARCHAR(15) NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_cabinapasajero),
    CONSTRAINT fk_cabinapasajero FOREIGN KEY (dni_cabinapasajero) REFERENCES TRIPULANTE (dni_tripulante) ON DELETE CASCADE
    
);

CREATE TABLE AZAFATA 
(
    dni_azafata VARCHAR(9) UNIQUE NOT NULL,
	impventa DOUBLE NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_azafata),
    CONSTRAINT fk_azafata FOREIGN KEY (dni_azafata) REFERENCES CABINAPASAJERO (dni_cabinapasajero) ON DELETE CASCADE

);

CREATE TABLE SOBRECARGO 
(
	dni_sobrecargo VARCHAR(9) UNIQUE NOT NULL,
    horas_sobrecargo DOUBLE NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dni_sobrecargo),
    CONSTRAINT fk_sobrecargo FOREIGN KEY (dni_sobrecargo) REFERENCES CABINAPASAJERO (dni_cabinapasajero) ON DELETE CASCADE
);

CREATE TABLE PISTA
(
    numpista DOUBLE UNIQUE NOT NULL,
	longitud DOUBLE NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (numpista)
  
);

CREATE TABLE AVION
(
    idavion VARCHAR(6) UNIQUE NOT NULL,
    modelo VARCHAR(10) NOT NULL,
    cargamax DECIMAL (5,2) NOT NULL,
    numplazas DOUBLE NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idrecorrido)
);



CREATE TABLE PUERTAEMBARQUE
(
    codpuerta VARCHAR(4) UNIQUE NOT NULL,
    terminal VARCHAR(2)  NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (codpuerta)
);

CREATE TABLE AEROLINEA
(
	idaerolinea VARCHAR(8) UNIQUE NOT NULL,
	nombre VARCHAR(12) NOT NULL,
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
     ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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

insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ATYF08', 'K18ETO3', '542366704S', '499965AZ', '2020-05-24 12:29:37', 5, 'SCA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DYZX90', 'Q38TUZ6', '149071155B', '374336OU', '2019-09-25 06:41:56', 11, 'RCZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VJPN65', 'R84KRN5', '376082483V', '546564OU', '2017-11-13 12:07:38', 4, 'HHK5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OHPA97', 'H56ZWQ1', '006126532S', '878357UM', '2017-12-08 01:25:49', 7, 'LVW9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RAGZ69', 'Z81VGL7', '063444692F', '126325AB', '2020-07-17 02:38:11', 9, 'OEE3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ENBH08', 'G05GYK4', '394738372Y', '688809MA', '2018-02-12 18:33:14', 6, 'KYZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LIVI96', 'G05GYK4', '173374240E', '188566ZL', '2016-02-18 15:09:20', 2, 'XHE0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YDUS17', 'J06SGB8', '650204365I', '442699XU', '2018-02-08 05:14:16', 3, 'TPO0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SYFL31', 'X31HJI1', '627260389P', '177659BU', '2016-09-17 16:38:04', 6, 'LEA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NHFN54', 'R62EPI2', '233461298A', '553124PW', '2018-05-09 00:56:20', 12, 'ZVM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WIBT45', 'G82TUN9', '803158842X', '692308PP', '2021-05-16 14:49:36', 3, 'KNN9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LQER89', 'M16EYB7', '504869441H', '899781CS', '2018-03-21 05:51:16', 10, 'YFV8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RCTR34', 'V26SKR5', '171568970U', '022480GF', '2018-10-14 15:34:56', 10, 'JKU9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DFRY94', 'J77MLD0', '151242685J', '676821LN', '2019-08-28 15:26:04', 8, 'UVC1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QPOI93', 'H76VEO1', '652255744J', '035450RF', '2018-04-05 12:05:51', 11, 'MPR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CHRA62', 'H12QIE8', '634532858H', '552824UW', '2020-06-28 19:59:41', 3, 'WMZ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YFZL10', 'R59OBH2', '173374240E', '154046AU', '2017-09-24 07:19:34', 7, 'KNN9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LXAJ19', 'U95XJO7', '499777409Q', '016703PP', '2018-07-11 23:09:27', 8, 'COR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XJIJ86', 'H76VEO1', '676522141Z', '042776KQ', '2018-10-03 17:27:01', 9, 'EXR2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UOVP34', 'T27GXO8', '774287974Y', '385720VY', '2016-05-06 14:07:03', 3, 'LHD3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JBRQ29', 'H80SLM1', '481885108N', '816069KH', '2020-04-03 02:36:16', 7, 'SUE8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DKYT41', 'Q05AWW6', '643538765O', '866931YZ', '2018-01-31 16:12:33', 3, 'HQC8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EQYL80', 'W21BWK4', '859640888S', '895484KK', '2016-04-21 05:54:06', 11, 'XGF5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VMWP80', 'S61DYT2', '744180337H', '163470EV', '2020-02-24 22:24:58', 9, 'EXR2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MYOS45', 'R68LFX0', '319107657K', '712452GP', '2021-04-07 19:07:04', 7, 'MQX6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RBOW00', 'R34WVX1', '397196720Y', '464653IR', '2017-09-02 21:30:43', 9, 'PGX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MSOL82', 'K29MTU2', '789954790S', '774177ZB', '2016-10-01 19:31:01', 8, 'BFY2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MSAG13', 'W05IFW0', '817185530N', '480033CB', '2018-06-11 19:29:29', 5, 'EXR2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CFDY17', 'R62EPI2', '549007318J', '339196KC', '2017-08-11 11:54:47', 10, 'YNF4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RZZR30', 'N74ULY4', '567538877Z', '923205VG', '2016-07-14 22:09:12', 7, 'ZCX8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UBSH06', 'U13RYR3', '306030369P', '594043US', '2017-03-12 06:56:30', 10, 'DYB4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GKLW48', 'X31HJI1', '523679322Y', '371254UZ', '2016-12-26 12:04:19', 9, 'RCZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CRFX33', 'S22CUN3', '179523211K', '077098AD', '2018-12-24 00:17:28', 1, 'SUE8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OGQI63', 'X15JBF8', '043858979X', '547200VZ', '2020-04-29 12:27:44', 1, 'LVW9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TFYD64', 'V12MBR7', '625486097D', '204291DT', '2018-09-02 01:49:10', 12, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EPDS39', 'S59UQF4', '043858979X', '672876CP', '2019-03-13 16:52:19', 9, 'CME9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QRFV95', 'O52YXS5', '006126532S', '806868HF', '2016-06-13 16:37:47', 4, 'VFJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FEWP24', 'H55ZCC0', '859640888S', '158864AA', '2017-07-09 22:19:45', 3, 'XRZ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HYKO22', 'E55SSY1', '063364295I', '574306YW', '2019-05-09 21:41:44', 5, 'KOD4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JMJW04', 'B82TEX9', '003471832Y', '002540TX', '2020-08-24 08:15:20', 8, 'EEF2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FSIO41', 'W61YHV1', '614756497L', '598007JL', '2020-04-20 14:20:06', 5, 'VPL8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ORZZ26', 'L20BHD1', '481885108N', '291542XG', '2016-05-05 17:40:14', 11, 'EAN0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AGLS23', 'R80VKR0', '319971554M', '480033CB', '2017-01-27 12:25:09', 1, 'RRR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QMES51', 'L93MGP1', '521323832D', '263717CV', '2019-01-03 14:49:29', 4, 'TRQ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZXWK14', 'R68KKB0', '890583845I', '858858RY', '2017-01-23 11:48:12', 6, 'ZZQ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZXOY75', 'A85NFC1', '537457963M', '520392WQ', '2021-11-11 07:29:09', 11, 'KOD4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BJFP92', 'K68EGA4', '999017599B', '222409UH', '2021-12-27 04:38:17', 7, 'SOL2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RJDX79', 'S59UQF4', '177510534I', '303407PW', '2016-11-07 23:08:37', 9, 'PGX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ACRF16', 'C26RKD4', '723870867D', '158864AA', '2021-08-05 14:27:47', 12, 'TWT6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IDBR63', 'T49GOM0', '182718758L', '710901RB', '2017-10-22 09:29:25', 9, 'XYH4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EZOD19', 'R55XVR4', '900131706L', '598007JL', '2020-11-17 17:16:26', 8, 'COR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FFDL03', 'Q96BEG8', '319971554M', '299171RZ', '2016-02-26 05:02:00', 2, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NTQK27', 'B50ATK3', '904174108S', '035450RF', '2017-02-20 13:26:43', 3, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BBKM54', 'X17HYT2', '900131706L', '344494RZ', '2018-02-09 10:14:12', 5, 'HVU9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VYZZ71', 'V76FXO4', '723870867D', '743508AR', '2018-07-08 00:49:08', 4, 'HSS3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FMIM89', 'X82IBB5', '668235461Z', '563885ZU', '2017-04-03 07:49:25', 3, 'ZJZ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YUBX74', 'L84DFQ2', '297023554G', '110666YH', '2018-09-22 22:02:31', 12, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YNOG42', 'H97BFG6', '147995979M', '513577KN', '2016-05-13 09:51:45', 2, 'GCT5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LEJC58', 'G82TUN9', '893087626P', '942793IS', '2017-07-11 05:09:17', 2, 'TWT6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZFUA60', 'R04EHB7', '394738372Y', '480033CB', '2018-11-22 02:47:41', 3, 'ZJC5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WGSB43', 'S71WEV4', '433217946H', '422708HC', '2021-08-26 14:08:34', 7, 'ETF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SJHN46', 'O91XPE6', '627260389P', '712452GP', '2018-11-09 10:36:22', 3, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ADXQ41', 'H97BFG6', '652255744J', '629765JD', '2018-04-18 12:18:39', 3, 'LCJ6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CWUO79', 'W05IFW0', '066306837W', '632789HO', '2016-08-03 13:33:05', 6, 'CRE6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BKMQ49', 'B50ATK3', '689216804E', '464684AY', '2018-08-04 22:46:43', 2, 'QDV1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VKVA87', 'J98MVA2', '830347082D', '464653IR', '2018-12-01 04:47:46', 9, 'MQW6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BIII35', 'J39DDO0', '956032232X', '979059OQ', '2021-02-09 17:37:07', 5, 'VFJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EIJM45', 'Y04FBS8', '617677484Q', '364595KW', '2016-10-07 01:57:02', 3, 'EUX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UGLJ78', 'N58KJE9', '105418638V', '842521PL', '2021-02-05 16:45:58', 4, 'ETF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VGTY59', 'B48CCB9', '537457963M', '273143QN', '2016-06-20 05:54:27', 3, 'EEF2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WFEB86', 'T41HPF1', '430772605B', '959088YH', '2017-11-30 11:13:53', 12, 'ZJC5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HVKH04', 'F06SSJ7', '393850830J', '274588DV', '2019-01-02 12:38:43', 9, 'OLW0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DIGA57', 'G41JHL2', '633157509I', '971221TV', '2018-04-08 17:22:16', 10, 'CUZ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MXFT47', 'X88WMX2', '317890290F', '079607IP', '2020-12-31 18:56:13', 7, 'TRQ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UHQY43', 'C35IXL6', '990783493P', '248505WE', '2016-06-11 19:42:59', 9, 'HJK6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YLLK55', 'V17AZH2', '480133586U', '157632ZH', '2016-09-05 20:44:10', 11, 'ZPS8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GEPY67', 'D64YVD5', '830347082D', '632789HO', '2017-05-04 23:58:39', 4, 'LRF3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZYDW53', 'J73YVQ5', '376082483V', '154046AU', '2016-10-10 13:41:18', 6, 'DJL8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KKXL78', 'N76TFG7', '909240077X', '466764DM', '2016-12-27 12:03:41', 6, 'VXQ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QEHU12', 'L65GFX9', '630121462K', '010971CX', '2017-02-06 10:52:39', 8, 'WDS6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ADSV74', 'U51DRU1', '521323832D', '442699XU', '2018-03-29 16:18:19', 11, 'EWK2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UZVS70', 'K95TNO6', '282798534O', '497344UK', '2016-11-28 12:22:48', 12, 'AYP2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JKUJ49', 'M17QYG8', '702782178D', '008348BE', '2018-10-15 03:48:38', 7, 'OBM3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OANP50', 'U95XJO7', '971898444G', '177659BU', '2020-06-09 02:11:19', 8, 'DWP7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TDQR49', 'L93MGP1', '964805039P', '621095AU', '2021-08-09 01:35:48', 7, 'MVL0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YOSP56', 'M44QRR6', '508984035K', '277173IO', '2016-10-26 16:07:00', 10, 'SQD0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MXKY03', 'X57HOA7', '263548523R', '273143QN', '2021-04-26 03:50:31', 6, 'HMR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DCRU94', 'L20BHD1', '233461298A', '632789HO', '2018-07-11 19:01:29', 11, 'DYB4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EPFP33', 'F64DNC3', '125684064Y', '971221TV', '2018-03-20 09:57:34', 4, 'CTF6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KATU27', 'W21BWK4', '517873890E', '363449XI', '2021-04-03 19:32:21', 4, 'SSB4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BZUM50', 'X53GOU3', '376082483V', '651369JK', '2021-01-05 06:29:33', 7, 'QON8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QWTL72', 'Q33KPW8', '662492405O', '476861WC', '2016-03-18 04:14:20', 11, 'OEE3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IFFE27', 'M85CGE5', '776085384T', '141207TH', '2019-12-21 22:53:35', 2, 'WMZ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OSZA17', 'E98UZQ7', '523679322Y', '126325AB', '2019-11-11 21:14:08', 7, 'RCZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PAYG85', 'N76TFG7', '964805039P', '979059OQ', '2019-06-20 02:35:00', 1, 'HMJ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ODUX87', 'R55XVR4', '633157509I', '967969NP', '2021-11-21 14:33:48', 12, 'LHE0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HMXJ20', 'H50GHF0', '138092219R', '621095AU', '2016-06-09 06:32:37', 1, 'COR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DHGQ82', 'Q05AWW6', '134797672A', '550362DS', '2017-12-12 00:56:21', 10, 'HEB0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IQZV46', 'M13XWS0', '909240077X', '860365NF', '2020-11-04 23:15:24', 1, 'ARR5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HBAO45', 'W08WET4', '393850830J', '758792MS', '2021-11-12 18:56:30', 2, 'UGC3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VYSI09', 'Y58SLX0', '852883849N', '141207TH', '2016-12-01 21:01:19', 3, 'KNN9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AYWO22', 'J73YVQ5', '709247980W', '126325AB', '2020-03-21 06:25:51', 4, 'UCF1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UHOJ14', 'V17AZH2', '483037866U', '859629WQ', '2021-12-02 20:11:04', 10, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WQZN84', 'X11HFI9', '062489308B', '344494RZ', '2020-11-02 03:42:34', 9, 'ETF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WQEE03', 'U13RYR3', '551243732A', '035450RF', '2016-12-11 19:10:18', 9, 'WMZ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XWIE41', 'L65GFX9', '276116728D', '025761EB', '2019-12-12 20:57:46', 2, 'KAQ1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MKEG41', 'I49SSE8', '171568970U', '420191XF', '2017-12-18 22:57:35', 4, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NUKL03', 'S61DYT2', '410795735E', '018245JV', '2019-09-22 10:13:23', 6, 'XYH4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LVSK61', 'Q17IUA0', '105418638V', '009830VM', '2018-04-24 07:27:56', 1, 'HUM1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FTQT44', 'H07SZM9', '971898444G', '520451SX', '2018-08-23 01:16:57', 12, 'NEJ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EXBI05', 'K00LZJ6', '504869441H', '560227DX', '2016-08-06 01:23:46', 3, 'ZJC5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MHVY57', 'T49GOM0', '567538877Z', '776292ZE', '2018-04-01 21:55:50', 11, 'VOB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BWWZ38', 'J21NIJ6', '227422941T', '000084VF', '2021-03-13 22:13:53', 11, 'DWP7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JPKD62', 'H12QIE8', '804912605B', '344494RZ', '2018-12-31 01:59:24', 7, 'TRQ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AZRE73', 'B48CCB9', '252056898A', '157632ZH', '2020-10-20 06:15:24', 1, 'HJK6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IKYG17', 'U92VNM2', '904174108S', '618368PU', '2018-05-28 22:21:33', 5, 'CRE6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XSCK30', 'Y95SWL3', '700224352I', '903609RC', '2018-03-24 02:22:52', 10, 'KCL0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BITY64', 'G11VZO9', '306030369P', '476861WC', '2016-03-13 20:26:57', 9, 'UEW1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JMOK23', 'Y96GZC0', '689737943E', '563885ZU', '2017-05-30 22:36:52', 10, 'EUX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JPPX34', 'S22CUN3', '689216804E', '806868HF', '2021-03-19 07:48:39', 9, 'ODD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IHMK38', 'W05IFW0', '241741467J', '651369JK', '2020-09-20 10:56:01', 9, 'WEV5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AWNI10', 'P63QQK8', '397196720Y', '692308PP', '2017-07-03 14:36:09', 12, 'SOL2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DOAW38', 'R16EBM0', '125684064Y', '718362IS', '2021-05-28 20:53:11', 8, 'UYZ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SIQG29', 'H20KLJ7', '149071155B', '665913WM', '2021-08-05 07:21:06', 3, 'XYH4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZSFI22', 'K00DJN5', '938839845B', '406210HE', '2020-06-26 06:28:46', 2, 'JBY9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QVYE27', 'R55XVR4', '683971308T', '102094JX', '2018-05-09 23:46:24', 2, 'MSJ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GLRK17', 'J64LND6', '322697703G', '829960JO', '2019-10-01 22:46:37', 6, 'KIA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KMPT60', 'O91XPE6', '373040712T', '153553II', '2017-11-03 00:00:36', 5, 'ZVM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JKRA16', 'I49SSE8', '496672729C', '022480GF', '2020-02-17 16:45:00', 11, 'UFI0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZKUR76', 'Y07XOX1', '630121462K', '035450RF', '2016-06-03 12:53:33', 2, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EIUE54', 'R68VCV9', '614756497L', '739401AE', '2021-07-27 07:16:42', 11, 'RHH0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RRIU06', 'Y04FBS8', '652255744J', '720698EK', '2016-08-22 19:59:40', 2, 'GWH7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ARMZ49', 'J69UBL6', '693687383B', '075996AE', '2020-08-17 12:43:12', 3, 'WDS6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ITZR09', 'H55ZCC0', '374690163D', '442699XU', '2017-08-05 16:37:10', 11, 'UPN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WOYO27', 'B48CCB9', '683971308T', '862738YY', '2019-12-06 09:03:24', 6, 'XFP5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IAOP75', 'Q27IIP1', '549007318J', '879368RO', '2021-11-16 09:56:38', 6, 'WYD5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LRNB26', 'H20KLJ7', '523679322Y', '075996AE', '2021-05-13 21:15:06', 3, 'MGF7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GMLK60', 'N74ULY4', '182718758L', '758792MS', '2016-01-02 08:37:40', 11, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DEUU68', 'F06SSJ7', '030222740E', '709709IU', '2021-07-10 20:01:02', 8, 'SSB4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NNTL45', 'R55XVR4', '957499350R', '374336OU', '2016-11-04 13:23:49', 6, 'DOQ7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZBZL28', 'H97VDX7', '994877626G', '682061KM', '2018-02-01 22:31:47', 10, 'ZAK1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LTNR44', 'Q27IIP1', '202830989B', '299171RZ', '2016-12-21 16:46:56', 2, 'UVC1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TVCQ23', 'R55XVR4', '845075649U', '194104GZ', '2017-02-13 01:02:14', 5, 'YRG3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SRFF00', 'R59OBH2', '654553683G', '354442ZT', '2021-04-28 22:15:56', 7, 'SWB8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HRQP99', 'I29MPD3', '282798534O', '035450RF', '2020-06-30 21:15:17', 11, 'HUM1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CTUZ33', 'M71LZZ0', '567538877Z', '495365PE', '2018-03-20 16:23:24', 7, 'CTF6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OKVX23', 'V73RWY0', '332548442S', '928416XS', '2019-03-20 11:45:14', 7, 'IWB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EAWB19', 'H78UJL2', '243089355P', '635301DN', '2017-01-09 15:58:47', 6, 'UCF1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MXMN93', 'E74TWS1', '469624384L', '465887VX', '2016-07-27 14:43:33', 3, 'ZVM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YMZO63', 'W17IWD6', '804912605B', '520392WQ', '2017-09-29 13:02:12', 6, 'BFY2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EHKQ48', 'O91XPE6', '322697703G', '742840AD', '2017-07-09 07:35:44', 10, 'VPL8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XOLB07', 'N82VEQ5', '594455502K', '867895XE', '2020-01-22 04:41:20', 8, 'LHD3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NRDY70', 'N74ULY4', '270438704N', '594043US', '2018-02-06 20:26:58', 5, 'NLK7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JGGE03', 'K80PBU5', '983554010X', '009830VM', '2019-03-30 17:25:21', 11, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VUTE09', 'P36NXE7', '340236083A', '312045UV', '2017-07-17 07:52:55', 6, 'MII2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GESN89', 'B48BFZ9', '781293399D', '903097DQ', '2020-05-16 17:16:07', 12, 'QNF7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HYDE22', 'B78XYR3', '703492393T', '492828IH', '2021-08-01 05:57:27', 4, 'SGV3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MFIK33', 'H13NRI2', '536205627Z', '520451SX', '2016-02-18 19:57:34', 4, 'VOB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YLXK34', 'L20BHD1', '176757424T', '483813MB', '2016-12-19 19:18:27', 2, 'VDI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GLGF25', 'W17IWD6', '938839845B', '274588DV', '2019-03-15 06:02:39', 11, 'SJY5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JCYH85', 'X82IBB5', '817185530N', '651369JK', '2021-10-17 07:29:58', 5, 'ZZQ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MJZB56', 'I29MPD3', '521323832D', '923205VG', '2021-06-06 11:49:05', 10, 'NLK7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YLNP53', 'I13ABP5', '063364295I', '263717CV', '2019-01-20 22:34:00', 4, 'VOB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UABQ51', 'S22CUN3', '625486097D', '600128KO', '2019-11-30 11:45:10', 8, 'VXQ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SYCX21', 'Q30PKY8', '676522141Z', '547200VZ', '2017-05-22 22:04:21', 4, 'YRG3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RAWG18', 'F26LSK7', '163092377N', '553124PW', '2020-07-09 20:10:14', 9, 'MII2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EMOF11', 'P88AJU4', '959017408E', '859412OQ', '2016-03-19 13:06:19', 7, 'ZCB8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GGFX19', 'R84KRN5', '700224352I', '879368RO', '2019-05-27 11:30:55', 3, 'YYQ9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FBBQ63', 'R62EPI2', '179523211K', '862738YY', '2016-05-25 18:13:10', 6, 'SJY5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VJZY24', 'G61HNN8', '983554010X', '188566ZL', '2018-08-09 13:28:03', 8, 'JKU9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RPAY32', 'R62EPI2', '478455123A', '022480GF', '2020-09-07 14:51:32', 6, 'JFZ9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OLXL90', 'W61YHV1', '625486097D', '312045UV', '2019-09-09 11:26:55', 2, 'AYB3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WBKB29', 'E36FUS5', '206054009Y', '863901QK', '2021-04-29 16:33:11', 7, 'MGO1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NBFY27', 'T18MKW5', '675554791Q', '945383RK', '2020-07-18 05:20:15', 6, 'ZAK1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OCOL03', 'M71LZZ0', '303120368A', '080131CS', '2018-04-19 22:40:29', 5, 'ZPS8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GOWS75', 'Q22BBX9', '549007318J', '092546ZI', '2021-07-03 19:36:32', 9, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MBZT21', 'G75ZOA9', '964805039P', '497344UK', '2018-03-20 23:34:53', 9, 'LRF3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HBLX99', 'J64LND6', '440675847X', '273143QN', '2016-02-17 23:25:20', 6, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EIPH16', 'B70VVO6', '051795419G', '022668HB', '2020-12-25 14:32:54', 12, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BKGW49', 'Y07XOX1', '934567502P', '000084VF', '2020-06-02 06:20:09', 8, 'CDH7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OVGL24', 'B48BFZ9', '725030285D', '552824UW', '2016-01-06 04:50:31', 7, 'ZCX8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YDPO33', 'H67LUX8', '006126532S', '153553II', '2020-04-16 18:46:21', 7, 'MII2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WEGG85', 'Y07XOX1', '440675847X', '739401AE', '2020-07-31 05:41:56', 1, 'RVP0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DLIC43', 'D87CPL0', '508984035K', '665913WM', '2021-07-11 16:47:13', 11, 'BRJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CRGU23', 'R16EBM0', '185479911S', '008348BE', '2018-06-26 00:31:14', 2, 'FED7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CXGG00', 'F12JVM8', '549007318J', '065620QO', '2016-02-29 08:53:35', 10, 'VBN6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MQYZ25', 'A90LJY5', '363383213B', '065620QO', '2021-06-06 20:13:59', 6, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ORBN65', 'V73RWY0', '938839845B', '422708HC', '2017-03-20 22:34:31', 4, 'EDA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NTCB47', 'H20KLJ7', '859640888S', '308844BC', '2021-03-24 21:07:20', 4, 'SUE8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JOPH74', 'W07UPL6', '469624384L', '374336OU', '2020-07-04 07:04:00', 4, 'XQY7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OGPE49', 'Y95SWL3', '340236083A', '689920JG', '2017-03-14 20:06:15', 3, 'XQY7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ERUX27', 'R04EHB7', '263548523R', '602847ZC', '2020-02-12 11:51:55', 5, 'RHH0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DUYK89', 'E64UXI3', '646313702P', '053435VB', '2017-10-22 19:15:17', 12, 'MQW6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ORQA55', 'Q96BEG8', '173374240E', '859629WQ', '2018-06-08 06:52:02', 7, 'MII2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FZPT82', 'X11HFI9', '319971554M', '308844BC', '2016-07-03 00:21:19', 9, 'VFJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZBBC98', 'L59AYE1', '588280500B', '709709IU', '2019-04-15 13:43:46', 9, 'ZPS8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SSBC99', 'B82TEX9', '105418638V', '280958MN', '2021-08-23 05:28:40', 11, 'ETF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BJPM03', 'X10NBN2', '303120368A', '153553II', '2019-03-26 11:58:47', 9, 'MPR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZNDU93', 'U54NKY1', '043858979X', '068849AS', '2018-05-01 05:55:44', 2, 'HSS3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OBIK89', 'F31IAA6', '536205627Z', '079607IP', '2019-06-27 13:08:44', 1, 'DQJ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OMQC41', 'H12QIE8', '068873503K', '835232XV', '2016-07-20 06:41:52', 9, 'AYB3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MLKS67', 'P45NLM6', '517873890E', '495365PE', '2021-08-26 20:26:48', 10, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FMMO08', 'X15JBF8', '696567274U', '009830VM', '2016-08-19 13:07:24', 11, 'EXR2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KEFK08', 'W21BWK4', '705365019A', '895484KK', '2021-05-24 15:16:32', 4, 'XRZ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QIMW93', 'F91IJK8', '781293399D', '758792MS', '2017-03-07 15:14:38', 6, 'NFB1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OHAQ81', 'R62EPI2', '683971308T', '816069KH', '2019-09-07 07:55:13', 5, 'AVG2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DXSW04', 'I49SSE8', '340236083A', '959904UU', '2018-04-13 15:53:01', 3, 'TWT6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XCAF34', 'G82TUN9', '624771266V', '125847VQ', '2020-01-26 23:01:18', 4, 'AYP2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IRXQ32', 'X82IBB5', '328642831P', '971221TV', '2018-12-03 17:50:52', 11, 'CME9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UHBN56', 'D64YVD5', '957499350R', '589150XS', '2020-02-10 20:03:20', 3, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KQIR04', 'G05ZCQ0', '262014776Y', '959904UU', '2021-05-21 19:27:58', 6, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SFPK12', 'R62EPI2', '023284312M', '157632ZH', '2021-08-04 21:46:54', 7, 'ZJN3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('GXKL04', 'R34WVX1', '504869441H', '153553II', '2019-12-28 13:23:58', 1, 'ODD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZSLM04', 'X26ACJ3', '481885108N', '497344UK', '2019-09-28 12:16:04', 1, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UZOM42', 'Q05AWW6', '023284312M', '867895XE', '2021-05-06 10:08:45', 12, 'ZRO2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WLCL47', 'G11VZO9', '303120368A', '520451SX', '2016-09-10 11:31:38', 5, 'TMT0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CFOT07', 'R84KRN5', '306030369P', '589150XS', '2017-07-12 19:28:33', 7, 'ZJN3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HOQA34', 'M44QRR6', '319971554M', '263717CV', '2020-08-27 18:31:35', 12, 'UFM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IPXR55', 'V51VZR5', '051795419G', '635301DN', '2016-09-26 21:26:18', 7, 'KYZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XPEY48', 'B70VVO6', '918200695H', '370772GJ', '2018-01-10 06:57:22', 10, 'ZAK1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZCWT38', 'X88WMX2', '478455123A', '588695MA', '2018-11-29 01:06:57', 8, 'VFJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TIOU71', 'Q67HRJ6', '620415636C', '714264ZT', '2020-05-20 22:29:19', 1, 'IID4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QQSF49', 'O52YXS5', '893087626P', '495365PE', '2017-07-30 21:22:27', 3, 'MPR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LXQS91', 'Q30UIG5', '696567274U', '796356CT', '2016-06-29 18:39:18', 1, 'UVC1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IFDQ08', 'L65GFX9', '179523211K', '110666YH', '2019-06-03 00:50:17', 3, 'MJU8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AVWK23', 'O52YXS5', '184113114O', '736639DX', '2021-10-08 21:44:18', 11, 'ZAK1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MWNE39', 'W11ROQ2', '398247344W', '077098AD', '2019-10-29 06:27:50', 2, 'DOQ7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MITB38', 'U51DRU1', '163234990W', '923205VG', '2017-05-22 00:04:49', 10, 'TMT0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RMFE37', 'R55XVR4', '263548523R', '547200VZ', '2017-05-05 20:32:49', 10, 'GZX9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VHLA57', 'X55TYZ6', '048090125S', '495365PE', '2017-04-16 08:37:36', 4, 'HAY6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VCJZ68', 'H50GHF0', '369461984V', '181086QG', '2018-07-22 12:28:14', 10, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LWAF61', 'Z81VGL7', '957499350R', '588695MA', '2017-09-13 04:15:52', 8, 'ARR5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JFPO00', 'B70VVO6', '638989847D', '552824UW', '2016-05-18 10:18:32', 5, 'EEF2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EXUZ88', 'H55ZCC0', '270438704N', '903097DQ', '2019-05-08 11:29:40', 5, 'SJY5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JNXW98', 'K95TNO6', '252056898A', '795320MM', '2017-09-15 04:53:06', 1, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AVAF45', 'K64UFS0', '410795735E', '866452YW', '2018-08-15 07:45:28', 2, 'COR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IFJY90', 'H97BFG6', '134797672A', '712452GP', '2016-04-06 02:30:03', 6, 'MQX6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TEGJ22', 'J06SGB8', '332548442S', '959904UU', '2018-12-27 10:46:28', 3, 'RZB9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZIHC06', 'R78FZR7', '138092219R', '009830VM', '2017-11-16 18:47:23', 1, 'XFP5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NUQQ26', 'M17QYG8', '321271002N', '442699XU', '2017-09-15 14:29:13', 12, 'KCL0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PIJJ68', 'Q33KPW8', '627260389P', '895484KK', '2019-02-08 02:55:12', 12, 'VNJ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XXPS22', 'Q17IUA0', '774287974Y', '859412OQ', '2017-04-15 11:13:22', 4, 'QDV1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DTER96', 'S71WEV4', '781293399D', '499965AZ', '2018-05-13 01:10:18', 3, 'FED7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IGFW90', 'Q05AWW6', '693687383B', '945383RK', '2019-03-17 03:39:00', 4, 'YNF4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HBYV64', 'U13RYR3', '163234990W', '135662ZD', '2020-04-27 10:14:17', 5, 'OOE1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DKRG87', 'Q05AWW6', '549007318J', '494055WE', '2018-01-19 19:14:14', 12, 'CUZ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BYGH67', 'B78XYR3', '549007318J', '971221TV', '2020-10-17 05:14:29', 5, 'FDI9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PKRT88', 'J84FFX3', '163234990W', '018245JV', '2019-11-22 15:22:22', 7, 'QON8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CASD85', 'U54NKY1', '475428439A', '750357QM', '2019-12-26 02:25:41', 8, 'VNJ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ASDD87', 'T83GMU4', '903044670E', '000084VF', '2018-02-07 20:47:21', 7, 'WHM7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EYNG60', 'D64YVD5', '638989847D', '594043US', '2020-11-16 12:31:13', 8, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('URUX26', 'J98MVA2', '185479911S', '066084LH', '2018-04-14 02:44:34', 4, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UBQU45', 'Z81VGL7', '852883849N', '275811UE', '2017-07-24 09:50:44', 2, 'SUE8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('COFA89', 'L59AYE1', '419131040C', '776292ZE', '2021-07-14 11:07:31', 7, 'HQC8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WOVX85', 'I49SSE8', '082373576M', '920101ZR', '2020-05-06 03:44:10', 7, 'WMZ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TMZG07', 'B34NUZ0', '300230488I', '068849AS', '2021-08-11 06:29:35', 1, 'MII2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LRMA21', 'S71WEV4', '376082483V', '866931YZ', '2020-04-12 16:13:34', 11, 'ZJZ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QEGF93', 'T45TCO4', '890583845I', '374336OU', '2020-03-09 11:15:40', 1, 'AYB3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BAHO29', 'F12JVM8', '905197247M', '119580OE', '2016-07-09 17:34:39', 12, 'JFZ9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ABJW97', 'K18ETO3', '151242685J', '878357UM', '2021-06-15 02:46:28', 3, 'JJM5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KGXI36', 'N58KJE9', '438951898B', '816069KH', '2016-11-16 10:41:49', 6, 'TFF0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VAZI05', 'N58KJE9', '904174108S', '795320MM', '2017-04-24 16:14:25', 8, 'WDS6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VZSE08', 'F26LSK7', '105418638V', '594043US', '2021-08-08 00:30:37', 4, 'WRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EITC23', 'K00DJN5', '319971554M', '520451SX', '2019-06-27 02:22:02', 3, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EUGI56', 'Q30UIG5', '703482938M', '589150XS', '2020-01-05 14:15:42', 2, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LICT28', 'W21BWK4', '567538877Z', '594043US', '2018-08-27 22:19:01', 10, 'MPR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FVRQ54', 'T96YGJ0', '226836285R', '861404GP', '2016-04-27 22:45:45', 8, 'SCA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HFNH23', 'Q96BEG8', '546836407P', '077098AD', '2017-01-09 21:10:27', 9, 'AYP2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VENK46', 'U41WPL6', '689216804E', '942793IS', '2021-11-02 12:25:21', 10, 'HHK5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XMTV73', 'T49GOM0', '176757424T', '779122PO', '2021-03-21 08:59:18', 2, 'EBD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AJXU05', 'K00DJN5', '709247980W', '598007JL', '2018-10-26 14:05:42', 8, 'XKX3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZWDJ62', 'O26RSR7', '277376266P', '330180LF', '2017-11-04 20:52:54', 10, 'TFF0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PFXI95', 'U54NKY1', '638989847D', '779122PO', '2017-05-06 03:48:09', 9, 'ARR5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SSZE98', 'X55TYZ6', '236097419P', '860365NF', '2020-07-18 13:14:02', 10, 'ARR5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ATWW63', 'H55ZCC0', '252056898A', '303407PW', '2020-12-11 04:26:56', 9, 'AYB3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BHNN00', 'W92ZPS1', '134797672A', '629765JD', '2018-08-15 08:08:16', 8, 'GAO6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WLDA27', 'R80VKR0', '499777409Q', '065620QO', '2018-11-22 12:45:15', 9, 'ARR5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HWJT73', 'Z81VGL7', '496672729C', '282668IB', '2019-07-24 16:41:33', 5, 'ZPS8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SBOT11', 'K80PBU5', '662492405O', '796356CT', '2018-11-26 05:58:42', 10, 'SQD0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TNCD90', 'X11HFI9', '236097419P', '867895XE', '2016-04-29 01:40:30', 8, 'HMR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PFWH88', 'A90LJY5', '804912605B', '356775OU', '2018-12-18 14:59:09', 6, 'DQJ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YAWG91', 'X53GOU3', '068873503K', '487198JH', '2016-08-23 04:17:11', 2, 'UPN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VYDF62', 'Q38TUZ6', '551243732A', '487198JH', '2017-03-13 17:48:16', 5, 'EBD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EDZM72', 'A85NFC1', '731482551S', '860365NF', '2016-01-26 06:45:10', 3, 'UFI0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MYRS60', 'Q05AWW6', '176757424T', '263717CV', '2016-05-01 06:12:07', 9, 'AVG2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WLQD61', 'U47UID1', '851881721R', '022668HB', '2020-05-28 08:33:40', 11, 'PGX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZVRX24', 'G61HNN8', '703492393T', '967969NP', '2021-04-11 03:10:15', 5, 'DOI3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TZOP68', 'M13XWS0', '176757424T', '406210HE', '2017-09-16 03:42:02', 6, 'ZRO2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QCYE85', 'B82TEX9', '030222740E', '291542XG', '2018-07-07 07:03:55', 1, 'CTF6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VJYM37', 'Y96GZC0', '475428439A', '629765JD', '2017-05-01 17:08:20', 6, 'ZPS8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JAFF49', 'K68EGA4', '300230488I', '291542XG', '2016-08-19 23:44:53', 4, 'EXR2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CLGH30', 'J84FFX3', '340236083A', '313618HP', '2020-12-27 14:27:21', 9, 'UFM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EKHB83', 'P45NLM6', '149071155B', '312045UV', '2017-01-04 06:49:05', 1, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RODE77', 'K95TNO6', '438951898B', '495365PE', '2021-11-12 19:59:14', 4, 'TFF0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CMCE18', 'Y07XOX1', '430772605B', '967969NP', '2021-08-24 12:14:56', 2, 'HJK6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PFVI63', 'U54NKY1', '035152296U', '113465RL', '2016-11-29 10:45:48', 12, 'HUM1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DYJL03', 'J84FFX3', '627260389P', '204291DT', '2018-12-25 21:55:05', 8, 'QBE9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CGAE78', 'H97BFG6', '227422941T', '018245JV', '2021-02-17 18:09:45', 7, 'RZB9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DSVY91', 'L24TWE0', '363383213B', '871709HX', '2016-05-02 22:57:38', 8, 'UFM4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TVMP66', 'R68VCV9', '851881721R', '374336OU', '2018-03-01 01:53:20', 7, 'TME1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NLCP49', 'H56ZWQ1', '363383213B', '651369JK', '2020-12-09 02:55:52', 2, 'ODD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EYSE02', 'V43CRH5', '369461984V', '529891ZW', '2017-07-24 19:12:24', 6, 'XYH4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('VPQI64', 'K68EGA4', '410795735E', '842521PL', '2021-06-15 08:01:23', 10, 'LHE0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MNOA43', 'M85CGE5', '206054009Y', '194104GZ', '2021-11-25 01:05:09', 10, 'UPN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MBZM22', 'R74JLT8', '068873503K', '589150XS', '2018-05-04 22:55:40', 3, 'MVL0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MWES29', 'R04EHB7', '676522141Z', '866452YW', '2020-06-06 14:48:24', 9, 'UDO7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CIRH41', 'R62EPI2', '852883849N', '858858RY', '2016-06-24 05:56:15', 9, 'LQQ7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XFOB38', 'R68KKB0', '376082483V', '705089WW', '2016-12-03 11:05:36', 11, 'MPR3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IVOX53', 'G41JHL2', '394738372Y', '774177ZB', '2020-02-19 16:31:49', 6, 'QDV1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZEHV55', 'N76TFG7', '062489308B', '010971CX', '2018-06-26 10:58:07', 4, 'WDS6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZQDM59', 'U41WPL6', '023284312M', '258449QS', '2021-06-15 11:38:54', 7, 'HMR7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NMEZ13', 'H97VDX7', '744180337H', '637556BG', '2021-09-05 10:38:14', 6, 'QXQ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LAKY81', 'J77MLD0', '638989847D', '651369JK', '2021-10-23 05:43:52', 11, 'FDI9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LEGL45', 'C05QDP0', '696567274U', '665913WM', '2017-05-07 02:19:01', 12, 'CME9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SPMO59', 'U51DRU1', '397196720Y', '275811UE', '2020-06-11 04:11:02', 8, 'EDA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YEJT71', 'B82TEX9', '633157509I', '513577KN', '2019-06-15 19:04:27', 10, 'WZY0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TPPH81', 'B50ATK3', '480133586U', '720698EK', '2020-03-10 04:14:04', 8, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WXJA72', 'W32SEA4', '051795419G', '546564OU', '2018-01-11 05:03:54', 6, 'LCJ6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XJKP61', 'H07SZM9', '373040712T', '153553II', '2017-10-16 13:22:09', 3, 'SQD0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KONT44', 'J69UBL6', '373040712T', '866931YZ', '2016-11-15 21:23:48', 10, 'JFZ9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OTEP64', 'J84FFX3', '705365019A', '371254UZ', '2016-04-07 06:30:34', 9, 'SQD0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BMGX81', 'U74SXB3', '623088424M', '282668IB', '2019-03-23 08:01:21', 12, 'SSB4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IHEZ97', 'J39DDO0', '576920130N', '464653IR', '2021-08-20 06:37:42', 9, 'HHK5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TVHD90', 'E36FUS5', '630121462K', '080131CS', '2017-01-13 03:45:10', 1, 'SQD0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MYEI41', 'B82TEX9', '043858979X', '672876CP', '2019-05-24 22:16:18', 10, 'HSS3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QLUX47', 'B48CCB9', '079537565Z', '048580VQ', '2021-07-13 01:43:20', 1, 'TMT0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YRKT59', 'Z81VGL7', '145903714D', '618368PU', '2016-11-08 00:28:43', 7, 'QBF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TPTJ79', 'E98UZQ7', '730161442H', '464653IR', '2016-01-01 06:36:36', 1, 'KIA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FZIF20', 'U47UID1', '320383285B', '339196KC', '2017-07-29 01:11:36', 2, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AGIX19', 'S23BLK1', '934567502P', '313618HP', '2016-05-10 12:03:47', 1, 'VYS6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NKJM16', 'H12QIE8', '654553683G', '563885ZU', '2016-11-02 11:04:32', 4, 'WYD5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DRSJ42', 'S23BLK1', '536205627Z', '736639DX', '2020-04-28 14:23:21', 12, 'XKX3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YXKY51', 'K95TNO6', '320383285B', '204291DT', '2018-06-30 00:55:20', 9, 'PXN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PLFX61', 'H97BFG6', '157784697Y', '792946FE', '2020-12-14 08:33:16', 2, 'HGQ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SCWO70', 'K00DJN5', '528375746S', '720698EK', '2019-11-18 00:27:39', 10, 'QBE9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NYIX63', 'R16EBM0', '646313702P', '277156EI', '2020-10-30 18:58:41', 4, 'APZ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WDXB61', 'N58KJE9', '006126532S', '542354MN', '2018-06-14 23:32:47', 6, 'TFF0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WEIJ40', 'F30LVH8', '990783493P', '113465RL', '2017-01-09 08:36:41', 5, 'ODD6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NKWB45', 'M44QRR6', '523679322Y', '635301DN', '2020-10-02 10:09:32', 8, 'LXB6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ERIC29', 'J69UBL6', '839939902W', '858858RY', '2017-01-12 11:50:53', 6, 'UVC1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UEEN55', 'R59OBH2', '430772605B', '313618HP', '2021-04-06 22:01:59', 11, 'SWB8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MIOD72', 'X31HJI1', '594455502K', '280958MN', '2016-03-30 14:20:41', 8, 'TAH6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LFQF32', 'W17IWD6', '676522141Z', '450839JZ', '2019-11-29 15:10:06', 10, 'EQZ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TTCD02', 'G75ZOA9', '789954790S', '965932UQ', '2017-09-12 16:23:56', 8, 'UNZ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RQKC37', 'H12QIE8', '971898444G', '364595KW', '2017-06-13 18:12:05', 3, 'VNJ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('IEZB16', 'G68GGM7', '956032232X', '779122PO', '2017-03-29 19:24:29', 8, 'XYH4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HYAU76', 'E55SSY1', '063364295I', '588695MA', '2016-01-14 08:40:31', 5, 'RZB9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SRRK50', 'N74ULY4', '723870867D', '699036TZ', '2017-02-14 20:15:43', 8, 'EDA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('UVLM71', 'F03JFC5', '184113114O', '385720VY', '2021-02-26 22:40:02', 10, 'QNF7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XXNO51', 'X88WMX2', '528375746S', '204291DT', '2016-12-09 07:15:15', 9, 'HSS3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SSWP01', 'J69UBL6', '104581889J', '618368PU', '2019-07-20 19:41:25', 2, 'NSH9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ONZM25', 'A85NFC1', '810451330U', '530977FV', '2021-05-30 10:01:17', 1, 'OAJ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BLBJ49', 'J79SKR7', '634532858H', '942793IS', '2018-11-16 19:00:40', 12, 'MQW6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KUZU94', 'B48CCB9', '282798534O', '313618HP', '2018-07-09 05:04:38', 1, 'HJK6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('HHYG24', 'S71WEV4', '634532858H', '282668IB', '2019-11-10 05:33:26', 6, 'EDA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OFZE14', 'J64LND6', '956032232X', '923205VG', '2018-05-23 23:44:11', 11, 'UPN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('QLQW53', 'C35IXL6', '730161442H', '204291DT', '2017-03-29 20:51:50', 11, 'ZCB8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YOAF98', 'W08WET4', '233461298A', '742840AD', '2018-03-26 21:01:24', 12, 'JJM5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PDOC41', 'H07SZM9', '900131706L', '665913WM', '2018-01-28 08:04:33', 2, 'UEW1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('MKSS58', 'L30OAB4', '374690163D', '588695MA', '2021-07-18 19:10:08', 1, 'UCZ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OPCW01', 'I13ABP5', '654553683G', '065620QO', '2021-03-11 08:32:50', 1, 'TMT0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EEFV55', 'V51VZR5', '900131706L', '194723PN', '2019-12-31 01:31:40', 12, 'VOB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AMKG63', 'M17QYG8', '438951898B', '816069KH', '2017-11-05 15:28:17', 8, 'DQJ0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('YXRH79', 'P63QQK8', '227422941T', '204291DT', '2016-12-15 18:20:56', 3, 'IJD4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('FULU38', 'F47NYN6', '918200695H', '330180LF', '2018-04-19 19:11:57', 10, 'QBE9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('BFZC92', 'D84RNK2', '236097419P', '853591LN', '2016-11-06 13:04:51', 6, 'PXN7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CEAO80', 'C53IZV8', '904174108S', '819685IH', '2016-07-11 19:34:26', 8, 'TRQ5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NSBC87', 'K57JIA2', '689737943E', '487198JH', '2021-08-11 22:14:48', 11, 'XVQ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XSWN54', 'C10FWL0', '804912605B', '699036TZ', '2021-01-06 05:04:11', 3, 'XRZ4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('OTCB86', 'L84DFQ2', '700224352I', '465887VX', '2021-03-03 13:36:18', 7, 'LML8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CFMX91', 'Z13BTG5', '171568970U', '914945PH', '2019-10-22 13:42:18', 7, 'JOA4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NODV38', 'C53IZV8', '306030369P', '879368RO', '2018-04-19 14:44:07', 11, 'QBF8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('KBGG79', 'Q30UIG5', '508984035K', '705089WW', '2017-12-22 21:18:42', 9, 'UYZ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('XSTZ86', 'X55TYZ6', '297023554G', '520451SX', '2017-03-03 06:00:25', 6, 'OBM3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SPZZ25', 'R68LFX0', '276290889A', '163470EV', '2017-09-28 10:24:53', 11, 'OEE3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CIJM40', 'G68GGM7', '612977845G', '009830VM', '2017-12-16 03:11:43', 1, 'CRE6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('SHDB17', 'Y04FBS8', '433217946H', '806868HF', '2016-08-18 15:37:37', 5, 'ZRO2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CSFK29', 'K68EGA4', '133776055Y', '529891ZW', '2021-04-09 14:02:58', 12, 'JBY9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NHKX50', 'E74TWS1', '475428439A', '819685IH', '2018-07-12 12:10:08', 5, 'TWT6');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('NPUV61', 'U54NKY1', '173374240E', '637556BG', '2017-03-28 16:16:16', 8, 'BEK0');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JWJK12', 'Q05AWW6', '890583845I', '546015WF', '2016-11-06 23:01:11', 7, 'CME9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ACRV19', 'H33DSI3', '241741467J', '177659BU', '2018-07-14 16:48:10', 3, 'UCF1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZFIC49', 'H48XIS9', '376082483V', '637556BG', '2016-12-26 21:14:28', 10, 'WRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PLQL85', 'J64LND6', '703482938M', '714865CS', '2020-11-24 00:44:47', 2, 'CDH7');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('ZUUK25', 'M71LZZ0', '546836407P', '928416XS', '2020-08-10 17:19:49', 6, 'VOB5');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JRXU57', 'H97VDX7', '145903714D', '135662ZD', '2021-06-26 00:05:31', 3, 'UYZ2');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('CTAQ19', 'J98MVA2', '630121462K', '796989PJ', '2018-09-15 16:00:07', 7, 'KAQ1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('TKUR44', 'R68KKB0', '252056898A', '374336OU', '2018-12-13 11:21:50', 1, 'QPN3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PJQX48', 'W11ROQ2', '082373576M', '718362IS', '2019-02-25 06:12:02', 12, 'IJD4');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WCUU03', 'O52YXS5', '241741467J', '899781CS', '2016-08-18 10:32:49', 6, 'FDI9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('JIMU85', 'X11HFI9', '393850830J', '386008HE', '2017-10-08 15:40:57', 9, 'EUX1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('WOOH07', 'Y04FBS8', '340236083A', '308844BC', '2018-10-11 05:45:10', 3, 'MJU8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RYFZ39', 'T83GMU4', '043858979X', '135662ZD', '2020-08-30 02:19:15', 6, 'PRJ3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('PHJF98', 'Q22BBX9', '005230863X', '688809MA', '2017-01-12 07:16:33', 7, 'BRJ8');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EBEL90', 'F91IJK8', '125684064Y', '676821LN', '2018-08-01 13:04:28', 10, 'JBY9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('DCVW95', 'K57JIA2', '398247344W', '959088YH', '2020-04-21 08:34:43', 9, 'RZB9');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('AYCB92', 'R68KKB0', '938839845B', '000084VF', '2018-08-30 18:55:14', 10, 'KAQ1');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('EXAR20', 'E55SSY1', '903044670E', '903097DQ', '2018-03-05 14:15:54', 1, 'ZJN3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('LAXW57', 'Y04FBS8', '549007318J', '291542XG', '2020-12-10 10:43:41', 3, 'EDA3');
insert into VUELO (idvuelo, idavion, idrecorrido, idaerolinea, fecha_salida, numpista, codpuerta) values ('RVMV64', 'M44QRR6', '785280662Z', '079607IP', '2021-08-25 15:23:39', 5, 'SWB8');

insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0878FK3073VV226', 'KKXL78', 'OCIO', '2016-11-22 15:03:41', 2837.91, 'FISICO', 'Furi Viajes', 0.19, 'BUSINESS', '97G', '53712077K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7242EW2626JZ820', 'GESN89', 'OCIO', '2020-03-09 16:16:07', 1511.34, 'DIGITAL', 'Alejandro Murias Turismo', 0, 'TURISTA', '16G', '43167839X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1018TK7373KK378', 'GXKL04', 'OCIO', '2019-12-03 06:23:58', 3236.75, 'DIGITAL', 'C-Costa Cruceros', 0.05, 'TURISTA', '8G', '13195673E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9064DF6311DQ841', 'SRFF00', 'OCIO', '2021-03-05 10:15:56', 3259.69, 'DIGITAL', 'Estudio Turistico', 0.28, 'PREFERENTE', '50F', '26807992N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7048VW0500MX277', 'DYZX90', 'TRABAJO', '2019-08-15 18:41:56', 1647.02, 'DIGITAL', 'Prosa Viajes', 0.14, 'TURISTA', '36C', '31649376I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0268VX4997SE488', 'ORBN65', 'TRABAJO', '2017-01-18 15:34:31', 2236.95, 'DIGITAL', 'Garcia Fernandez Turismo', 0.25, 'PREFERENTE', '9F', '31649376I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9231CZ0688SP738', 'TEGJ22', 'TRABAJO', '2018-10-12 19:46:28', 2864.72, 'FISICO', 'Aymara Turismo', 0.07, 'TURISTA', '46D', '88975906N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2405MM2074RJ729', 'RBOW00', 'TRABAJO', '2017-08-20 02:30:43', 2772.81, 'DIGITAL', 'Turismo Pecom S.A.C.F.I.', 0, 'TURISTA', '42F', '85659619A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1765OO0408XL461', 'UABQ51', 'OCIO', '2019-09-27 13:45:10', 206.61, 'FISICO', 'Oestetour S.R.L.', 0.18, 'TURISTA', '2F', '30537638Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1528IQ0676AV306', 'EAWB19', 'OCIO', '2016-11-24 01:58:47', 1585.98, 'DIGITAL', 'Scholem Tur S.R.L.', 0.03, 'PREFERENTE', '56G', '00247726I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9045WP0995TX510', 'EYSE02', 'OCIO', '2017-04-30 05:12:24', 3566.89, 'FISICO', 'Punta Del Sol Viajes', 0.07, 'PREFERENTE', '8G', '22463253I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9914ET3576TA187', 'ZXOY75', 'ESTUDIOS', '2021-09-21 16:29:09', 199.62, 'DIGITAL', 'Elio Ricardo Cuello E Hijos', 0.03, 'TURISTA', '13G', '09904890A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6127AC5593SM696', 'WEIJ40', 'TRABAJO', '2016-11-05 10:36:41', 48.51, 'FISICO', 'Turismo Oldani', 0.15, 'TURISTA', '8G', '88353701Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6609JB9439CH230', 'JBRQ29', 'ESTUDIOS', '2020-02-19 18:36:16', 2260.4, 'FISICO', 'Jorge Tagle Servicios Turisticos', 0.28, 'PREFERENTE', '47F', '28368887A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7141IL7982VT282', 'MWES29', 'TRABAJO', '2020-05-27 10:48:24', 3711.13, 'DIGITAL', 'Travel Company', 0.23, 'PREFERENTE', '71F', '19767799D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6389OG3352MC810', 'GEPY67', 'OCIO', '2017-04-23 14:58:39', 1043.42, 'FISICO', 'Barlovento Viajes Y Turismo', 0.2, 'TURISTA', '81G', '26491980A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0131VQ0952VP737', 'DSVY91', 'TRABAJO', '2016-02-13 13:57:38', 2139.31, 'DIGITAL', 'Levy''S Tours', 0, 'PREFERENTE', '7F', '84661096R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2708KB0548HN771', 'CSFK29', 'TRABAJO', '2021-02-22 12:02:58', 1860.77, 'FISICO', 'Damsol Turismo Internacional', 0.15, 'TURISTA', '8G', '41791106A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9774PQ1929WN518', 'CIJM40', 'TRABAJO', '2017-12-12 10:11:43', 3232.2, 'DIGITAL', 'Diser Viajes Y Turismo', 0.12, 'TURISTA', '61G', '80131381X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6750AK4823TL543', 'EEFV55', 'ESTUDIOS', '2019-11-20 14:31:40', 2379.81, 'FISICO', 'Oestetour S.R.L.', 0.18, 'BUSINESS', '7G', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4475CY6058OO028', 'TTCD02', 'OCIO', '2017-07-06 02:23:56', 1516.92, 'DIGITAL', 'Turismo Viajes S.R.L.', 0.2, 'PREFERENTE', '9F', '70464474N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8339NZ5826BG648', 'NKJM16', 'ESTUDIOS', '2016-08-22 23:04:32', 2638.02, 'FISICO', 'Avc - Agencia De Viajes Centro', 0.03, 'PREFERENTE', '0F', '29838624Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8297NS1197SY624', 'BJPM03', 'ESTUDIOS', '2019-03-01 11:58:47', 2655.96, 'FISICO', 'Polvani Tours', 0.13, 'PREFERENTE', '4B', '38280831H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3697UQ7181IE462', 'GEPY67', 'OCIO', '2017-02-20 03:58:39', 1043.42, 'FISICO', 'Hispatur Empresa De Viajes Y Turismo', 0.04, 'PREFERENTE', '9C', '44546083M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9175PG2501ZI126', 'CFOT07', 'OCIO', '2017-06-05 03:28:33', 3739.02, 'FISICO', 'Chacotur Viajes S.R.L.', 0.08, 'TURISTA', '1G', '92932216M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6378YY3916WQ374', 'IPXR55', 'ESTUDIOS', '2016-09-21 09:26:18', 569.84, 'DIGITAL', 'Asociacion Bancaria (Asociacion De Empleados De Banco)', 0.06, 'BUSINESS', '24A', '41349385O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3234WX7576AP862', 'GOWS75', 'ESTUDIOS', '2021-06-15 02:36:32', 558.38, 'FISICO', 'Prime Travel', 0.1, 'PREFERENTE', '7F', '29838624Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4903CS6277BH254', 'JOPH74', 'TRABAJO', '2020-04-10 17:04:00', 3881.69, 'FISICO', 'Hispania Turismo S.A.', 0.06, 'PREFERENTE', '0G', '58496330S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1491DW7090VL702', 'RMFE37', 'OCIO', '2017-04-27 22:32:49', 3782.33, 'FISICO', 'Leon Travel', 0.16, 'TURISTA', '89F', '41349385O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3095CV0954FE593', 'BMGX81', 'OCIO', '2019-01-19 20:01:21', 169.31, 'FISICO', 'Equitur S.R.L.', 0.06, 'TURISTA', '0G', '02382074A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3304OY5582HI050', 'BFZC92', 'TRABAJO', '2016-10-01 08:04:51', 1757.03, 'DIGITAL', 'Planeta Tierra', 0.08, 'TURISTA', '9G', '86687145N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1952QG9786AV915', 'JNXW98', 'TRABAJO', '2017-06-28 14:53:06', 2889.43, 'DIGITAL', 'Alumine', 0.1, 'BUSINESS', '1F', '03709449R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0076ZB6182UQ348', 'SJHN46', 'OCIO', '2018-08-22 18:36:22', 117.08, 'DIGITAL', 'Tierras Y Gentes', 0.09, 'PREFERENTE', '3C', '09904890A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2794AR5589CD983', 'QRFV95', 'ESTUDIOS', '2016-06-12 22:37:47', 1936.36, 'FISICO', 'Sintec Tur L''Alianxa Travel Network Argentina', 0.1, 'TURISTA', '1G', '70891770A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6021KP8574HI319', 'VGTY59', 'TRABAJO', '2016-04-18 18:54:27', 1831.89, 'FISICO', 'Badia Tour', 0.15, 'BUSINESS', '52G', '58496330S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5023OY1084DM028', 'MYEI41', 'TRABAJO', '2019-05-18 18:16:18', 3004.81, 'DIGITAL', 'Sonia Witte', 0.07, 'PREFERENTE', '0F', '22012118W');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7225KH5693JM703', 'EUGI56', 'OCIO', '2019-10-30 08:15:42', 3117.66, 'FISICO', 'Turismo Ale', 0.13, 'BUSINESS', '18F', '12623557E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7853PV9793BN402', 'UHOJ14', 'OCIO', '2021-09-30 08:11:04', 529.21, 'DIGITAL', 'Rainforest', 0.15, 'BUSINESS', '3B', '67716684G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2948FR9080UT711', 'JGGE03', 'OCIO', '2019-03-23 17:25:21', 2499.02, 'FISICO', 'Turecon', 0.19, 'PREFERENTE', '67F', '74256620Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7753EG0623ID565', 'ZSLM04', 'OCIO', '2019-06-30 13:16:04', 1069.43, 'DIGITAL', 'Firenze Viajes', 0.23, 'TURISTA', '42F', '57403366Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9902QO7472WK073', 'FSIO41', 'ESTUDIOS', '2020-03-20 11:20:06', 3215.24, 'DIGITAL', 'Molise Viajes', 0.22, 'TURISTA', '44G', '28368887A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3907ZJ3747GY915', 'WFEB86', 'OCIO', '2017-09-17 19:13:53', 3313.9, 'FISICO', 'Turismo Don Francisco', 0.15, 'PREFERENTE', '70D', '79962229X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5203KV7309WC559', 'YXKY51', 'OCIO', '2018-04-24 11:55:20', 18.55, 'DIGITAL', 'Beachcomber Tours', 0.19, 'PREFERENTE', '2G', '11375516I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9278TP9809VO331', 'UHBN56', 'ESTUDIOS', '2019-11-28 15:03:20', 2066.64, 'FISICO', 'T.A.S. Turismo', 0, 'BUSINESS', '5G', '58844888I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0257SJ1353ZK045', 'UZOM42', 'ESTUDIOS', '2021-04-22 13:08:45', 2194.32, 'DIGITAL', 'Naipi Viajes Y Negocios', 0.13, 'PREFERENTE', '11G', '38234174I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9514QH9350AW813', 'EITC23', 'ESTUDIOS', '2019-05-29 11:22:02', 3352.28, 'DIGITAL', 'Passingtur S.R.L.', 0.27, 'PREFERENTE', '2F', '05014779K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9980JY1617WI087', 'VPQI64', 'ESTUDIOS', '2021-05-16 13:01:23', 1896.24, 'FISICO', 'Ferrytur', 0.28, 'BUSINESS', '14G', '47938670T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5145AV1753TC029', 'JNXW98', 'ESTUDIOS', '2017-06-28 06:53:06', 2889.43, 'DIGITAL', 'Club Atletico San Jorge Mutual Y Social', 0.27, 'PREFERENTE', '2F', '70716796H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3515YN1971TC819', 'LWAF61', 'ESTUDIOS', '2017-07-14 03:15:52', 3952.46, 'FISICO', 'Turismo Ballester S.A.', 0.25, 'TURISTA', '3G', '53961118L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7029IV2351FX824', 'WIBT45', 'OCIO', '2021-02-25 17:49:36', 2444.45, 'FISICO', 'Les Amis', 0.08, 'TURISTA', '26D', '27278555E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1620JI8873ID377', 'LRMA21', 'OCIO', '2020-01-21 04:13:34', 1533.39, 'DIGITAL', 'Magnus Viajes Y Turismo', 0.07, 'PREFERENTE', '8G', '78133090Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3976ZB3319ID065', 'WFEB86', 'OCIO', '2017-10-04 10:13:53', 3313.9, 'FISICO', 'Maria Y Maria Viajes Y Turismo', 0.05, 'PREFERENTE', '54G', '83743817J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8894PL9335HB272', 'TZOP68', 'OCIO', '2017-06-27 00:42:02', 2631.64, 'DIGITAL', 'Spring Travel', 0.07, 'BUSINESS', '0F', '61436494H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4823MI6882PY763', 'YMZO63', 'TRABAJO', '2017-07-12 10:02:12', 2048.47, 'DIGITAL', 'Alfageme Viajes', 0.11, 'PREFERENTE', '66G', '42954838B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7423IW8877XY815', 'TPPH81', 'OCIO', '2020-02-05 00:14:04', 2299.11, 'DIGITAL', 'Martesa Tours', 0.29, 'BUSINESS', '49C', '16305315P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1590DF2368MS387', 'ZYDW53', 'TRABAJO', '2016-10-01 08:41:18', 2510.96, 'FISICO', 'Grado 42', 0.11, 'TURISTA', '59G', '49455567O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0405SX5173DE594', 'GKLW48', 'TRABAJO', '2016-10-10 11:04:19', 1375.21, 'FISICO', 'Rumbo Sur Sociedad De Responsabilidad Limitada', 0.25, 'BUSINESS', '4G', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8549MZ9112IZ314', 'OMQC41', 'OCIO', '2016-07-04 16:41:52', 2669.46, 'DIGITAL', 'Turismo Certificado', 0.24, 'BUSINESS', '2D', '28368887A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8235BR0938NP780', 'CLGH30', 'OCIO', '2020-12-06 23:27:21', 617.69, 'DIGITAL', 'El Lago S.A. Viajes', 0.07, 'PREFERENTE', '7D', '40208744O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7822MB7045WP375', 'GGFX19', 'ESTUDIOS', '2019-04-25 10:30:55', 2919.35, 'FISICO', 'Alejandro Maruzzi Empresa De Viajes Y Turismo', 0.08, 'BUSINESS', '5D', '23206970X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2202QP7444KL603', 'BZUM50', 'OCIO', '2020-11-14 02:29:33', 1622.39, 'FISICO', 'Turismo Tastil', 0.09, 'PREFERENTE', '80G', '82767796L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8154PY6651KD397', 'ABJW97', 'TRABAJO', '2021-06-12 23:46:28', 3918.23, 'FISICO', 'Albo Rap', 0.2, 'TURISTA', '67F', '65736826L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3793FU5784MZ230', 'NLCP49', 'OCIO', '2020-09-14 09:55:52', 2347.86, 'DIGITAL', 'Erman Tour', 0.17, 'TURISTA', '5G', '01729342J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4334RE6272JV605', 'GXKL04', 'OCIO', '2019-10-06 21:23:58', 3236.75, 'DIGITAL', 'Caliri Viajes Y Turismo', 0.09, 'PREFERENTE', '97F', '14970824X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5199UY1916OE939', 'WEGG85', 'OCIO', '2020-06-25 05:41:56', 2068.67, 'FISICO', 'Hermotur', 0.01, 'PREFERENTE', '74F', '47428291L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6509RN8927LU607', 'DFRY94', 'ESTUDIOS', '2019-06-25 17:26:04', 2861.7, 'DIGITAL', 'Rumbo S.R.L.', 0.14, 'TURISTA', '09C', '37900304M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2833SP6508DW024', 'EYSE02', 'TRABAJO', '2017-06-01 05:12:24', 3566.89, 'DIGITAL', 'Coovaeco Turismo', 0.03, 'PREFERENTE', '2G', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5426PH9583UX423', 'QEGF93', 'ESTUDIOS', '2019-12-24 16:15:40', 2811.99, 'FISICO', 'Nuestro Mundo', 0.29, 'TURISTA', '4F', '18260942C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4333FL6982FE983', 'HMXJ20', 'ESTUDIOS', '2016-04-18 12:32:37', 2800.24, 'DIGITAL', 'D.M.S. Tour', 0.22, 'BUSINESS', '75G', '90924101M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1293UQ7973FK172', 'ORBN65', 'ESTUDIOS', '2017-01-20 03:34:31', 2236.95, 'FISICO', 'De Allende Viajes Y Turismo S.R.L.', 0.1, 'PREFERENTE', '6D', '85659619A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8020JG5503ZY033', 'ZFUA60', 'ESTUDIOS', '2018-11-16 04:47:41', 3353.74, 'DIGITAL', 'Agencia De Viajes Y Turismo Chalten', 0.27, 'TURISTA', '09C', '43914194N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9796KP7014YB567', 'YOAF98', 'ESTUDIOS', '2018-01-11 11:01:24', 1563.11, 'DIGITAL', 'Oremar', 0.1, 'TURISTA', '16G', '58496330S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4732WJ4414EI643', 'WQEE03', 'ESTUDIOS', '2016-09-18 21:10:18', 3984.04, 'DIGITAL', 'El Claro', 0.11, 'PREFERENTE', '8G', '27848391E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2145NE4380CA284', 'HYKO22', 'ESTUDIOS', '2019-04-27 08:41:44', 3193.73, 'FISICO', 'Spring Travel', 0.07, 'TURISTA', '0G', '93990482O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8028VX2520SK628', 'WCUU03', 'TRABAJO', '2016-07-13 06:32:49', 3233.74, 'FISICO', 'Gador Viajes', 0.27, 'TURISTA', '22C', '37398296C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2713CJ3144HI859', 'DYZX90', 'TRABAJO', '2019-08-20 14:41:56', 1647.02, 'FISICO', 'Go - Up', 0.11, 'PREFERENTE', '57F', '85659619A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6435YC4565HV478', 'ASDD87', 'ESTUDIOS', '2017-12-01 17:47:21', 2143.15, 'DIGITAL', 'Turisur Navegando La Patagonia', 0.24, 'PREFERENTE', '85F', '25886038L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6652XJ1274MG124', 'CIRH41', 'OCIO', '2016-06-12 09:56:15', 1730.85, 'DIGITAL', 'Shelk''Nam Viajes', 0.12, 'BUSINESS', '9G', '48758609Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0662PH1065JR762', 'WBKB29', 'OCIO', '2021-04-27 02:33:11', 2085.44, 'DIGITAL', 'Van Tur', 0.24, 'PREFERENTE', '3F', '99591663Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5484SK0116EN550', 'FVRQ54', 'ESTUDIOS', '2016-02-22 01:45:45', 17.21, 'FISICO', 'Action Travel', 0.21, 'BUSINESS', '93D', '51788970Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9198QV2356DB462', 'OHAQ81', 'OCIO', '2019-08-03 12:55:13', 3033.4, 'FISICO', 'Karen Travel', 0.15, 'TURISTA', '0D', '09904890A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1007UR9800GK015', 'WEIJ40', 'OCIO', '2016-12-27 06:36:41', 48.51, 'DIGITAL', 'Zanzibar Viajes Y Turismo', 0.02, 'PREFERENTE', '5G', '47938670T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7523TF2176AR393', 'MJZB56', 'TRABAJO', '2021-04-04 09:49:05', 3055.78, 'DIGITAL', 'Z.T. Zarate Turismo', 0.25, 'PREFERENTE', '17G', '72816443M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7918NI4293DS158', 'QEHU12', 'ESTUDIOS', '2016-11-17 22:52:39', 1573.48, 'DIGITAL', 'San Nicolas Tur', 0.23, 'BUSINESS', '5G', '30744361T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0472NT0376JU716', 'ORQA55', 'TRABAJO', '2018-04-22 20:52:02', 876.27, 'DIGITAL', 'Keenly Travel', 0.15, 'TURISTA', '35F', '35493398N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2166SR9667FV767', 'AGLS23', 'OCIO', '2016-12-23 18:25:09', 3483.66, 'FISICO', 'Viajes Celta', 0.04, 'PREFERENTE', '75F', '05413206A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1364XC9103PQ326', 'XWIE41', 'ESTUDIOS', '2019-10-16 13:57:46', 2323.31, 'FISICO', 'El Torreon Viajes Y Turismo', 0.25, 'PREFERENTE', '3F', '43216152P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5266CT0474RM401', 'IEZB16', 'TRABAJO', '2016-12-31 10:24:29', 2556.76, 'FISICO', 'Cuyun - Co', 0.11, 'PREFERENTE', '9F', '74527513B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4208MU6366CM741', 'ONZM25', 'ESTUDIOS', '2021-05-26 14:01:17', 518.53, 'FISICO', 'Neptunia S.R.L.', 0.18, 'PREFERENTE', '90C', '06553546P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1516EV0157MK237', 'KATU27', 'TRABAJO', '2021-01-15 13:32:21', 1558.32, 'FISICO', 'Huarpe Viajes Y Turismo', 0.2, 'BUSINESS', '25G', '27278555E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3716VF0284PC252', 'VKVA87', 'ESTUDIOS', '2018-09-22 10:47:46', 2765.37, 'FISICO', 'Sauchuk Turismo', 0.29, 'BUSINESS', '3G', '53937246W');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3870OO5295WL673', 'DYZX90', 'ESTUDIOS', '2019-07-18 09:41:56', 1647.02, 'FISICO', 'Uco Travel', 0.17, 'TURISTA', '6G', '38280831H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3762FY8099JE695', 'MYEI41', 'OCIO', '2019-04-06 23:16:18', 3004.81, 'DIGITAL', 'Sindicato De Luz Y Fuerza', 0.15, 'TURISTA', '90F', '83743817J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7841TZ0521UB164', 'DKRG87', 'TRABAJO', '2017-12-09 01:14:14', 3759.81, 'FISICO', 'Anhelos', 0.01, 'TURISTA', '64D', '30430995N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4632SQ6976LH886', 'ZQDM59', 'OCIO', '2021-05-03 15:38:54', 3767.91, 'DIGITAL', 'Joytur', 0.13, 'TURISTA', '97D', '49247296N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2928YY9749KC522', 'IRXQ32', 'ESTUDIOS', '2018-10-17 14:50:52', 2147.5, 'FISICO', 'Della Croce Tour', 0.25, 'TURISTA', '67G', '82222322K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7363TT7098SU302', 'UHOJ14', 'ESTUDIOS', '2021-10-04 14:11:04', 529.21, 'FISICO', 'Sentinel Travel', 0.19, 'PREFERENTE', '54G', '85659619A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9250FS2193CJ619', 'MYRS60', 'OCIO', '2016-02-26 04:12:07', 928.89, 'DIGITAL', 'Excel Viajes', 0.15, 'PREFERENTE', '8D', '56904806S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0699ET7581OC392', 'FVRQ54', 'OCIO', '2016-03-12 08:45:45', 17.21, 'FISICO', 'Pilar Garcia', 0.09, 'BUSINESS', '83F', '80902946P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1353VA2240YM655', 'VYZZ71', 'ESTUDIOS', '2018-04-24 21:49:08', 2129.79, 'DIGITAL', 'Westur', 0.12, 'PREFERENTE', '4G', '38234174I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1248JE2381EV840', 'MQYZ25', 'TRABAJO', '2021-06-04 19:13:59', 321.86, 'FISICO', 'Subal Tur', 0.09, 'PREFERENTE', '02G', '94342268B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4221YY0246BD985', 'DKRG87', 'ESTUDIOS', '2018-01-15 13:14:14', 3759.81, 'FISICO', 'Vatapa Tur', 0.24, 'TURISTA', '30F', '73494812M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2061BK3941SM869', 'KGXI36', 'TRABAJO', '2016-10-02 13:41:49', 1001.18, 'FISICO', 'San Cristobal Viajes Y Turismo', 0.25, 'TURISTA', '07G', '31649376I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7704QV4840TI315', 'RRIU06', 'TRABAJO', '2016-06-22 00:59:40', 2777.19, 'DIGITAL', 'Turismo Serrano', 0.17, 'BUSINESS', '81G', '92799068T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1902ZG9952OQ424', 'BITY64', 'OCIO', '2016-02-14 13:26:57', 1347.55, 'FISICO', 'Mares K Turismo', 0.25, 'BUSINESS', '3G', '99591663Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3080MT8705MU509', 'AGLS23', 'ESTUDIOS', '2017-01-19 00:25:09', 3483.66, 'DIGITAL', 'Mulemba', 0, 'PREFERENTE', '30G', '42954838B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7772GC0447BW149', 'BZUM50', 'ESTUDIOS', '2020-11-21 06:29:33', 1622.39, 'FISICO', 'Turismo Uspallata', 0.17, 'BUSINESS', '40F', '19328559L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3142WU9058DI797', 'IFDQ08', 'TRABAJO', '2019-04-18 14:50:17', 1890.33, 'DIGITAL', 'Transnoa Viajes', 0.18, 'TURISTA', '61G', '56904806S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2035OG6976MV278', 'QIMW93', 'ESTUDIOS', '2017-02-15 10:14:38', 1663.29, 'FISICO', 'Joytur', 0.13, 'PREFERENTE', '18F', '21597780C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2632EO3924BN567', 'CIJM40', 'OCIO', '2017-10-26 16:11:43', 3232.2, 'DIGITAL', 'Balogh Turismo', 0.05, 'BUSINESS', '50F', '03709449R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9931DN7727FR259', 'EYSE02', 'ESTUDIOS', '2017-05-02 02:12:24', 3566.89, 'FISICO', 'Asociacion Bancaria (Asociacion De Empleados De Banco)', 0.06, 'BUSINESS', '97D', '80548424Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0257TA2787II446', 'DIGA57', 'TRABAJO', '2018-02-20 20:22:16', 3739.51, 'FISICO', 'Turismo Sur Internacional', 0.15, 'TURISTA', '7F', '55581377B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6388XW9801DB205', 'XFOB38', 'ESTUDIOS', '2016-10-02 10:05:36', 734.93, 'DIGITAL', 'Savaglio Viaggi', 0.22, 'PREFERENTE', '38F', '89255796Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0695YU3463VR394', 'MITB38', 'ESTUDIOS', '2017-04-29 21:04:49', 197.44, 'DIGITAL', 'Rand Tours', 0.03, 'TURISTA', '6C', '37900304M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1898PE8528HC234', 'KEFK08', 'OCIO', '2021-05-14 06:16:32', 1738.71, 'FISICO', 'King Midas', 0.07, 'PREFERENTE', '2G', '38280831H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4786MP6587MY382', 'PLFX61', 'ESTUDIOS', '2020-10-08 06:33:16', 1704.4, 'FISICO', 'Caliri Viajes Y Turismo', 0.09, 'BUSINESS', '7G', '88460292P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4175BS3894TM619', 'PLQL85', 'OCIO', '2020-11-10 16:44:47', 1877.61, 'FISICO', 'Guilhem Turismo', 0.29, 'TURISTA', '6F', '56443612Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1293US3828FD302', 'MNOA43', 'OCIO', '2021-09-09 06:05:09', 3886.24, 'DIGITAL', 'Olano Viajes Y Turismo Srl', 0.06, 'TURISTA', '70G', '31238243H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8526OX2584LX278', 'DLIC43', 'ESTUDIOS', '2021-04-16 02:47:13', 570.5, 'DIGITAL', 'Bolivie Tur Pasajes - Agente Btp.Com.Ar', 0.29, 'TURISTA', '81A', '93205706M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7952OK0693WZ026', 'MBZT21', 'OCIO', '2018-01-07 20:34:53', 3773.13, 'FISICO', 'Obra Social Union Del Personal Civil De La Nacion', 0.03, 'TURISTA', '72G', '79839942M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7988AK7507AB850', 'RODE77', 'ESTUDIOS', '2021-11-12 13:59:14', 1221.7, 'DIGITAL', 'Fosco Turismo', 0.04, 'TURISTA', '9G', '57403366Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9128HU6150LM121', 'RBOW00', 'TRABAJO', '2017-08-08 17:30:43', 2772.81, 'FISICO', 'Turismo Filadelfia', 0.17, 'TURISTA', '6G', '94489726X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0187AJ5250HY011', 'EYSE02', 'OCIO', '2017-05-25 22:12:24', 3566.89, 'DIGITAL', 'Surland Viajes', 0.03, 'BUSINESS', '3G', '83743817J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0054TT1491YT268', 'QVYE27', 'OCIO', '2018-03-21 00:46:24', 1528.7, 'DIGITAL', 'Sinfonia Travel', 0.13, 'PREFERENTE', '8G', '30430995N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9574FR9837VK599', 'QLQW53', 'TRABAJO', '2017-02-11 12:51:50', 1853.04, 'FISICO', 'Bliss', 0.21, 'PREFERENTE', '36F', '22463253I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7157DW4612OT962', 'MYOS45', 'TRABAJO', '2021-04-07 08:07:04', 1198.65, 'FISICO', 'Direccion De Bienestar De La Armada', 0.28, 'TURISTA', '30G', '42954838B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4851OE2513GZ474', 'ZYDW53', 'TRABAJO', '2016-09-24 15:41:18', 2510.96, 'FISICO', 'Turismo Franck', 0.08, 'TURISTA', '84G', '13640802Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6576KW2630QN407', 'HYDE22', 'OCIO', '2021-07-09 18:57:27', 85.41, 'FISICO', 'Leisure Express', 0.18, 'TURISTA', '4G', '30744361T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4638OZ6489DS600', 'YXRH79', 'ESTUDIOS', '2016-12-08 02:20:56', 147.91, 'FISICO', 'Cynsa Tour Operator', 0.2, 'TURISTA', '0F', '80131381X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3147VK2270UN411', 'CTAQ19', 'ESTUDIOS', '2018-07-04 06:00:07', 3163.23, 'DIGITAL', 'Rumbo S.R.L.', 0.14, 'TURISTA', '54B', '00337814K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9210YL5520ZA941', 'DOAW38', 'OCIO', '2021-05-16 10:53:11', 1418.52, 'DIGITAL', 'Ibis Turismo', 0.1, 'BUSINESS', '1G', '20923495U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1172QZ7548XE225', 'SHDB17', 'OCIO', '2016-05-25 20:37:37', 3640.99, 'DIGITAL', 'Tecni Austral', 0.14, 'TURISTA', '16F', '02382074A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1060WS3775GK791', 'VJPN65', 'TRABAJO', '2017-10-27 13:07:38', 2767.13, 'DIGITAL', 'Nerja Tours', 0.07, 'TURISTA', '7G', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6180VM2927ZG258', 'MBZT21', 'TRABAJO', '2018-01-05 23:34:53', 3773.13, 'DIGITAL', 'Nievemar Tours', 0.14, 'PREFERENTE', '53F', '14970824X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9181SR8803ZQ142', 'ARMZ49', 'TRABAJO', '2020-06-11 21:43:12', 457.69, 'FISICO', 'Travinter', 0.16, 'PREFERENTE', '71G', '94675329B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9874DK8666DD723', 'WCUU03', 'OCIO', '2016-07-20 07:32:49', 3233.74, 'FISICO', 'Royal Trust Internacional Travel', 0.23, 'BUSINESS', '2F', '98147633H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3624IF8512DN561', 'UOVP34', 'TRABAJO', '2016-04-02 23:07:03', 2566.83, 'DIGITAL', 'Aviatur One Group', 0.08, 'TURISTA', '0F', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3667QO6322FV028', 'VYDF62', 'ESTUDIOS', '2017-03-06 14:48:16', 2261.61, 'FISICO', 'Bru Bus', 0.26, 'TURISTA', '8D', '96797810K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5722DR8530DG199', 'RVMV64', 'OCIO', '2021-07-08 02:23:39', 1475.66, 'FISICO', 'Secon Turismo', 0.24, 'TURISTA', '3D', '29703831K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7947DN1816FN642', 'QRFV95', 'TRABAJO', '2016-04-07 04:37:47', 1936.36, 'FISICO', 'Inditur', 0.17, 'BUSINESS', '4D', '49741113Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4754GT7790GS562', 'BAHO29', 'ESTUDIOS', '2016-04-11 17:34:39', 3777.65, 'DIGITAL', 'Nuestro Mundo', 0.29, 'BUSINESS', '1G', '30537638Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0882BL6821FL035', 'UOVP34', 'OCIO', '2016-04-16 18:07:03', 2566.83, 'DIGITAL', 'Agencia De Viajes Y Turismo Chalten', 0.27, 'TURISTA', '7G', '43807742M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5886CP2878XZ366', 'RMFE37', 'OCIO', '2017-03-08 21:32:49', 3782.33, 'DIGITAL', 'Della Croce Tour', 0.25, 'TURISTA', '3A', '90909458T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4768BU9503TW171', 'BKMQ49', 'ESTUDIOS', '2018-07-10 01:46:43', 318.64, 'FISICO', 'Komo Kieras', 0.27, 'BUSINESS', '8G', '03665031G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9192EB8457MQ494', 'DKRG87', 'OCIO', '2017-11-06 08:14:14', 3759.81, 'FISICO', 'T.A.S. Turismo', 0, 'TURISTA', '1G', '30737589B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6117QF8158GA903', 'SFPK12', 'TRABAJO', '2021-07-04 12:46:54', 3626.71, 'FISICO', 'Cuenta Turismo Inmotur', 0.04, 'BUSINESS', '45G', '58844888I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3449DX5613CZ764', 'ASDD87', 'OCIO', '2017-11-18 14:47:21', 2143.15, 'FISICO', 'Turismo Sat', 0.09, 'PREFERENTE', '6G', '73630839H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1897MP2339FX797', 'FULU38', 'TRABAJO', '2018-02-23 14:11:57', 2817.07, 'FISICO', 'Tandiltur Viajes Y Turismo', 0, 'TURISTA', '0G', '53961118L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9211VS2594GU128', 'OTCB86', 'ESTUDIOS', '2020-12-21 17:36:18', 613.79, 'FISICO', 'Nuestra Tierra', 0.1, 'BUSINESS', '5F', '70464474N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0851EL2274CI236', 'DRSJ42', 'ESTUDIOS', '2020-03-02 06:23:21', 3856.14, 'FISICO', 'Juan Jose Montaña', 0.16, 'BUSINESS', '9A', '88460292P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9834MT2465MS163', 'ZBBC98', 'TRABAJO', '2019-04-03 04:43:46', 1748.95, 'FISICO', 'Royal Trust Internacional Travel', 0.23, 'PREFERENTE', '90G', '48758609Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6590NJ7437CH913', 'GXKL04', 'OCIO', '2019-12-02 04:23:58', 3236.75, 'DIGITAL', 'Cacciola S.A. Viajes Y Turismo', 0.3, 'TURISTA', '0G', '70891770A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7537RG8842QE788', 'ZKUR76', 'OCIO', '2016-04-27 05:53:33', 871.9, 'FISICO', 'Se - Tur Servicios Turisticos S.R.L.', 0.02, 'BUSINESS', '78G', '70716796H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1205FK8205UW391', 'OANP50', 'TRABAJO', '2020-05-21 09:11:19', 1248.44, 'DIGITAL', 'Iemanja E.V.T.', 0.08, 'BUSINESS', '38D', '79962229X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9278HB2905FQ428', 'GGFX19', 'OCIO', '2019-04-07 15:30:55', 2919.35, 'FISICO', 'Pullman', 0.1, 'PREFERENTE', '88G', '73630839H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8079OQ0078GJ608', 'AJXU05', 'ESTUDIOS', '2018-09-12 03:05:42', 1126.45, 'DIGITAL', 'Ola', 0.1, 'PREFERENTE', '1G', '37398296C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6942PZ6035MJ216', 'DXSW04', 'TRABAJO', '2018-03-05 13:53:01', 3389.92, 'DIGITAL', 'Agencia Ultramar', 0.21, 'PREFERENTE', '38F', '74018986T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2215JS6154AO384', 'XMTV73', 'ESTUDIOS', '2021-03-20 07:59:18', 2352.77, 'DIGITAL', 'Cayambe Viajes Y Turismo', 0.24, 'PREFERENTE', '83G', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3076CM8087KR294', 'BZUM50', 'OCIO', '2020-11-11 17:29:33', 1622.39, 'DIGITAL', 'Avignon', 0.25, 'TURISTA', '88G', '49247296N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1488LA5025FH423', 'YRKT59', 'ESTUDIOS', '2016-08-15 04:28:43', 559.46, 'DIGITAL', 'Uco Travel', 0.17, 'BUSINESS', '2F', '29703831K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6942IG6992ZG903', 'HBLX99', 'TRABAJO', '2016-02-03 14:25:20', 2453.1, 'DIGITAL', 'Jose Dieguez Servicios Turisticos', 0.1, 'PREFERENTE', '73F', '30430995N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0792SX4484ZX359', 'UZOM42', 'OCIO', '2021-04-29 07:08:45', 2194.32, 'FISICO', 'Nuestro Mundo', 0.29, 'TURISTA', '62F', '19767799D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9369GK1524ST708', 'NODV38', 'OCIO', '2018-03-14 18:44:07', 3251.28, 'DIGITAL', 'Uco Travel', 0.17, 'BUSINESS', '74F', '15425036J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7365RJ4859BQ863', 'MJZB56', 'OCIO', '2021-04-08 04:49:05', 3055.78, 'FISICO', 'Turismo Sendas', 0.03, 'TURISTA', '9G', '38234174I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7291PQ3663GP777', 'EPFP33', 'OCIO', '2018-01-29 18:57:34', 470.17, 'FISICO', 'Turismo Taragui S.R.L.', 0.24, 'PREFERENTE', '85G', '24007893U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3357KY3791NE008', 'PIJJ68', 'TRABAJO', '2018-12-28 18:55:12', 578.14, 'DIGITAL', 'Credigal S.R.L.', 0.11, 'PREFERENTE', '58G', '43914194N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8638JK5968YX315', 'CRFX33', 'TRABAJO', '2018-11-26 09:17:28', 2979.23, 'DIGITAL', 'Aroma', 0.25, 'PREFERENTE', '80G', '63097304T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2279GA3432ZM385', 'SPZZ25', 'OCIO', '2017-08-30 17:24:53', 1480.77, 'DIGITAL', 'Turismo Soliver', 0.25, 'TURISTA', '03G', '72816443M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8455LP2094DZ295', 'DFRY94', 'OCIO', '2019-07-21 05:26:04', 2861.7, 'DIGITAL', 'Tamanaha Travel Service S.R.L.', 0.11, 'BUSINESS', '74G', '21597780C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9302SD4057IW862', 'ACRF16', 'OCIO', '2021-06-08 11:27:47', 2117.17, 'DIGITAL', 'Aqui Y Ahora Turismo', 0.06, 'TURISTA', '3C', '57769934B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9810PJ6240SE271', 'JOPH74', 'ESTUDIOS', '2020-05-29 06:04:00', 3881.69, 'DIGITAL', 'Derim Travel', 0.26, 'BUSINESS', '22D', '45137271Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7930NL8584RQ682', 'LXAJ19', 'OCIO', '2018-05-02 17:09:27', 2175.17, 'FISICO', 'Hermotur', 0.01, 'PREFERENTE', '43D', '21597780C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5567DZ7382OA441', 'EIJM45', 'OCIO', '2016-09-29 22:57:02', 691.34, 'DIGITAL', 'Travinter', 0.16, 'BUSINESS', '6G', '67716684G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5845ZA4338QT812', 'YOAF98', 'TRABAJO', '2018-03-17 16:01:24', 1563.11, 'FISICO', 'Almundo.Com', 0.12, 'BUSINESS', '1G', '58435558H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0389BK7787XF194', 'CMCE18', 'OCIO', '2021-07-23 01:14:56', 647.76, 'FISICO', 'Cruise The World', 0.13, 'BUSINESS', '92D', '00247726I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9471BL5980XS462', 'EPDS39', 'TRABAJO', '2019-01-11 21:52:19', 2591.85, 'FISICO', 'Constelacion Tours', 0.09, 'BUSINESS', '86F', '91981768G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4899GW0707PA938', 'WFEB86', 'TRABAJO', '2017-11-07 13:13:53', 3313.9, 'DIGITAL', 'Eurovips', 0.26, 'BUSINESS', '1G', '38234174I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8621AS1412DE560', 'OCOL03', 'TRABAJO', '2018-03-02 06:40:29', 2958.58, 'DIGITAL', 'Consult House Travel', 0.06, 'PREFERENTE', '4D', '29958060M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2052AN7658CZ651', 'MYRS60', 'ESTUDIOS', '2016-04-10 11:12:07', 928.89, 'DIGITAL', 'Atuel Travel', 0.09, 'BUSINESS', '9B', '84780067I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3499WM6806GU498', 'MKEG41', 'TRABAJO', '2017-12-07 05:57:35', 3264.17, 'FISICO', 'Pretti Viajes', 0.22, 'PREFERENTE', '40C', '85654886A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9635MX0685ST323', 'DXSW04', 'OCIO', '2018-03-31 19:53:01', 3389.92, 'FISICO', 'Selene Viajes Y Turismo', 0.1, 'TURISTA', '17F', '80548424Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5487JU3634RO313', 'NTQK27', 'OCIO', '2016-12-02 14:26:43', 185.43, 'DIGITAL', 'Turismo Sabita', 0.07, 'BUSINESS', '8B', '92932216M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1505EZ4131PE377', 'XXNO51', 'TRABAJO', '2016-12-06 12:15:15', 3704.83, 'FISICO', 'Albo Rap', 0.2, 'TURISTA', '3F', '79839942M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9808XY7533ZI900', 'BBKM54', 'TRABAJO', '2017-12-01 02:14:12', 1547.83, 'FISICO', 'Aaron Tours', 0.1, 'BUSINESS', '9G', '84087080L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8898PB7134AS248', 'EHKQ48', 'ESTUDIOS', '2017-05-18 01:35:44', 2971.75, 'FISICO', 'Laguna Evt', 0.16, 'BUSINESS', '0F', '86687145N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0427YN4526LG496', 'HYAU76', 'OCIO', '2015-12-24 22:40:31', 2943.59, 'FISICO', 'Fazio S.R.L. Turismo', 0.1, 'TURISTA', '0G', '05014779K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9700AQ2647YX348', 'CEAO80', 'ESTUDIOS', '2016-07-04 03:34:26', 3144.86, 'DIGITAL', 'Famtur', 0.23, 'BUSINESS', '3G', '52839438O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1431UG6905UL620', 'XSTZ86', 'TRABAJO', '2017-01-21 20:00:25', 3544.51, 'DIGITAL', 'Prosa Viajes', 0.14, 'PREFERENTE', '39F', '69239536K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8314XS4659YX932', 'LXQS91', 'TRABAJO', '2016-04-29 07:39:18', 2980.23, 'DIGITAL', 'Pullman', 0.1, 'TURISTA', '5A', '49455567O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0458MW9253UQ228', 'CWUO79', 'OCIO', '2016-06-21 07:33:05', 183.69, 'DIGITAL', 'Alemi Tours', 0.11, 'BUSINESS', '5G', '05016607S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8242MA8836TM815', 'GLGF25', 'TRABAJO', '2019-03-12 19:02:39', 3404.33, 'FISICO', 'C.S. Turismo', 0.15, 'PREFERENTE', '9G', '85673820A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4107YR9212UA390', 'QPOI93', 'ESTUDIOS', '2018-02-28 19:05:51', 1269.45, 'DIGITAL', 'Escalatur S.R.L.', 0.06, 'TURISTA', '3G', '00247726I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5219XT6802ED396', 'ZVRX24', 'TRABAJO', '2021-03-15 13:10:15', 3305.22, 'FISICO', 'Viaje Con Hurtado', 0.27, 'TURISTA', '1G', '95501108I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6978YP3057NI184', 'UHQY43', 'ESTUDIOS', '2016-05-19 07:42:59', 1242.88, 'DIGITAL', 'Tango Tour', 0.06, 'BUSINESS', '24F', '43914194N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9980OQ7957QK570', 'IGFW90', 'OCIO', '2019-02-16 04:39:00', 971.93, 'FISICO', 'Buenos Aires Vision', 0.28, 'TURISTA', '1D', '52051003V');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4875UL4852HI000', 'IHMK38', 'TRABAJO', '2020-07-25 11:56:01', 3920.04, 'DIGITAL', 'Carlos Di Fiore Tour & Travel', 0.01, 'TURISTA', '14F', '41173696K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5776KE8689YK513', 'EKHB83', 'TRABAJO', '2016-10-28 14:49:05', 1505.41, 'DIGITAL', 'Federacion De Educadores Bonaerenses Domingo Faustino Sarmiento', 0.01, 'BUSINESS', '3C', '48758609Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4309FO1065QJ898', 'WBKB29', 'TRABAJO', '2021-04-15 18:33:11', 2085.44, 'FISICO', 'Ineltur', 0.09, 'TURISTA', '0F', '56443612Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8355AY2196ZK513', 'VENK46', 'OCIO', '2021-09-02 07:25:21', 62.08, 'FISICO', 'Youlike Travel', 0.25, 'BUSINESS', '1C', '19767799D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0830GS1920LP241', 'MBZT21', 'ESTUDIOS', '2018-02-11 15:34:53', 3773.13, 'DIGITAL', 'Viajes Tobal S.A.', 0.11, 'PREFERENTE', '8B', '73763582N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9567BV6603SQ730', 'IHMK38', 'ESTUDIOS', '2020-08-16 01:56:01', 3920.04, 'DIGITAL', 'Turismo Dallas', 0.17, 'TURISTA', '1G', '92388292H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9413DJ2268AP949', 'GOWS75', 'OCIO', '2021-05-01 16:36:32', 558.38, 'FISICO', 'Pioneros', 0.2, 'PREFERENTE', '32A', '98654381E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2408XA2658ZF276', 'YXRH79', 'ESTUDIOS', '2016-11-18 20:20:56', 147.91, 'DIGITAL', 'Navital Viajes', 0.03, 'TURISTA', '00G', '63097304T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0543BE7529TM956', 'KEFK08', 'OCIO', '2021-03-24 08:16:32', 1738.71, 'DIGITAL', 'Turismo Del Comahue', 0.08, 'BUSINESS', '5G', '46113088B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7809PC0499SB675', 'OMQC41', 'TRABAJO', '2016-05-30 05:41:52', 2669.46, 'DIGITAL', 'Yellowstone Travel', 0.19, 'TURISTA', '3D', '55581377B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9966JB9105NF450', 'RZZR30', 'ESTUDIOS', '2016-06-05 06:09:12', 3191.97, 'DIGITAL', 'Consejo Profesional De Ciencias Economicas De La Cuidad Autonoma De Buenos Aires', 0.04, 'PREFERENTE', '5C', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7245OW4534NA697', 'DUYK89', 'TRABAJO', '2017-09-21 13:15:17', 918.98, 'FISICO', 'Mediterranea Turismo', 0.09, 'PREFERENTE', '16G', '82767796L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7690IY2316VG722', 'HYDE22', 'ESTUDIOS', '2021-05-07 23:57:27', 85.41, 'DIGITAL', 'Tucma Tours S.R.L.', 0.2, 'BUSINESS', '15C', '25886038L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5932YE8110ZS673', 'LIVI96', 'OCIO', '2016-01-27 20:09:20', 3413.96, 'FISICO', 'Novasol Travel Service', 0.21, 'BUSINESS', '4G', '44546083M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2925YW4891ZJ969', 'QVYE27', 'TRABAJO', '2018-02-10 03:46:24', 1528.7, 'FISICO', 'D Z Travel', 0.26, 'BUSINESS', '20G', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8333XE1935FA396', 'BZUM50', 'TRABAJO', '2020-10-08 00:29:33', 1622.39, 'DIGITAL', 'Station Travel', 0.23, 'PREFERENTE', '38G', '49741113Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9358DF4556AL061', 'VUTE09', 'TRABAJO', '2017-06-16 10:52:55', 172.85, 'DIGITAL', 'Santa Teresita', 0.15, 'BUSINESS', '3G', '18260942C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9739UI8286DL486', 'HYDE22', 'ESTUDIOS', '2021-05-31 14:57:27', 85.41, 'FISICO', 'Agencia Lisboa', 0.27, 'PREFERENTE', '39G', '91981768G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2644OB1061DH840', 'RVMV64', 'TRABAJO', '2021-08-13 14:23:39', 1475.66, 'FISICO', 'Tur Cen Viajes Y Turismo', 0.22, 'BUSINESS', '61G', '74018986T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3948BZ0089MO360', 'QPOI93', 'OCIO', '2018-01-26 16:05:51', 1269.45, 'FISICO', 'Libor Tour', 0.18, 'PREFERENTE', '70G', '93990482O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0758EO1070LA509', 'OGPE49', 'ESTUDIOS', '2017-03-11 09:06:15', 3103.84, 'FISICO', 'Turismo Barbaglia', 0.1, 'PREFERENTE', '01D', '31370859H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0833NN5131WJ779', 'PHJF98', 'OCIO', '2016-11-07 07:16:33', 1964.74, 'FISICO', 'Sanchez Hidalgo Viajes S.R.L.', 0.08, 'PREFERENTE', '7F', '42954838B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9045GO2650FI160', 'CIRH41', 'ESTUDIOS', '2016-05-06 13:56:15', 1730.85, 'FISICO', 'Beachcomber Tours', 0.19, 'BUSINESS', '99G', '30537638Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4058ZB0268HL496', 'GGFX19', 'ESTUDIOS', '2019-05-10 07:30:55', 2919.35, 'DIGITAL', 'Paybe Turismo', 0.13, 'TURISTA', '74G', '22463253I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9666WO6886AV480', 'CFMX91', 'ESTUDIOS', '2019-09-04 23:42:18', 294.99, 'DIGITAL', 'Our Tour', 0.08, 'PREFERENTE', '76F', '53961118L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8987RT1959FC185', 'WBKB29', 'ESTUDIOS', '2021-02-03 04:33:11', 2085.44, 'FISICO', 'Malen Viajes', 0.03, 'BUSINESS', '32G', '24007893U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6965ZU4467TO305', 'JCYH85', 'OCIO', '2021-09-06 22:29:58', 3025.27, 'DIGITAL', 'Asociacion Bancaria (Asociacion De Empleados De Banco)', 0.06, 'BUSINESS', '83F', '45199729Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0214RC2749JC737', 'IFJY90', 'ESTUDIOS', '2016-03-26 15:30:03', 1771.46, 'FISICO', 'Paybe Turismo', 0.13, 'TURISTA', '14G', '92956925I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3614HX7694SV136', 'ZCWT38', 'OCIO', '2018-10-16 13:06:57', 1421.9, 'FISICO', 'Sobrino Turismo', 0.08, 'TURISTA', '1F', '80902946P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1700UE9953UD947', 'ODUX87', 'OCIO', '2021-10-19 20:33:48', 1785.96, 'DIGITAL', 'Cuenta Turismo Inmotur', 0.04, 'BUSINESS', '9F', '95924257Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6086JS4916HR477', 'TPTJ79', 'ESTUDIOS', '2015-11-28 03:36:36', 1522.83, 'DIGITAL', 'Labrador Turismo', 0.03, 'TURISTA', '79C', '37398296C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0898EE4720DG126', 'JPKD62', 'TRABAJO', '2018-10-26 01:59:24', 422.56, 'DIGITAL', 'Subal Tur', 0.09, 'TURISTA', '79F', '85342697Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5338FZ4846SD075', 'JKUJ49', 'ESTUDIOS', '2018-07-23 04:48:38', 1237.43, 'DIGITAL', 'Sinfonia Travel', 0.13, 'TURISTA', '85G', '74527513B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0719AU2783NN347', 'SPMO59', 'OCIO', '2020-05-08 21:11:02', 1422.79, 'DIGITAL', 'Horus Turismo', 0.07, 'TURISTA', '1G', '84087080L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3432PW7091DS543', 'LVSK61', 'OCIO', '2018-03-15 22:27:56', 1414.3, 'FISICO', 'Geminiani', 0.09, 'PREFERENTE', '07G', '50150286R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6815ET4289OR037', 'NHKX50', 'TRABAJO', '2018-04-24 21:10:08', 1512.27, 'DIGITAL', 'Dominique', 0.2, 'PREFERENTE', '2C', '92932216M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6828PW1320PW793', 'KKXL78', 'ESTUDIOS', '2016-10-23 12:03:41', 2837.91, 'DIGITAL', 'Turecon', 0.19, 'BUSINESS', '65F', '95501108I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5630TJ3161VA434', 'WOOH07', 'ESTUDIOS', '2018-09-02 06:45:10', 3702.12, 'DIGITAL', 'Halifax Viajes', 0.18, 'BUSINESS', '86G', '51977060S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3985YU9984ZF026', 'AZRE73', 'ESTUDIOS', '2020-08-05 00:15:24', 639.46, 'FISICO', 'Keymun Turismo', 0.2, 'PREFERENTE', '6G', '16305315P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1074ZS1465HP861', 'FVRQ54', 'ESTUDIOS', '2016-02-23 13:45:45', 17.21, 'FISICO', 'Mutual De Socios De La Asociacion Medica De Rosario', 0.02, 'PREFERENTE', '20G', '18993101I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4553CE8649SP172', 'ZWDJ62', 'ESTUDIOS', '2017-10-02 10:52:54', 496.16, 'DIGITAL', 'Rach Turismo', 0.06, 'BUSINESS', '8G', '58982427V');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0317HR5891WO988', 'SCWO70', 'OCIO', '2019-08-28 13:27:39', 2437.08, 'FISICO', 'Piter Tours', 0.18, 'PREFERENTE', '4G', '13640802Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6273FT7588BG919', 'HBAO45', 'TRABAJO', '2021-10-19 21:56:30', 1026.27, 'FISICO', 'B. G. F. Turismo', 0.02, 'PREFERENTE', '27F', '98147633H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3894RT3903IZ521', 'VJPN65', 'ESTUDIOS', '2017-11-06 06:07:38', 2767.13, 'DIGITAL', 'Setubal Viajes Y Turismo', 0.16, 'PREFERENTE', '40D', '85342697Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4440MI5787PQ600', 'ZQDM59', 'TRABAJO', '2021-06-07 08:38:54', 3767.91, 'FISICO', 'Huarpe Viajes Y Turismo', 0.2, 'BUSINESS', '2F', '11375516I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3597ZJ4339UE793', 'IEZB16', 'OCIO', '2017-02-11 18:24:29', 2556.76, 'FISICO', 'Franca Tour', 0.25, 'PREFERENTE', '2D', '92140486L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5056SD3969GB789', 'JIMU85', 'ESTUDIOS', '2017-08-29 23:40:57', 2546.27, 'FISICO', 'Mutual De Socios De La Asociacion Medica De Rosario', 0.02, 'TURISTA', '3G', '11375516I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6800AK0374UB850', 'MKEG41', 'ESTUDIOS', '2017-10-20 23:57:35', 3264.17, 'DIGITAL', 'Mirst Travel', 0.02, 'TURISTA', '58G', '58435558H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9493HG0802EV179', 'LXQS91', 'TRABAJO', '2016-04-24 16:39:18', 2980.23, 'FISICO', 'Zepelin Tours', 0.28, 'BUSINESS', '2F', '51977060S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2373GR4525WK857', 'OMQC41', 'ESTUDIOS', '2016-07-06 10:41:52', 2669.46, 'FISICO', 'Sonia Witte', 0.07, 'PREFERENTE', '04G', '00247726I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7662BG5403ZX774', 'FEWP24', 'TRABAJO', '2017-05-05 18:19:45', 970.58, 'FISICO', 'Marbi Tours', 0.05, 'TURISTA', '90C', '18993101I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8410KM5662QG139', 'OSZA17', 'ESTUDIOS', '2019-09-20 03:14:08', 2070.3, 'FISICO', 'Piñeyro Travels', 0.12, 'BUSINESS', '0D', '18260942C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1997MV8898JQ765', 'MYOS45', 'OCIO', '2021-03-12 16:07:04', 1198.65, 'DIGITAL', 'Asociacion Mutual Mercantil Buenos Aires', 0.06, 'BUSINESS', '1F', '03665031G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7955BU2379UL713', 'IFDQ08', 'OCIO', '2019-05-23 04:50:17', 1890.33, 'DIGITAL', 'Goldytur', 0.06, 'BUSINESS', '5D', '86687145N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7907PO7092HN345', 'JAFF49', 'ESTUDIOS', '2016-06-29 17:44:53', 3328.44, 'FISICO', 'Rygsa Viajes Y Turismo', 0.3, 'TURISTA', '4F', '59643079M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4013HZ6396QM432', 'CEAO80', 'TRABAJO', '2016-06-28 18:34:26', 3144.86, 'DIGITAL', 'Clipper Viajes & Turismo', 0.28, 'TURISTA', '74D', '04955523F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1394RA2882KV505', 'NHFN54', 'ESTUDIOS', '2018-02-23 20:56:20', 2631.94, 'FISICO', 'Viajes Fontana', 0.2, 'TURISTA', '49D', '58435558H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2895CF4535RE360', 'XSCK30', 'OCIO', '2018-01-19 14:22:52', 3949.66, 'FISICO', 'Sentinel Travel', 0.19, 'TURISTA', '44C', '05413206A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8651CE8810DQ283', 'WOOH07', 'ESTUDIOS', '2018-09-21 05:45:10', 3702.12, 'FISICO', 'Baradero Tours S.R.L.', 0.3, 'BUSINESS', '1F', '53712077K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2201WT7054LO922', 'MQYZ25', 'OCIO', '2021-04-22 06:13:59', 321.86, 'DIGITAL', 'Playmo Tur', 0.09, 'BUSINESS', '0F', '50150286R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1875NN2895PV158', 'CASD85', 'OCIO', '2019-11-02 19:25:41', 2709.78, 'DIGITAL', 'Icaro Viajes', 0.03, 'TURISTA', '5G', '21597780C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3522PE2484DZ561', 'EIUE54', 'OCIO', '2021-05-16 21:16:42', 3185.88, 'DIGITAL', 'Turismo Norte', 0.13, 'BUSINESS', '67D', '92140486L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9175RC1327JC627', 'WFEB86', 'TRABAJO', '2017-11-06 17:13:53', 3313.9, 'FISICO', 'Turismo Jet De Antartica', 0.05, 'BUSINESS', '07G', '47946012S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3084BW0624YC455', 'AGLS23', 'ESTUDIOS', '2016-12-19 05:25:09', 3483.66, 'DIGITAL', 'Cambytur S.A.', 0.08, 'TURISTA', '0G', '52051003V');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7538XV4954ZL378', 'UABQ51', 'ESTUDIOS', '2019-09-05 07:45:10', 206.61, 'FISICO', 'Fernandez De Cieza Viajes', 0.15, 'PREFERENTE', '30A', '30430995N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7454UH2328NB327', 'IKYG17', 'OCIO', '2018-04-16 10:21:33', 2172.93, 'FISICO', 'Consult House Travel', 0.06, 'TURISTA', '85G', '50150286R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2375CH6077VV219', 'DCRU94', 'OCIO', '2018-06-29 21:01:29', 1767.62, 'FISICO', 'Asoc. Colonia De Vacaciones Personal Del Banco Pcia. De Bs. As.', 0.21, 'TURISTA', '9F', '58982427V');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0446NN0453IG603', 'IHMK38', 'OCIO', '2020-08-23 03:56:01', 3920.04, 'FISICO', 'Folgar Viajes', 0.26, 'PREFERENTE', '25D', '98147633H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4111XU8299NF689', 'DHGQ82', 'TRABAJO', '2017-10-07 13:56:21', 2218.64, 'FISICO', 'B. G. F. Turismo', 0.02, 'BUSINESS', '4F', '96575776M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1156SP2945PI355', 'XXPS22', 'TRABAJO', '2017-03-09 06:13:22', 703.71, 'FISICO', 'Turam Viajes', 0.04, 'BUSINESS', '46D', '31238243H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7867MM0046AG181', 'VAZI05', 'TRABAJO', '2017-02-17 17:14:25', 2656.18, 'FISICO', 'Fernando Toriani Travel Services', 0.21, 'PREFERENTE', '44F', '92956925I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1747GA7848MA331', 'YOAF98', 'ESTUDIOS', '2018-02-04 17:01:24', 1563.11, 'DIGITAL', 'Perrier Viajes', 0.18, 'TURISTA', '44G', '75154918H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6755GD1419XO043', 'BKMQ49', 'OCIO', '2018-06-21 00:46:43', 318.64, 'FISICO', 'Turismo Ituzaingo', 0.15, 'BUSINESS', '0F', '45137271Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4488VP4037FN381', 'EPFP33', 'OCIO', '2018-01-06 04:57:34', 470.17, 'DIGITAL', 'Olivari Viajes Pta', 0.04, 'TURISTA', '25G', '30744361T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5789QM0937JN020', 'DRSJ42', 'ESTUDIOS', '2020-04-12 23:23:21', 3856.14, 'FISICO', 'Cayambe Viajes Y Turismo', 0.24, 'TURISTA', '78G', '59643079M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8924FY5247MX617', 'WEIJ40', 'OCIO', '2016-11-13 11:36:41', 48.51, 'DIGITAL', 'Horus Turismo', 0.07, 'TURISTA', '0G', '88460292P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3795IX1341EC413', 'TZOP68', 'OCIO', '2017-09-01 23:42:02', 2631.64, 'DIGITAL', 'A.G.O. Viajes', 0.08, 'TURISTA', '22G', '58618293D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0647KU0524WX833', 'IFDQ08', 'TRABAJO', '2019-03-09 03:50:17', 1890.33, 'DIGITAL', 'Turismo Sat', 0.09, 'BUSINESS', '40G', '05016607S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2713JO8753QL283', 'LRMA21', 'OCIO', '2020-01-14 07:13:34', 1533.39, 'FISICO', 'Zafiro Viajes', 0.06, 'BUSINESS', '98C', '67716684G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4430FC9149TO329', 'JCYH85', 'TRABAJO', '2021-09-27 00:29:58', 3025.27, 'DIGITAL', 'Limay Travel Safaris Y Adventures', 0.24, 'PREFERENTE', '62F', '42954838B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7409BY1865FA790', 'NUQQ26', 'TRABAJO', '2017-08-03 05:29:13', 3325.54, 'DIGITAL', 'Exdel Turismo', 0.12, 'PREFERENTE', '96G', '31370859H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6003KD9091AU436', 'UBSH06', 'OCIO', '2017-02-22 01:56:30', 684.91, 'FISICO', 'Agreste', 0.04, 'TURISTA', '6F', '41173696K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8074ON7283HL827', 'AJXU05', 'TRABAJO', '2018-08-16 02:05:42', 1126.45, 'FISICO', 'Guaranty Tours & Travel', 0.09, 'BUSINESS', '8G', '58982427V');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9195ZU0465BZ610', 'OTEP64', 'ESTUDIOS', '2016-03-14 20:30:34', 1750.37, 'DIGITAL', 'Perletto Viajes S.R.L.', 0.04, 'BUSINESS', '5G', '07055242C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9636UL6745XN753', 'GOWS75', 'TRABAJO', '2021-05-14 16:36:32', 558.38, 'FISICO', 'Sailing Travel', 0.07, 'BUSINESS', '11G', '58496330S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3603US8816FK178', 'UHOJ14', 'ESTUDIOS', '2021-09-20 10:11:04', 529.21, 'DIGITAL', 'Alejandro Murias Turismo', 0, 'PREFERENTE', '5F', '47946012S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2765AK9663JF864', 'MNOA43', 'ESTUDIOS', '2021-10-25 16:05:09', 3886.24, 'DIGITAL', 'Asia Travel Service', 0.09, 'TURISTA', '6B', '92956925I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6975ZI7195XI820', 'ZXOY75', 'TRABAJO', '2021-09-24 13:29:09', 199.62, 'FISICO', 'Elyos Tours', 0.18, 'PREFERENTE', '13F', '03399464U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0179QK7725OR658', 'PIJJ68', 'OCIO', '2019-01-10 19:55:12', 578.14, 'DIGITAL', 'Asoc. Mutual Telefonica Buenos Aires', 0.27, 'TURISTA', '1G', '14970824X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5689XB4519ZT494', 'MITB38', 'ESTUDIOS', '2017-04-11 04:04:49', 197.44, 'DIGITAL', 'Warman Tour', 0.09, 'PREFERENTE', '77F', '73630839H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8056XY1237YS724', 'LRMA21', 'TRABAJO', '2020-03-24 00:13:34', 1533.39, 'DIGITAL', 'Avec Tour', 0.11, 'PREFERENTE', '00F', '79839942M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0568ZZ0357FC230', 'TKUR44', 'ESTUDIOS', '2018-09-30 13:21:50', 2814.08, 'DIGITAL', 'Arvion Soc.Anonima Comercial Financiera', 0.25, 'PREFERENTE', '48D', '45199729Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7808RN7350ZG486', 'OLXL90', 'OCIO', '2019-06-22 22:26:55', 2422.94, 'FISICO', 'Patsa Turismo', 0.02, 'BUSINESS', '5G', '74527513B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2719LV4919HI200', 'WEIJ40', 'TRABAJO', '2017-01-04 10:36:41', 48.51, 'DIGITAL', 'Turismo La Frontera', 0.14, 'TURISTA', '29G', '37900304M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8590YQ5586NS880', 'ZEHV55', 'TRABAJO', '2018-04-20 13:58:07', 3710.4, 'DIGITAL', 'Konatour Empresa De Viajes Y Turismo', 0.08, 'BUSINESS', '71G', '80131381X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2387MN1211MT839', 'YLNP53', 'ESTUDIOS', '2019-01-06 03:34:00', 962.18, 'FISICO', 'Elio Ricardo Cuello E Hijos', 0.03, 'BUSINESS', '73G', '94489726X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7346VM9532EX479', 'MXKY03', 'ESTUDIOS', '2021-04-02 15:50:31', 1196.07, 'FISICO', 'Babilonia Viajes Y Turismo', 0.18, 'BUSINESS', '37G', '67716684G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6711XK5637OF618', 'ZSLM04', 'TRABAJO', '2019-08-19 08:16:04', 1069.43, 'DIGITAL', 'Turismo Corabi', 0.2, 'PREFERENTE', '3D', '84661096R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9026LB9545RK609', 'WGSB43', 'ESTUDIOS', '2021-08-07 17:08:34', 3083.75, 'FISICO', 'Alemi Tours', 0.11, 'TURISTA', '3F', '58844888I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6592AK1672QC070', 'RPAY32', 'TRABAJO', '2020-06-09 23:51:32', 243.28, 'DIGITAL', 'De Sol A Sol Turismo', 0.01, 'PREFERENTE', '6G', '73301916I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1912SD6564NF519', 'UZOM42', 'OCIO', '2021-02-19 20:08:45', 2194.32, 'DIGITAL', 'Rossani Turismo', 0.08, 'BUSINESS', '96F', '31592071S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6619TQ7619RR971', 'ADSV74', 'TRABAJO', '2018-03-07 01:18:19', 3837.64, 'FISICO', 'Turismo 2000', 0.12, 'BUSINESS', '09G', '88413344X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9884ST4696IM373', 'XMTV73', 'OCIO', '2021-01-20 00:59:18', 2352.77, 'FISICO', 'Rincon Andino', 0.13, 'BUSINESS', '6F', '46113088B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1658IL4567PZ088', 'HWJT73', 'ESTUDIOS', '2019-06-08 20:41:33', 2988.2, 'DIGITAL', 'Huilliches Turismo', 0.15, 'TURISTA', '80G', '78133090Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6322YB1487GB067', 'LIVI96', 'ESTUDIOS', '2016-01-21 19:09:20', 3413.96, 'FISICO', 'Othon Viajes', 0.19, 'TURISTA', '93G', '20273199J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6217OD7757VB712', 'SYFL31', 'TRABAJO', '2016-09-17 03:38:04', 1331.77, 'FISICO', 'Aretha Tur', 0.18, 'TURISTA', '0C', '01729342J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8900RU6999WU373', 'AZRE73', 'ESTUDIOS', '2020-09-27 13:15:24', 639.46, 'DIGITAL', 'Ledefax', 0.05, 'PREFERENTE', '82F', '95924257Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4117AB4975MT404', 'LEJC58', 'ESTUDIOS', '2017-04-20 00:09:17', 3618.11, 'DIGITAL', 'Amadeo Gentili Turismo', 0, 'BUSINESS', '82F', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8658QP0973KS203', 'TEGJ22', 'ESTUDIOS', '2018-11-05 04:46:28', 2864.72, 'DIGITAL', 'Elida Martin', 0.07, 'PREFERENTE', '4F', '49247296N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6329NG5158VD686', 'JMOK23', 'OCIO', '2017-03-30 14:36:52', 1498.36, 'FISICO', 'Eklo Travel', 0.25, 'TURISTA', '0F', '92388292H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0901EI8852RU145', 'NMEZ13', 'OCIO', '2021-07-02 02:38:14', 3729.76, 'FISICO', 'Sinisi Turismo', 0.25, 'PREFERENTE', '6F', '36802529Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9392UX8320FB585', 'IRXQ32', 'ESTUDIOS', '2018-11-03 16:50:52', 2147.5, 'FISICO', 'Mutual Siderurgica General Savio', 0.14, 'TURISTA', '1G', '73630839H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7115RH1789LU021', 'XSTZ86', 'TRABAJO', '2017-01-16 03:00:25', 3544.51, 'FISICO', 'Turismo 2000', 0.12, 'TURISTA', '0C', '85659619A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4826HU5088PR272', 'SIQG29', 'OCIO', '2021-06-24 15:21:06', 513.66, 'FISICO', 'Refasi Turismo', 0.18, 'PREFERENTE', '9D', '84848139W');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0919GT8765UU696', 'DKYT41', 'ESTUDIOS', '2018-01-28 13:12:33', 670.7, 'FISICO', 'Firenze Viajes', 0.23, 'TURISTA', '2D', '98654381E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1487ZZ4479KJ030', 'VAZI05', 'TRABAJO', '2017-04-14 00:14:25', 2656.18, 'DIGITAL', 'Calipso Viajes', 0.21, 'BUSINESS', '4G', '26491980A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9686OW2714MV137', 'OPCW01', 'TRABAJO', '2021-02-13 12:32:50', 2976.05, 'DIGITAL', 'Cambytur S.A.', 0.08, 'PREFERENTE', '8G', '12623557E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2365WK1650KX112', 'ENBH08', 'ESTUDIOS', '2017-12-12 19:33:14', 2542.95, 'FISICO', 'Gustavia Viajes', 0.06, 'BUSINESS', '9C', '97814136Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9260AB0104TW303', 'IFDQ08', 'ESTUDIOS', '2019-03-11 11:50:17', 1890.33, 'DIGITAL', 'El Refugio', 0.07, 'TURISTA', '26G', '99220378I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5119UN7392AD417', 'DFRY94', 'ESTUDIOS', '2019-08-23 22:26:04', 2861.7, 'FISICO', 'Instituto De Previson Y Seguridad Social De Tucuman', 0.09, 'BUSINESS', '40G', '29838624Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1682GQ7175TM995', 'RRIU06', 'ESTUDIOS', '2016-06-04 20:59:40', 2777.19, 'FISICO', 'Vie Tur', 0.3, 'TURISTA', '9G', '80902946P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8636CR3362VF667', 'YXRH79', 'TRABAJO', '2016-12-12 19:20:56', 147.91, 'DIGITAL', 'Secon Turismo', 0.24, 'PREFERENTE', '23G', '92799068T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6790JJ2033LO337', 'FVRQ54', 'ESTUDIOS', '2016-04-05 04:45:45', 17.21, 'FISICO', 'Coral Travel', 0.23, 'PREFERENTE', '52C', '82767796L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9844AW0232FO630', 'ENBH08', 'OCIO', '2017-12-13 01:33:14', 2542.95, 'DIGITAL', 'South American Tours De Argentina S.A.', 0.24, 'BUSINESS', '2G', '78133090Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5537CY7129QC850', 'YEJT71', 'TRABAJO', '2019-06-05 20:04:27', 2289.75, 'DIGITAL', 'Emeage Turismo', 0.28, 'TURISTA', '52G', '92956925I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8640NL0235QJ376', 'UGLJ78', 'TRABAJO', '2020-11-29 05:45:58', 3923.43, 'FISICO', 'Ferrytur', 0.28, 'TURISTA', '39G', '99613595U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4105TX0896OX155', 'EDZM72', 'TRABAJO', '2015-11-10 10:45:10', 256.14, 'DIGITAL', 'Nazabal Y Asociados', 0.24, 'PREFERENTE', '97F', '37900304M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0171CD4069JT455', 'SPMO59', 'ESTUDIOS', '2020-06-01 05:11:02', 1422.79, 'FISICO', 'Gusmar Tours', 0.12, 'BUSINESS', '0G', '07558371D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0735HN6421XZ504', 'WQZN84', 'ESTUDIOS', '2020-10-26 21:42:34', 285.04, 'FISICO', 'Turismo Sendas', 0.03, 'BUSINESS', '64F', '89255796Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8398CX7630ZN892', 'CXGG00', 'ESTUDIOS', '2016-01-27 22:53:35', 2467.12, 'DIGITAL', 'Ulyses Viajes Y Turismo S.R.L.', 0.13, 'TURISTA', '60G', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3812IL0405QZ849', 'NKJM16', 'OCIO', '2016-08-09 10:04:32', 2638.02, 'FISICO', 'Mutual De Asociados De La Asoc. Deportiva 9 De Julio', 0.24, 'TURISTA', '74G', '46113088B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9288DX0353BI348', 'VPQI64', 'TRABAJO', '2021-06-10 23:01:23', 1896.24, 'FISICO', 'Pioneros', 0.2, 'TURISTA', '0D', '49247296N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6612GX0172EU376', 'OCOL03', 'TRABAJO', '2018-02-20 04:40:29', 2958.58, 'DIGITAL', 'Turismo Ballester S.A.', 0.25, 'TURISTA', '50G', '45199729Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1410JC7687WU029', 'NLCP49', 'OCIO', '2020-11-13 08:55:52', 2347.86, 'DIGITAL', 'Schaab Turismo', 0.11, 'BUSINESS', '1C', '90924101M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7929DS1212KT792', 'ABJW97', 'TRABAJO', '2021-04-02 16:46:28', 3918.23, 'DIGITAL', 'Agencia Miyamoto S.R.L.', 0.3, 'BUSINESS', '7G', '00337814K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3015JD3424AM925', 'EBEL90', 'OCIO', '2018-07-15 13:04:28', 459.92, 'FISICO', 'Apolo Viajes', 0.11, 'PREFERENTE', '36G', '93205706M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4424WS2708CU178', 'NMEZ13', 'ESTUDIOS', '2021-08-01 06:38:14', 3729.76, 'FISICO', 'Molise Viajes', 0.22, 'BUSINESS', '61G', '78133090Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5961AE7140SS039', 'CIJM40', 'ESTUDIOS', '2017-10-08 21:11:43', 3232.2, 'FISICO', 'Viajes Tait', 0.16, 'BUSINESS', '0G', '58435558H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2201VH0164VM355', 'WDXB61', 'TRABAJO', '2018-05-11 12:32:47', 3642.86, 'DIGITAL', 'Turecon', 0.19, 'BUSINESS', '44C', '43914194N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7994CJ0461CL867', 'VJPN65', 'OCIO', '2017-10-17 11:07:38', 2767.13, 'DIGITAL', 'Pais Sur S.R.L.', 0.23, 'BUSINESS', '4F', '94489726X');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3825JU6694YM750', 'ATYF08', 'ESTUDIOS', '2020-03-09 05:29:37', 594.72, 'FISICO', 'La Ideal Turismo', 0.01, 'BUSINESS', '7A', '11375516I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2786SQ8528NW915', 'YLNP53', 'ESTUDIOS', '2018-12-28 10:34:00', 962.18, 'DIGITAL', 'Olam Viajes Y Turismo', 0.09, 'PREFERENTE', '1G', '58496330S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2575IZ9905ZF129', 'SCWO70', 'OCIO', '2019-09-01 19:27:39', 2437.08, 'DIGITAL', 'Obra Social Del Personal De Direccion De Sanidad Luis Pasteur', 0.12, 'TURISTA', '43G', '47938670T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0139PF8502WE123', 'WGSB43', 'ESTUDIOS', '2021-06-14 16:08:34', 3083.75, 'FISICO', 'Abba Tours S.A.', 0.02, 'TURISTA', '6G', '03438149Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2103XY0706JL185', 'AZRE73', 'TRABAJO', '2020-10-09 06:15:24', 639.46, 'FISICO', 'Saltur S.A.', 0.16, 'TURISTA', '78F', '30737589B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4717OQ0182ZE519', 'DCRU94', 'ESTUDIOS', '2018-06-25 16:01:29', 1767.62, 'FISICO', 'Komo Kieras', 0.27, 'BUSINESS', '56F', '83743817J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6803FE7868HM962', 'UZVS70', 'OCIO', '2016-11-21 08:22:48', 1008.04, 'DIGITAL', 'Sabatini Viajes Y Turismo', 0.19, 'BUSINESS', '2F', '31370859H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5221RV7469JA506', 'MITB38', 'ESTUDIOS', '2017-04-15 10:04:49', 197.44, 'DIGITAL', 'Covitour Incoming & Corporate', 0.04, 'BUSINESS', '8G', '73494812M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5899BN2899DL054', 'YDPO33', 'TRABAJO', '2020-03-05 13:46:21', 415.53, 'DIGITAL', 'Molachino Viajes Y Turismo', 0.09, 'BUSINESS', '9G', '49247296N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6903QZ5759DY753', 'NLCP49', 'ESTUDIOS', '2020-09-20 20:55:52', 2347.86, 'FISICO', 'Rayantu', 0.26, 'PREFERENTE', '4G', '95501108I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8070TH4788HI696', 'DOAW38', 'OCIO', '2021-03-02 10:53:11', 1418.52, 'DIGITAL', 'Del Pilar', 0.11, 'BUSINESS', '6G', '03709449R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5603KO3381LY493', 'QQSF49', 'TRABAJO', '2017-05-13 07:22:27', 1102.68, 'DIGITAL', 'A.G.O. Viajes', 0.08, 'BUSINESS', '8G', '70464474N');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4702LZ8037PC271', 'WXJA72', 'TRABAJO', '2017-11-29 16:03:54', 1605.04, 'FISICO', 'Turismo Caupolican', 0.29, 'PREFERENTE', '68G', '20250544Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0429HV9874MO475', 'VGTY59', 'OCIO', '2016-05-12 00:54:27', 1831.89, 'DIGITAL', 'G.M.D. Viajes Y Congresos', 0.13, 'TURISTA', '92G', '38280831H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2065OA9017PY608', 'JMJW04', 'ESTUDIOS', '2020-08-09 15:15:20', 3374.2, 'DIGITAL', 'Private Service', 0.13, 'BUSINESS', '66F', '22463253I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6550NI1285AE955', 'WGSB43', 'OCIO', '2021-06-27 09:08:34', 3083.75, 'DIGITAL', 'Se - Tur Servicios Turisticos S.R.L.', 0.02, 'TURISTA', '0G', '55581377B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7296XM8212WU315', 'AWNI10', 'OCIO', '2017-06-29 18:36:09', 1883.9, 'DIGITAL', 'Aldao Viajes', 0.29, 'PREFERENTE', '9G', '05413503F');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5202UO5707TQ112', 'EMOF11', 'TRABAJO', '2016-02-16 11:06:19', 2895.02, 'FISICO', 'Empretur', 0.2, 'BUSINESS', '7F', '63097304T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9491YJ9149NB898', 'URUX26', 'TRABAJO', '2018-03-25 03:44:34', 2717.37, 'FISICO', 'Olam Viajes Y Turismo', 0.09, 'PREFERENTE', '9G', '46885767Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4475NN4444SG167', 'ZUUK25', 'OCIO', '2020-08-10 13:19:49', 525.64, 'DIGITAL', 'Vatapa Tur', 0.24, 'PREFERENTE', '75F', '21597780C');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1886BB4553IG840', 'IHEZ97', 'OCIO', '2021-06-29 21:37:42', 2128.85, 'DIGITAL', 'Martha Dumic Viajes Y Turismo', 0.29, 'BUSINESS', '00G', '63097304T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0815JP0173DV988', 'AGIX19', 'ESTUDIOS', '2016-04-28 02:03:47', 2618.3, 'DIGITAL', 'Mares K Turismo', 0.25, 'TURISTA', '6G', '20273199J');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7627PU1074JG986', 'RAWG18', 'OCIO', '2020-06-28 10:10:14', 2954.73, 'FISICO', 'Clio Viajes Y Turismo', 0.04, 'TURISTA', '1F', '05016607S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4328IG9565JA995', 'YXRH79', 'ESTUDIOS', '2016-09-29 02:20:56', 147.91, 'FISICO', 'Gema Tours', 0.09, 'TURISTA', '40F', '18861987Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7273QE5820NR671', 'UHOJ14', 'TRABAJO', '2021-12-02 09:11:04', 529.21, 'DIGITAL', 'Laguna Evt', 0.16, 'PREFERENTE', '46G', '67716684G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0762HJ0173LQ473', 'HBLX99', 'ESTUDIOS', '2016-01-23 19:25:20', 2453.1, 'FISICO', 'Italplata', 0.09, 'TURISTA', '6B', '84661096R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0542IR8462OH807', 'KUZU94', 'TRABAJO', '2018-05-07 20:04:38', 1369.48, 'FISICO', 'Alumine', 0.1, 'TURISTA', '1G', '51788970Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8650VD1174UV365', 'VUTE09', 'ESTUDIOS', '2017-05-27 09:52:55', 172.85, 'FISICO', 'Nippon Tourist', 0.25, 'TURISTA', '2F', '47428291L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0405SH5274BB263', 'TDQR49', 'TRABAJO', '2021-07-24 16:35:48', 573.53, 'FISICO', 'Rand Tours', 0.03, 'BUSINESS', '6G', '20185493S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2740GG6569ON817', 'RBOW00', 'ESTUDIOS', '2017-07-28 20:30:43', 2772.81, 'DIGITAL', 'Nazabal Y Asociados', 0.24, 'BUSINESS', '5G', '61436494H');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6670LS7347DM948', 'TFYD64', 'OCIO', '2018-08-06 09:49:10', 782.05, 'FISICO', 'Oremar', 0.1, 'PREFERENTE', '4G', '25886038L');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8022CO8375HA722', 'FZIF20', 'TRABAJO', '2017-06-09 15:11:36', 1342.62, 'DIGITAL', 'Sindicato De Luz Y Fuerza', 0.15, 'BUSINESS', '63F', '69239536K');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8790PU8677EG310', 'NPUV61', 'OCIO', '2017-03-20 03:16:16', 3557.99, 'FISICO', 'Ultimo Confin', 0.1, 'BUSINESS', '01G', '92799068T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1082YD0890CE918', 'VYSI09', 'OCIO', '2016-10-15 12:01:19', 3878.82, 'FISICO', 'E.P.S. Internacional', 0.13, 'BUSINESS', '48G', '47938670T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0752VP1071JB431', 'NKJM16', 'ESTUDIOS', '2016-09-21 20:04:32', 2638.02, 'DIGITAL', 'Turismo Pu-Ma', 0.29, 'BUSINESS', '5A', '73494812M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8372ZS4114FO418', 'IKYG17', 'ESTUDIOS', '2018-03-22 01:21:33', 2172.93, 'DIGITAL', 'Zafiro Viajes', 0.06, 'PREFERENTE', '6F', '28928594D');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3399JU8143OH752', 'HYKO22', 'TRABAJO', '2019-02-24 00:41:44', 3193.73, 'DIGITAL', 'Cazenave Y Asociados', 0.06, 'BUSINESS', '39F', '57403366Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8804MQ3551JG904', 'WDXB61', 'TRABAJO', '2018-05-21 09:32:47', 3642.86, 'FISICO', 'Saitur Saul Saidel Viajes S.R.L.', 0.2, 'BUSINESS', '8G', '98654381E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0669GZ8079WO535', 'IEZB16', 'ESTUDIOS', '2017-02-09 06:24:29', 2556.76, 'FISICO', 'Exdel Turismo', 0.12, 'TURISTA', '82G', '44546083M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('9869ZZ1044IO227', 'ZEHV55', 'TRABAJO', '2018-05-27 10:58:07', 3710.4, 'DIGITAL', 'Agencia Lisboa', 0.27, 'PREFERENTE', '4F', '43216152P');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('7525PN8615RA175', 'RMFE37', 'TRABAJO', '2017-04-11 16:32:49', 3782.33, 'FISICO', 'Biblos', 0.29, 'TURISTA', '8F', '72816443M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0255CH9106MU505', 'EAWB19', 'ESTUDIOS', '2016-10-31 11:58:47', 1585.98, 'DIGITAL', 'Cetan', 0.08, 'PREFERENTE', '2D', '92382459A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4409SK6939RH936', 'LICT28', 'OCIO', '2018-06-12 04:19:01', 2086.4, 'DIGITAL', 'Huilliches Turismo', 0.15, 'BUSINESS', '34G', '53937246W');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1026TL7996RT895', 'WCUU03', 'ESTUDIOS', '2016-07-20 22:32:49', 3233.74, 'FISICO', 'Setubal Viajes Y Turismo', 0.16, 'PREFERENTE', '91F', '26491980A');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5888JQ8507XM368', 'BKMQ49', 'ESTUDIOS', '2018-06-07 21:46:43', 318.64, 'FISICO', 'Macuco Tur', 0.01, 'PREFERENTE', '0D', '29958060M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0327JM1389ZN014', 'IFDQ08', 'OCIO', '2019-04-03 01:50:17', 1890.33, 'FISICO', 'D''Alessandro Turismo', 0.28, 'PREFERENTE', '68G', '70878793O');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5736JG2210FV877', 'VKVA87', 'OCIO', '2018-10-31 04:47:46', 2765.37, 'DIGITAL', 'Turismo Zakalik', 0.04, 'BUSINESS', '0F', '91981768G');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3538XX6180GA194', 'SCWO70', 'OCIO', '2019-08-22 00:27:39', 2437.08, 'DIGITAL', 'Falvella Viajes', 0.08, 'TURISTA', '9G', '99591663Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5041PF9182KJ896', 'QRFV95', 'TRABAJO', '2016-03-29 13:37:47', 1936.36, 'FISICO', 'Giugno Turismo', 0.21, 'PREFERENTE', '6D', '74527513B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('3321KM5634WT035', 'LXQS91', 'OCIO', '2016-06-11 06:39:18', 2980.23, 'FISICO', 'Davi-Mar Turismo', 0.24, 'TURISTA', '63F', '56904806S');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('1391KG3300QH273', 'ADSV74', 'TRABAJO', '2018-03-17 11:18:19', 3837.64, 'DIGITAL', 'Glape Tur', 0.25, 'PREFERENTE', '9F', '18861987Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8110TB5743IA675', 'ZBBC98', 'OCIO', '2019-02-21 06:43:46', 1748.95, 'DIGITAL', 'Turismo Morteros', 0.17, 'TURISTA', '0F', '03709449R');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('8983KI4751JX241', 'IQZV46', 'TRABAJO', '2020-09-28 17:15:24', 1214.42, 'DIGITAL', 'Bel Tempo', 0.09, 'BUSINESS', '7G', '13195673E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5203EU6205QQ265', 'BZUM50', 'TRABAJO', '2020-11-14 13:29:33', 1622.39, 'FISICO', 'Tacul Viajes', 0.15, 'TURISTA', '34G', '30744361T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4864NN6841HJ475', 'EITC23', 'TRABAJO', '2019-05-14 13:22:02', 3352.28, 'DIGITAL', 'Tucano Tours S.R.L.', 0.1, 'TURISTA', '06G', '55237927E');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5643FL2422VU083', 'AYCB92', 'TRABAJO', '2018-08-25 22:55:14', 1735.73, 'FISICO', 'Top Dest Empresa De Viajes Y Turismo Wholesaler & Tour Operator', 0.18, 'BUSINESS', '9G', '63097304T');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6865VN8313BL876', 'EBEL90', 'OCIO', '2018-06-19 20:04:28', 459.92, 'DIGITAL', 'La Aldea Turismo', 0.28, 'PREFERENTE', '16G', '20923495U');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('4189TA6881BH151', 'CRFX33', 'TRABAJO', '2018-10-23 20:17:28', 2979.23, 'DIGITAL', 'Turismo Pecom S.A.C.F.I.', 0, 'PREFERENTE', '8G', '03583687M');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0828IJ7289YO311', 'NSBC87', 'OCIO', '2021-07-07 02:14:48', 2939.88, 'FISICO', 'Estudio Turistico', 0.28, 'BUSINESS', '50G', '99220378I');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('6056IH8456EA235', 'HBYV64', 'ESTUDIOS', '2020-02-05 00:14:17', 3354.83, 'DIGITAL', 'Navital Viajes', 0.03, 'BUSINESS', '37G', '30737589B');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5436OW1949YP067', 'OCOL03', 'OCIO', '2018-04-05 19:40:29', 2958.58, 'DIGITAL', 'Graeltur', 0.04, 'BUSINESS', '15G', '51788970Q');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('2494CK1239KK383', 'EITC23', 'ESTUDIOS', '2019-04-04 04:22:02', 3352.28, 'FISICO', 'Elida Martin', 0.07, 'PREFERENTE', '3F', '85342697Z');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0774IZ1254OG795', 'IEZB16', 'TRABAJO', '2017-03-06 10:24:29', 2556.76, 'FISICO', 'Turismo Morteros', 0.17, 'TURISTA', '2F', '89255796Y');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('0680PN0544WI421', 'QIMW93', 'OCIO', '2017-02-01 06:14:38', 1663.29, 'FISICO', 'Curundu Viajes', 0.17, 'BUSINESS', '9F', '22012118W');
insert into BILLETE (idbillete, idvuelo, motivo, fecha_compra, precio, formato, lugar_compra, descuento, clase, plaza, dni_cliente) values ('5856FO4740XW159', 'YAWG91', 'ESTUDIOS', '2016-06-23 22:17:11', 3529.45, 'FISICO', 'Mapamundi Viajes Y Turismo', 0.07, 'TURISTA', '14G', '93990482O');
