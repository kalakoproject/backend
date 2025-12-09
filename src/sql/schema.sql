--
-- PostgreSQL database dump
--

\restrict pacgLgnysKFjgw3E4riUtDsTYRIxiP15PFrQzPjxn9LvOSENFnk2C6LpmekpqJI

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-09 09:47:03

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
-- TOC entry 215 (class 1259 OID 18065)
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    owner_name character varying(255) NOT NULL,
    owner_id_number character varying(50),
    address text,
    phone character varying(30) NOT NULL,
    email character varying(255),
    subdomain character varying(100) NOT NULL,
    status character varying(20) DEFAULT 'trial'::character varying,
    trial_ends_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    city character varying(100),
    district character varying(100),
    sub_district character varying(100),
    province character varying(100),
    store_photo_url text
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 18064)
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO postgres;

--
-- TOC entry 3450 (class 0 OID 0)
-- Dependencies: 214
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 233 (class 1259 OID 18594)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    client_id bigint,
    name character varying(150),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 18593)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 232
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 219 (class 1259 OID 18098)
-- Name: email_otp_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_otp_codes (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    otp character varying(6) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.email_otp_codes OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18097)
-- Name: email_otp_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_otp_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_otp_codes_id_seq OWNER TO postgres;

--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 218
-- Name: email_otp_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_otp_codes_id_seq OWNED BY public.email_otp_codes.id;


--
-- TOC entry 223 (class 1259 OID 18121)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    client_id bigint,
    subscription_id bigint,
    amount numeric(15,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT now() NOT NULL,
    method character varying(50),
    status character varying(20) DEFAULT 'success'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18120)
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO postgres;

--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 222
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- TOC entry 225 (class 1259 OID 18526)
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    id bigint NOT NULL,
    client_id bigint,
    name character varying(100) NOT NULL
);


ALTER TABLE public.product_categories OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18525)
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_categories_id_seq OWNER TO postgres;

--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 224
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.product_categories.id;


--
-- TOC entry 227 (class 1259 OID 18538)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    client_id bigint,
    name character varying(150) NOT NULL,
    selling_price numeric(15,2) DEFAULT 0 NOT NULL,
    stock numeric(15,3) DEFAULT 0 NOT NULL,
    unit character varying(20) DEFAULT 'PCS'::character varying NOT NULL,
    category_id bigint,
    expiry_date date,
    last_out_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 18537)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- TOC entry 3455 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 231 (class 1259 OID 18577)
-- Name: sales_transaction_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_transaction_items (
    id bigint NOT NULL,
    transaction_id bigint,
    product_id bigint,
    quantity numeric(15,3) NOT NULL,
    unit_price numeric(15,2) NOT NULL,
    subtotal numeric(15,2) NOT NULL
);


ALTER TABLE public.sales_transaction_items OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 18576)
-- Name: sales_transaction_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_transaction_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_transaction_items_id_seq OWNER TO postgres;

--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 230
-- Name: sales_transaction_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_transaction_items_id_seq OWNED BY public.sales_transaction_items.id;


--
-- TOC entry 229 (class 1259 OID 18559)
-- Name: sales_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_transactions (
    id bigint NOT NULL,
    client_id bigint,
    cashier_id bigint,
    total_amount numeric(15,2) NOT NULL,
    paid_amount numeric(15,2) NOT NULL,
    change_amount numeric(15,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sales_transactions OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 18558)
-- Name: sales_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_transactions_id_seq OWNER TO postgres;

--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 228
-- Name: sales_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_transactions_id_seq OWNED BY public.sales_transactions.id;


--
-- TOC entry 221 (class 1259 OID 18106)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    client_id bigint,
    plan_name character varying(100) NOT NULL,
    price_per_period numeric(15,2) NOT NULL,
    billing_period character varying(20) NOT NULL,
    next_billing_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18105)
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO postgres;

--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 220
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- TOC entry 217 (class 1259 OID 18079)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    client_id bigint,
    name character varying(255) NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18078)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3218 (class 2604 OID 18068)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 18597)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 18101)
-- Name: email_otp_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_otp_codes ALTER COLUMN id SET DEFAULT nextval('public.email_otp_codes_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 18124)
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 18529)
-- Name: product_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- TOC entry 3237 (class 2604 OID 18541)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 18580)
-- Name: sales_transaction_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items ALTER COLUMN id SET DEFAULT nextval('public.sales_transaction_items_id_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 18562)
-- Name: sales_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions ALTER COLUMN id SET DEFAULT nextval('public.sales_transactions_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 18109)
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 18082)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3426 (class 0 OID 18065)
-- Dependencies: 215
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, owner_name, owner_id_number, address, phone, email, subdomain, status, trial_ends_at, created_at, updated_at, city, district, sub_district, province, store_photo_url) FROM stdin;
3	toko maju	Rahmat	3573011307060001	Jl. Mencintaimu	082334553192	raihan.ts16b@gmail.com	toko-maju	trial	2025-12-17 14:22:21.76085	2025-12-03 14:22:21.76085	2025-12-03 14:22:21.76085	Kota Malang	Blimbing	Purwodadi	Jawa Timur	/uploads/store_photos/1764746538914_youtube_20181017_090334.webp
4	sehatsejahtera	Baruna	3455511112233	Jl. Sumpi 1 no 33	08222222	rey130706@gmail.com	sehatsejahtera	trial	2025-12-22 08:14:35.314292	2025-12-08 08:14:35.314292	2025-12-08 08:14:35.314292	Kota Malang	Blimbing	Purwodadi	Jawa Timur	/uploads/store_photos/1765156429136_Logo-Compilation-Grid.png
\.


--
-- TOC entry 3444 (class 0 OID 18594)
-- Dependencies: 233
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, client_id, name, phone, created_at) FROM stdin;
\.


--
-- TOC entry 3430 (class 0 OID 18098)
-- Dependencies: 219
-- Data for Name: email_otp_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_otp_codes (id, email, otp, expires_at, created_at) FROM stdin;
\.


--
-- TOC entry 3434 (class 0 OID 18121)
-- Dependencies: 223
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, client_id, subscription_id, amount, payment_date, method, status, created_at) FROM stdin;
\.


--
-- TOC entry 3436 (class 0 OID 18526)
-- Dependencies: 225
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_categories (id, client_id, name) FROM stdin;
2	3	Makanan
3	4	Makanan
\.


--
-- TOC entry 3438 (class 0 OID 18538)
-- Dependencies: 227
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, client_id, name, selling_price, stock, unit, category_id, expiry_date, last_out_at, created_at, updated_at) FROM stdin;
1	\N	Test	1000.00	0.000	pcs	\N	\N	\N	2025-12-08 11:01:36.42605	\N
5	\N	Indomie Goreng Rendang	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:06:39.756787	\N
6	\N	Indomie Goreng Ayam Kecap	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:13:56.375583	\N
7	\N	Indomie Goreng Ayam Kecap	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:15:24.294479	\N
10	3	Indomie Goreng Ayam Kecap	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:17:57.875956	\N
11	3	Indomie Goreng Ayam o	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:19:01.344709	\N
12	3	Indomie Goreng Ayam o	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:20:12.435183	\N
14	4	Mie telor	2000.00	20.000	PCS	3	2025-12-24	\N	2025-12-08 12:51:38.596397	\N
15	4	Ayam	2000.00	5.000	PCS	3	2026-02-19	\N	2025-12-08 12:52:02.759487	\N
13	4	Indomie	5000.00	1997.000	PCS	3	2026-01-22	2025-12-08 12:52:29.591814	2025-12-08 12:51:12.655807	\N
16	4	beras	2000.00	4.500	KG	3	2025-12-31	2025-12-08 12:53:51.91588	2025-12-08 12:53:11.903891	\N
8	3	Indomie Goreng Ayam Kecap	3200.00	14.000	pcs	2	2025-11-30	2025-12-09 07:10:52.577434	2025-12-08 11:15:51.743619	\N
17	3	indomie	3000.00	0.000	KG	2	2025-12-12	2025-12-09 07:20:55.416199	2025-12-09 07:16:44.872378	\N
9	3	Indomie Goreng Ayam Kecap	3200.00	17.000	pcs	2	2025-11-30	2025-12-09 07:20:55.416199	2025-12-08 11:16:43.559248	\N
\.


--
-- TOC entry 3442 (class 0 OID 18577)
-- Dependencies: 231
-- Data for Name: sales_transaction_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_transaction_items (id, transaction_id, product_id, quantity, unit_price, subtotal) FROM stdin;
1	1	8	2.000	3200.00	6400.00
2	2	13	3.000	5000.00	15000.00
3	3	16	0.500	2000.00	1000.00
4	4	8	4.000	3200.00	12800.00
5	5	17	0.020	3000.00	60.00
6	5	9	3.000	3200.00	9600.00
\.


--
-- TOC entry 3440 (class 0 OID 18559)
-- Dependencies: 229
-- Data for Name: sales_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_transactions (id, client_id, cashier_id, total_amount, paid_amount, change_amount, created_at) FROM stdin;
1	3	4	6400.00	200000.00	193600.00	2025-12-08 11:29:28.568691
2	4	5	15000.00	100000.00	85000.00	2025-12-08 12:52:29.591814
3	4	5	1000.00	1000.00	0.00	2025-12-08 12:53:51.91588
4	3	4	12800.00	50000.00	37200.00	2025-12-09 07:10:52.577434
5	3	4	9660.00	10000.00	340.00	2025-12-09 07:20:55.416199
\.


--
-- TOC entry 3432 (class 0 OID 18106)
-- Dependencies: 221
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, client_id, plan_name, price_per_period, billing_period, next_billing_date, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3428 (class 0 OID 18079)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, client_id, name, username, password_hash, role, is_active, created_at, updated_at) FROM stdin;
1	\N	Admin Kalako	superadmin	$2a$10$AdUy8zEfjBm4z8WxA0RduuHQiiv/qbiP6vS2W/bgFpOCkksYSwNTe	super_admin	t	2025-11-30 21:35:51.808884	2025-11-30 21:35:51.808884
4	3	Rahmat	admin	$2a$10$yQY4ZGjst0zBf/kbUUObdeV9eYm1CzIKSwZUe/YnjQqbrumClK.B2	client_admin	t	2025-12-03 14:22:21.76085	2025-12-03 14:22:21.76085
5	4	Baruna	manda	$2a$10$4nf5A9n61Acd6QlZg/tFjOI8piC6gvxHY0eLq/qUYBcdpt7epHUuC	client_admin	t	2025-12-08 08:14:35.314292	2025-12-08 08:14:35.314292
\.


--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 214
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 4, true);


--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 232
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 218
-- Name: email_otp_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_otp_codes_id_seq', 10, true);


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 222
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 224
-- Name: product_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_categories_id_seq', 3, true);


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 17, true);


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 230
-- Name: sales_transaction_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_transaction_items_id_seq', 6, true);


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 228
-- Name: sales_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_transactions_id_seq', 5, true);


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 220
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 1, false);


--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- TOC entry 3248 (class 2606 OID 18075)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 18077)
-- Name: clients clients_subdomain_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_subdomain_key UNIQUE (subdomain);


--
-- TOC entry 3270 (class 2606 OID 18600)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3256 (class 2606 OID 18104)
-- Name: email_otp_codes email_otp_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_otp_codes
    ADD CONSTRAINT email_otp_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 3260 (class 2606 OID 18129)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3262 (class 2606 OID 18531)
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3264 (class 2606 OID 18547)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3268 (class 2606 OID 18582)
-- Name: sales_transaction_items sales_transaction_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3266 (class 2606 OID 18565)
-- Name: sales_transactions sales_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 18114)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 3252 (class 2606 OID 18089)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3254 (class 2606 OID 18091)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3282 (class 2606 OID 18601)
-- Name: customers customers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3273 (class 2606 OID 18130)
-- Name: payments payments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3274 (class 2606 OID 18135)
-- Name: payments payments_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id);


--
-- TOC entry 3275 (class 2606 OID 18532)
-- Name: product_categories product_categories_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3276 (class 2606 OID 18553)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- TOC entry 3277 (class 2606 OID 18548)
-- Name: products products_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3280 (class 2606 OID 18588)
-- Name: sales_transaction_items sales_transaction_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3281 (class 2606 OID 18583)
-- Name: sales_transaction_items sales_transaction_items_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.sales_transactions(id) ON DELETE CASCADE;


--
-- TOC entry 3278 (class 2606 OID 18571)
-- Name: sales_transactions sales_transactions_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id);


--
-- TOC entry 3279 (class 2606 OID 18566)
-- Name: sales_transactions sales_transactions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3272 (class 2606 OID 18115)
-- Name: subscriptions subscriptions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3271 (class 2606 OID 18092)
-- Name: users users_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


-- Completed on 2025-12-09 09:47:03

--
-- PostgreSQL database dump complete
--

\unrestrict pacgLgnysKFjgw3E4riUtDsTYRIxiP15PFrQzPjxn9LvOSENFnk2C6LpmekpqJI

