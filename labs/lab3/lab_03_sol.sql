/*
lab 03
Stephen Rout
This script creats a databse of movie ratings, then populates it with content. Afterwards, a new, better-designed databse is created.
*/

#To prevent issues with re-running the code
DROP DATABASE IF EXISTS movie_ratings;

#create and begin to use the new database
CREATE DATABASE movie_ratings;
USE movie_ratings;

CREATE TABLE movies (
    MovieID     INT unsigned NOT NULL AUTO_INCREMENT,   #A unique ID
    MovieTitle  VARCHAR(100) NOT NULL,                  #The official title of the movie
    ReleaseDate DATE NOT NULL,                          #The release date of the movie in the most relevant country
    Genre       VARCHAR(80),                            #A list of genre identifiers - this will not cause any problems down the line!
    PRIMARY KEY (MovieID),                              #As the ID is the only field that can be unique, it serves as  primary key.
    DESCRIPTION TEXT                                            
);

CREATE TABLE consumers
(
    ConsumerID  INT unsigned NOT NULL AUTO_INCREMENT,   #A unique ID
    FirstName   VARCHAR(100) NOT NULL,                  #The first name of the consumer, as chosen by the consumer
    LastName    VARCHAR(100) NOT NULL,                  #The last name of the consumer, as chosen by the consumer
    Address     VARCHAR(100) NOT NULL,                  #The address of the consumer
    City        VARCHAR(50) NOT NULL,                   #The city of residence of the consumer
    State       VARCHAR(4) NOT NULL,                    #The state of resident of the consumer
    ZIPCode     INT unsigned NOT NULL,                  #The zip code of residence of the consumer
    PRIMARY KEY (ConsumerID)                            
);

CREATE TABLE ratings
(
    MovieID     INT unsigned NOT NULL,                  #Foreign key  
    ConsumerID  INT unsigned NOT NULL,                  #Foreign key
    WhenRated   DATE NOT NULL,                          #The date that the rating was written
    NumberStars INT NOT NULL,                           #The overall summary of the rating
    FOREIGN KEY (MovieID) REFERENCES movies(MovieID),   
    FOREIGN KEY (ConsumerID) REFERENCES consumers(ConsumerID),
    PRIMARY KEY (MovieID, ConsumerID)                   #We assume that any given reviewer will only review a given film once, so the combination of the consumer and film IDs will uniquely identify a given review
);

/*
We now begin populating the first database
*/

INSERT INTO movies (MovieTitle, ReleaseDate, Genre)
VALUES  ('The Hunt for Red October', '1990-03-02', 'Action, Adventure, Thriller'),
        ('Lady Bird', '2017-12-01', 'Comedy, Drama'),
        ('Inception', "2010-08-16",'Action, Adventure, Science Fiction'),
        ('Monty Python and the Holy Grail', '1975-04-03', 'Comedy');

INSERT INTO consumers ( FirstName, LastName, Address, City, State, ZIPCode)
VALUES  ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46343),
        ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincetown', 'NJ', 08088),
        ('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
        ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);

INSERT INTO ratings (MovieID, ConsumerID, WhenRated, NumberStars)
VALUES  (1, 1, '2010-09-02 10:54:19', 4),
        (1, 3, '2012-08-05 15:00:01', 3),
        (1, 4, '2016-10-02 23:58:12', 1),
        (2, 3, '2017-03-27 00:12:48', 2),
        (2, 4, '2018-08-02 00:54:42', 4);



/* Generate a report */
SELECT FirstName, LastName, MovieTitle, NumberStars
FROM movies
    NATURAL JOIN consumers
    NATURAL JOIN ratings;


/*
The genres field of the movies table is a multi-part field. I propose to solve this by creating two new 
tables; one table will contain a list of possible genre names, and their associate IDs, and the other table
will be a list of movie-genre relationships, each relationship being a seperate entry.
*/


/*
REDESIGNED TABLES
*/
DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;
USE movie_ratings;

CREATE TABLE movies (
    MovieID     INT unsigned NOT NULL AUTO_INCREMENT,   #A unique ID
    MovieTitle  VARCHAR(100) NOT NULL,                  #The official title of the movie
    ReleaseDate DATE NOT NULL,                          #The release date of the movie in the most relevant country
    PRIMARY KEY (MovieID),                              #As the ID is the only field that can be unique, it serves as  primary key.
    DESCRIPTION TEXT                                            
);

CREATE TABLE consumers
(
    ConsumerID  INT unsigned NOT NULL AUTO_INCREMENT,   #A unique ID
    FirstName   VARCHAR(100) NOT NULL,                  #The first name of the consumer, as chosen by the consumer
    LastName    VARCHAR(100) NOT NULL,                  #The last name of the consumer, as chosen by the consumer
    Address     VARCHAR(100) NOT NULL,                  #The address of the consumer
    City        VARCHAR(50) NOT NULL,                   #The city of residence of the consumer
    State       VARCHAR(4) NOT NULL,                    #The state of resident of the consumer
    ZIPCode     INT unsigned NOT NULL,                  #The zip code of residence of the consumer
    PRIMARY KEY (ConsumerID)                            
);

CREATE TABLE ratings
(
    MovieID     INT unsigned NOT NULL,                  #Foreign key  
    ConsumerID  INT unsigned NOT NULL,                  #Foreign key
    WhenRated   DATE NOT NULL,                          #The date that the rating was written
    NumberStars INT NOT NULL,                           #The overall summary of the rating
    FOREIGN KEY (MovieID) REFERENCES movies(MovieID),   
    FOREIGN KEY (ConsumerID) REFERENCES consumers(ConsumerID),
    PRIMARY KEY (MovieID, ConsumerID)                   #We assume that any given reviewer will only review a given film once, so the combination of the consumer and film IDs will uniquely identify a given review
);

/*
This table will contain a list of valid genres, such as "Action"
*/
CREATE TABLE genres
(
    GenreID     INT unsigned NOT NULL AUTO_INCREMENT,   #Unique identifier for a given genre
    GenreName   VARCHAR(40) NOT NULL,                   #The human-readable genre name.
    PRIMARY KEY (GenreID)                               #For convenience we will use the ID instead of the human-readable name
);

/*
The purpose of this table is to link films with as many genres as needed.
*/
CREATE TABLE film_genres
(
    MovieID     INT unsigned NOT NULL,
    GenreID     INT unsigned NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES movies(MovieID),
    FOREIGN KEY (GenreID) REFERENCES genres(GenreID)
);

/*
Now we once again populate the database with sample data
*/

INSERT INTO genres(GenreName)
VALUES  ('Action'),
        ('Adventure'),
        ('Thriller'),
        ('Comedy'),
        ('Drama'),
        ('Science Fiction');

INSERT INTO movies (MovieTitle, ReleaseDate)
VALUES  ('The Hunt for Red October', '1990-03-02'),
        ('Lady Bird', '2017-12-01'),
        ('Inception', "2010-08-16"),
        ('Monty Python and the Holy Grail', '1975-04-03');

INSERT INTO consumers ( FirstName, LastName, Address, City, State, ZIPCode)
VALUES  ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46343),
        ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincetown', 'NJ', 08088),
        ('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
        ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);

INSERT INTO ratings (MovieID, ConsumerID, WhenRated, NumberStars)
VALUES  (1, 1, '2010-09-02 10:54:19', 4),
        (1, 3, '2012-08-05 15:00:01', 3),
        (1, 4, '2016-10-02 23:58:12', 1),
        (2, 3, '2017-03-27 00:12:48', 2),
        (2, 4, '2018-08-02 00:54:42', 4);

/*
A set of 1 to N film-genre pairs describes the set of genres for a given film.
*/
INSERT INTO film_genres (MovieID, GenreID)
VALUES  (1,1),
        (1,2),
        (1,3),
        (2,4),
        (2,5),
        (3,1),
        (3,2),
        (3,6),
        (4,4);

