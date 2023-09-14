-- Added spaces after line comment dashes to fix syntax errors.
DROP DATABASE school; -- This allows the script to be re-run without namespace collisions.

-- Create the database and begin to use it
CREATE DATABASE school;
USE school;

-- Create the only table in our database
CREATE TABLE instructors
(
    instructor_id       INT unsigned NOT NULL AUTO_INCREMENT,   -- Each instructor should have their own ID
    inst_first_name     VARCHAR(20) NOT NULL,                   -- Remaining fields are identical
    inst_last_name      VARCHAR(20) NOT NULL,
    campus_phone        VARCHAR(20) NOT NULL,
    PRIMARY KEY         (instructor_id)                         -- Designate instructor_id as the primary key
);

-- We now populate the table with sample data
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) VALUES
    ("Kira","Bently","363-9948"),
    ("Timothy","Ennis","527-4992"),
    ("Shannon","Black","336-5992"),
    ("Estela","Rosales","322-6992");

-- Fetch and display the data
SELECT * 
FROM instructors; /* I'm not sure if, in this context, breaking this into two lines is actually helpful. However, this is
one of the potential pitfalls that is specifically called out in the rubric, so no way am I going to skip it*/