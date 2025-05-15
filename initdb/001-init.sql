
CREATE DATABASE normalizador_territorial_ar;
\c normalizador_territorial_ar
DROP TABLE IF EXISTS public.provincia;

DROP TABLE IF EXISTS public.departamento;
DROP TABLE IF EXISTS public.localidad;
DROP TABLE IF EXISTS public.calle;

CREATE TABLE public.provincias(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR ,
    iso_id VARCHAR ,
    categoria VARCHAR
);
CREATE TABLE public.departamento (
    id_departamento BIGINT PRIMARY KEY,
    nombre_departamento VARCHAR ,
    provincia_id BIGINT,
    FOREIGN KEY (provincia_id) REFERENCES provincias(id)
);

CREATE TABLE public.localidad (
    id_localidad_censal BIGINT PRIMARY KEY,
    nombre_localidad VARCHAR ,
    departamento_id BIGINT,
    FOREIGN KEY (departamento_id) REFERENCES departamento(id_departamento)
);

CREATE TABLE public.calle (
    id_calle BIGINT PRIMARY KEY,
    nombre_calle VARCHAR ,
    altura_fin_derecha BIGINT,
    altura_fin_izquierda BIGINT,
    altura_inicio_derecha BIGINT,
    altura_inicio_izquierda BIGINT,
    categoria VARCHAR ,
    localidad_censal_id BIGINT,
    FOREIGN KEY (localidad_censal_id) REFERENCES localidad(id_localidad_censal)
);

