-- 1. Insertar Sedes (Exactamente 3 sucursales)
INSERT INTO Sedes (telefono, nombreSede, direccion, estado) VALUES
('2255-0101', 'Vida Activa Escalón', 'Paseo General Escalón #3500, San Salvador', TRUE),
('2255-0202', 'Vida Activa Santa Elena', 'Blvr. Santa Elena #12, Antiguo Cuscatlán', TRUE),
('2255-0303', 'Vida Activa Benito', 'Colonia San Benito, Av. La Capilla #405, San Salvador', TRUE);

-- 2. Insertar Membresías (5 planes orientados a una red de gimnasios)
INSERT INTO Membresias (tituloMembresia, descripcion, precio, duracionMeses, estado) VALUES
('Plan Básico', 'Acceso ilimitado a 1 sola sede fija (área de pesas y cardio)', 29.99, 1, TRUE),
('Plan VIP Multi-Sede', 'Acceso ilimitado a todas las sedes del país + 1 invitado por visita', 49.99, 1, TRUE),
('Plan Anual Pro', 'Acceso Multi-Sede por 1 año con 20% de descuento incluido', 479.99, 12, TRUE),
('Plan Estudiantil', 'Acceso a 1 sede con tarifa preferencial para estudiantes', 19.99, 1, TRUE),
('Plan Elite Performance', 'Acceso a todas las sedes + evaluación nutricional mensual + lockers VIP', 79.99, 1, TRUE);

-- 3. Insertar Miembros (10 atletas de fútbol y fisicoculturistas)
INSERT INTO Miembros (DUI, nombreMiembro, apellidoMiembro, correoMiembro, activo) VALUES
('01234567-8', 'Ronnie', 'Coleman', 'ronnie.coleman@email.com', TRUE),
('02345678-9', 'Arnold', 'Schwarzenegger', 'arnold.s@email.com', TRUE),
('03456789-0', 'Jay', 'Cutler', 'jay.cutler@email.com', TRUE),
('04567890-1', 'Chris', 'Bumstead', 'cbum@email.com', TRUE),
('05678901-2', 'Phil', 'Heath', 'phil.heath@email.com', TRUE),
('06789012-3', 'Lionel', 'Messi', 'leo.messi@email.com', TRUE),
('07890123-4', 'Cristiano', 'Ronaldo', 'cr7.ronaldo@email.com', TRUE),
('08901234-5', 'Kylian', 'Mbappé', 'k.mbappe@email.com', TRUE),
('09012345-6', 'Erling', 'Haaland', 'e.haaland@email.com', TRUE),
('10123456-7', 'Luka', 'Modric', 'luka.modric@email.com', TRUE);

-- 4. Insertar Entrenadores (10 entrenadores)
INSERT INTO Entrenadores (idSede, nombreEntrenador, apellidoEntrenador, telefonoEntrenador, correoEntrenador, activo) VALUES
(1, 'Carlos', 'Prieto', '7890-1111', 'carlos.p@vidaactiva.com', TRUE),
(1, 'Sofía', 'López', '7890-2222', 'sofia.l@vidaactiva.com', TRUE),
(1, 'Roberto', 'Mendoza', '7890-3333', 'roberto.m@vidaactiva.com', TRUE),
(2, 'Andrea', 'Gómez', '7890-4444', 'andrea.g@vidaactiva.com', TRUE),
(2, 'Fernando', 'Torres', '7890-5555', 'fernando.t@vidaactiva.com', TRUE),
(2, 'Lucía', 'Fernández', '7890-6666', 'lucia.f@vidaactiva.com', TRUE),
(3, 'Diego', 'Simeone', '7890-7777', 'diego.s@vidaactiva.com', TRUE),
(3, 'Mariana', 'Ríos', '7890-8888', 'mariana.r@vidaactiva.com', TRUE),
(3, 'Javier', ' Zanetti', '7890-9999', 'javier.z@vidaactiva.com', TRUE),
(1, 'Elena', 'Benítez', '7890-0000', 'elena.b@vidaactiva.com', TRUE);

-- 5. Insertar AreasSede (10 zonas funcionales dentro de las sedes)
INSERT INTO AreasSede (idSede, nombreArea, capacidad) VALUES
(1, 'Zona de Pesas Libres', 50),
(1, 'Cardio Cinema', 35),
(1, 'Salón de Spinning', 25),
(2, 'Zona de Alto Rendimiento', 40),
(2, 'Piscina Olímpica', 20),
(2, 'Área de Calistenia', 30),
(3, 'Ring de Boxeo y Artes Marciales', 25),
(3, 'Salón de Functional Training', 35),
(3, 'Zona de Máquinas Guiadas', 45),
(2, 'Área de Recuperación y Sauna', 15);

-- 6. Insertar Equipos (10 máquinas/equipamiento del gimnasio)
INSERT INTO Equipos (idArea, nombreEquipo, marca) VALUES
(1, 'Racks de Sentadillas Pro', 'Rogue Fitness'),
(1, 'Banca Olímpica Plana', 'Hammer Strength'),
(2, 'Caminadora Comercial T80', 'Life Fitness'),
(2, 'Elíptica Ergonométrica', 'Precor'),
(3, 'Bicicleta de Spinning Indoor', 'Schwinn'),
(4, 'Plataforma de Levantamiento Olímpico', 'Eleiko'),
(6, 'Estación Multi-Rig de Calistenia', 'Rogue Fitness'),
(7, 'Saco de Boxeo Profesional 100lb', 'Everlast'),
(8, 'Sets de Kettlebells 4kg-32kg', 'Rogue Fitness'),
(9, 'Prensa de Piernas 45 Grados', 'CybeX');

-- 7. Insertar Suscripciones (10 suscripciones activas vinculadas a los miembros)
INSERT INTO Suscripciones (idMembresia, idMiembro, fechaInicio, fechaFin, estadoSuscripcion) VALUES
(2, 1, '2026-01-01', '2026-12-31', TRUE), -- Ronnie Coleman (VIP Multi-Sede)
(2, 2, '2026-01-01', '2026-12-31', TRUE), -- Arnold Schwarzenegger (VIP Multi-Sede)
(5, 3, '2026-02-01', '2026-03-01', TRUE), -- Jay Cutler (Elite)
(5, 4, '2026-02-01', '2026-03-01', TRUE), -- CBum (Elite)
(3, 5, '2026-01-01', '2026-12-31', TRUE), -- Phil Heath (Anual Pro)
(2, 6, '2026-01-15', '2026-02-15', TRUE), -- Lionel Messi (VIP Multi-Sede)
(5, 7, '2026-01-10', '2026-02-10', TRUE), -- Cristiano Ronaldo (Elite)
(2, 8, '2026-02-01', '2026-03-01', TRUE), -- Mbappé (VIP Multi-Sede)
(2, 9, '2026-02-01', '2026-03-01', TRUE), -- Haaland (VIP Multi-Sede)
(1, 10, '2026-01-20', '2026-02-20', TRUE); -- Modric (Plan Básico)

-- 8. Insertar Pagos (10 transacciones asociadas a las suscripciones)
INSERT INTO Pagos (idSuscripcion, monto, fechaPago) VALUES
(1, 49.99, '2026-01-01 08:30:00'),
(2, 49.99, '2026-01-01 09:15:00'),
(3, 79.99, '2026-02-01 10:00:00'),
(4, 79.99, '2026-02-01 11:30:00'),
(5, 479.99, '2026-01-01 14:00:00'),
(6, 49.99, '2026-01-15 16:45:00'),
(7, 79.99, '2026-01-10 07:20:00'),
(8, 49.99, '2026-02-01 12:10:00'),
(9, 49.99, '2026-02-01 15:50:00'),
(10, 29.99, '2026-01-20 18:00:00');

-- 9. Insertar Accesos (10 registros de entrada al gimnasio)
INSERT INTO Accesos (idMiembro, idSede, fechaHoraEntrada, autorizado) VALUES
(1, 1, '2026-03-01 06:00:00', TRUE), -- Ronnie en Escalón
(2, 1, '2026-03-01 06:30:00', TRUE), -- Arnold en Escalón
(7, 2, '2026-03-01 07:00:00', TRUE), -- CR7 en Santa Elena
(6, 2, '2026-03-01 08:00:00', TRUE), -- Messi en Santa Elena
(4, 3, '2026-03-01 09:15:00', TRUE), -- CBum en San Benito
(3, 3, '2026-03-01 10:00:00', TRUE), -- Jay Cutler en San Benito
(8, 2, '2026-03-01 11:00:00', TRUE), -- Mbappé en Santa Elena
(9, 1, '2026-03-01 14:30:00', TRUE), -- Haaland en Escalón
(5, 3, '2026-03-01 16:00:00', TRUE), -- Phil Heath en San Benito
(10, 1, '2026-03-01 17:15:00', TRUE); -- Modric en Escalón

-- 10. Insertar Actividades (Máximo 5 clases/actividades)
INSERT INTO Actividades (idEntrenador, nombreActividad, descripcion, fechaProgramada) VALUES
(1, 'Hipertrofia Extrema', 'Entrenamiento intensivo centrado en volumen e hipertrofia muscular', '2026-03-05 17:00:00'),
(4, 'Potencia y Velocidad', 'Sesión de acondicionamiento físico enfocado en sprint y agilidad para atletas', '2026-03-06 08:00:00'),
(2, 'Spinning Alta Intensidad', 'Clase grupal de ciclismo bajo techo con intervalos metabólicos', '2026-03-06 18:00:00'),
(7, 'Cross-Training Funcional', 'Circuito de fuerza y resistencia funcional para rendimiento deportivo', '2026-03-07 09:00:00'),
(8, 'Pilates & Movilidad', 'Trabajo de flexibilidad, fortalecimiento de core y prevención de lesiones', '2026-03-07 10:30:00');

-- 11. Insertar ReservasActividad (10 reservas hechas por miembros a las actividades)
INSERT INTO ReservasActividad (idActividad, idMiembro, fechaReserva, asistio) VALUES
(1, 1, '2026-03-01 10:00:00', TRUE), -- Ronnie a Hipertrofia
(1, 2, '2026-03-01 11:30:00', TRUE), -- Arnold a Hipertrofia
(1, 3, '2026-03-02 09:00:00', TRUE), -- Jay Cutler a Hipertrofia
(1, 4, '2026-03-02 09:15:00', TRUE), -- CBum a Hipertrofia
(2, 6, '2026-03-02 14:00:00', TRUE), -- Messi a Potencia y Velocidad
(2, 7, '2026-03-02 15:00:00', TRUE), -- CR7 a Potencia y Velocidad
(2, 8, '2026-03-03 08:00:00', TRUE), -- Mbappé a Potencia y Velocidad
(2, 9, '2026-03-03 08:30:00', TRUE), -- Haaland a Potencia y Velocidad
(4, 5, '2026-03-03 10:00:00', FALSE),-- Phil Heath a Cross-Training
(4, 10, '2026-03-03 11:00:00', TRUE); -- Modric a Cross-Training




-- 1. Generar 2,000 Miembros adicionales (IDs 11 al 2010)
INSERT INTO Miembros (DUI, nombreMiembro, apellidoMiembro, correoMiembro, activo)
SELECT
    LPAD((20000000 + g)::text, 8, '0') || '-' || (g % 10),
    'Miembro_' || g,
    CASE (g % 5)
        WHEN 0 THEN 'Modric'
        WHEN 1 THEN 'Hernandez'
        WHEN 2 THEN 'Martinez'
        WHEN 3 THEN 'Gomez'
        ELSE 'Lopez'
    END,
    'miembro_' || g || '@vidaactiva.com',
    (g % 4 <> 0) -- 75% activos (TRUE) y 25% inactivos (FALSE) para el índice parcial
FROM generate_series(11, 2010) AS g;

-- 2. Generar 1,500 AreasSede adicionales (distribuidas en las 3 sedes: 1, 2 y 3)
INSERT INTO AreasSede (idSede, nombreArea, capacidad)
SELECT
    1 + (g % 3),
    'Zona Entrenamiento #' || g,
    30
FROM generate_series(11, 1510) AS g;

-- 3. Generar 2,000 Suscripciones adicionales (enlazadas a las 5 membresías existentes)
INSERT INTO Suscripciones (idMembresia, idMiembro, fechaInicio, fechaFin, estadoSuscripcion)
SELECT
    1 + (g % 5),
    g,
    '2026-01-01'::date + (g % 180),
    '2026-12-31'::date,
    (g % 3 <> 0) -- Mezcla de activas e inactivas para el índice parcial
FROM generate_series(11, 2010) AS g;

-- 4. Generar 2,000 Pagos (usando el precio exacto de Membresias y fechas dentro de 2026)
INSERT INTO Pagos (idSuscripcion, monto, fechaPago)
SELECT
    s.idSuscripcion,
    m.precio,
    '2026-01-01 08:00:00'::timestamp + ((g - 11) * interval '3 hours')
FROM generate_series(11, 2010) AS g
JOIN Suscripciones s ON s.idSuscripcion = g
JOIN Membresias m ON m.idMembresia = s.idMembresia;

-- 5. Generar 1,500 Actividades adicionales (IDs 6 al 1505, repartidas entre 10 entrenadores)
INSERT INTO Actividades (idEntrenador, nombreActividad, descripcion, fechaProgramada)
SELECT
    1 + (g % 10),
    'Clase Funcional #' || g,
    'Sesión de acondicionamiento físico y fuerza #' || g,
    '2026-03-10 07:00:00'::timestamp + ((g - 11) * interval '2 hours')
FROM generate_series(11, 1510) AS g;

-- 6. Generar 2,000 ReservasActividad (cumpliendo la restricción uq_reserva_unica)
INSERT INTO ReservasActividad (idActividad, idMiembro, fechaReserva, asistio)
SELECT
    6 + ((g - 11) % 1500),
    g,
    '2026-03-10 08:00:00'::timestamp + ((g - 11) * interval '1 hour'),
    (g % 5 <> 0)
FROM generate_series(11, 2010) AS g;

-- 7. Generar 6,000 Accesos repartidos entre las particiones mensuales de 2026
INSERT INTO Accesos (idMiembro, idSede, fechaHoraEntrada, autorizado)
SELECT
    11 + ((g - 11) % 2000),
    1 + (g % 3),
    '2026-01-01 06:00:00'::timestamp + ((g - 11) * interval '1 hour'),
    (g % 10 <> 0)
FROM generate_series(11, 6010) AS g;