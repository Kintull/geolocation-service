--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6
-- Dumped by pg_dump version 15.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: geolocations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geolocations (
    id bigint NOT NULL,
    ip_address character varying(16),
    country_code character varying(2),
    country character varying(100),
    city character varying(40),
    latitude character varying(20),
    longitude character varying(20),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: geolocations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geolocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geolocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geolocations_id_seq OWNED BY public.geolocations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: geolocations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geolocations ALTER COLUMN id SET DEFAULT nextval('public.geolocations_id_seq'::regclass);


--
-- Name: geolocations geolocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geolocations
    ADD CONSTRAINT geolocations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: geolocations_ip_address_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX geolocations_ip_address_index ON public.geolocations USING btree (ip_address);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20230915121901);
INSERT INTO public."schema_migrations" (version) VALUES (20230918083952);
