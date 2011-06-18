-- Database: fielderic

DROP DATABASE fielderic;

CREATE DATABASE fielderic
  WITH OWNER = eric
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'C'
       LC_CTYPE = 'C'
       CONNECTION LIMIT = -1;

DROP TABLE IF EXISTS field;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS match;

CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    password VARCHAR(50),
    coordinates VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    date TIMESTAMPTZ NOT NULL,
    location VARCHAR(100) NOT NULL,
    type SMALLINT NOT NULL,
    players_required SMALLINT NOT NULL,
    comment TEXT
);

CREATE TABLE field (
    id SERIAL,
    player_id INT NOT NULL REFERENCES player (id),
    match_id INT NOT NULL REFERENCES match(id),
    is_organizer BOOLEAN NOT NULL,
    PRIMARY KEY (player_id, match_id)
);

commit;