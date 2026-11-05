-- 1. Tabla: Sedes
CREATE TABLE Sedes (
    idSede SERIAL PRIMARY KEY,
    telefono VARCHAR(9) NOT NULL,
    nombreSede VARCHAR(150) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    estado BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

-- 2. Tabla: Membresias
CREATE TABLE Membresias (
    idMembresia SERIAL PRIMARY KEY,
    tituloMembresia VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL,
    duracionMeses INT NOT NULL,
    estado BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

-- 3. Tabla: Miembros
CREATE TABLE Miembros (
    idMiembro SERIAL PRIMARY KEY,
    DUI VARCHAR(10) NOT NULL UNIQUE,
    nombreMiembro VARCHAR(100) NOT NULL,
    apellidoMiembro VARCHAR(100) NOT NULL,
    correoMiembro VARCHAR(100) NOT NULL,
    activo BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

-- 4. Tabla: Entrenadores
CREATE TABLE Entrenadores (
    idEntrenador SERIAL PRIMARY KEY,
    idSede INT NOT NULL,
    nombreEntrenador VARCHAR(100) NOT NULL,
    apellidoEntrenador VARCHAR(100) NOT NULL,
    telefonoEntrenador VARCHAR(10) NOT NULL,
    correoEntrenador VARCHAR(150) NULL,
    activo BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_entrenadores_sedes FOREIGN KEY (idSede) REFERENCES Sedes(idSede)
);

-- 5. Tabla: AreasSede
CREATE TABLE AreasSede (
    idArea SERIAL PRIMARY KEY,
    idSede INT NOT NULL,
    nombreArea VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    CONSTRAINT fk_areassede_sedes FOREIGN KEY (idSede) REFERENCES Sedes(idSede)
);

-- 6. Tabla: Equipos
CREATE TABLE Equipos (
    idEquipo SERIAL PRIMARY KEY,
    idArea INT NOT NULL,
    nombreEquipo VARCHAR(150) NOT NULL,
    marca VARCHAR(150) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_equipos_areassede FOREIGN KEY (idArea) REFERENCES AreasSede(idArea)
);

-- 7. Tabla: Accesos
CREATE TABLE Accesos (
	idAcceso SERIAL NOT NULL,
    idMiembro INT NOT NULL,
    idSede INT NOT NULL,
    fechaHoraEntrada TIMESTAMP NOT NULL,
    autorizado BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_accesos_miembros FOREIGN KEY (idMiembro) REFERENCES Miembros(idMiembro),
    CONSTRAINT fk_accesos_sedes FOREIGN KEY (idSede) REFERENCES Sedes(idSede),
    PRIMARY KEY(idAcceso, fechaHoraEntrada)
);

-- 8. Tabla: Suscripciones
CREATE TABLE Suscripciones (
    idSuscripcion SERIAL PRIMARY KEY,
    idMembresia INT NOT NULL,
    idMiembro INT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    estadoSuscripcion BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_suscripciones_membresias FOREIGN KEY (idMembresia) REFERENCES Membresias(idMembresia),
    CONSTRAINT fk_suscripciones_miembros FOREIGN KEY (idMiembro) REFERENCES Miembros(idMiembro)
);

-- 9. Tabla: Pagos
CREATE TABLE Pagos (
    idPago SERIAL NOT NULL,
    idSuscripcion INT NOT NULL,
    monto NUMERIC(10, 2) NOT NULL,
    fechaPago TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_pagos_suscripciones FOREIGN KEY (idSuscripcion) REFERENCES Suscripciones(idSuscripcion),
    PRIMARY KEY(idPago, fechaPago)
);

-- 10. Tabla: Actividades
CREATE TABLE Actividades (
    idActividad SERIAL PRIMARY KEY,
    idEntrenador INT NOT NULL,
    nombreActividad VARCHAR(150) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    fechaProgramada TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_actividades_entrenadores FOREIGN KEY (idEntrenador) REFERENCES Entrenadores(idEntrenador)
);

-- 11. Tabla: ReservasActividad
CREATE TABLE ReservasActividad (
    idReserva SERIAL PRIMARY KEY,
    idActividad INT NOT NULL,
    idMiembro INT NOT NULL,
    fechaReserva TIMESTAMP NOT NULL,
    asistio BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_reservasactividad_actividades FOREIGN KEY (idActividad) REFERENCES Actividades(idActividad),
    CONSTRAINT fk_reservasactividad_miembros FOREIGN KEY (idMiembro) REFERENCES Miembros(idMiembro),
    CONSTRAINT uq_reserva_unica UNIQUE (idActividad, idMiembro, fechaReserva)
);