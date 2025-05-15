# 📊 postgres-etl

Un proyecto ETL con Docker, PostgreSQL y Apache Superset para el análisis de datos geográficos de Argentina.

---

## 📥 Descarga de Datasets

Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del Gobierno de Argentina:

🔗 [https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Este portal proporciona información pública reutilizable, incluyendo datos relacionados con los **servicios de normalización de direcciones** y **unidades territoriales** de Argentina.

---

## 🧭 Resumen del Tutorial

Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando:

- Docker
- PostgreSQL
- Apache Superset

### Incluye instrucciones para:

1. Levantar los servicios con Docker.
2. Configurar la conexión a la base de datos en Superset.
3. Ejecutar consultas SQL para analizar los datos.
4. Crear gráficos y tableros interactivos.

---

## 🛠️ Descripción del Proyecto

Este proyecto implementa un flujo **ETL (Extract, Transform, Load)** para cargar y analizar datos relacionados con los servicios de normalización de direcciones y unidades territoriales de Argentina.

Utilizamos herramientas como:

- **Docker**: para contenerizar los servicios.
- **PostgreSQL**: como base de datos relacional.
- **Apache Superset**: para visualización de datos.

El objetivo es construir una solución **escalable y reproducible** que permita analizar datos de **provincias, departamentos, localidades y calles** de Argentina mediante dashboards interactivos.

---

## ✅ Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)
- Un navegador web (para acceder a Superset)

---

## 🧱 Servicios definidos en `docker-compose.yml`

```yaml
services:
  db:
    image: postgres:alpine
    env_file:
      - .env.db
    restart: unless-stopped
    environment:
      - POSTGRES_INITDB_ARGS=--auth-host=md5 --auth-local=trust
    healthcheck:
      test: [ "CMD-SHELL", "pg_isready" ]
      interval: 10s
      timeout: 2s
      retries: 5
    ports:
      - 5439:5432
    volumes:
      - postgres-db:/var/lib/postgresql/data
      - ./initdb:/docker-entrypoint-initdb.d
      - ./datos:/superset/datos
    networks:
      - net

  superset:
    image: apache/superset:4.0.0
    restart: unless-stopped
    env_file:
      - .env.db
    ports:
      - 8088:8088
    depends_on:
      db:
        condition: service_healthy
    networks:
      - net
```
##⚙️ Instrucciones de Configuración
1. Clonar el repositorio
   ```yaml
     git clone <URL_DEL_REPOSITORIO>
     cd postgres-etl
   ```
2. Crear archivo .env.db
   Crea el archivo .env.db en la raíz del proyecto con este contenido:
   ```yaml
     DATABASE_HOST=db
    DATABASE_PORT=5432
    DATABASE_NAME=postgres
    DATABASE_USER=postgres
    DATABASE_PASSWORD=postgres
    POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=trust"
    
    POSTGRES_PASSWORD=${DATABASE_PASSWORD}
    PGUSER=${DATABASE_USER}
    
    SUPERSET_SECRET_KEY=your_secret_key_here
   ```
3.Levantar los servicios
    ```yaml
     docker compose up -d
   ```
