
-- ==========================================
-- ISSUE #8: SEGURIDAD A NIVEL DE FILA (RLS)
-- ==========================================

-- 1. Habilitar RLS en actividades
ALTER TABLE actividades ENABLE ROW LEVEL SECURITY;

-- Forzar cumplimiento incluso para el propietario
ALTER TABLE actividades FORCE ROW LEVEL SECURITY;

-- 2. Permitir consultar entrenadores para identificar al usuario
GRANT SELECT ON TABLE entrenadores TO grp_entrenador;

-- 3. Política: cada entrenador ve sus propias actividades
CREATE POLICY politica_mis_actividades
ON actividades
FOR SELECT
TO grp_entrenador
USING (
    identrenador = (
        SELECT identrenador
        FROM entrenadores
        WHERE lower(nombreentrenador) = current_user
    )
);
