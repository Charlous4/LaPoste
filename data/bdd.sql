-- Adminer 5.4.1 PostgreSQL 15.18 dump

DROP TABLE IF EXISTS "affectation";
DROP SEQUENCE IF EXISTS affectation_id_seq;
CREATE SEQUENCE affectation_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."affectation" (
    "id" integer DEFAULT nextval('affectation_id_seq') NOT NULL,
    "id_facteur" integer NOT NULL,
    "id_tournee" integer,
    "date_debut" date NOT NULL,
    "date_fin" date,
    "role_affectation" character varying(20) NOT NULL,
    CONSTRAINT "affectation_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "affectation" ("id", "id_facteur", "id_tournee", "date_debut", "date_fin", "role_affectation") VALUES
(1,	1,	2,	'2026-01-01',	NULL,	'TITULAIRE'),
(2,	2,	3,	'2026-04-01',	NULL,	'REMPLACANT'),
(4,	2,	1,	'2026-05-18',	NULL,	'TITULAIRE'),
(6,	2,	1,	'2026-05-11',	NULL,	'TITULAIRE'),
(8,	2,	3,	'2026-05-31',	NULL,	'TITULAIRE'),
(9,	2,	1,	'2026-05-31',	NULL,	'TITULAIRE'),
(10,	2,	1,	'2026-05-31',	NULL,	'TITULAIRE'),
(43,	2,	1,	'2026-06-01',	NULL,	'TITULAIRE'),
(44,	3,	3,	'2026-06-01',	NULL,	'TITULAIRE'),
(50,	2,	1,	'2026-06-01',	NULL,	'TITULAIRE'),
(79,	2,	1,	'2026-06-05',	NULL,	'TITULAIRE'),
(80,	2,	3,	'2026-06-06',	NULL,	'TITULAIRE'),
(81,	2,	NULL,	'2026-06-06',	NULL,	'TITULAIRE'),
(82,	2,	1,	'2026-06-06',	NULL,	'TITULAIRE'),
(84,	1,	2,	'2026-06-07',	NULL,	'TITULAIRE'),
(85,	2,	1,	'2026-06-22',	NULL,	'TITULAIRE'),
(86,	3,	3,	'2026-06-15',	NULL,	'TITULAIRE'),
(87,	2,	1,	'2026-06-08',	NULL,	'TITULAIRE'),
(88,	2,	1,	'2026-06-07',	NULL,	'TITULAIRE'),
(89,	3,	3,	'2026-06-07',	NULL,	'TITULAIRE'),
(90,	3,	34,	'2026-06-07',	NULL,	'TITULAIRE'),
(91,	3,	3,	'2026-06-07',	NULL,	'TITULAIRE'),
(92,	2,	3,	'2026-06-07',	NULL,	'TITULAIRE'),
(93,	3,	34,	'2026-06-07',	NULL,	'TITULAIRE'),
(94,	2,	1,	'2026-06-07',	NULL,	'TITULAIRE'),
(95,	5,	34,	'2026-06-08',	NULL,	'TITULAIRE');

DROP TABLE IF EXISTS "facteur";
DROP SEQUENCE IF EXISTS facteur_id_seq;
CREATE SEQUENCE facteur_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."facteur" (
    "id" integer DEFAULT nextval('facteur_id_seq') NOT NULL,
    "nom" character varying(100) NOT NULL,
    "prenom" character varying(100) NOT NULL,
    "contrat" character varying(20) NOT NULL,
    "role" character varying(20) NOT NULL,
    CONSTRAINT "facteur_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "facteur" ("id", "nom", "prenom", "contrat", "role") VALUES
(1,	'PLANCHET',	'Mickael',	'CDI',	'TITULAIRE'),
(2,	'RUBIO',	'Charles',	'INTERIM',	'REMPLACANT'),
(3,	'BERRY',	'Lea',	'INTERIM',	'REMPLACANT'),
(5,	'REIGNER',	'Hervé',	'INTERIM',	'REMPLACANT');

DROP TABLE IF EXISTS "prestation";
DROP SEQUENCE IF EXISTS prestation_id_seq;
CREATE SEQUENCE prestation_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."prestation" (
    "id" integer DEFAULT nextval('prestation_id_seq') NOT NULL,
    "type" character varying(100) NOT NULL,
    "adresse" character varying(200) NOT NULL,
    "id_tournee" integer,
    CONSTRAINT "prestation_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "prestation" ("id", "type", "adresse", "id_tournee") VALUES
(4,	'BAL Jaune',	'1 rue Beauregard',	1),
(1,	'ExpBal',	'128 Rue Bourbon',	3),
(2,	'Collecte',	'55 rue du 14e RTA',	2),
(3,	'BAL Jaune',	'67 rue des Naurais',	3);

DROP TABLE IF EXISTS "tournee";
DROP SEQUENCE IF EXISTS tournee_id_seq;
CREATE SEQUENCE tournee_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."tournee" (
    "id" integer DEFAULT nextval('tournee_id_seq') NOT NULL,
    "numero" integer NOT NULL,
    "vehicule" character varying(20) NOT NULL,
    "rues" text NOT NULL,
    CONSTRAINT "tournee_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "tournee" ("id", "numero", "vehicule", "rues") VALUES
(1,	3101,	'VAE',	'Rue Alfred Herault, Rue du General Reibel, Rue du General Sarrail'),
(2,	3107,	'VAE',	'Rue Jeanne d Arc, Rue de la Chevretterie, Bd Victor Hugo, Faubourg St Jacques, Rue Hilaire Gilbert'),
(3,	9113,	'VCAE',	'Rue Bourbon, Rue des limousins, Av Pierre Ablin'),
(34,	9411,	'VOITURE',	'Rue François Aragot');

ALTER TABLE ONLY "public"."affectation" ADD CONSTRAINT "affectation_id_facteur_fkey" FOREIGN KEY (id_facteur) REFERENCES facteur(id) NOT DEFERRABLE;
ALTER TABLE ONLY "public"."affectation" ADD CONSTRAINT "affectation_id_tournee_fkey" FOREIGN KEY (id_tournee) REFERENCES tournee(id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."prestation" ADD CONSTRAINT "prestation_id_tournee_fkey" FOREIGN KEY (id_tournee) REFERENCES tournee(id) NOT DEFERRABLE;

-- 2026-06-08 13:35:37 UTC