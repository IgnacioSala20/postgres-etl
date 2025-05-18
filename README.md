# 📊 postgres-etl

Un proyecto ETL con Docker, PostgreSQL y Apache Superset para el análisis de datos geográficos de Argentina.
---

## 📥 Descarga de Datasets

Los datasets utilizados en este proyecto pueden descargarse desde la pagina oficial de datos abiertos del Gobierno de Argentina:

🔗 [https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Esta ruta proporciona información pública reutilizable, incluyendo datos relacionados con los **servicios de normalización de direcciones** y **unidades territoriales** de Argentina.

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
## ⚙️ Instrucciones de Configuración
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

4.Crear un usuario administrador en Superset(todo esto desde la terminal donde levantamos los servicios)

  - Inicializamos el usuario de superset
  
  Mismo comando para Windosw que Linux, si da error en windows, se utiliza el comando de abajo que se encuentra en una sola linea
  ```yaml
    docker compose exec -it superset superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin
  ```
O si lo queremos ejecutar en windows en una sola linea:
  ```yaml
    docker compose exec -it superset superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin
  ```
Migramos la base de datos
  ```yaml
    docker compose exec -it superset superset db upgrade
  ```
Por ultimo Seteamos los Roles
  ```yaml
    docker compose exec -it superset superset init
  ```
Ahora si estamos listos para acceder a nuestras herramienta!!!

5.Acceso a las herramientas
- Superset: http://localhost:8088
- Usuario por defecto generado: admin / admin
  
## 🚀 Uso del Proyecto

### 1. Conectar Superset con la base de datos

En Superset:

- Navega a **Settings > Database Connections**
- Haz clic en **+ Database**
- Completa los siguientes campos:
    ```yaml
    Host: db
    Puerto: 5432
    Base de datos: normalizador_territorial_ar
    Usuario: postgres
    Contraseña: postgres
  ```
asegúrate de que la conexión sea exitosa antes de continuar.

---

### 2. Cargar datasets

Una vez conectada la base de datos, puedes cargar tus datasets en las tablas de PostgreSQL.  
Asegúrate de que los datos se hayan cargado en las tablas de tu contenedor, para cargar los datos

- Dirigirse a Datasets --> + Dataset --> Seleccionar la base de datos
    - Seleccionamos public
    - Luego seleccionamos la tabla que cargaremos al Superset
---

### 3. Ejecutar consultas SQL

Desde Superset:

- Ve a **SQL Lab > SQL Editor**
- Elige la base de datos conectada, seleccionamos el schema publico y luego la tabla a utilizar
- Ejecuta una consulta, por ejemplo:

```sql
SELECT * FROM provincias;
```
💡 Reemplaza provincias por el nombre de la tabla que hayas cargado.

### Consultas para la Presentacion

Las consultas utilizadas para la presentacion seran:

1. La primer consulta devuelve la cantidad de localidades por cada departamento
```sql
SELECT departamento.nombre_departamento,
COUNT(*) as cantidad
FROM localidad 
JOIN departamento ON departamento.id_departamento = localidad.departamento_id
GROUP BY departamento.id_departamento
ORDER BY departamento.nombre_departamento;
```

2. La segunda consulta lo que devuelve son las localidades por departamento especifico que le digamos
```sql
SELECT localidad.nombre_localidad
FROM localidad 
JOIN departamento ON departamento.id_departamento = localidad.departamento_id
WHERE departamento.nombre_departamento = 'Unión'
ORDER BY localidad.nombre_localidad;
```

3. La tercer consulta devuelve la cantidad de calles por categoria que hay por cada provincia
```sql
SELECT 
  provincias.nombre AS provincia,
  CASE calle.categoria
    WHEN 'AV' THEN 'Avenida'
    WHEN 'BV' THEN 'Boulevard'
    WHEN 'CALLE' THEN 'Calle'
    WHEN 'CJON' THEN 'Callejón'
    WHEN 'CURSO DE AGUA' THEN 'Curso de agua'
    WHEN 'HUELLA' THEN 'Huella'
    WHEN 'LINEA FERREA' THEN 'Línea férrea'
    WHEN 'LINEA IMAGINARIA' THEN 'Línea imaginaria'
    WHEN 'PASAJE' THEN 'Pasaje'
    WHEN 'PEATONAL' THEN 'Peatonal'
    WHEN 'PJE' THEN 'Pasaje'
    WHEN 'RUTA' THEN 'Ruta'
    WHEN 'AUT' THEN 'Autopista'
    WHEN 'ACC' THEN 'Acceso'
  END AS tipo_calle,
  COUNT(*) AS cantidad
FROM calle
JOIN localidad ON localidad.id_localidad_censal = calle.localidad_censal_id 
JOIN departamento ON departamento.id_departamento = localidad.departamento_id
JOIN provincias ON provincias.id = departamento.provincia_id
WHERE calle.categoria IN (
  'AV', 'BV', 'CALLE', 'CJON', 'CURSO DE AGUA', 'HUELLA', 
  'LINEA FERREA', 'LINEA IMAGINARIA', 'PASAJE', 'PEATONAL', 
  'PJE', 'RUTA', 'AUT', 'ACC'
)
GROUP BY provincias.nombre, tipo_calle
ORDER BY provincias.nombre, tipo_calle;
```

¡¡¡ Algo que podemos hacer es guardar estas consultas como dataset (tabla virtual) de forma que nos generen los graficos correspondientes a la consulta o sino luego generarlo desde Charts!!!

### 4. Crear gráficos y dashboards

- Accede a la sección **Charts**
- Haz clic en **+ Chart**
- Selecciona el dataset que desees utilizar
- Configura:
  - Tipo de gráfico
  - Ejes
  - Métricas
  - Filtros (opcional)

Luego, agrupa tus gráficos en un **Dashboard** desde la sección correspondiente.
---




