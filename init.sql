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


/********
ENTITY TABLES
***********/


CREATE TABLE AppUser (
    username 	varchar(50) PRIMARY KEY,
    firstName	varchar(20) NOT NULL,
    lastName 	varchar(20) NOT NULL,
    password 	varchar(50) NOT NULL,
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



/****************************************************************
DATA INSERTION
****************************************************************/
insert into AppUser values ('user1', 'Cart', 'Klemensiewicz', 'password', 2863945039);
insert into AppUser values ('user2', 'Kit', 'Thurlow', 'password', 8215865769);
insert into AppUser values ('user3', 'Brynna', 'Fetter', 'password', 7734451473);
insert into AppUser values ('user4', 'Silvester', 'Churly', 'password', 1365739490);
insert into AppUser values ('user5', 'Hugo', 'Shoesmith', 'password', 3436796564);
insert into AppUser values ('user6', 'Theodor', 'MacCostigan', 'password', 2055996866);
insert into AppUser values ('user7', 'Heriberto', 'Antusch', 'password', 3029039526);
insert into AppUser values ('user8', 'Georgia', 'Morgue', 'password', 5377426205);
insert into AppUser values ('user9', 'Marius', 'Reavell', 'password', 9725999259);
insert into AppUser values ('user10', 'Pennie', 'Nelle', 'password', 2645471052);
insert into AppUser values ('user11', 'Derick', 'Kennaway', 'password', 5185617186);
insert into AppUser values ('user12', 'Othelia', 'Divine', 'password', 9182609085);
insert into AppUser values ('user13', 'Concordia', 'Kobierra', 'password', 5544703777);
insert into AppUser values ('user14', 'Sonnie', 'Llop', 'password', 3995005082);
insert into AppUser values ('user15', 'Estella', 'McCroary', 'password', 4832356120);
insert into AppUser values ('user16', 'Joanie', 'Wanley', 'password', 7106811550);
insert into AppUser values ('user17', 'Hillary', 'Izon', 'password', 5355440695);
insert into AppUser values ('user18', 'Hew', 'Leakner', 'password', 4794001078);
insert into AppUser values ('user19', 'Mallissa', 'Mahmood', 'password', 9435003533);
insert into AppUser values ('user20', 'Jocelyn', 'Seabrook', 'password', 6749453810);

insert into Passenger values ('user1');
insert into Passenger values ('user2');
insert into Passenger values ('user3');
insert into Passenger values ('user4');
insert into Passenger values ('user5');
insert into Passenger values ('user6');
insert into Passenger values ('user7');
insert into Passenger values ('user8');
insert into Passenger values ('user9');
insert into Passenger values ('user10');
insert into Passenger values ('user11');
insert into Passenger values ('user12');
insert into Passenger values ('user13');
insert into Passenger values ('user14');
insert into Passenger values ('user15');
insert into Passenger values ('user16');
insert into Passenger values ('user17');
insert into Passenger values ('user18');
insert into Passenger values ('user19');
insert into Passenger values ('user20');

INSERT INTO Driver VALUES ('user4', NULL, 1234567);
