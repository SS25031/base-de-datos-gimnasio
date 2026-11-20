--CREACIÓN DE ÍNDICES EN CLAVES FORÁNEAS

-- 1. ENTRENADORES
--Referencia a Sedes (idsede)
CREATE INDEX idx_entrenadores_idsede
ON Entrenadores (idsede);

-- 2. AREASSEDE
-- Referencia a Sedes (idsede)
CREATE INDEX idx_areassede_idsede
ON AreasSede (idsede);

-- 3. EQUIPOS
-- Referencia a AreasSede (idarea)
CREATE INDEX idx_equipos_idarea
ON Equipos (idarea);

-- 4. ACCESOS (Particionada)
-- Referencia a Miembros (idmiembro)
CREATE INDEX idx_accesos_idmiembro
ON Accesos (idmiembro);

-- Referencia a Sedes (idsede)
CREATE INDEX idx_accesos_idsede
ON Accesos (idsede);

-- 5. SUSCRIPCIONES
-- Referencia a Membresias (idmembresia)
CREATE INDEX idx_suscripciones_idmembresia
ON Suscripciones (idmembresia);

--Referencia a Miembros (idmiembro)
CREATE INDEX idx_suscripciones_idmiembro
ON Suscripciones (idmiembro);

-- 6. PAGOS (Tabla particionada)
-- Referencia a Suscripciones (idsuscripcion)
CREATE INDEX idx_pagos_idsuscripcion
ON Pagos (idsuscripcion);

-- 7. ACTIVIDADES
-- Referencia a Entrenadores (identrenador)
CREATE INDEX idx_actividades_identrenador
ON Actividades (identrenador);

-- 8. RESERVASACTIVIDAD
-- Referencia a Actividades (idactividad)
CREATE INDEX idx_reservasactividad_idactividad
ON ReservasActividad (idactividad);

-- Referencia a Miembros (idmiembro)
CREATE INDEX idx_reservasactividad_idmiembro
ON ReservasActividad (idmiembro);


-- =======================================================
-- CREACIÓN DE ÍNDICE COMPUESTO
CREATE INDEX idx_accesos_sede_fecha
ON Accesos (idsede, fechahoraentrada);

--========================================================
-- CREACIÓN DE ÍNDICES PARCIALES

--1. Miembros activos
CREATE INDEX idx_miembros_activos
ON Miembros (idmiembro)
WHERE activo = TRUE;

--2. Membresias activas
CREATE INDEX idx_membresias_activas
ON Membresias (idmembresia)
WHERE estado = TRUE;

--3. Entrenadores activos
CREATE INDEX idx_entrenadores_activos
ON Entrenadores (identrenador)
WHERE activo = true;

-- 4. Suscripciones activas
CREATE INDEX idx_suscripciones_activas
ON Suscripciones (idsuscripcion)
WHERE estadoSuscripcion = TRUE;


--==========================================
--INDICE UNICO CASE-SENSITIVE

-- CORREO DE MIEMBROS

CREATE UNIQUE INDEX idx_miembros_correo_lower
ON Miembros (lower(correoMiembro));

-- CORREO DE ENTRENADORES

CREATE UNIQUE INDEX idx_entrenadores_correo_lower
ON Entrenadores (lower(correoEntrenador));

/*SELECT lower(correoMiembro) as correo_normalizado,
    count(*) as total_duplicados,
    array_agg(idmiembro) as ids_involucrados
FROM miembros
GROUP BY lower(correoMiembro)
HAVING COUNT(*) > 1;*/

--=====================================================

--BUSQUEDA AVANZADA CON PG_TRGM

--Activar la extension pg_trgm
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Creacion de indice GIN en MIEMBROS
-- Para la columna nombreMiembro
CREATE INDEX idx_miembros_nombre_trgm
ON Miembros USING GIN (nombreMiembro gin_trgm_ops);

-- Para la columna apellidoMiembro
CREATE INDEX idx_miembros_apellido_trgm
ON Miembros USING GIN (apellidoMiembro gin_trgm_ops);

--Creacion de indice GIN en ENTRENADORES
--Para la columna nombreEntrenador
CREATE INDEX idx_entrenadores_nombre_trgm
ON Entrenadores USING GIN (nombreEntrenador gin_trgm_ops);

--Para la columna apellidoEntrenador
CREATE INDEX idx_entrenadores_apellido_trgm
ON Entrenadores USING GIN (apellidoEntrenador gin_trgm_ops);

SELECT idmiembro,
        nombremiembro,
        apellidoMiembro,
        similarity(apellidoMiembro, 'Mobric') AS grado_similitud
FROM Miembros
WHERE apellidoMiembro % 'Mobric'
ORDER BY grado_similitud DESC;

EXPLAIN ANALYZE 
SELECT * FROM Miembros WHERE apellidoMiembro % 'Mobric';

CREATE UNIQUE INDEX idx_suscripciones_unicas_activas_miembros
ON Suscripciones (idMiembro)
WHERE estadoSuscripcion = TRUE;