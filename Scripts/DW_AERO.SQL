DROP DATABASE IF EXISTS dw_aero;
CREATE DATABASE dw_aero;
USE dw_aero;


CREATE TABLE dim_cliente
(
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
    PRIMARY KEY(id_cliente)
);

CREATE TABLE dim_vuelo
(
    id_vuelo INT NOT NULL,
    duracion_vuelo INT NOT NULL,
    capacidad DOUBLE NOT NULL,
    tipo_vuelo ENUM('NACIONAL','INTERNACIONAL') NOT NULL,
    tipo_avion VARCHAR(10) NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_vuelo)
);

CREATE TABLE dim_lugar
(
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
    PRIMARY KEY(id_lugar)
);

CREATE TABLE dim_fecha
(
    id_fecha INT NOT NULL,
    dia INT NOT NULL,
    mes VARCHAR(15) NOT NULL,
    anho INT NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    estacion ENUM('verano','otoño','invierno','primavera') NOT NULL,
    es_festivo BOOLEAN NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_fecha)
);

CREATE TABLE dim_agencia
(
    id_agencia INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(30) NOT NULL,
    descuento_vip DOUBLE NOT NULL,
    especializacion ENUM('nacionales','internacionales','mixta') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_agencia)
);

CREATE TABLE dim_hora
(
    id_hora INT NOT NULL,
    hora INT NOT NULL,
    minutos INT NOT NULL,
    segundos int NOT NULL,
    mediodia ENUM('AM','PM') NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_hora)
);


CREATE TABLE fact_ventas
(
    id_vuelo INT NOT NULL,
    id_lugar INT NOT NULL,
    id_fecha INT NOT NULL,
    id_hora INT NOT NULL,
    id_agencia INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    num_vuelos DOUBLE NOT NULL,
    num_clientes DOUBLE NOT NULL,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fkid_vuelo_venta  FOREIGN KEY (id_vuelo) REFERENCES dim_vuelo (id_vuelo) ON DELETE CASCADE,
    CONSTRAINT fkid_lugar  FOREIGN KEY (id_lugar) REFERENCES dim_lugar (id_lugar) ON DELETE CASCADE,
    CONSTRAINT fkid_fecha  FOREIGN KEY (id_fecha) REFERENCES dim_fecha (id_fecha) ON DELETE CASCADE,
	CONSTRAINT fkid_agencia  FOREIGN KEY (id_agencia) REFERENCES dim_agencia (id_agencia) ON DELETE CASCADE,
    CONSTRAINT fkid_hora  FOREIGN KEY (id_hora) REFERENCES dim_hora (id_hora) ON DELETE CASCADE

);