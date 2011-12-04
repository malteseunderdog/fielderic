-- Database: fielderic
-- Date: 19/06/2011
-- Creates a small test data set

INSERT INTO player (nickname, name, email, mobile, password, coordinates, location) VALUES ('dave', 'David Camilleri', 'dave@fielderic.com', '+44 75 6447 2800', crypt('oldTrafford', gen_salt('bf')), '61.496254,-0.226986', 'London,United Kingdom');
INSERT INTO player (nickname, name, email, mobile, password, coordinates, location) VALUES ('mike', 'Michael Camilleri', 'mike@fielderic.com', '00447512345678', crypt('oldTrafford', gen_salt('bf')), '57.524475,-0.010339', 'London,United Kingdom');
INSERT INTO player (nickname, name, email, mobile, password, coordinates, location) VALUES ('jp', 'Jean-Paul Ebejer', 'jp@fielderic.com', '+4475 88888888', crypt('delleAlpi', gen_salt('bf')), '51.752279,-1.255884', 'Oxford,United Kingdom');
INSERT INTO player (nickname, name, email, mobile, password, coordinates, location) VALUES ('eric', 'Eric Cantona', 'eric@fielderic.com', '+77 77 77 77 77 77', NULL, '77.721200,10.911567', 'New York,United States of America');

INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-20 18:00:00', 'Qormi,Malta', 5, 10, 1, NULL);
INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-20 17:30:00', 'Mellieha,Malta', 5, 2, 1, '5-a-side match at Mellieha. Beers after the match at Zapps!!!!!!!!');
INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-20 18:00:00', 'London,United Kingdom', 5, 5, 2, '5-a-side tournament match. Playing for car pink slips! Expect blood!!');
INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-20 19:00:00', 'Milan,Italy', 11, 26, 3, 'partita di calcietto a 5. nel piccolo stadio del Meazza. livello bassissimo');
INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-20 17:00:00', 'Barcelona,Spain', 5, 12, 2, 'partido a entrenar para convertirse en mejores que los de Barcelona el primer equipo!');
INSERT INTO match (occurs, location, kind, required_players, organizedby_id, comment) VALUES ('2011-06-19 20:00:00', 'Qormi,Malta', 7, 1, 1,E'5-a-side match at Qormi. Before coming, ask this question...\'are you good enough?\'');

INSERT INTO field (player_id, match_id) VALUES (1, 1);
INSERT INTO field (player_id, match_id) VALUES (1, 2);
INSERT INTO field (player_id, match_id) VALUES (2, 4);
INSERT INTO field (player_id, match_id) VALUES (1, 3);
INSERT INTO field (player_id, match_id) VALUES (1, 5);
INSERT INTO field (player_id, match_id) VALUES (2, 2);
INSERT INTO field (player_id, match_id) VALUES (4, 2);
INSERT INTO field (player_id, match_id) VALUES (2, 3);
INSERT INTO field (player_id, match_id) VALUES (1, 4);
INSERT INTO field (player_id, match_id) VALUES (4, 1);
