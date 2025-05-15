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
## ⚙️ Instrucciones de Configuración

### Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd postgres-etl
Configurar el archivo .env.db
Crea un archivo .env.db en la raíz del proyecto con las siguientes variables de entorno:

env
Copiar
Editar
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_NAME=postgres
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=trust"
POSTGRES_PASSWORD=${DATABASE_PASSWORD}
PGUSER=${DATABASE_USER}
SUPERSET_SECRET_KEY=your_secret_key_here
Levantar los servicios
bash
Copiar
Editar
docker compose up -d
Acceso a Apache Superset
URL: http://localhost:8088/

Credenciales predeterminadas: admin/admin

Crear usuario administrador para Apache Superset
bash
Copiar
Editar
docker exec -it superset-superset-1 superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@superset.com \
  --password admin
Eliminar usuario administrador (opcional)
bash
Copiar
Editar
docker exec -it superset-superset-1 superset fab delete-user --username admin
📊 Uso del Proyecto
1. Configuración de la Base de Datos
Accede a Apache Superset.

Crea una conexión a la base de datos PostgreSQL en la sección Settings.

Usa los siguientes datos para la conexión:

Parámetro	Valor
Host	db
Puerto	5432
Nombre de la BD	postgres
Usuario	postgres
Contraseña	postgres

2. Carga de Datasets
Carga los datasets desde la sección correspondiente para poder realizar gráficos y análisis.

3. Consultas SQL
Utiliza la terminal SQL Lab de Superset para ejecutar consultas sobre los datos cargados y explorar la información.

Ejemplo de consulta SQL:
Aquí puedes agregar ejemplos de consultas que sean relevantes para el análisis.

4. Creación de Gráficos y Tableros
Crea gráficos nuevos en Superset.

Configura cada gráfico con la consulta o dataset adecuado.

Combina los gráficos en tableros interactivos para facilitar el análisis visual.

sql
Copiar
Editar

¿Quieres que te prepare también un ejemplo concreto de consulta SQL para añadir?






Dijiste:
pero hazto todo en uno mismo, asi copio y pego tyodo


ChatGPT dijo:
Por supuesto, aquí tienes todo junto y listo para copiar y pegar en tu README.md:

markdown
Copiar
Editar
## ⚙️ Instrucciones de Configuración

### Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd postgres-etl
Configurar el archivo .env.db
Crea un archivo .env.db en la raíz del proyecto con las siguientes variables de entorno:

env
Copiar
Editar
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_NAME=postgres
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=trust"
POSTGRES_PASSWORD=${DATABASE_PASSWORD}
PGUSER=${DATABASE_USER}
SUPERSET_SECRET_KEY=your_secret_key_here
Levantar los servicios
bash
Copiar
Editar
docker compose up -d
Acceso a Apache Superset
URL: http://localhost:8088/

Credenciales predeterminadas: admin/admin

Crear usuario administrador para Apache Superset
bash
Copiar
Editar
docker exec -it superset-superset-1 superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@superset.com \
  --password admin
Eliminar usuario administrador (opcional)
bash
Copiar
Editar
docker exec -it superset-superset-1 superset fab delete-user --username admin
📊 Uso del Proyecto
1. Configuración de la Base de Datos
Accede a Apache Superset.

Crea una conexión a la base de datos PostgreSQL en la sección Settings.

Usa los siguientes datos para la conexión:

Parámetro	Valor
Host	db
Puerto	5432
Nombre de la BD	postgres
Usuario	postgres
Contraseña	postgres

2. Carga de Datasets
Carga los datasets desde la sección correspondiente para poder realizar gráficos y análisis.

3. Consultas SQL
Utiliza la terminal SQL Lab de Superset para ejecutar consultas sobre los datos cargados y explorar la información.

Ejemplo de consulta SQL:
Aquí puedes agregar ejemplos de consultas que sean relevantes para el análisis.

4. Creación de Gráficos y Tableros
Crea gráficos nuevos en Superset.

Configura cada gráfico con la consulta o dataset adecuado.

Combina los gráficos en tableros interactivos para facilitar el análisis visual.

