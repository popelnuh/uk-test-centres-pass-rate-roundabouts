-- Ogr2ogr Upload the point roads dataset
-- ogr2ogr -f PostgreSQL "PG:dbname=postgis host=localhost port=5433 user=user password=password" oproad_gb.gpkg

-- Select unique values for the road nodes
SELECT DISTINCT formofroadnode
FROM roadnode;

-- 
"junction"
"pseudo node"
"road end"
"roundabout"
--

-- Select Roundabouts into a table
SELECT * INTO roundabouts
FROM public.roadnode
WHERE formofroadnode = 'roundabout';

--Create an empty table to import the test centres, their geographic location and their pass rate
CREATE TABLE pass_rate_centre(
	field_1 varchar(255),
	centre varchar(255),
	rate varchar(255),
	lat numeric,
	long numeric);

--Add column for geometry
alter table pass_rate_centre add column geom geometry(Point, 4326);

--Populate geometry for the test centres
update pass_rate_centre set geom=st_SetSrid(st_MakePoint(long, lat), 4326);

--Reproject into British National Grid so that it matched that of roundabouts
ALTER TABLE public.pass_rate_centre 
  ALTER COLUMN geom
  TYPE Geometry(Point, 27700) 
  USING ST_Transform(geom, 27700);

--We want to add another geometry column for the 30 km buffer
ALTER TABLE public.pass_rate_centre
ADD COLUMN buffer
geometry(Geometry,27700);

--Add a 30 km buffer to the test centres (30km radius)
UPDATE public.pass_rate_centre
SET buffer = ST_Buffer(geom, 30000)

--Calculate number of roundbaouts within the 30 km buffer
SELECT pass_rate_centre.centre, pass_rate_centre.rate, pass_rate_centre.geom, count(roundabouts.geom) AS number_roundabouts
INTO centre_rate_roundabout
FROM pass_rate_centre
LEFT JOIN roundabouts
ON st_contains(pass_rate_centre.buffer,roundabouts.geom) 
GROUP BY pass_rate_centre.centre, pass_rate_centre.rate, pass_rate_centre.geom;


--Export the table as a Shapefile/GeoJSON
--ogr2ogr -f "ESRI Shapefile" centre_pass_rate_roundabout.shp  "PG:dbname=postgis host=localhost port=5433 user=user password=password" -sql "SELECT * FROM centre_rate_roundabout"
--ogr2ogr -f "GeoJSON" centre_pass_rate_roundabout.json "PG:dbname=postgis host=localhost port=5433 user=user password=password" -sql "SELECT * FROM centre_rate_roundabout"
--Export table as a CSV for analysis in R
--ogr2ogr -f "CSV" centre_pass_rate_roundabout.csv "PG:dbname=postgis host=localhost port=5433 user=user password=password" -sql "SELECT * FROM centre_rate_roundabout"
