--
-- PostgreSQL database dump
--

BEGIN TRANSACTION;

SET client_encoding = 'UNICODE';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 66828)
-- Name: event_type_localized; Type: TABLE DATA; Schema: public; Owner: pentabarf
--

INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (1, 120, 'Lecture');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (3, 120, 'Workshop');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (4, 120, 'Movie');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (6, 120, 'Podium');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (7, 120, 'Meeting');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (8, 120, 'Other');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (6, 144, 'Podium');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (7, 144, 'Treffen');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (8, 144, 'Sonstiges');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (1, 144, 'Vortrag');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (3, 144, 'Workshop');
INSERT INTO event_type_localized (event_type_id, language_id, name) VALUES (4, 144, 'Film');

COMMIT TRANSACTION;

