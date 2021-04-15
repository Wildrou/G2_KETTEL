DROP DATABASE IF EXISTS dw_aero;
CREATE DATABASE dw_aero;
USE dw_aero;


CREATE TABLE dim_cliente
(
    cliente_key INT NOT NULL AUTO_INCREMENT ,
    id_cliente INT NOT NULL,
    edad INT NOT NULL,
    estado_civil ENUM('CASADO','SOLTERO','UNION DE HECHO','SEPARADO','VIUDO','DIVORCIADO') NOT NULL,
    ocupacion VARCHAR(50) NOT NULL,
    hijos INT NOT NULL,
    lugar_residencia VARCHAR(50) NOT NULL,
    pais_residencia VARCHAR(30) NOT NULL,
    pais_origen VARCHAR(30) NOT NULL,
    estudios VARCHAR(50) NOT NULL,
    genero ENUM('HOMBRE', 'MUJER','OTRO') NOT NULL,
    precio_billete DECIMAL (8,2) NOT NULL,
    clase_billete ENUM('TURISTA','BUSINESS','PREFERENTE') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(cliente_key)
);

CREATE TABLE dim_vuelo
(
    vuelo_key INT NOT NULL AUTO_INCREMENT,
    id_vuelo VARCHAR(6) NOT NULL,
    duracion_vuelo INT NOT NULL,
    capacidad DOUBLE NOT NULL,
    tipo_vuelo ENUM('NACIONAL','INTERNACIONAL') NOT NULL,
    tipo_avion VARCHAR(10) NOT NULL,
    aerolinea VARCHAR(12) NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(vuelo_key)
);

CREATE TABLE dim_lugar
(
    lugar_key INT NOT NULL AUTO_INCREMENT,
    id_lugar INT NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    admin_territorial VARCHAR(70),
    pais VARCHAR(50) NOT NULL,
    poblacion INT,
    ubicacion_geografica ENUM('costera', 'interior', 'montañosa', 'urbana', 'boscosa') NOT NULL,
    interes_turistico ENUM('alto','moderado','bajo') NOT NULL,
    temperatura DECIMAL(4,2) NOT NULL,
    precipitaciones DECIMAL(6,2) NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(lugar_key)
);

CREATE TABLE dim_fecha
(
    fecha_key INT NOT NULL,
    dia INT NOT NULL,
    mes VARCHAR(15) NOT NULL,
    anho INT NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    estacion ENUM('verano','otoño','invierno','primavera') NOT NULL,
    es_festivo BOOLEAN NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(fecha_key)
);

CREATE TABLE dim_agencia
(
    agencia_key INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(30) NOT NULL,
    descuento_vip DOUBLE NOT NULL,
    especializacion ENUM('nacionales','internacionales','mixta') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(agencia_key)
);

CREATE TABLE dim_hora
(
    hora_key INT NOT NULL,
    hora INT NOT NULL,
    minutos INT NOT NULL,
    segundos int NOT NULL,
    mediodia ENUM('AM','PM') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(hora_key)
);


CREATE TABLE fact_ventas
(
    vuelo_key INT NOT NULL,
    lugar_key INT NOT NULL,
    fecha_key INT NOT NULL,
    hora_key INT NOT NULL,
    agencia_key INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    num_vuelos DOUBLE NOT NULL,
    num_clientes DOUBLE NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fkvuelo_key_venta  FOREIGN KEY (vuelo_key) REFERENCES dim_vuelo (vuelo_key) ON DELETE CASCADE,
    CONSTRAINT fklugar_key  FOREIGN KEY (lugar_key) REFERENCES dim_lugar (lugar_key) ON DELETE CASCADE,
    CONSTRAINT fkfecha_key  FOREIGN KEY (fecha_key) REFERENCES dim_fecha (fecha_key) ON DELETE CASCADE,
	CONSTRAINT fkagencia_key  FOREIGN KEY (agencia_key) REFERENCES dim_agencia (agencia_key) ON DELETE CASCADE,
    CONSTRAINT fkhora_key  FOREIGN KEY (hora_key) REFERENCES dim_hora (hora_key) ON DELETE CASCADE

);