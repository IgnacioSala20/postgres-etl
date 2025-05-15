\c normalizador_territorial_ar


/*
Creo las tablas temporales para cargar los datos
*/
CREATE TEMPORARY TABLE temp_provincias (
    categoria VARCHAR,
    centroide_lat FLOAT,
    centroide_lon FLOAT,
    fuente VARCHAR,
    id BIGINT,
    iso_id VARCHAR,
    iso_nombre VARCHAR,
    nombre VARCHAR,
    nombre_completo VARCHAR
);

CREATE TEMPORARY TABLE temp_departamentos (
    categoria VARCHAR,
    centroide_lat FLOAT,
    centroide_lon FLOAT,
    fuente VARCHAR,
    id VARCHAR,
    nombre VARCHAR,
    nombre_completo VARCHAR,
    provincia_id VARCHAR,
    provincia_interseccion FLOAT,
    provincia_nombre VARCHAR
);
CREATE TEMPORARY TABLE temp_localidades (
    categoria VARCHAR,
    centroide_lat FLOAT,
    centroide_lon FLOAT,
    departamento_id VARCHAR,
    departamento_nombre VARCHAR,
    fuente VARCHAR,
    id VARCHAR,
    localidad_censal_id VARCHAR,
    localidad_censal_nombre VARCHAR,
    municipio_id VARCHAR NULL,
    municipio_nombre VARCHAR,
    nombre VARCHAR,
    provincia_id VARCHAR,
    provincia_nombre VARCHAR
);

CREATE TEMPORARY TABLE temp_calle (
    altura_fin_derecha BIGINT,
    altura_fin_izquierda BIGINT,
    altura_inicio_derecha BIGINT,
    altura_inicio_izquierda BIGINT,
    categoria VARCHAR (255),
    departamento_id VARCHAR (255),
    departamento_nombre VARCHAR (255),
    fuente VARCHAR (255),
    id VARCHAR (255),
    localidad_censal_id VARCHAR (255),
    localidad_censal_nombre VARCHAR (255),
    nombre VARCHAR (255),
    provincia_id VARCHAR (255),
    provincia_nombre VARCHAR (255)
);

COPY temp_provincias 
FROM '/superset/datos/provincias.csv' DELIMITER ',' CSV HEADER;

INSERT INTO public.provincias (
    id,
    nombre,
    iso_id,
    categoria
)
SELECT DISTINCT
    id::BIGINT,
    nombre,
    iso_id,
    categoria
FROM temp_provincias
WHERE id::BIGINT NOT IN (
    SELECT id::BIGINT
    FROM public.provincias
);

COPY temp_departamentos FROM '/superset/datos/departamentos.csv' DELIMITER ',' CSV HEADER;

INSERT INTO public.departamento (
    id_departamento,
    nombre_departamento,
    provincia_id
)
SELECT DISTINCT
    id::BIGINT,
    nombre,
    provincia_id::BIGINT
FROM temp_departamentos
WHERE id::BIGINT NOT IN (
    SELECT id::BIGINT
    FROM public.departamento
);

COPY temp_localidades FROM '/superset/datos/localidades.csv' DELIMITER ',' CSV HEADER;

INSERT INTO public.localidad (
    id_localidad_censal,
    nombre_localidad,
    departamento_id
)
SELECT DISTINCT
    id::BIGINT,
    nombre,
    departamento_id::BIGINT 
FROM temp_localidades
WHERE id::BIGINT NOT IN (
    SELECT id::BIGINT
    FROM public.localidad
);

COPY temp_calle FROM '/superset/datos/calles.csv' DELIMITER ',' CSV HEADER; 

INSERT INTO public.calle (
    id_calle,
    nombre_calle,
    altura_fin_derecha,
    altura_fin_izquierda,
    altura_inicio_derecha,
    altura_inicio_izquierda,
    categoria,
    localidad_censal_id
)   
SELECT DISTINCT
    id::BIGINT,
    nombre,
    altura_fin_derecha,
    altura_fin_izquierda,
    altura_inicio_derecha,
    altura_inicio_izquierda,
    categoria,
    localidad_censal_id::BIGINT
FROM temp_calle tc
WHERE EXISTS (
    SELECT 1
    FROM localidad l
    WHERE l.id_localidad_censal =  tc.localidad_censal_id::BIGINT
);


