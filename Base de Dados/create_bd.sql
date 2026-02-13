-- Drop the data base in case there is lready one with the same name followed by the creation of the same.
drop database if exists proj;
create database if not exists proj;
use proj;

-- Creation of the Table Brand that will represent the different brands of watches.
drop table if exists brand;
create table brand(
	name VARCHAR(50) PRIMARY KEY -- Limited to 50 characters because brand names do not tend to be very long.
);

-- Creation of the Table Contacts that will represent the various contacts that a brand can possibly have.
drop table if exists contacts;
create table contacts(
	contact_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    site VARCHAR(100) NULL, 
    brand_fk VARCHAR(50), -- The FK that will identify the brand to what these contacts belong.
	FOREIGN KEY (brand_fk) REFERENCES brand(name) 
);

-- Creation of the Table Model that will represent the model of the watch.
drop table if exists model;
create table model(
	designation VARCHAR(100) PRIMARY KEY, -- Model name
	color VARCHAR(50) NOT NULL, 
	material VARCHAR(50) NOT NULL, -- The main material of what the watch is made
    special_edition BOOLEAN NOT NULL,
    vintage BOOLEAN NOT NULL 
);

-- Creation of the table Watch that will represent the individual watches that the auctioneer have in "stock".
drop table if exists watch;
create table watch(
	watch_id INT auto_increment PRIMARY KEY,
    fabrication_year INT NOT NULL,
    is_new BOOLEAN NOT NULL -- First hand or has been used (still "in the box" or has been on a wrist).
);

-- Creation of the Table batch_state 
drop table if exists batch_state;
create table batch_state(
	state_desc VARCHAR(50) NOT NULL UNIQUE --  Designation of the state of the batch ex: selling, not sold or sold.
);

-- Creation of the Table Batch that will represent a group of watches or just one ready to be put on auction.
drop table if exists batch;
create table batch(
	batch_id INT auto_increment PRIMARY KEY,
	base_price DECIMAL(10,2) NOT NULL, -- Inicial price of the batch before any bidding.
	state_fk VARCHAR(50) NOT NULL, -- The state of the batch at the moment (sold, no solt or selling).
    FOREIGN KEY (state_fk) REFERENCES batch_state(state_desc)
    -- category dont remember
);

-- Creation of the Table Session that will represent a session of an auction where participants can make biddings.
drop table if exists session;
create table session(
	session_id INT auto_increment PRIMARY KEY,
	session_date DATE NOT NULL, -- The day when the session will take place
	start_session TIME NOT NULL, -- The hour of the opening of the session
    end_session TIME NOT NULL -- The hour of the closing of the session
);

-- Creation of the Table bidding that will represent the bidding made on a session of an auction. 
drop table if exists bidding;
create table bidding(
	bidding_id INT auto_increment PRIMARY KEY,
    value NUMERIC(11,2) NOT NULL -- Value of the bidding.
);

-- Creation of the Table auction_state that represent the state on what the action is at the moment.
drop table if exists auction_state;
create table auction_state(
	state_desc VARCHAR(50) NOT NULL UNIQUE --  Designation of the state of the auction ex: canceled, open or close.
);

-- Creation of the Table Auction that will represent the auction and "store" the sessions.
drop table if exists auction;
create table auction(
	auction_id INT auto_increment PRIMARY KEY,
    start_date DATE NOT NULL,	-- The day of opening of the auction
	final_date DATE NULL,	-- The day of ending of the auction
	locality VARCHAR(100) NOT NULL, -- Where the auction will take place
    auction_description VARCHAR(200) NULL, -- Optional description of the auction
	state_fk VARCHAR(50) NOT NULL, -- The state of the auction at the moment (open, close or canceled).
    FOREIGN KEY (state_fk) REFERENCES auction_state(state_desc) -- List of possible states in which the auction can be found
);

-- Creation of the Table Organizer that will represent the person responsible for organizing the auction
drop table if exists organizer;
create table organizer(
	organizer_id INT auto_increment PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	contact VARCHAR(50) NOT NULL, 
    address VARCHAR(100) NOT NULL 
);

--  Model -> brand
ALTER TABLE model ADD COLUMN brand_fk VARCHAR(50) NOT NULL; -- Adding the column that will associate the Brand and Model of the watch. 
ALTER TABLE model ADD CONSTRAINT FOREIGN KEY(brand_fk) REFERENCES brand(name);

-- watch -> Model
ALTER TABLE watch ADD COLUMN model_fk VARCHAR(100) NOT NULL; -- Adding the column that will associate the Model of the watch to the watch.
ALTER TABLE watch ADD CONSTRAINT FOREIGN KEY(model_fk) REFERENCES model(designation); 

-- auction -> Organizer 
ALTER TABLE auction ADD COLUMN organizer_fk INT NOT NULL; -- Adding the column that will associate the auction and his respective organizer.
ALTER TABLE auction ADD CONSTRAINT FOREIGN KEY(organizer_fk) REFERENCES organizer(organizer_id);

-- Session -> auction
ALTER TABLE session ADD COLUMN auction_fk INT NOT NULL; -- Adding the column that will associate the session to his auction.
ALTER TABLE session ADD CONSTRAINT FOREIGN KEY(auction_fk) REFERENCES auction(auction_id);

-- bidding -> Session
ALTER TABLE bidding ADD COLUMN session_fk INT NOT NULL; -- Adding the column that will associate the bidding and the session in wich it was made.
ALTER TABLE bidding ADD CONSTRAINT FOREIGN KEY(session_fk) REFERENCES session(session_id);

-- bidding -> batch
ALTER TABLE bidding ADD COLUMN batch_fk INT NOT NULL; --  Adding the column that will associate the bidding and the batch and the biddings made to that batch.
ALTER TABLE bidding ADD CONSTRAINT FOREIGN KEY(batch_fk) REFERENCES batch(batch_id);

-- Creation of the Table (batch <-> Session) wich will associate the batch that are in a certain session.
drop table if exists batch_session;
create table batch_session (
    batch_id INT NOT NULL,
    session_id INT NOT NULL,
    PRIMARY KEY (batch_id, session_id),
    FOREIGN KEY (batch_id) REFERENCES batch(batch_id),
    FOREIGN KEY (session_id) REFERENCES session(session_id)
);

-- Creation of the Table (batch <-> watch) wich will associate the batch and the watches in him.
drop table if exists watch_batch;
create table watch_batch (
    watch_id INT NOT NULL,
    batch_id INT NOT NULL,
    PRIMARY KEY (watch_id, batch_id),
    FOREIGN KEY (watch_id) REFERENCES watch(watch_id),
    FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
);

-- Creation of the Table Participant that will represent the participants registered in the system
drop table if exists Participant;
CREATE TABLE participant (
    participant_id INT auto_increment PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    locality VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    cc_number VARCHAR(20) NOT NULL,
    recommends_id INT NULL, -- recommends another participant
    CONSTRAINT recommends_id FOREIGN KEY (recommends_id) REFERENCES participant(participant_id)
);

-- Creation of the Table bidder that will represent a participant that is a bidder.
drop table if exists bidder;
CREATE TABLE bidder (
    participant_id INT PRIMARY KEY,
    FOREIGN KEY (participant_id) REFERENCES participant(participant_id)
);

-- Creation of the Table seller that will represent a participant that is a seller.
drop table if exists seller;
CREATE TABLE seller (
    participant_id INT PRIMARY KEY,
    FOREIGN KEY (participant_id) REFERENCES participant(participant_id)
);

-- (Bidder <-> Bidding)
ALTER TABLE bidding ADD COLUMN bidder_fk INT NOT NULL; --  Adding the column that will associate the bidding and the bidder.
ALTER TABLE bidding ADD CONSTRAINT fk_bidding_bidder FOREIGN KEY (bidder_fk) REFERENCES bidder(participant_id);
        
-- (Seller <-> Batch)
ALTER TABLE batch ADD COLUMN seller_fk INT NOT NULL; -- Adding the column that will associate the batch and is seller.
ALTER TABLE batch ADD CONSTRAINT fk_batch_seller FOREIGN KEY (seller_fk) REFERENCES seller(participant_id);

-- (Participant <-> Watch)
ALTER TABLE watch ADD COLUMN participant_fk INT NULL; -- Adding the column that will associate the participant and is watch/s.
ALTER TABLE watch ADD CONSTRAINT participant FOREIGN KEY (participant_fk) REFERENCES participant(participant_id);

-- Creation of the Table (participant <-> auction) wich will associate the participants taht participate in an auction.
drop table if exists participant_auction;
create table participant_auction (
    participant_id INT NOT NULL,
    auction_id INT NOT NULL,
    PRIMARY KEY (participant_id, auction_id),
    FOREIGN KEY (participant_id) REFERENCES participant(participant_id),
    FOREIGN KEY (auction_id) REFERENCES auction(auction_id)
);










