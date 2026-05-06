-- Adminer 5.4.1 PostgreSQL 15.15 dump

DROP TABLE IF EXISTS "affectation";
DROP SEQUENCE IF EXISTS affectation_id_seq;
CREATE SEQUENCE affectation_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."affectation" (
    "id" integer DEFAULT nextval('affectation_id_seq') NOT NULL,
    "id_facteur" integer NOT NULL,
    "id_tournee" integer NOT NULL,
    "date_debut" date NOT NULL,
    "date_fin" date,
    "role_affectation" character varying(20) NOT NULL,
    CONSTRAINT "affectation_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "affectation" ("id", "id_facteur", "id_tournee", "date_debut", "date_fin", "role_affectation") VALUES
(1,	1,	2,	'2026-01-01',	NULL,	'TITULAIRE'),
(2,	2,	3,	'2026-04-01',	NULL,	'REMPLACANT'),
(3,	2,	4,	'2026-05-05',	NULL,	'TITULAIRE'),
(4,	2,	1,	'2026-05-18',	NULL,	'TITULAIRE'),
(5,	2,	4,	'2026-05-05',	NULL,	'TITULAIRE'),
(6,	2,	1,	'2026-05-11',	NULL,	'TITULAIRE'),
(7,	3,	4,	'2026-05-25',	NULL,	'TITULAIRE');

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
(3,	'BERRY',	'Lea',	'INTERIM',	'REMPLACANT');

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
(3,	'BAL Jaune',	'67 rue des Naurais',	NULL),
(4,	'BAL Jaune',	'1 rue Beauregard',	NULL),
(1,	'ExpBal',	'128 Rue Bourbon',	NULL),
(2,	'Collecte',	'55 rue du 14e RTA',	NULL);

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
(4,	9411,	'VOITURE',	'Rue Francois Arago, Rue Gustave Eiffeil, Rue de la Bastille');

ALTER TABLE ONLY "public"."affectation" ADD CONSTRAINT "affectation_id_facteur_fkey" FOREIGN KEY (id_facteur) REFERENCES facteur(id) NOT DEFERRABLE;
ALTER TABLE ONLY "public"."affectation" ADD CONSTRAINT "affectation_id_tournee_fkey" FOREIGN KEY (id_tournee) REFERENCES tournee(id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."prestation" ADD CONSTRAINT "prestation_id_tournee_fkey" FOREIGN KEY (id_tournee) REFERENCES tournee(id) NOT DEFERRABLE;

-- 2026-05-06 12:30:58 UTC