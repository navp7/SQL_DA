-- create database
CREATE DATABASE music_store;

-- use database
USE music_store;

-- create table employee
CREATE TABLE employee(
employee_id INT AUTO_INCREMENT,
last_name VARCHAR(20) NOT NULL,
first_name VARCHAR(20) NOT NULL,
title VARCHAR(30) NOT NULL,
reports_to INT,
levels VARCHAR(5),
birthdate datetime,
hire_date datetime,
address VARCHAR(50),
city VARCHAR(20),
state VARCHAR(15),
country VARCHAR(20),
postal_code VARCHAR(20),
phone VARCHAR(20),
fax VARCHAR(20),
email VARCHAR(30),
PRIMARY KEY (employee_id));


-- create table customer
CREATE TABLE customer(
customer_id INT AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
company VARCHAR(100) ,
address VARCHAR(50),
city VARCHAR(20),
state VARCHAR(15),
country VARCHAR(20),
postal_code VARCHAR(20),
phone VARCHAR(20),
fax VARCHAR(20),
email VARCHAR(30),
support_rep_id INT,
PRIMARY KEY (customer_id)
);


-- create table invoice
CREATE TABLE invoice(
invoice_id INT,
customer_id INT ,
invoice_date DATETIME ,
billing_address VARCHAR(50),
billing_city VARCHAR(30),
billing_state VARCHAR(20),
billing_country VARCHAR(30),
billing_postal_code VARCHAR(10),
total FLOAT,
PRIMARY KEY (invoice_id)
);


-- create table invoice_line
CREATE TABLE invoice_line(
invoice_line_id INT,
invoice_id INT,
track_id INT,
unit_price FLOAT,
quantity INT,
PRIMARY KEY (invoice_line_id)
);


-- create table playlist
CREATE TABLE playlist(
playlist_id INT,
name VARCHAR(100),
PRIMARY KEY (playlist_id)
);

-- create table artist
CREATE TABLE artist(
artist_id INT,
name VARCHAR(100),
PRIMARY KEY (artist_id));


-- create table album
CREATE TABLE album(
album_id INT,
title VARCHAR(100),
artist_id INT,
PRIMARY KEY (album_id)
);

-- create table media_type
CREATE TABLE media_type (
media_type_id INT,
name VARCHAR(100),
PRIMARY KEY (media_type_id)
);



-- create table genre
CREATE TABLE genre (
genre_id INT,
name VARCHAR(80),
PRIMARY KEY (genre_id)
);


-- create table track
CREATE TABLE track(
track_id INT,
name VARCHAR(100),
album_id INT,
media_type_id INT,
genre_id INT,
composer VARCHAR(100),
milliseconds MEDIUMINT unsigned,
bytes MEDIUMINT unsigned,
unit_price FLOAT,
PRIMARY KEY(track_id)
);

-- Altering some column data type to store data correctly:
ALTER TABLE track
MODIFY milliseconds INT unsigned;

ALTER TABLE track
MODIFY bytes INT unsigned ;

ALTER TABLE track
MODIFY name VARCHAR(150) ;

ALTER TABLE track
MODIFY composer VARCHAR(200) ;


-- create table playlist_track
CREATE TABLE playlist_track(
playlist_id INT,
track_id INT,
FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
FOREIGN KEY (track_id) REFERENCES track(track_id)
);


-- Adding constraints to build relation among tables:

ALTER TABLE customer
ADD 
CONSTRAINT fk_customer
FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id);


ALTER TABLE invoice
ADD 
CONSTRAINT fk_invoice
FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


ALTER TABLE invoice_line
ADD 
CONSTRAINT fk_invoice_line
FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id);


ALTER TABLE invoice_line
ADD 
CONSTRAINT fk_invoice_line_track
FOREIGN KEY (track_id) REFERENCES track(track_id);


ALTER TABLE playlist_track
ADD 
CONSTRAINT fk_playlist_track_id
FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id);


ALTER TABLE playlist_track
ADD 
CONSTRAINT fk_playlist_id
FOREIGN KEY (track_id) REFERENCES track(track_id);


ALTER TABLE album
ADD 
CONSTRAINT fk_album
FOREIGN KEY (artist_id) REFERENCES artist(artist_id);


ALTER TABLE track
ADD 
CONSTRAINT fk_track_album
FOREIGN KEY (album_id) REFERENCES album(album_id);

ALTER TABLE track
ADD 
CONSTRAINT fk_track_media
FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id);

ALTER TABLE track
ADD 
CONSTRAINT fk_track_genre
FOREIGN KEY (genre_id) REFERENCES genre(genre_id);

ALTER TABLE employee
ADD 
CONSTRAINT fk_employee
FOREIGN KEY (reports_to) REFERENCES employee(employee_id);



