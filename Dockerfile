FROM postgres:16

# Carpeta para el tablespace y asignación de permisos al usuario postgres
RUN mkdir -p /var/lib/postgresql/tablespace_historico && \
    chown postgres:postgres /var/lib/postgresql/tablespace_historico && \
    chmod 700 /var/lib/postgresql/tablespace_historico

# Carpeta para los archivos WAL
RUN mkdir -p /wal_archive /backup_data && \
    chown -R postgres:postgres /wal_archive /backup_data && \
    chmod 700 /wal_archive /backup_data