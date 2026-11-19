-- 03_funciones_triggers.sql

-- ============================================================
-- 1. Trigger de mantenibilidad: updated_at
-- ============================================================
CREATE OR REPLACE FUNCTION fn_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_miembros_updated_at
    BEFORE UPDATE ON Miembros
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_entrenadores_updated_at
    BEFORE UPDATE ON Entrenadores
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_sedes_updated_at
    BEFORE UPDATE ON Sedes
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_membresias_updated_at
    BEFORE UPDATE ON Membresias
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_suscripciones_updated_at
    BEFORE UPDATE ON Suscripciones
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_pagos_updated_at
    BEFORE UPDATE ON Pagos
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_actividades_updated_at
    BEFORE UPDATE ON Actividades
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_equipos_updated_at
    BEFORE UPDATE ON Equipos
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE OR REPLACE TRIGGER trg_reservasactividad_updated_at
    BEFORE UPDATE ON ReservasActividad
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();


-- ============================================================
-- 2. Trigger de auditoría: Auditoria_Log
-- ============================================================
CREATE TABLE IF NOT EXISTS Auditoria_Log (
    id           BIGSERIAL PRIMARY KEY,
    tabla        VARCHAR(100) NOT NULL,
    operacion    VARCHAR(10)  NOT NULL,
    usuario      VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
    fecha        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_viejos JSONB,
    datos_nuevos JSONB
);

CREATE OR REPLACE FUNCTION fn_auditoria()
RETURNS TRIGGER AS $$
DECLARE
    v_tabla TEXT;
BEGIN
    SELECT relname
    INTO v_tabla
    FROM pg_class
    WHERE oid = COALESCE(pg_partition_root(TG_RELID), TG_RELID);

    IF TG_OP = 'INSERT' THEN
        INSERT INTO Auditoria_Log (tabla, operacion, usuario, datos_viejos, datos_nuevos)
        VALUES (v_tabla, TG_OP, CURRENT_USER, NULL, to_jsonb(NEW));
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO Auditoria_Log (tabla, operacion, usuario, datos_viejos, datos_nuevos)
        VALUES (v_tabla, TG_OP, CURRENT_USER, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;

    ELSE  -- DELETE
        INSERT INTO Auditoria_Log (tabla, operacion, usuario, datos_viejos, datos_nuevos)
        VALUES (v_tabla, TG_OP, CURRENT_USER, to_jsonb(OLD), NULL);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_miembros_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON Miembros
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria();

CREATE OR REPLACE TRIGGER trg_pagos_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON Pagos
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria();

CREATE OR REPLACE TRIGGER trg_suscripciones_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON Suscripciones
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria();


-- ============================================================
-- 3. Regla de negocio: Accesos
-- ============================================================
CREATE OR REPLACE FUNCTION fn_validar_acceso()
RETURNS TRIGGER AS $$
DECLARE
    v_miembro_activo      BOOLEAN;
    v_suscripcion_vigente BOOLEAN;
BEGIN
    SELECT activo
    INTO v_miembro_activo
    FROM Miembros
    WHERE idMiembro = NEW.idMiembro;

    SELECT EXISTS (
        SELECT 1
        FROM Suscripciones
        WHERE idMiembro = NEW.idMiembro
          AND estadoSuscripcion = TRUE
          AND CURRENT_DATE BETWEEN fechaInicio AND fechaFin
    )
    INTO v_suscripcion_vigente;

    IF COALESCE(v_miembro_activo, FALSE) = FALSE OR NOT v_suscripcion_vigente THEN
        NEW.autorizado := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_accesos_validar
    BEFORE INSERT ON Accesos
    FOR EACH ROW EXECUTE FUNCTION fn_validar_acceso();


-- ============================================================
-- 4. Regla de negocio: monto de Pagos
-- ============================================================
CREATE OR REPLACE FUNCTION fn_validar_monto_pago()
RETURNS TRIGGER AS $$
DECLARE
    v_precio NUMERIC(10, 2);
BEGIN
    SELECT m.precio
    INTO v_precio
    FROM Suscripciones s
    JOIN Membresias m ON m.idMembresia = s.idMembresia
    WHERE s.idSuscripcion = NEW.idSuscripcion;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La suscripción % no existe', NEW.idSuscripcion;
    END IF;

    IF NEW.monto <> v_precio THEN
        RAISE EXCEPTION 'El monto % no coincide con el precio de la membresía (%)',
            NEW.monto, v_precio;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_pagos_validar_monto
    BEFORE INSERT ON Pagos
    FOR EACH ROW EXECUTE FUNCTION fn_validar_monto_pago();
