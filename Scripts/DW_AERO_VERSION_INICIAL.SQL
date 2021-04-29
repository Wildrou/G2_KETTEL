DROP DATABASE IF EXISTS dw_aero;
CREATE DATABASE dw_aero;
USE dw_aero;


CREATE TABLE dim_cliente
(
    cliente_key INT NOT NULL AUTO_INCREMENT ,
    id_cliente VARCHAR(9),
    edad INT,
    estado_civil ENUM('CASADO','SOLTERO','UNION DE HECHO','SEPARADO','VIUDO','DIVORCIADO'),
    ocupacion VARCHAR(50),
    hijos INT,
    lugar_residencia VARCHAR(50),
    pais_residencia VARCHAR(30),
    pais_origen VARCHAR(30),
    estudios VARCHAR(50),
    genero ENUM('HOMBRE', 'MUJER','OTRO'),
    precio_billete DECIMAL (8,2),
    clase_billete ENUM('TURISTA','BUSINESS','PREFERENTE'),
    cliente_valid_from DATE,
    cliente_valid_through DATE,
    cliente_version_number SMALLINT,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(cliente_key)
);

CREATE TABLE dim_vuelo
(
    vuelo_key INT NOT NULL AUTO_INCREMENT,
    id_vuelo VARCHAR(6),
    duracion_vuelo INT,
    capacidad DOUBLE,
    tipo_vuelo ENUM('NACIONAL','INTERNACIONAL'),
    tipo_avion VARCHAR(10),
    aerolinea VARCHAR(12),
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(vuelo_key)
);

CREATE TABLE dim_lugar
(
    lugar_key INT NOT NULL AUTO_INCREMENT,
    id_lugar INT,
    ciudad VARCHAR(50),
    admin_territorial VARCHAR(70),
    pais VARCHAR(50),
    poblacion ENUM('gran poblacion', 'muy elevada', 'elevada', 'moderada', 'escasa','poco poblado','deshabitado'),
    ubicacion_geografica ENUM('costera', 'interior', 'montañosa', 'urbana', 'boscosa'),
    interes_turistico ENUM('alto','moderado','bajo'),
    temperatura ENUM('muy elevada', 'elevada', 'moderada', 'suave', 'fria','gelida'),
    precipitaciones ENUM('muy elevadas', 'elevadas', 'moderadas', 'escasas', 'deserticas'),
    lugar_valid_from DATE,
    lugar_valid_through DATE,
    lugar_version_number SMALLINT,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(lugar_key)
);

CREATE TABLE dim_fecha
(
    fecha_key INT NOT NULL,
    dia INT,
    mes VARCHAR(15),
    anho INT,
    dia_semana VARCHAR(15),
    estacion ENUM('verano','otoño','invierno','primavera'),
    es_festivo BOOLEAN,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(fecha_key)
);

CREATE TABLE dim_agencia
(
    agencia_key INT NOT NULL AUTO_INCREMENT,
    id_agencia INT,
    nombre VARCHAR(500),
    nacionalidad VARCHAR(500),
    descuento_vip DOUBLE,
    especializacion ENUM('nacionales','internacionales','mixta'),
    agencia_valid_from DATE,
    agencia_valid_through DATE,
    agencia_version_number SMALLINT,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(agencia_key)
);

CREATE TABLE dim_hora
(
    hora_key INT NOT NULL,
    hora INT,
    minutos INT,
    segundos int,
    mediodia ENUM('AM','PM'),
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(hora_key)
);


CREATE TABLE fact_ventas
(
    venta_key INT NOT NULL AUTO_INCREMENT,
    vuelo_key INT NOT NULL,
    lugar_salida_key INT NOT NULL,
    lugar_llegada_key INT NOT NULL,
    fecha_key INT NOT NULL,
    hora_key INT NOT NULL,
    agencia_key INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    num_vuelos DOUBLE NOT NULL,
    num_clientes DOUBLE NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(venta_key),
    CONSTRAINT fkvuelo_key_venta  FOREIGN KEY (vuelo_key) REFERENCES dim_vuelo (vuelo_key) ON DELETE CASCADE,
    CONSTRAINT fklugar_origen_key  FOREIGN KEY (lugar_salida_key) REFERENCES dim_lugar (lugar_key) ON DELETE CASCADE,
    CONSTRAINT fklugar_destino_key  FOREIGN KEY (lugar_llegada_key) REFERENCES dim_lugar (lugar_key) ON DELETE CASCADE,
    CONSTRAINT fkfecha_key  FOREIGN KEY (fecha_key) REFERENCES dim_fecha (fecha_key) ON DELETE CASCADE,
	CONSTRAINT fkagencia_key  FOREIGN KEY (agencia_key) REFERENCES dim_agencia (agencia_key) ON DELETE CASCADE,
    CONSTRAINT fkhora_key  FOREIGN KEY (hora_key) REFERENCES dim_hora (hora_key) ON DELETE CASCADE

);