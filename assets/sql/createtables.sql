-- Table: public."Tasks"

-- DROP TABLE public."Tasks";

CREATE TABLE public."Tasks"
(
    "Id" integer NOT NULL DEFAULT nextval('"Tasks_Id_seq"'::regclass),
    "Completed" boolean NOT NULL,
    "Priority" integer NOT NULL,
    "Title" text COLLATE pg_catalog."default",
    CONSTRAINT "PK_Tasks" PRIMARY KEY ("Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."Tasks"
    OWNER to postgres;