-- script to generate cities table for PostGis
-- used in examples 

-- Source: http://www.realestate3d.com/gps/latlong.htm

CREATE USER ggl password 'ggl' createdb;
CREATE DATABASE ggl OWNER=ggl template=postgis;


DROP TABLE  IF EXISTS  cities;
CREATE TABLE cities(id serial PRIMARY KEY, name VARCHAR(25));

SELECT addgeometrycolumn('','cities','location','4326','POINT',2);
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -71.03 42.37)', 4326), 'Boston');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -87.65 41.90)', 4326), 'Chicago');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -95.35 29.97)', 4326), 'Houston');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT(-118.40 33.93)', 4326), 'Los Angeles');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -80.28 25.82)', 4326), 'Miami');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -73.98 40.77)', 4326), 'New York');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT(-112.02 33.43)', 4326), 'Phoenix');
INSERT INTO cities(LOCATION, name) VALUES(GeometryFromText('POINT( -77.04 38.85)', 4326), 'Washington DC');
