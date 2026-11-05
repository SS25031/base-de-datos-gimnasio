FROM postgres:16

# Carpeta para el tablespace y asignación de permisos al usuario postgres
RUN mkdir -p /var/lib/postgresql/tablespace_historico && \
    chown postgres:postgres /var/lib/postgresql/tablespace_historico && \
    chmod 700 /var/lib/postgresql/tablespace_historico