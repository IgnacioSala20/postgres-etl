# postgres-etl

---

## 📥 Descarga de Datasets

Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del gobierno de Argentina:

[https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Este portal proporciona información pública en formatos reutilizables, incluyendo datos relacionados con los Servicios de normalización de direcciones y unidades territoriales de Argentina.

---

## 📋 Resumen del Tutorial

Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando Docker, PostgreSQL y Apache Superset. Se incluyen instrucciones detalladas para:

1. Levantar los servicios con Docker.
2. Configurar la conexión a la base de datos en Apache Superset.
3. Ejecutar consultas SQL para analizar los datos de los Servicios de normalización de direcciones y unidades territoriales de Argentina.
4. Crear gráficos y tableros interactivos para la visualización de datos.

---

## 🚀 Descripción del Proyecto

Este proyecto implementa un proceso ETL (Extract, Transform, Load) para la carga y análisis de datos relacionados con casos de los Servicios de normalización de direcciones y unidades territoriales de Argentina.

Se utilizan herramientas como Docker, PostgreSQL y Apache Superset para facilitar la gestión, análisis y visualización de datos.

El objetivo principal es proporcionar una solución escalable y reproducible para analizar datos de provincias, departamentos, localidades y calles, permitiendo la creación de tableros interactivos y gráficos personalizados.

---

## 🛠️ Requisitos Previos

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- Docker
- Docker Compose
- Navegador web para acceder a Apache Superset

---

## 🧩 Servicios Definidos en `docker-compose.yml`

El archivo `docker-compose.yml` define los siguientes servicios:

```yaml
db:
  image: postgres:alpine
  env_file:
    - .env.db
  restart: unless-stopped
  environment:
    - POSTGRES_INITDB_ARGS=--auth-host=md5 --auth-local=trust
  healthcheck:
    test: ["CMD-SHELL", "pg_isready"]
    interval: 10s
    timeout: 2s
    retries: 5
  ports:
    - 5439:5432
  volumes:
    - postgres-db:/var/lib/postgresql/data
    - ./initdb:/docker-entrypoint-initdb.d # Scripts que se ejecutan solo al iniciar el servidor por primera vez
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
      condition: service_healthy # Espera a que la base de datos esté lista
  networks:
    - net
# postgres-etl

---

## 📥 Descarga de Datasets

Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del gobierno de Argentina:

[https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Este portal proporciona información pública en formatos reutilizables, incluyendo datos relacionados con los Servicios de normalización de direcciones y unidades territoriales de Argentina.

---

## 📋 Resumen del Tutorial

Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando Docker, PostgreSQL y Apache Superset. Se incluyen instrucciones detalladas para:

1. Levantar los servicios con Docker.
2. Configurar la conexión a la base de datos en Apache Superset.
3. Ejecutar consultas SQL para analizar los datos de los Servicios de normalización de direcciones y unidades territoriales de Argentina.
4. Crear gráficos y tableros interactivos para la visualización de datos.

---

## 🚀 Descripción del Proyecto

Este proyecto implementa un proceso ETL (Extract, Transform, Load) para la carga y análisis de datos relacionados con casos de los Servicios de normalización de direcciones y unidades territoriales de Argentina.

Se utilizan herramientas como Docker, PostgreSQL y Apache Superset para facilitar la gestión, análisis y visualización de datos.

El objetivo principal es proporcionar una solución escalable y reproducible para analizar datos de provincias, departamentos, localidades y calles, permitiendo la creación de tableros interactivos y gráficos personalizados.

---

## 🛠️ Requisitos Previos

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- Docker
- Docker Compose
- Navegador web para acceder a Apache Superset

---

## 🧩 Servicios Definidos en `docker-compose.yml`

El archivo `docker-compose.yml` define los siguientes servicios:

```yaml
db:
  image: postgres:alpine
  env_file:
    - .env.db
  restart: unless-stopped
  environment:
    - POSTGRES_INITDB_ARGS=--auth-host=md5 --auth-local=trust
  healthcheck:
    test: ["CMD-SHELL", "pg_isready"]
    interval: 10s
    timeout: 2s
    retries: 5
  ports:
    - 5439:5432
  volumes:
    - postgres-db:/var/lib/postgresql/data
    - ./initdb:/docker-entrypoint-initdb.d # Scripts que se ejecutan solo al iniciar el servidor por primera vez
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
      condition: service_healthy # Espera a que la base de datos esté lista
  networks:
    - net
