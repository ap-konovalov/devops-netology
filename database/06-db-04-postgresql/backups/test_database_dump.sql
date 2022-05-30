--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-1.pgdg110+1)
-- Dumped by pg_dump version 13.7 (Debian 13.7-1.pgdg110+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE public.orders OWNER TO admin;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO admin;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders_less_than_500; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.orders_less_than_500 (
    CONSTRAINT orders_less_than_500_price_check CHECK ((price <= 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_less_than_500 OWNER TO admin;

--
-- Name: orders_more_than_499; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.orders_more_than_499 (
    CONSTRAINT orders_more_than_499_price_check CHECK ((price > 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_more_than_499 OWNER TO admin;

--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_less_than_500 id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders_less_than_500 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_less_than_500 price; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders_less_than_500 ALTER COLUMN price SET DEFAULT 0;


--
-- Name: orders_more_than_499 id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders_more_than_499 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_more_than_499 price; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders_more_than_499 ALTER COLUMN price SET DEFAULT 0;


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.orders (id, title, price) FROM stdin;
\.


--
-- Data for Name: orders_less_than_500; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.orders_less_than_500 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
7	Me and my bash-pet	499
\.


--
-- Data for Name: orders_more_than_499; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.orders_more_than_499 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
8	Dbiezdmin	501
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.orders_id_seq', 8, true);


--
-- Name: orders orders_pkey1; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey1 PRIMARY KEY (id);


--
-- Name: orders orders_less_than_500_insert; Type: RULE; Schema: public; Owner: admin
--

CREATE RULE orders_less_than_500_insert AS
    ON INSERT TO public.orders
   WHERE (new.price <= 499) DO INSTEAD  INSERT INTO public.orders_less_than_500 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- Name: orders orders_more_than_insert; Type: RULE; Schema: public; Owner: admin
--

CREATE RULE orders_more_than_insert AS
    ON INSERT TO public.orders
   WHERE (new.price > 499) DO INSTEAD  INSERT INTO public.orders_more_than_499 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- PostgreSQL database dump complete
--

