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
    duracion_vuelo VARCHAR(30),
    capacidad VARCHAR(30),
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
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(lugar_key)
);

CREATE TABLE dim_fecha
(
    fecha_key INT NOT NULL,
    dia_completo VARCHAR(50),
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
    venta_key VARCHAR(15) NOT NULL,
    vuelo_key INT NOT NULL,
    cliente_key INT NOT NULL,
    lugar_salida_key INT NOT NULL,
    lugar_llegada_key INT NOT NULL,
    fecha_salida_key INT NOT NULL,
    hora_salida_key INT NOT NULL,
    fecha_compra_key INT NOT NULL,
    hora_compra_key INT NOT NULL,
    agencia_key INT NOT NULL,
    importe DECIMAL(10,2),
    vuelo_cont INT,
    precio_agencia DECIMAL(10,2),
    beneficio DECIMAL(10,2),
    antelacion_compra INT,
    ultima_actualizacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(venta_key),
    CONSTRAINT fkvuelo_key_venta  FOREIGN KEY (vuelo_key) REFERENCES dim_vuelo (vuelo_key) ON DELETE CASCADE,
    CONSTRAINT fkcliente_key_venta  FOREIGN KEY (cliente_key) REFERENCES dim_cliente (cliente_key) ON DELETE CASCADE,
    CONSTRAINT fklugar_origen_key  FOREIGN KEY (lugar_salida_key) REFERENCES dim_lugar (lugar_key) ON DELETE CASCADE,
    CONSTRAINT fklugar_destino_key  FOREIGN KEY (lugar_llegada_key) REFERENCES dim_lugar (lugar_key) ON DELETE CASCADE,
    CONSTRAINT fkfecha_salida_key  FOREIGN KEY (fecha_salida_key) REFERENCES dim_fecha (fecha_key) ON DELETE CASCADE,
    CONSTRAINT fkhora_salida_key  FOREIGN KEY (hora_salida_key) REFERENCES dim_hora (hora_key) ON DELETE CASCADE,
    CONSTRAINT fkfecha_compra_key  FOREIGN KEY (fecha_compra_key) REFERENCES dim_fecha (fecha_key) ON DELETE CASCADE,
    CONSTRAINT fkhora_compra_key  FOREIGN KEY (hora_compra_key) REFERENCES dim_hora (hora_key) ON DELETE CASCADE,
	CONSTRAINT fkagencia_key  FOREIGN KEY (agencia_key) REFERENCES dim_agencia (agencia_key) ON DELETE CASCADE

);


INSERT INTO `dim_lugar` (`lugar_key`, `id_lugar`, `ciudad`, `admin_territorial`, `pais`, `poblacion`, `ubicacion_geografica`, `interes_turistico`, `temperatura`, `precipitaciones`, `ultima_actualizacion`) VALUES ('-1', '-1', 'N/A', 'N/A', 'N/A', NULL, NULL, NULL, NULL, NULL, '1990-01-01 00:00:00');
INSERT INTO `dim_agencia` (`agencia_key`, `id_agencia`, `nombre`, `nacionalidad`, `descuento_vip`, `especializacion`, `agencia_valid_from`, `agencia_valid_through`, `agencia_version_number`, `ultima_actualizacion`) VALUES ('-1', '-1', 'N/A', 'N/A', NULL, NULL, '1900-01-01', '2199-12-31', '1', '1990-01-01 00:00:00');

