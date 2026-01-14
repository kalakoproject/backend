--
-- PostgreSQL database dump
--

\restrict SLtD52pxgNA7aGQ8nMlvNjhaEg0KjNpK6FK2yXbBTW2HUovP0LAZm3m47V6hNoZ

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)

-- Started on 2026-01-13 09:06:21 WIB

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
-- TOC entry 209 (class 1259 OID 16385)
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
    store_photo_url text,
    suspended_at timestamp without time zone,
    suspension_reason character varying(255)
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16393)
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
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 210
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 211 (class 1259 OID 16394)
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
-- TOC entry 212 (class 1259 OID 16398)
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
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 212
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 213 (class 1259 OID 16399)
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
-- TOC entry 214 (class 1259 OID 16403)
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
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 214
-- Name: email_otp_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_otp_codes_id_seq OWNED BY public.email_otp_codes.id;


--
-- TOC entry 215 (class 1259 OID 16404)
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
    created_at timestamp without time zone DEFAULT now(),
    proof_url text,
    proof_uploaded_at timestamp without time zone,
    reviewed_by bigint,
    reviewed_at timestamp without time zone,
    review_note text
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16410)
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
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 216
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- TOC entry 228 (class 1259 OID 24738)
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    id bigint NOT NULL,
    client_id bigint,
    name character varying(100) NOT NULL
);


ALTER TABLE public.product_categories OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24737)
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
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 227
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.product_categories.id;


--
-- TOC entry 217 (class 1259 OID 16415)
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
-- TOC entry 218 (class 1259 OID 16422)
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
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 219 (class 1259 OID 16423)
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
-- TOC entry 220 (class 1259 OID 16426)
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
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 220
-- Name: sales_transaction_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_transaction_items_id_seq OWNED BY public.sales_transaction_items.id;


--
-- TOC entry 221 (class 1259 OID 16427)
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
-- TOC entry 222 (class 1259 OID 16431)
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
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 222
-- Name: sales_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_transactions_id_seq OWNED BY public.sales_transactions.id;


--
-- TOC entry 223 (class 1259 OID 16432)
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
-- TOC entry 224 (class 1259 OID 16438)
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
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 224
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- TOC entry 225 (class 1259 OID 16439)
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
-- TOC entry 226 (class 1259 OID 16447)
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
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 226
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3255 (class 2604 OID 16448)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 3257 (class 2604 OID 16449)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3259 (class 2604 OID 16450)
-- Name: email_otp_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_otp_codes ALTER COLUMN id SET DEFAULT nextval('public.email_otp_codes_id_seq'::regclass);


--
-- TOC entry 3263 (class 2604 OID 16451)
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 24741)
-- Name: product_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- TOC entry 3268 (class 2604 OID 16453)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3269 (class 2604 OID 16454)
-- Name: sales_transaction_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items ALTER COLUMN id SET DEFAULT nextval('public.sales_transaction_items_id_seq'::regclass);


--
-- TOC entry 3271 (class 2604 OID 16455)
-- Name: sales_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions ALTER COLUMN id SET DEFAULT nextval('public.sales_transactions_id_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 16456)
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 16457)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3460 (class 0 OID 16385)
-- Dependencies: 209
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, owner_name, owner_id_number, address, phone, email, subdomain, status, trial_ends_at, created_at, updated_at, city, district, sub_district, province, store_photo_url, suspended_at, suspension_reason) FROM stdin;
4	sehatsejahtera	Baruna	3455511112233	Jl. Sumpi 1 no 33	08222222	rey130706@gmail.com	sehatsejahtera	active	2026-01-30 14:06:57.067981	2025-12-08 08:14:35.314292	2025-12-08 08:14:35.314292	Kota Malang	Blimbing	Purwodadi	Jawa Timur	/uploads/store_photos/1765156429136_Logo-Compilation-Grid.png	\N	\N
7	Toko Sumpil Mundur Seribu Tahun	King Reyhan	\N	Jl. Kehidupan	082334553192	mastersaberluke@gmail.com	toko-sumpil-mundur-seribu-tahun	trial	2026-01-19 14:47:10.844026	2026-01-05 14:47:10.844026	2026-01-05 14:47:10.844026	Malang	Sumpil	Sumpil	Jakarta	\N	\N	\N
8	Maju Bersama	Aji	3511111111111	Mayang	081286900593	aji.candra.l.cfs@gmail.com	maju-bersama	trial	2026-01-19 15:09:20.459418	2026-01-05 15:09:20.459418	2026-01-05 15:09:20.459418	Malang	Blimbing	Bunulrejo	JAWA TIMUR	/uploads/store_photos/1767600558753_1000747181.jpg	\N	\N
5	test	barunskuy	\N	Jl. Banyuputih 07	0813 3354 6332	kalako.pro@gmail.com	test	active	2026-02-05 14:09:31.757779	2025-12-29 14:19:49.714033	2025-12-29 14:19:49.714033	Malang	ok	ok	Jawa Timur — East Java	\N	\N	\N
6	Berkah Jaya	atus	\N	Jln. Lombok Bamban	082141342998	slnikmatus@gmail.com	berkah-jaya	suspended	2026-01-12 14:45:05.898578	2025-12-29 14:45:05.898578	2025-12-29 14:45:05.898578	Malang	Asrikaton	Pakis	Jawa Timur	/uploads/store_photos/1766994303350_logo__2___1_-removebg-preview.png	2026-01-13 00:01:00.028874	Trial period expired
3	toko maju	Rahmat	3573011307060001	Jl. Mencintaimu	082334553192	raihan.ts16b@gmail.com	toko-maju	active	2026-01-13 09:09:21.76085	2025-12-03 14:22:21.76085	2025-12-03 14:22:21.76085	Kota Malang	Blimbing	Purwodadi	Jawa Timur	/uploads/store_photos/1764746538914_youtube_20181017_090334.webp	\N	\N
\.


--
-- TOC entry 3462 (class 0 OID 16394)
-- Dependencies: 211
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, client_id, name, phone, created_at) FROM stdin;
\.


--
-- TOC entry 3464 (class 0 OID 16399)
-- Dependencies: 213
-- Data for Name: email_otp_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_otp_codes (id, email, otp, expires_at, created_at) FROM stdin;
13	kontol@gmail.com	285741	2025-12-29 15:31:54.473	2025-12-29 15:26:54.474097
\.


--
-- TOC entry 3466 (class 0 OID 16404)
-- Dependencies: 215
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, client_id, subscription_id, amount, payment_date, method, status, created_at, proof_url, proof_uploaded_at, reviewed_by, reviewed_at, review_note) FROM stdin;
1	3	\N	100000.00	2025-12-31 13:26:14.368	bank_transfer	success	2025-12-31 13:26:14.369098	/uploads/store_photos/1767162371952_Screenshot_from_2025-12-31_12-57-03.png	2025-12-31 13:26:14.368	1	2025-12-31 13:34:54.312	\N
2	3	\N	100000.00	2025-12-31 14:03:23.098	bank_transfer	success	2025-12-31 14:03:23.098791	/uploads/store_photos/1767164597853_Screenshot_from_2025-12-31_13-42-57.png	2025-12-31 14:03:23.098	1	2025-12-31 14:03:30.926	\N
3	4	\N	1000000.00	2025-12-31 14:06:48.703	bank_transfer	success	2025-12-31 14:06:48.703838	/uploads/store_photos/1767164807047_Screenshot_from_2025-12-31_13-32-48.png	2025-12-31 14:06:48.703	1	2025-12-31 14:06:57.061	\N
4	5	\N	100000.00	2026-01-06 14:08:57.778	bank_transfer	success	2026-01-06 14:08:57.778898	/uploads/store_photos/1767683336228_Logo.png	2026-01-06 14:08:57.778	1	2026-01-06 14:09:31.744	ok
\.


--
-- TOC entry 3479 (class 0 OID 24738)
-- Dependencies: 228
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_categories (id, client_id, name) FROM stdin;
1	7	Makanan
\.


--
-- TOC entry 3468 (class 0 OID 16415)
-- Dependencies: 217
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, client_id, name, selling_price, stock, unit, category_id, expiry_date, last_out_at, created_at, updated_at) FROM stdin;
1	\N	Test	1000.00	0.000	pcs	\N	\N	\N	2025-12-08 11:01:36.42605	\N
5	\N	Indomie Goreng Rendang	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:06:39.756787	\N
6	\N	Indomie Goreng Ayam Kecap	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:13:56.375583	\N
7	\N	Indomie Goreng Ayam Kecap	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:15:24.294479	\N
11	3	Indomie Goreng Ayam o	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:19:01.344709	\N
12	3	Indomie Goreng Ayam o	3200.00	20.000	pcs	2	2025-11-30	\N	2025-12-08 11:20:12.435183	\N
14	4	Mie telor	2000.00	20.000	PCS	3	2025-12-24	\N	2025-12-08 12:51:38.596397	\N
15	4	Ayam	2000.00	5.000	PCS	3	2026-02-19	\N	2025-12-08 12:52:02.759487	\N
13	4	Indomie	5000.00	1997.000	PCS	3	2026-01-22	2025-12-08 12:52:29.591814	2025-12-08 12:51:12.655807	\N
16	4	beras	2000.00	4.500	KG	3	2025-12-31	2025-12-08 12:53:51.91588	2025-12-08 12:53:11.903891	\N
18	5	dsad	12000.00	3.000	PCS	4	2025-12-15	2025-12-29 14:23:50.642591	2025-12-29 14:23:31.737069	\N
10	3	Indomie Goreng Ayam Kecap	3200.00	19.000	pcs	2	2025-11-30	2025-12-29 16:58:22.789973	2025-12-08 11:17:57.875956	\N
9	3	Indomie Goreng Ayam Kecap	3200.00	16.000	pcs	2	2025-11-30	2026-01-05 08:42:14.300709	2025-12-08 11:16:43.559248	\N
19	3	Mie King Reyhan	3000.00	10.000	PCS	2	\N	\N	2026-01-05 08:46:02.738046	\N
8	3	Indomie Goreng Ayam Kecap	3200.00	12.000	pcs	2	2025-11-30	2026-01-05 14:31:37.139134	2025-12-08 11:15:51.743619	\N
20	3	minyak	1000.00	20.000	L	5	\N	\N	2026-01-05 14:37:13.903167	\N
21	8	Mie	3500.00	2.000	PCS	6	2026-01-20	2026-01-05 15:11:23.687354	2026-01-05 15:10:48.27555	\N
17	3	indomie	3000.00	10.000	PCS	2	\N	2026-01-06 09:24:50.869587	2025-12-09 07:16:44.872378	\N
22	7	Mi Rehan	1000000.00	19.000	PCS	7	\N	2026-01-06 09:31:31.845539	2026-01-06 09:31:05.088069	\N
23	7	Bakso Pentol Rehan	2000000.00	998.000	PCS	7	\N	2026-01-06 09:47:20.967233	2026-01-06 09:46:36.912044	\N
25	7	Manuk Emprit Goreng King Rehan	1000000.00	1000.000	PCS	1	\N	\N	2026-01-08 14:45:28.458899	\N
\.


--
-- TOC entry 3470 (class 0 OID 16423)
-- Dependencies: 219
-- Data for Name: sales_transaction_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_transaction_items (id, transaction_id, product_id, quantity, unit_price, subtotal) FROM stdin;
1	1	8	2.000	3200.00	6400.00
2	2	13	3.000	5000.00	15000.00
3	3	16	0.500	2000.00	1000.00
4	4	8	4.000	3200.00	12800.00
5	5	17	0.020	3000.00	60.00
6	5	9	3.000	3200.00	9600.00
7	6	18	1.000	12000.00	12000.00
8	7	10	1.000	3200.00	3200.00
9	8	8	1.000	3200.00	3200.00
10	9	9	1.000	3200.00	3200.00
11	10	8	1.000	3200.00	3200.00
12	11	21	8.000	3500.00	28000.00
13	12	17	1.000	3000.00	3000.00
14	13	17	1.000	3000.00	3000.00
15	14	22	1.000	1000000.00	1000000.00
16	15	23	1.000	2000000.00	2000000.00
17	16	23	1.000	2000000.00	2000000.00
\.


--
-- TOC entry 3472 (class 0 OID 16427)
-- Dependencies: 221
-- Data for Name: sales_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_transactions (id, client_id, cashier_id, total_amount, paid_amount, change_amount, created_at) FROM stdin;
1	3	4	6400.00	200000.00	193600.00	2025-12-08 11:29:28.568691
2	4	5	15000.00	100000.00	85000.00	2025-12-08 12:52:29.591814
3	4	5	1000.00	1000.00	0.00	2025-12-08 12:53:51.91588
4	3	4	12800.00	50000.00	37200.00	2025-12-09 07:10:52.577434
5	3	4	9660.00	10000.00	340.00	2025-12-09 07:20:55.416199
6	5	6	12000.00	12000.00	0.00	2025-12-29 14:23:50.642591
7	3	4	3200.00	5000.00	1800.00	2025-12-29 16:58:22.789973
8	3	4	3200.00	5000.00	1800.00	2025-12-29 23:18:31.055741
9	3	4	3200.00	3200.00	0.00	2026-01-05 08:42:14.300709
10	3	4	3200.00	4000.00	800.00	2026-01-05 14:31:37.139134
11	8	9	28000.00	50000.00	22000.00	2026-01-05 15:11:23.687354
12	3	4	3000.00	3000.00	0.00	2026-01-05 20:49:27.277384
13	3	4	3000.00	3000.00	0.00	2026-01-06 09:24:50.869587
14	7	8	1000000.00	1000000.00	0.00	2026-01-06 09:31:31.845539
15	7	8	2000000.00	2000000.00	0.00	2026-01-06 09:46:57.478299
16	7	8	2000000.00	3000000.00	1000000.00	2026-01-06 09:47:20.967233
\.


--
-- TOC entry 3474 (class 0 OID 16432)
-- Dependencies: 223
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, client_id, plan_name, price_per_period, billing_period, next_billing_date, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3476 (class 0 OID 16439)
-- Dependencies: 225
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, client_id, name, username, password_hash, role, is_active, created_at, updated_at) FROM stdin;
5	4	Baruna	manda	$2a$10$4nf5A9n61Acd6QlZg/tFjOI8piC6gvxHY0eLq/qUYBcdpt7epHUuC	client_admin	t	2025-12-08 08:14:35.314292	2025-12-08 08:14:35.314292
7	6	atus	atus	$2a$10$Js/VepccRuUPlCcpTQtizem0q70774Qetk/adovYL37v25q02Ci.q	client_admin	t	2025-12-29 14:45:05.898578	2025-12-29 14:45:05.898578
1	\N	Admin Kalako	superadmin	$2a$12$biFJXCt2vulY3he0R8CylubAkhXJRnopiS6GJfK81PfQAUs6/dh9K	super_admin	t	2025-11-30 21:35:51.808884	2025-11-30 21:35:51.808884
9	8	Aji	Aji	$2a$10$N9lVIMeyhCcISVEJ3rB0tu4eIBoYB0H/HmMRuooV.B5rm7dEzkdAa	client_admin	t	2026-01-05 15:09:20.459418	2026-01-05 15:09:20.459418
6	5	barunskuy	admin	$2a$12$biFJXCt2vulY3he0R8CylubAkhXJRnopiS6GJfK81PfQAUs6/dh9K	client_admin	t	2025-12-29 14:19:49.714033	2025-12-29 14:19:49.714033
4	3	Rahmat	admin	$2a$10$PyJ2eK7zRWWS38LBDCwTgOVMvteKYpSHoYKPP492NaPWCd9RP3wdC	client_admin	t	2025-12-03 14:22:21.76085	2025-12-03 14:22:21.76085
8	7	King Reyhan	rehantampan	$2a$10$mozLYWpt5zGGLHDNiNUmkOL8M16.WipJ/l2rxCY3.0lwyaX432sXK	client_admin	t	2026-01-05 14:47:10.844026	2026-01-05 14:47:10.844026
\.


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 210
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 8, true);


--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 212
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 214
-- Name: email_otp_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_otp_codes_id_seq', 18, true);


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 216
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 4, true);


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 227
-- Name: product_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_categories_id_seq', 1, true);


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 25, true);


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 220
-- Name: sales_transaction_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_transaction_items_id_seq', 17, true);


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 222
-- Name: sales_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_transactions_id_seq', 16, true);


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 224
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 1, false);


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 226
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- TOC entry 3282 (class 2606 OID 16463)
-- Name: clients clients_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);


--
-- TOC entry 3284 (class 2606 OID 16459)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 3286 (class 2606 OID 16461)
-- Name: clients clients_subdomain_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_subdomain_key UNIQUE (subdomain);


--
-- TOC entry 3288 (class 2606 OID 16465)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 16467)
-- Name: email_otp_codes email_otp_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_otp_codes
    ADD CONSTRAINT email_otp_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 3293 (class 2606 OID 16469)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3309 (class 2606 OID 24743)
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3295 (class 2606 OID 16473)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3297 (class 2606 OID 16475)
-- Name: sales_transaction_items sales_transaction_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 16477)
-- Name: sales_transactions sales_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 16479)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 3304 (class 2606 OID 16483)
-- Name: users users_client_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_client_username_unique UNIQUE (client_id, username);


--
-- TOC entry 3306 (class 2606 OID 16481)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3291 (class 1259 OID 16600)
-- Name: idx_payments_client_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_client_status ON public.payments USING btree (client_id, status);


--
-- TOC entry 3307 (class 1259 OID 24744)
-- Name: idx_product_categories_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_categories_client_id ON public.product_categories USING btree (client_id);


--
-- TOC entry 3300 (class 1259 OID 16601)
-- Name: idx_subscriptions_next_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_next_billing ON public.subscriptions USING btree (next_billing_date);


--
-- TOC entry 3310 (class 2606 OID 16484)
-- Name: customers customers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3311 (class 2606 OID 16489)
-- Name: payments payments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3313 (class 2606 OID 16593)
-- Name: payments payments_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- TOC entry 3312 (class 2606 OID 16494)
-- Name: payments payments_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id);


--
-- TOC entry 3314 (class 2606 OID 16509)
-- Name: products products_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3315 (class 2606 OID 16514)
-- Name: sales_transaction_items sales_transaction_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3316 (class 2606 OID 16519)
-- Name: sales_transaction_items sales_transaction_items_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transaction_items
    ADD CONSTRAINT sales_transaction_items_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.sales_transactions(id) ON DELETE CASCADE;


--
-- TOC entry 3317 (class 2606 OID 16524)
-- Name: sales_transactions sales_transactions_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id);


--
-- TOC entry 3318 (class 2606 OID 16529)
-- Name: sales_transactions sales_transactions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_transactions
    ADD CONSTRAINT sales_transactions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3319 (class 2606 OID 16534)
-- Name: subscriptions subscriptions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3320 (class 2606 OID 16539)
-- Name: users users_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


-- Completed on 2026-01-13 09:06:21 WIB

--
-- PostgreSQL database dump complete
--

\unrestrict SLtD52pxgNA7aGQ8nMlvNjhaEg0KjNpK6FK2yXbBTW2HUovP0LAZm3m47V6hNoZ

