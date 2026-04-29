--Creating the database
CREATE DATABASE StarWars;

--Creating the table of planets, values from this table will later be used in subsequent tables.
CREATE TABLE StarWars.dbo.Planets (
	PlanetID	INT IDENTITY(1,1) PRIMARY KEY,
	PlanetName	NVARCHAR(30) NOT NULL UNIQUE,
	Region		NVARCHAR(50) NULL,
	Climate		NVARCHAR(100) NULL,
	Terrain		NVARCHAR(100) NULL,
	[Population]BIGINT NULL CHECK([Population] IS NULL OR [Population]>=0)
	
);

--Creating a table of characters, their homeworld will be referenced to the Planets table.
--If a character is updated, it will change subsequent tables as well.
--If a character is deleted, it will become null in later tables.
CREATE TABLE StarWars.dbo.Characters (
	CharacterID			INT IDENTITY(1,1) PRIMARY KEY,
	Cname				NVARCHAR(100) NOT NULL,
	Species				NVARCHAR(100) NOT NULL,
	HomeworldID			INT NULL,
	Affiliation			NVARCHAR(100) NULL,
	Gender				NVARCHAR(20) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Non-binary', 'Droid', 'Other')),
	BirthYear			INT NULL,
	IsForceSensitive	BIT NOT NULL DEFAULT (0),
	CONSTRAINT FK_Characters_Planets	
		Foreign KEY (HomeworldID) REFERENCES StarWars.dbo.Planets (PlanetID)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);
--Creating a table of spaceships/vehicles. 
--References to Planets table, and Characters table.
--If a ship is deleted, it will become null for its owner character.
CREATE TABLE StarWars.dbo.Starshipsvehicles (
	VehicleID				INT IDENTITY(1,1) PRIMARY KEY,
	ShipName				NVARCHAR(120) NOT NULL,
	ShipType				NVARCHAR(20) NOT NULL CHECK (ShipType IN ('Starship', 'Vehicle')),
	Class					NVARCHAR(50) NULL,
	Model					NVARCHAR(120) NULL,
	Manufacturer			NVARCHAR(120) NULL,
	CrewCapacity			INT NULL CHECK (CrewCapacity IS NULL OR CrewCapacity>=0),
	CargoCapacityKg			INT NULL CHECK (CargoCapacityKg IS NULL OR CargoCapacityKg>=0),
	HyperdriveRating		FLOAT NULL, 
	MaxAtmosphericSpeedKph	INT NULL CHECK (MaxAtmosphericSpeedKph IS NULL OR MaxAtmosphericSpeedKph>=0),
	OwnerCharacterID		INT NULL,
	CurrentPlanetID			INT NULL, 
	CONSTRAINT FK_SV_Characters
		FOREIGN KEY (OwnerCharacterID) REFERENCES StarWars.dbo.Characters(CharacterID)
		ON DELETE SET NULL,
	CONSTRAINT FK_SV_Planets
		FOREIGN KEY (CurrentPlanetID) REFERENCES StarWars.dbo.Planets(PlanetID)
		ON DELETE SET NULL
);

CREATE TABLE StarWars.dbo.Weapons (
	WeaponID			INT IDENTITY (1,1) PRIMARY KEY,
	WeaponName			NVARCHAR(120) NOT NULL,
	WeaponCategory		NVARCHAR(30) NOT NULL
						CHECK (WeaponCategory IN ('Lightsaber', 'Blaster', 'Explosive', 'Melee', 'Bowcaster', 'Other')),
	DamageType			NVARCHAR(30) NULL	
						CHECK (DamageType IN ('Energy', 'Kinetic', 'Explosive', 'Other')),
	Era					NVARCHAR (60) NULL,
	Material			NVARCHAR (120) NULL,
	IsRestricted		BIT NOT NULL DEFAULT (0),
	PrimaryWielderID	INT NULL,
	Notes				NVARCHAR(400) NULL,
	CONSTRAINT FK_Weapons_Characters
		FOREIGN KEY (PrimaryWielderID) REFERENCES StarWars.dbo.Characters(CharacterID)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

--Inserting data into the Planets table
INSERT INTO StarWars.dbo.Planets (PlanetName, Region, Climate, Terrain, [Population]) VALUES
('Tatooine','Outer Rim','Arid, hot','Desert, dunes, rocky canyons',200000),
('Alderaan','Core Worlds','Temperate','Grasslands, mountains, forests',2000000000),
('Coruscant','Core Worlds','Temperate, artificial','Ecumenopolis (city-planet)',1000000000000),
('Naboo','Mid Rim','Temperate, tropical','Plains, lakes, swamps',4500000000),
('Mustafar','Outer Rim','Hot, volcanic','Lava rivers, volcanic mountains',20000),
('Hoth','Outer Rim','Frozen, frigid','Ice fields, tundra, glaciers',NULL),
('Endor (forest moon)','Outer Rim','Mild, temperate','Forests, mountains, rivers',30000000),
('Kashyyyk','Mid Rim','Tropical, humid','Wroshyr forests, rivers',45000000),
('Kamino','Extragalactic','Rainy, stormy','Endless oceans, stormy seas',1000000000),
('Geonosis','Outer Rim','Hot, arid','Rocky deserts, mesas, hive structures',100000000),
('Bespin','Outer Rim','Temperate, artificial','Gas giant (Cloud City floating)',6000000),
('Dagobah','Outer Rim','Humid, swampy','Swamps, jungles, caves',0),
('Mandalore','Outer Rim','Arid, seasonal extremes','Cities, deserts, mountains',4000000),
('Dathomir','Outer Rim','Temperate, humid','Swamps, forests, mountains',520000),
('Jakku','Western Reaches','Arid, hot','Desert, wreckage fields',300000),
('Jedha','Mid Rim','Cold desert, arid','Rocky deserts, ancient ruins',11000000),
('Scarif','Outer Rim','Tropical, humid','Islands, oceans, shield gate station',200000),
('Lothal','Outer Rim','Temperate','Grasslands, plains, cities',12000000),
('Mon Cala','Mid Rim','Aquatic, humid','Oceans, floating cities',27000000000),
('Ilum','Unknown Regions','Frozen, frigid','Ice plains, kyber crystal caves',0),
('Ahch-To','Unknown Regions','Cool, stormy','Islands, oceans, cliffs',100),
('Exegol','Unknown Regions','Dark, stormy','Rocky wastelands, ancient temples',NULL),
('Corellia','Core Worlds','Temperate, industrial','Urban centers, shipyards, forests',3000000000),
('Yavin 4','Outer Rim','Tropical, humid','Jungles, temples, rivers',8000),
('Ryloth','Outer Rim','Harsh, arid (dayside); frozen (nightside)','Canyons, mountains, caves',1500000000);

--Inserting data into Characters table
INSERT INTO StarWars.dbo.Characters
(Cname, Species, HomeworldID, Affiliation, Gender, BirthYear, IsForceSensitive)
VALUES
('Luke Skywalker','Human',1,'Rebel Alliance','Male',19,1),
('Anakin Skywalker','Human',1,'Jedi Order / Sith','Male',41,1),
('Shmi Skywalker','Human',1,'None','Female',NULL,0),
('Leia Organa','Human',2,'Rebel Alliance','Female',19,1),
('Bail Organa','Human',2,'Galactic Senate','Male',67,0),
('Sheev Palpatine','Human',3,'Galactic Empire','Male',84,1),
('Mas Amedda','Chagrian',3,'Galactic Senate','Male',NULL,0),
('Padmé Amidala','Human',4,'Galactic Senate','Female',46,0),
('Jar Jar Binks','Gungan',4,'Galactic Senate','Male',52,0),
('Darth Maul','Zabrak',14,'Sith','Male',54,1),
('Galen Erso','Human',16,'Rebel Sympathizer','Male',52,0),
('Jyn Erso','Human',16,'Rebel Alliance','Female',21,0),
('Cassian Andor','Human',17,'Rebel Alliance','Male',26,0),
('Ezra Bridger','Human',18,'Jedi / Rebel Alliance','Male',19,1),
('Mon Mothma','Human',2,'Rebel Alliance','Female',48,0),
('Han Solo','Human',23,'Rebel Alliance','Male',29,0),
('Qi''ra','Human',23,'Crimson Dawn','Female',31,0),
('Chewbacca','Wookiee',8,'Rebel Alliance','Male',200,0),
('Yoda','Unknown',NULL,'Jedi Order','Male',896,1),
('Obi-Wan Kenobi','Human',3,'Jedi Order','Male',57,1),
('Count Dooku','Human',3,'Sith','Male',83,1),
('Darth Vader','Human',1,'Sith','Male',41,1),
('Saw Gerrera','Human',16,'Partisans','Male',48,0),
('Hera Syndulla','Twi''lek',25,'Rebel Alliance','Female',29,0),
('Cham Syndulla','Twi''lek',25,'Rebel Freedom Fighter','Male',58,0);

--Inserting data into the Starships and vehicles table
INSERT INTO StarWars.dbo.StarshipsVehicles
(ShipName, ShipType, Class, Model, Manufacturer, CrewCapacity, CargoCapacityKg, HyperdriveRating, MaxAtmosphericSpeedKph, OwnerCharacterID, CurrentPlanetID)
VALUES
('Millennium Falcon','Starship','Freighter','YT-1300f','Corellian Engineering Corporation',2,100000,0.5,NULL,16,11),
('Red Five','Starship','Starfighter','T-65B X-wing','Incom Corporation',1,110,1.0,1050,1,24),
('TIE Advanced x1','Starship','Starfighter','TIE/x1','Sienar Fleet Systems',1,65,1.0,NULL,22,NULL),
('N-1 Starfighter','Starship','Starfighter','N-1','Theed Palace Space Vessel Eng. Corps',1,50,1.0,1100,2,4),
('Jedi Starfighter','Starship','Starfighter','Delta-7 Aethersprite','Kuat Systems Engineering',1,20,1.0,1150,20,10),
('LAAT/i Gunship','Vehicle','Gunship','LAAT/i','Rothana Heavy Engineering',6,1000,NULL,620,NULL,10),
('AT-AT Walker','Vehicle','Walker','All Terrain Armored Transport','Kuat Drive Yards',5,10000,NULL,60,22,6),
('AT-ST Walker','Vehicle','Walker','All Terrain Scout Transport','Kuat Drive Yards',2,2000,NULL,90,NULL,7),
('Lambda-class Shuttle','Starship','Shuttle','T-4a','Sienar Fleet Systems',6,800,1.0,850,22,7),
('Ghost','Starship','Light Freighter','VCX-100','Corellian Engineering Corporation',4,70000,1.0,NULL,24,18),
('Phantom','Starship','Auxiliary Shuttle','Attack Shuttle','Kuat Systems Engineering',2,500,1.0,1000,24,18),
('U-wing','Starship','Gunship/Transport','UT-60D','Incom UT',2,7000,1.0,950,13,16),
('ARC-170','Starship','Starfighter','Aggressive ReConnaissance-170','Incom/Subpro',3,250,1.0,1000,2,3),
('Vulture Droid','Starship','Droid Starfighter','Variable Geometry Self-Propelled Battle Droid, Mark I','Haor Chall Eng.',0,0,NULL,1200,21,10),
('Kom''rk-class Fighter','Starship','Assault Transport','Gauntlet','MandalMotors',4,15000,1.0,1000,NULL,13),
('Twilight','Starship','Freighter','G9 Rigger-class','Corellian Engineering Corporation',2,60000,1.0,NULL,2,3),
('Tantive IV','Starship','Corvette','CR90','Corellian Engineering Corporation',30,3000,2.0,NULL,5,2),
('Home One','Starship','Capital Ship','MC80 Star Cruiser','Mon Calamari Shipyards',5400,2500000,1.0,NULL,15,19),
('B-wing Prototype','Starship','Starfighter','A/SF-01 B-wing','Slayn & Korpil',1,80,1.0,950,24,18),
('BTL-A4 Y-wing','Starship','Starfighter','BTL-A4','Koensayr Manufacturing',1,110,1.0,1000,14,24),
('74-Z Speeder Bike','Vehicle','Speeder Bike','74-Z','Aratech Repulsor Company',1,5,NULL,500,1,7),
('X-34 Landspeeder','Vehicle','Landspeeder','X-34','SoroSuub Corporation',1,50,NULL,250,1,1),
('STAP','Vehicle','Single Trooper Aerial Platform','STAP','Baktoid Armor Workshop',1,5,NULL,400,10,4),
('Devastator','Starship','Star Destroyer','Imperial I-class','Kuat Drive Yards',37000,36000000,2.0,NULL,22,17);

--Inserting data into the Weapons table
INSERT INTO StarWars.dbo.Weapons
(WeaponName, WeaponCategory, DamageType, Era, Material, IsRestricted, PrimaryWielderID, Notes)
VALUES
('Luke''s Lightsaber (green)','Lightsaber','Energy','Galactic Civil War','kyber (green)',1,1,NULL),
('Anakin''s Lightsaber (blue)','Lightsaber','Energy','Clone Wars','kyber (blue)',1,2,'Later passed to Luke/Leia'),
('Darth Vader''s Lightsaber','Lightsaber','Energy','Galactic Civil War','kyber (red)',1,22,NULL),
('Obi-Wan Kenobi''s Lightsaber','Lightsaber','Energy','Clone Wars','kyber (blue)',1,20,NULL),
('Darth Maul''s Double-Bladed Saber','Lightsaber','Energy','Prequel Era','kyber (red)',1,10,NULL),
('Count Dooku''s Curved-Hilt Saber','Lightsaber','Energy','Clone Wars','kyber (red)',1,21,NULL),
('Yoda''s Lightsaber','Lightsaber','Energy','Clone Wars','kyber (green)',1,19,NULL),
('Han Solo''s DL-44','Blaster','Energy','Galactic Civil War',NULL,1,16,'Heavy blaster pistol'),
('Leia''s Sporting Blaster (ELG-3A)','Blaster','Energy','Galactic Civil War',NULL,1,4,NULL),
('Chewbacca''s Bowcaster','Bowcaster','Energy','Galactic Civil War',NULL,1,18,NULL),
('Jyn Erso''s A180','Blaster','Energy','Galactic Civil War',NULL,1,12,'Modular blaster pistol'),
('Cassian Andor''s A280-CFE','Blaster','Energy','Galactic Civil War',NULL,1,13,'Modular pistol/carbine'),
('Padmé''s Naboo Defender','Blaster','Energy','Prequel Era',NULL,1,8,'ELG series'),
('Bail Organa''s Defender','Blaster','Energy','Prequel Era',NULL,1,5,NULL),
('Saw Gerrera''s Heavy Blaster','Blaster','Energy','Galactic Civil War',NULL,1,23,NULL),
('Hera Syndulla''s Blaster Pistol','Blaster','Energy','Rebellion Era',NULL,1,24,NULL),
('Cham Syndulla''s Blaster Rifle','Blaster','Energy','Rebellion Era',NULL,1,25,NULL),
('Ezra Bridger''s Lightsaber (v1)','Lightsaber','Energy','Rebellion Era','kyber (blue/green)',1,14,'Early design'),
('E-11 Blaster Rifle','Blaster','Energy','Galactic Civil War',NULL,1,NULL,'Standard Imperial issue'),
('A280 Blaster Rifle','Blaster','Energy','Galactic Civil War',NULL,1,NULL,'Standard Rebel rifle'),
('Thermal Detonator','Explosive','Explosive','Various',NULL,1,NULL,'Hand grenade-class explosive'),
('Vibroblade','Melee','Kinetic','Various','vibro-edged alloy',0,NULL,NULL),
('Force Pike','Melee','Kinetic','Galactic Civil War',NULL,0,NULL,'Used by Royal Guards'),
('Gungan Booma Orbs','Explosive','Explosive','Prequel Era','plasma spheres',0,9,'Thrown energy “booma”'),
('Bowcaster (generic)','Bowcaster','Energy','Various',NULL,1,NULL,'Wookiee crossbow, non-specific');


SELECT * FROM StarWars.dbo.Planets
SELECT * FROM StarWars.dbo.Characters
SELECT * FROM StarWars.dbo.Starshipsvehicles
SELECT * FROM StarWars.dbo.Weapons

drop table StarWars.dbo.Planets;
drop table StarWars.dbo.Characters;
drop table StarWars.dbo.Starshipsvehicles;
drop table StarWars.dbo.Weapons;