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


--
-- Name: comment_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.comment_category AS ENUM (
    'keep',
    'stop',
    'try'
);


--
-- Name: retrospective_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.retrospective_status AS ENUM (
    'open',
    'closed'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    content text NOT NULL,
    anonymous boolean DEFAULT false NOT NULL,
    retrospective_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    category public.comment_category DEFAULT 'keep'::public.comment_category NOT NULL,
    slack_user_id character varying,
    slack_username character varying,
    CONSTRAINT check_slack_info_if_not_anonymous CHECK (((anonymous AND (slack_user_id IS NULL) AND (slack_username IS NULL)) OR ((NOT anonymous) AND (slack_user_id IS NOT NULL) AND (slack_username IS NOT NULL))))
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: retrospectives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.retrospectives (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status public.retrospective_status DEFAULT 'open'::public.retrospective_status NOT NULL
);


--
-- Name: retrospectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.retrospectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: retrospectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.retrospectives_id_seq OWNED BY public.retrospectives.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    team_id character varying,
    name character varying,
    domain character varying,
    token character varying,
    oauth_scope character varying,
    oauth_version character varying DEFAULT 'v1'::character varying NOT NULL,
    bot_user_id character varying,
    activated_user_id character varying,
    activated_user_access_token character varying,
    active boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: retrospectives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives ALTER COLUMN id SET DEFAULT nextval('public.retrospectives_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: retrospectives retrospectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.retrospectives
    ADD CONSTRAINT retrospectives_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: index_comments_on_retrospective_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_retrospective_id ON public.comments USING btree (retrospective_id);


--
-- Name: index_retrospectives_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_retrospectives_on_title ON public.retrospectives USING btree (title);


--
-- Name: comments fk_rails_1b0a312e58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_1b0a312e58 FOREIGN KEY (retrospective_id) REFERENCES public.retrospectives(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20231003124110'),
('20231003125437'),
('20231004114901'),
('20231107124352'),
('20231127134515'),
('20231127134525'),
('20231127135016');


