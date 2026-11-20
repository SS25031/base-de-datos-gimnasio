-- ==========================================
-- 06_SEGURIDAD.SQL
-- IMPLEMENTACION DE ROLES Y PERMISOS
-- ==========================================

-- 1. CREACION DE GRUPOS SIN LOGIN

CREATE ROLE grp_admin NOLOGIN;
CREATE ROLE grp_recepcionista NOLOGIN;
CREATE ROLE grp_entrenador NOLOGIN;

-- 2. PERMISOS PARA ADMINISTRADOR

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public
TO grp_admin;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public
TO grp_admin;

-- 3. PERMISOS PARA RECEPCIONISTA

GRANT SELECT ON TABLE suscripciones, membresias
TO grp_recepcionista;

-- Permisos para registrar miembros nuevos
GRANT SELECT, INSERT ON TABLE miembros TO grp_recepcionista;

-- Permitir que los triggers de auditoría registren operaciones del recepcionista
GRANT INSERT ON TABLE Auditoria_Log TO grp_recepcionista;

-- Permisos para ver y crear suscripciones
GRANT SELECT, INSERT ON TABLE suscripciones TO grp_recepcionista;

GRANT INSERT, SELECT ON TABLE accesos, pagos
TO grp_recepcionista;

--RESTRICCIONES
REVOKE UPDATE, DELETE ON TABLE pagos
FROM grp_recepcionista;
REVOKE UPDATE, DELETE ON TABLE suscripciones FROM grp_recepcionista;
REVOKE UPDATE, DELETE ON TABLE miembros FROM grp_recepcionista;

-- 4. PERMISOS PARA ENTRENADOR

GRANT SELECT ON TABLE actividades, reservasactividad
TO grp_entrenador;

-- 5. PERMISOS DE ESQUEMA

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public
TO grp_recepcionista;

-- Permisos de acceso al esquema
GRANT USAGE ON SCHEMA public
TO grp_admin, grp_recepcionista, grp_entrenador;


-- 6. CREACION DE USUARIOS DE PRUEBA

-- Administrador
CREATE ROLE usuario_admin
WITH LOGIN PASSWORD 'admin123'
IN ROLE grp_admin;

-- Recepcionista
CREATE ROLE usuario_recepcion
WITH LOGIN PASSWORD 'recepcion123'
IN ROLE grp_recepcionista;

-- Entrenadores (nombres coinciden con la tabla)
CREATE ROLE carlos
WITH LOGIN PASSWORD '123'
IN ROLE grp_entrenador;

CREATE ROLE "sofía"
WITH LOGIN PASSWORD '123'
IN ROLE grp_entrenador;

CREATE ROLE roberto
WITH LOGIN PASSWORD '123'
IN ROLE grp_entrenador;

-- Usuario dedicado para replicación en flujo (Alta Disponibilidad)
CREATE ROLE replicador WITH REPLICATION LOGIN PASSWORD 'replica_pass';