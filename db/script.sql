-- Database: fielderic
-- Date: 19/06/2011
-- Creates database structure

DROP TABLE IF EXISTS field;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS match;

CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    password TEXT,
    coordinates VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    registration TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    created TIMESTAMPTZ NOT NULL DEFAULT now(),
    occurs TIMESTAMPTZ NOT NULL,
    location VARCHAR(100) NOT NULL,
    kind SMALLINT NOT NULL,
    players_required SMALLINT NOT NULL,
    comment TEXT
);

CREATE TABLE field (
    id SERIAL,
    player_id INT NOT NULL REFERENCES player (id),
    match_id INT NOT NULL REFERENCES match(id),
    organizer BOOLEAN NOT NULL,
    joined TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (player_id, match_id)
);

