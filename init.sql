CREATE TABLE AppUser (
	username 	varchar(50) PRIMARY KEY,
	password 	varchar(50) NOT NULL,
	firstName	varchar(20) NOT NULL,
	lastName 	varchar(20) NOT NULL,
	phoneNumber	varchar(20) NOT NULL
);

CREATE TABLE Driver (
	username 	varchar(50) PRIMARY KEY REFERENCES AppUser ON DELETE CASCADE,
	d_rating 	INTEGER,
	license_no 	INTEGER NOT NULL
);

CREATE TABLE Passenger (
	username varchar(50) PRIMARY KEY REFERENCES AppUser ON DELETE CASCADE,
	p_rating INTEGER
);

CREATE TABLE Model (
	name	varchar(20),
	brand 	varchar(50),
    size 	INTEGER NOT NULL,
	PRIMARY KEY (name, brand)
);

CREATE TABLE Car (
	plateNumber varchar(20) PRIMARY KEY,
    colours  	varchar(20) NOT NULL
);

CREATE TABLE Promo (
	promoCode 	varchar(20) PRIMARY KEY,
	quotaLeft 	INTEGER NOT NULL,
	maxDiscount INTEGER,
	minPrice 	INTEGER,		
	discount 	INTEGER NOT NULL	
);

CREATE TABLE Ride (
	rideID 		SERIAL PRIMARY KEY,
    p_comment 	varchar(50),
    p_rating	INTEGER,
    d_comment 	varchar(50),
    d_rating 	INTEGER	
);

CREATE TABLE Place (
	name varchar(50) PRIMARY KEY
);

CREATE TABLE Advertisement (
	timePosted 		TIMESTAMP,
	driverID 		varchar(50) REFERENCES Driver ON DELETE CASCADE,
    numPassengers 	INTEGER 	NOT NULL,
    departureTime 	INTEGER 	NOT NULL,
    price 			INTEGER 	NOT NULL,
    toPlace 		varchar(50) NOT NULL REFERENCES Place,
    fromPlace 		varchar(50) NOT NULL REFERENCES Place,

	PRIMARY KEY (timePosted, driverID)
);


/****************************************************************
RELATIONSHIPS
****************************************************************/
CREATE TABLE Creates (	-- Driver creates advertisement; weak entity
	timePosted	TIMESTAMP,
	username	varchar(50) REFERENCES Driver ON DELETE CASCADE,
	PRIMARY KEY (timePosted, username)
);

CREATE TABLE Bids (
	passengerID 	varchar(50) REFERENCES Passenger ON DELETE CASCADE,
	driverID 		varchar(50) REFERENCES Driver	 ON DELETE CASCADE,
	timePosted 		TIMESTAMP,
	price 			INTEGER,
	status			varchar(20),
	no_passengers 	INTEGER,
	PRIMARY KEY (passengerID, timePosted, driverID)
);

CREATE TABLE Schedules (
	rideID		INTEGER 	REFERENCES Ride,
	passengerID	varchar(50) NOT NULL,
	driverID 	varchar(50) NOT NULL,
	timePosted 	TIMESTAMP 	NOT NULL,
	status		varchar(20)	DEFAULT 'pending',
	PRIMARY KEY (rideID),
	FOREIGN KEY (passengerID, timePosted, driverID) REFERENCES Bids,

	CHECK (status = 'pending' OR status = 'ongoing' OR status = 'completed')
);

CREATE TABLE Redeems (
	rideID		INTEGER 	PRIMARY KEY REFERENCES Ride,
	promoCode	varchar(20) NOT NULL 	REFERENCES Promo,
	username 	varchar(50) NOT NULL 	REFERENCES Passenger
);

CREATE TABLE Owns (
	driverID	varchar(50) REFERENCES Driver,
	plateNumber	varchar(20) REFERENCES Car,
	PRIMARY KEY (driverID, plateNumber)
);

CREATE TABLE Belongs (
	plateNumber	varchar(20) REFERENCES Car,
	name		varchar(20)	NOT NULL,
	brand 		varchar(50) NOT NULL,
	PRIMARY KEY (plateNumber),
	FOREIGN KEY (name, brand) REFERENCES Model
);

/*****************
For our own debuggging only
******************/
DROP TABLE IF EXISTS AppUser CASCADE;
DROP TABLE IF EXISTS Driver CASCADE;
DROP TABLE IF EXISTS Passenger CASCADE;
DROP TABLE IF EXISTS Model CASCADE;
DROP TABLE IF EXISTS Car CASCADE;
DROP TABLE IF EXISTS Promo CASCADE;
DROP TABLE IF EXISTS Ride CASCADE;
DROP TABLE IF EXISTS Place CASCADE;
DROP TABLE IF EXISTS Advertisement CASCADE;
DROP TABLE IF EXISTS Creates CASCADE;
DROP TABLE IF EXISTS Bids CASCADE;
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS Redeems CASCADE;
DROP TABLE IF EXISTS Owns CASCADE;
DROP TABLE IF EXISTS Belongs CASCADE;



/****************************************************************
DATA INSERTION
****************************************************************/
insert into AppUser values ('user1', 'Cart', 'Klemensiewicz', '88 Hudson Crossing', 'password', 2863945039);
insert into AppUser values ('user2', 'Kit', 'Thurlow', '56695 Cambridge Hill', 'password', 8215865769);
insert into AppUser values ('user3', 'Brynna', 'Fetter', '6683 Sundown Park', 'password', 7734451473);
insert into AppUser values ('user4', 'Silvester', 'Churly', '82 Bellgrove Pass', 'password', 1365739490);
insert into AppUser values ('user5', 'Hugo', 'Shoesmith', '7 Sunfield Lane', 'password', 3436796564);
insert into AppUser values ('user6', 'Theodor', 'MacCostigan', '6 Chive Crossing', 'password', 2055996866);
insert into AppUser values ('user7', 'Heriberto', 'Antusch', '981 Briar Crest Way', 'password', 3029039526);
insert into AppUser values ('user8', 'Georgia', 'Morgue', '6972 Carberry Point', 'password', 5377426205);
insert into AppUser values ('user9', 'Marius', 'Reavell', '8544 Eggendart Lane', 'password', 9725999259);
insert into AppUser values ('user10', 'Pennie', 'Nelle', '2 Ridgeview Drive', 'password', 2645471052);
insert into AppUser values ('user11', 'Derick', 'Kennaway', '76300 Kim Junction', 'password', 5185617186);
insert into AppUser values ('user12', 'Othelia', 'Divine', '66 Esch Parkway', 'password', 9182609085);
insert into AppUser values ('user13', 'Concordia', 'Kobierra', '42 Esker Way', 'password', 5544703777);
insert into AppUser values ('user14', 'Sonnie', 'Llop', '4336 2nd Terrace', 'password', 3995005082);
insert into AppUser values ('user15', 'Estella', 'McCroary', '16 Holmberg Drive', 'password', 4832356120);
insert into AppUser values ('user16', 'Joanie', 'Wanley', '17902 Summit Point', 'password', 7106811550);
insert into AppUser values ('user17', 'Hillary', 'Izon', '50 Fuller Road', 'password', 5355440695);
insert into AppUser values ('user18', 'Hew', 'Leakner', '93231 Starling Junction', 'password', 4794001078);
insert into AppUser values ('user19', 'Mallissa', 'Mahmood', '90 Loftsgordon Road', 'password', 9435003533);
insert into AppUser values ('user20', 'Jocelyn', 'Seabrook', '68 Mifflin Junction', 'password', 6749453810);

INSERT INTO Driver VALUES ('user4', NULL, 1234567);
