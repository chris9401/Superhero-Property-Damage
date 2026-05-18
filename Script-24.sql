-- Create database called 'superhero' --

Create table dim_films (
	movie_id Integer Primary Key Not Null,
	movie_name Varchar (255),
	year Varchar(4),
	universe Varchar (255)
);

Create table dim_heroes (
	superhero_id Integer Primary Key Not Null,
	superhero_name Varchar (255)
);

Create table dim_villains (
	villain_id Integer Primary Key Not Null,
	villain_name Varchar (255)
);

Create table dim_locations (
	location_id Integer Primary Key Not Null,
	location_name Varchar (255)
);

Create table dim_asset_types (
	asset_type_id Integer Primary Key Not Null,
	asset_type_name Varchar (255)
);

Create table dim_damage_responsibility (
	damage_responsibility_id Integer Primary Key Not Null,
	damage_responsibility_name Varchar (255)
);

Create table fact_scenes (
	scene_id Int Primary Key Not Null,
	movie_id Integer,
	superhero_id Integer,
	villain_id Integer,
	location_id Integer,
	asset_type_id Integer,
	damage_responsibility_id Integer,
	asset_ownership Varchar (255),
	asset_weight Integer,
	severity Varchar (255),
	severity_score Integer,
	scale Varchar(255),
	scale_score Integer,
	power_class Varchar(255),
	cause Varchar (255),
	damage_duration Varchar(50),
	scene_score Integer,
	tier_level Integer,
	notes Varchar (255),
	Foreign Key (movie_id) references dim_films(movie_id),
	Foreign Key (superhero_id) references dim_heroes(superhero_id),
	Foreign Key (villain_id) references dim_villains(villain_id),
	Foreign Key (location_id) references dim_locations(location_id),
	Foreign Key (asset_type_id) references dim_asset_types(asset_type_id),
	Foreign Key (damage_responsibility_id) references dim_damage_responsibility
);

Create table dim_comic_characters (
	Comic_Character_id Integer Primary Key Not Null,
	Name Varchar(255),
	Identity Varchar(255),
	Alignment Varchar(55),
	Eyes Varchar(55),
	Hair Varchar(55),
	Sex Varchar(55),
	Alive Varchar(55),
	Appearances Integer,
	First_Appeared Date,
	Planet Varchar(55),
	Universe Varchar(55)
);
	
Create table dim_power_grid (
	Character Varchar(255),
	Role Varchar(55),
	Universe Varchar(55),
	INT Integer,
	STR Integer,
	SPD Integer,
	DUR Integer,
	NRG Integer,
	FGT Integer,
	Overall_Score Integer,
	Marvel_Official Integer
);

Create table bridge_hero_powergrid(
	bridge_id Integer Primary Key Not Null,
	superhero_id Integer,
	power_grid_id Integer,
	Foreign Key(superhero_id) References dim_heroes(superhero_id),
	Foreign Key(power_grid_id) References dim_power_grid(power_grid_id)
);

Create table bridge_villain_powergrid(
	bridge_id Integer Primary Key Not Null,
	villain_id Integer,
	power_grid_id Integer,
	Foreign Key(villain_id) References dim_villains(villain_id),
	Foreign Key(power_grid_id) References dim_power_grid(power_grid_id)
);

--Checking all my tables exist and have rows--

SELECT 'dim_films' as table_name, COUNT(*) as rows FROM dim_films
UNION ALL
SELECT 'dim_heroes', COUNT(*) FROM dim_heroes
UNION ALL
SELECT 'dim_villains', COUNT(*) FROM dim_villains
UNION ALL
SELECT 'dim_locations', COUNT(*) FROM dim_locations
UNION ALL
SELECT 'dim_asset_types', COUNT(*) FROM dim_asset_types
UNION ALL
SELECT 'dim_damage_responsibility', COUNT(*) FROM dim_damage_responsibility
UNION ALL
SELECT 'dim_power_grid', COUNT(*) FROM dim_power_grid
UNION ALL
SELECT 'fact_scenes', COUNT(*) FROM fact_scenes
UNION ALL
SELECT 'bridge_hero_powergrid', COUNT(*) FROM bridge_hero_powergrid
UNION ALL
SELECT 'bridge_villain_powergrid', COUNT(*) FROM bridge_villain_powergrid;

--previewing each main table--

SELECT * FROM dim_films LIMIT 5;
SELECT * FROM dim_heroes LIMIT 5;
SELECT * FROM dim_villains LIMIT 5;
SELECT * FROM fact_scenes LIMIT 5;
SELECT * FROM dim_power_grid LIMIT 5;

--test my foreign keys are working--

SELECT 
    f.movie_name,
    f.year,
    f.universe,
    COUNT(s.scene_id) as total_scenes
FROM fact_scenes s
JOIN dim_films f ON s.movie_id = f.movie_id
GROUP BY f.movie_name
ORDER BY total_scenes DESC
LIMIT 10;

--test my bridge tables are linked correctly--

SELECT 
    h.superhero_name,
    p.total_score,
    p.intelligence,
    p.strength,
    p.speed
FROM dim_heroes h
JOIN bridge_hero_powergrid b ON h.superhero_id = b.superhero_id
JOIN dim_power_grid p ON b.power_grid_id = p.power_grid_id
ORDER BY p.total_score DESC;

-- top 10 heroes by total damage by responsibility--

SELECT
    dr.damage_responsibility_name AS hero_name,
    SUM(s.scene_score) AS total_damage,
    COUNT(s.scene_id) AS total_scenes,
    AVG(s.scene_score) AS avg_damage
FROM fact_scenes s
JOIN dim_damage_responsibility dr ON s.damage_responsibility_id = dr.damage_responsibility_id
WHERE dr.character_type = 'Hero'
GROUP BY dr.damage_responsibility_name
ORDER BY total_damage DESC
LIMIT 10;

--top 10 villains by total damage by responsibility--

SELECT
    dr.damage_responsibility_name AS villain_name,
    SUM(s.scene_score) AS total_damage,
    COUNT(s.scene_id) AS total_scenes,
    AVG(s.scene_score) AS avg_damage
FROM fact_scenes s
JOIN dim_damage_responsibility dr ON s.damage_responsibility_id = dr.damage_responsibility_id
WHERE dr.character_type = 'Villain'
GROUP BY dr.damage_responsibility_name
ORDER BY total_damage DESC
LIMIT 10;

--top damage by universe--

SELECT
    f.universe,
    SUM(s.scene_score) AS total_damage,
    COUNT(s.scene_id) AS total_scenes,
    AVG(s.scene_score) AS avg_damage
FROM fact_scenes s
JOIN dim_films f ON s.movie_id = f.movie_id
GROUP BY f.universe
ORDER BY total_damage DESC;

--top damage by tier--

SELECT
    s.tier_level,
    COUNT(s.scene_id) AS total_scenes,
    SUM(s.scene_score) AS total_damage,
    AVG(s.scene_score) AS avg_damage,
    MAX(s.scene_score) AS max_damage
FROM fact_scenes s
GROUP BY s.tier_level
ORDER BY s.tier_level ASC;

--top 10 comic book appearances--

SELECT
    cc.name,
    cc.universe,
    cc.appearances,
    cc.alignment,
    cc.first_appeared
FROM dim_comic_characters cc
WHERE cc.appearances IS NOT NULL
ORDER BY cc.appearances DESC
LIMIT 10;

--does power level impact damage--

SELECT
    dr.damage_responsibility_name AS character_name,
    dr.character_type,
    pg.total_score AS power_level,
    pg.intelligence,
    pg.strength,
    pg.speed,
    pg.durability,
    pg.energy_proj,
    pg.fighting_skills,
    SUM(s.scene_score) AS total_damage,
    COUNT(s.scene_id) AS total_scenes,
    AVG(s.scene_score) AS avg_damage
FROM fact_scenes s
JOIN dim_damage_responsibility dr ON s.damage_responsibility_id = dr.damage_responsibility_id
JOIN dim_heroes h ON s.superhero_id = h.superhero_id
JOIN bridge_hero_powergrid bh ON h.superhero_id = bh.superhero_id
JOIN dim_power_grid pg ON bh.power_grid_id = pg.power_grid_id
WHERE dr.character_type IN ('Hero', 'Villain')
GROUP BY dr.damage_responsibility_name, dr.character_type, pg.total_score
ORDER BY pg.total_score DESC;

--top ten total damage by movie title--

SELECT
    f.movie_name,
    f.year,
    f.universe,
    SUM(s.scene_score) AS total_damage,
    COUNT(s.scene_id) AS total_scenes,
    AVG(s.scene_score) AS avg_damage,
    MAX(s.scene_score) AS max_damage
FROM fact_scenes s
JOIN dim_films f ON s.movie_id = f.movie_id
GROUP BY f.movie_name, f.year, f.universe
ORDER BY total_damage DESC
LIMIT 10;