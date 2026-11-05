# Proyecto Final - Administración de Bases de Datos (Gimnasio)

Este repositorio contiene la implementación de la base de datos para el sistema de gestión de un gimnasio, desarrollada en PostgreSQL y desplegada mediante Docker.

## Cómo levantar el proyecto (Para el equipo)

### Requisitos previos
- Tener instalado [Docker Desktop](https://www.docker.com/products/docker-desktop/).
- Tener instalado Git.

### Pasos para iniciar
1. Clona este repositorio en la máquina local.
2. Abrir una terminal en la raíz del proyecto.
3. Ejecutar el siguiente comando para levantar la base de datos desde cero:
   ```bash
   docker compose up -d --build