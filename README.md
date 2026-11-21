# Administración de Base de Datos — Gimnasio "Vida Activa"

Infraestructura de base de datos relacional centralizada, contenedorizada y altamente disponible para la gestión operativa, financiera y administrativa de la red de gimnasios **"Vida Activa"**, desarrollada sobre **PostgreSQL 16** y **Docker**.

---

## Información Académica

* **Institución:** Universidad de El Salvador — Facultad Multidisciplinaria de Occidente
* **Departamento:** Ingeniería y Arquitectura — Ingeniería en Desarrollo de Software
* **Asignatura:** Administración de Bases de Datos (Ciclo IV)
* **Equipo de Desarrollo:**
  * Jefferson Gerardo Quezada López (`QL25003`)
  * Denilson Alfredo Vega Granadino (`VG20024`)
  * Katherinne Jeanmillette Santos Sermeño (`SS25031`)
  * Alfredo Enrique Ortiz Hernández (`OH23001`)

---

## Descripción del Proyecto

La modernización de la plataforma de datos de **"Vida Activa"** resuelve la fragmentación de información entre sucursales, las fugas financieras por accesos no autorizados y los riesgos de pérdida de datos mediante una arquitectura desacoplada en **Docker** y **PostgreSQL 16**.

El diseño abarca todo el ciclo de vida de administración de bases de datos:
1. **Modelado Relacional e Integridad:** Automatización de reglas de negocio y auditoría transaccional mediante funciones y disparadores (*triggers*) en `PL/pgSQL`.
2. **Almacenamiento Multinivel y Escalabilidad:** Particionamiento declarativo por rango de fechas y separación física de datos históricos mediante *tablespaces*.
3. **Optimización de Rendimiento:** Estrategia híbrida de indexación (B-Tree, compuestos, parciales, funcionales y GIN) con mantenimiento preventivo en línea sin bloqueo.
4. **Seguridad y Gobernanza:** Control de acceso basado en roles (RBAC), inmutabilidad contable y Seguridad a Nivel de Fila (RLS).
5. **Continuidad Operativa y Alta Disponibilidad:** Respaldos lógicos automatizados, respaldos físicos base, recuperación a un punto en el tiempo (PITR) y replicación en flujo (*Streaming Replication*) con conmutación por fallo (*failover*).
6. **Observabilidad:** Monitoreo en tiempo real y alertas preventivas con Postgres Exporter, Prometheus y Grafana.

---

![Diagrama Entidad-Relación - db_gimnasio](docs/ER-db-gimnasio/db_gimnasio%20-%20db_gimnasio%20-%20public.png)

## Estructura del Repositorio

```text
db_gimnasio/
├── Dockerfile                      # Imagen PostgreSQL 16 con directorios para tablespaces y WAL
├── docker-compose.yml              # Nodo primario (db_gimnasio) y configuración de archivado WAL
├── docker-compose-recuperacion.yml # Instancia aislada para validación de respaldos físicos (db_recuperada)
├── docker-compose-pitr.yml         # Instancia dedicada para recuperación puntual (db_pitr)
├── docker-compose-replica.yml      # Nodo espejo Hot Standby para alta disponibilidad (db_replica)
├── docker-compose-monitoreo.yml    # Stack de observabilidad (Postgres Exporter, Prometheus, Grafana)
├── env.example                     # Plantilla de variables de entorno
├── prometheus.yml                  # Configuración de recolección de métricas cada 15s
├── init_db/                        # Scripts de inicialización automática del esquema
│   ├── 00_setup_tablespaces.sql    # Creación de tablespace histórico (ts_historico)
│   ├── 01_tablas.sql               # Definición DDL de las entidades principales
│   ├── 02_particiones.sql          # Particionamiento mensual y por defecto de Accesos y Pagos
│   ├── 03_funciones_triggers.sql   # Reglas de negocio, auditoría y actualización de timestamps
│   ├── 04_datos_prueba.sql         # Carga inicial de datos operativos
│   ├── 05_indices.sql              # Índices FK, compuestos, parciales, funcionales y GIN
│   ├── 06_seguridad.sql            # Roles de grupo (NOLOGIN), privilegios y usuarios (LOGIN)
│   └── 07_policies.sql             # Políticas de Seguridad a Nivel de Fila (RLS)
├── scripts_operaciones/
│   ├── backup_logico.ps1           # Automatización de respaldos lógicos (pg_dump) con retención de 7 días
│   └── backup_fisico.ps1           # Automatización de respaldos físicos (pg_basebackup) con retención de 7 días
└── docs/                           # Diagrama Entidad-Relación y evidencias de validación                          # Diagrama Entidad-Relación y evidencias de validación
```

---

## Modelo de Datos y Lógica de Negocio

El esquema relacional está compuesto por **11 tablas principales** (`Sedes`, `Membresias`, `Miembros`, `Entrenadores`, `AreasSede`, `Equipos`, `Accesos`, `Suscripciones`, `Pagos`, `Actividades`, `ReservasActividad`) complementadas por la bitácora de auditoría `Auditoria_Log`.

### Funciones y Triggers (`PL/pgSQL`)
Se implementaron y validaron **20 eventos de disparadores** activos en el catálogo del sistema (`information_schema.triggers`):
* **`fn_update_timestamp()`:** Actualiza automáticamente el campo `updated_at` (`BEFORE UPDATE`) en 9 tablas del esquema.
* **`fn_auditoria()`:** Registra operaciones `INSERT`, `UPDATE` y `DELETE` en `Auditoria_Log` (almacenando el estado anterior y nuevo en formato `JSONB`, el usuario ejecutor y la marca temporal) sobre las tablas críticas `Miembros`, `Pagos` y `Suscripciones`.
* **`fn_validar_acceso()`:** Evalúa en tiempo real (`BEFORE INSERT` en `Accesos`) si el miembro se encuentra activo y cuenta con una suscripción vigente; en caso contrario, asigna `autorizado = FALSE` dejando constancia del intento fallido para auditoría.
* **`fn_validar_monto_pago()`:** Verifica (`BEFORE INSERT` en `Pagos`) que el monto cobrado coincida exactamente con la tarifa vigente de la membresía asociada, abortando transacciones inconsistentes mediante `RAISE EXCEPTION`.

---

## Almacenamiento Multinivel y Particionamiento

* **Separación Física (`Tablespaces`):** Se implementó un esquema de almacenamiento por niveles (*tiered storage*) diferenciando los datos operativos recientes (`pg_default`) de los registros históricos (`ts_historico`, alojado en `/var/lib/postgresql/tablespace_historico`).
* **Particionamiento Declarativo (`PARTITION BY RANGE`):** Las tablas transaccionales de alto crecimiento (`Accesos` y `Pagos`) fueron particionadas por rango temporal con claves primarias compuestas:
  * **Histórico (2025):** `Accesos_2025_01` y `Pagos_2025_01` asignadas explícitamente al *tablespace* `ts_historico`.
  * **Operativo Mensual (2026):** 12 subtablas mensuales (`_2026_01` a `_2026_12`) alojadas en `pg_default` para aprovechar la poda de particiones (*Partition Pruning*).
  * **Contención:** Particiones `DEFAULT` (`Accesos_default`, `Pagos_default`) para absorber registros fuera de los rangos predefinidos sin fallos de inserción.

---

## Optimización de Consultas e Indexación

Se diseñó una estrategia híbrida de indexación validada mediante análisis de planes de ejecución (`EXPLAIN ANALYZE`):
* **Índices B-Tree en Claves Foráneas:** Aplicados sobre todas las llaves foráneas para acelerar operaciones `JOIN` y verificaciones de integridad referencial.
* **Índice Compuesto:** `idx_accesos_sede_fecha` sobre `Accesos (idSede, fechaHoraEntrada)` para reportes de asistencia por sucursal y rango de fechas.
* **Índices Parciales:** Subconjuntos filtrados para registros activos (`WHERE activo = TRUE` / `estado = TRUE`), reduciendo el tamaño del índice en disco.
* **Índice Único Funcional:** `idx_miembros_correo_lower` sobre `lower(correoMiembro)` para impedir correos duplicados sin distinción entre mayúsculas y minúsculas.
* **Índices GIN con Trigramas (`pg_trgm`):** Búsquedas difusas por similitud tipográfica en nombres y apellidos de miembros y entrenadores desde recepción.

**Resultados y Mantenimiento:**
* En consultas de búsqueda puntual sobre `Miembros`, el plan de ejecución pasó de un barrido secuencial (`Seq Scan`, $3.816\text{ ms}$) a un acceso indexado directo (`Index Scan`, $0.849\text{ ms}$).
* Ante fragmentación (*index bloat*) provocada por actualizaciones masivas, la compactación en línea mediante `REINDEX INDEX CONCURRENTLY` redujo el tamaño del índice GIN de $352\text{ kB}$ a $48\text{ kB}$, recuperando el $86.4\%$ del espacio sin bloquear operaciones de lectura ni escritura.

---

## Seguridad y Gobernanza de Datos

La arquitectura de seguridad se estructuró bajo el **principio de mínimo privilegio** en dos capas complementarias:

### 1. Control de Acceso Basado en Roles (RBAC)
Se desacoplaron los perfiles funcionales (`NOLOGIN`) de las cuentas individuales (`LOGIN`):
* **`grp_admin` (`usuario_admin`):** Control total (`ALL PRIVILEGES`) sobre todas las tablas y secuencias del esquema público, con atributo `BYPASSRLS`.
* **`grp_recepcionista` (`usuario_recepcion`):** Permisos restringidos a consulta (`SELECT`) e inserción (`INSERT`) para gestionar afiliaciones, suscripciones, entradas y cobros. Se revocaron explícitamente `UPDATE` y `DELETE` sobre `Pagos`, `Suscripciones` y `Miembros` para garantizar la inmutabilidad contable.
* **`grp_entrenador` (`carlos`, `sofía`, `roberto`):** Permisos limitados a lectura (`SELECT`) sobre `Actividades`, `ReservasActividad` y `Entrenadores`.

### 2. Seguridad a Nivel de Fila (RLS)
En la tabla `Actividades` se habilitó y forzó el cumplimiento de RLS (`ENABLE` y `FORCE ROW LEVEL SECURITY`). Mediante políticas dinámicas vinculadas a `current_user`, cada entrenador visualiza y gestiona únicamente sus propias clases asignadas, aislando la información respecto al resto de instructores.

---

## Respaldos, Recuperación (PITR) y Alta Disponibilidad

| Estrategia | Herramienta / Mecanismo | Objetivo Operativo |
| :--- | :--- | :--- |
| **Respaldo Lógico** | `pg_dump -Fc` + `backup.ps1` (Programador de Tareas a las 02:00 AM, retención de 7 días) | Copias portátiles en `./backups_locales` para restauración granular de tablas mediante `pg_restore`. |
| **Respaldo Físico Automático** | `pg_basebackup --tablespace-mapping` + volumen externo `backup_data` + `backup_fisico.ps1` | Recuperación completa ante pérdida total del servidor, validada en el contenedor `db_recuperada` (puerto `5435`). |
| **PITR (Recuperación Puntual)** | `wal_level = replica`, `archive_mode = on` + `recovery.signal` en `db_pitr` (puerto `5436`) | Reversión de errores lógicos graves hasta el segundo exacto previo al incidente ($\text{RPO} \approx 0$). |
| **Alta Disponibilidad (HA)** | *Streaming Replication* activo-pasivo (`db_gimnasio` `:5432` -> `db_replica` `:5437`) | Réplica *Hot Standby* sincronizada en tiempo real con conmutación inmediata mediante `SELECT pg_promote();` y autorrecuperación (`unless-stopped`). |

---

## Observabilidad, Monitoreo y Alertas

Se desplegó una arquitectura de monitoreo desacoplada compuesta por:
* **Postgres Exporter (puerto `9187`):** Recolección de métricas internas del motor mediante la extensión `pg_stat_statements`.
* **Prometheus (puerto `9090`):** Almacenamiento de series temporales con intervalo de muestreo de $15\text{ segundos}$.
* **Grafana (puerto `3000`):** Visualización en tiempo real mediante el *Dashboard 9628* (`PostgreSQL Database`).

### Alertas Críticas Configuradas (Evaluación cada 1 minuto)
1. **Uso Crítico de Memoria (`process_resident_memory_bytes`):** Detecta consumo anómalo de memoria RAM antes de comprometer la estabilidad del contenedor.
2. **Caída del Servidor (`pg_up < 1`):** Configurada con manejo explícito de estados `No Data` y `Execution Error` para disparar alertas inmediatas ante la indisponibilidad del nodo primario.

---

## Guía Rápida de Despliegue

### 1. Configurar variables de entorno y volúmenes externos
```bash
cp env.example .env
docker volume create backup_data
docker volume create wal_archive_data
```

### 2. Levantar el entorno principal de PostgreSQL 16
```bash
docker compose up -d --build
```
El contenedor principal quedará disponible en `localhost:5432` bajo el nombre `db_gimnasio`.

### 3. Levantar el stack de monitoreo y alertas
```bash
docker compose -f docker-compose-monitoreo.yml up -d
```
* **Grafana:** `http://localhost:3000` (credenciales iniciales: `admin` / `admin`)
* **Prometheus:** `http://localhost:9090`