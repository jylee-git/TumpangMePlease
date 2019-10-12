CREATE TABLE AppUser (
	username varchar(50) PRIMARY KEY,
	password varchar(50) NOT NULL,
    firstName varchar(20) NOT NULL,
    lastName varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    phoneNumber integer NOT NULL
);

CREATE TABLE Driver (
	username varchar(50) PRIMARY KEY REFERENCES AppUser ON DELETE cascade,
	d_rating integer,
	license_no integer NOT NULL
);

CREATE TABLE Passenger (
	username varchar(50) PRIMARY KEY REFERENCES AppUser ON DELETE cascade,
	p_rating integer
);

CREATE TABLE Model (
	name varchar(20),
	brand varchar(50),
    size INTEGER NOT NULL,
	PRIMARY KEY (name, brand)
);

CREATE TABLE Car (
	plateNumber varchar(20) PRIMARY KEY,
    colours  varchar(20) NOT NULL
);

CREATE TABLE Promo (
	promoCode varchar(20) PRIMARY KEY,
	quotaLeft integer NOT NULL,
	maxDiscount integer,   -- Can we put default here?
	minPrice integer,		
	discount integer NOT NULL	
);

CREATE TABLE Ride (
	rideID varchar(20) PRIMARY KEY,	-- Is this auto increment?
    p_comment varchar(50),
    p_rating integer,
    d_comment varchar(50),
    d_rating integer	
);

CREATE TABLE Advertisement (
	timePosted integer PRIMARY KEY,	-- Change to AdID instead? Since this is a driverID concat with time
    numPassengers integer NOT NULL,
    departureTime integer NOT NULL,
    price integer NOT NULL,
    toPlace varchar(50) NOT NULL,
    fromPlace varchar(50) NOT NULL
);


/****************************************************************
RELATIONSHIPS
****************************************************************/
CREATE TABLE Creates (	-- Driver creates advertisement; weak entity
	timePosted	integer,
	username	varchar(50) REFERENCES Driver ON DELETE cascade,
	PRIMARY KEY (timePosted, username)
);

CREATE TABLE Bids (
	username 		varchar(50)	REFERENCES Passenger (username),
	timePosted 		integer 	REFERENCES Advertisement ON DELETE CASCADE,
	time 			integer 	NOT NULL,
	price			integer,
	status			varchar(20),
	no_passengers	integer,
	PRIMARY KEY (username, timePosted)
);

CREATE TABLE Schedules (
	rideID		varchar(20) REFERENCES Ride,
	username 	varchar(50),
	timePosted 	integer,
	status		varchar(20),
PRIMARY KEY (rideID, username, timePosted),
FOREIGN KEY (username, timePosted) REFERENCES Bids (username, timePosted)
);

CREATE TABLE Redeems (
	rideID		varchar(20) REFERENCES Ride,
	promoCode	varchar(20) REFERENCES Promo,
	username 	varchar(50) REFERENCES Passenger,
PRIMARY KEY (rideID, promoCode, username)
);

CREATE TABLE Owns (
	username	varchar(50) REFERENCES Driver,
	plateNumber	varchar(20) REFERENCES Car,
	PRIMARY KEY (username, plateNumber)
);

CREATE TABLE Belongs (
	plateNumber	varchar(20) REFERENCES Car,
	name		varchar(20),
	brand 		varchar(50),
	PRIMARY KEY (plateNumber, name),
	FOREIGN KEY (name, brand) REFERENCES Model
);

/*****************
For our own debuggging only
******************/
DROP TABLE IF EXISTS AppUser;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Advertisement;
DROP TABLE IF EXISTS Ride;
DROP TABLE IF EXISTS Redeems;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Owns;
DROP TABLE IF EXISTS Belongs;
DROP TABLE IF EXISTS Creates;
DROP TABLE IF EXISTS Bids;
DROP TABLE IF EXISTS Schedules;
DROP TABLE IF EXISTS Promo;


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

INSERT INTO Driver VALUES ('user4', , 'S1234567C');
