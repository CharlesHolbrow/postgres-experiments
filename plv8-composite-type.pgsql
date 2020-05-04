/*
Testing how plv8 handles composite types.
QUESTION: Does it intelligently make sub objects out of composite types?
ANSWER: Yes. Inside the plv8 trigger function below, interperates NEW like this:
{"id":1,"c":{"map_name":"alpha","cx":0,"cy":0},"name":"alice"}
*/

-- CREATE TYPE chunk AS (
--     map_name varchar(32),
--     cx numeric,
--     cy numeric
-- );

-- CREATE TABLE named_chunks (
--     id serial PRIMARY KEY,
--     c chunk UNIQUE NOT NULL,
--     name text
-- );

-- CREATE OR REPLACE FUNCTION on_chunk_mod() RETURNS trigger AS $ocm$
-- plv8.elog(WARNING, JSON.stringify(NEW));
-- return NEW;
-- $ocm$ LANGUAGE "plv8";

-- CREATE TRIGGER update_chunk_trigger
--   BEFORE INSERT OR UPDATE OR DELETE on named_chunks
--   FOR EACH ROW
--   EXECUTE FUNCTION on_chunk_mod ();


-- INSERT INTO named_chunks (c, name) VALUES (('alpha', 0, 0), 'bob');
UPDATE named_chunks SET name='alice' WHERE name='bob';
