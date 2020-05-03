
CREATE TABLE mapchunks (
  v integer DEFAULT 0,
  map_name text,
  cx integer,
  cy integer,
  PRIMARY KEY (map_name, cx, cy)
);

CREATE TABLE characters (
  id serial PRIMARY KEY,
  v integer  NOT NULL DEFAULT 0,
  state json NOT NULL DEFAULT '{}'::json,
  map_name text,
  cx integer,
  cy integer,
  FOREIGN KEY (map_name,cx,cy) REFERENCES mapchunks (map_name,cx,cy)
);


CREATE OR REPLACE FUNCTION update_char() RETURNS trigger AS $func$
  if (TG_OP === 'UPDATE' || TG_OP === 'DELETE') NEW.v = OLD.v + 1;
  const sKey = [NEW.map_name, NEW.cx, NEW.cy].join('_');
  NEW.state.v = NEW.v;
  NEW.state.sKey = sKey;

  const json     = JSON.stringify(NEW.state);
  const dBracket = '$klrdpY495dDTo$';
  const escJson  = dBracket+json+dBracket;

  const notifyCommand = `NOTIFY ${sKey}, ${escJson}`;

  plv8.elog(WARNING, 'notifyCommand', notifyCommand);

  plv8.execute(notifyCommand);
  return NEW;
$func$ LANGUAGE "plv8";

CREATE TRIGGER update_char_trigger
BEFORE INSERT OR UPDATE OR DELETE ON characters
FOR EACH ROW EXECUTE FUNCTION update_char();

INSERT INTO mapchunks (map_name, cx, cy) VALUES ('a', 0, 0);
INSERT INTO mapchunks (map_name, cx, cy) VALUES ('a', 0, 1);
INSERT INTO mapchunks (map_name, cx, cy) VALUES ('a', 1, 0);
INSERT INTO mapchunks (map_name, cx, cy) VALUES ('a', 1, 1);


INSERT INTO characters (map_name, cx, cy) VALUES ('a', 0, 0);
