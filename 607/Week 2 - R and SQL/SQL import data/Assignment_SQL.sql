create database tb

use tb


/*
  tb.sql
*/

DROP TABLE IF EXISTS tb;

CREATE TABLE tb 
(
  country varchar(100) NOT NULL,
  year int NOT NULL,
  sex varchar(6) NOT NULL,
  child int NULL,
  adult int NULL,
  elderly int NULL
);

SELECT * FROM tb;

LOAD DATA INFILE 'C:/CUNY/Courses/607/Week 2 - Sep 4th/Assignment/SQL import data/tb.csv' 
INTO TABLE tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(country, year, sex, @child, @adult, @elderly)
SET
child = nullif(@child,-1),
adult = nullif(@adult,-1),
elderly = nullif(@elderly,-1)
;

SELECT * FROM tb WHERE elderly IS NULL;
SELECT COUNT(*) FROM tb;


create database movies

use movies

CREATE TABLE reviews1 (
  Votes int(11) DEFAULT NULL,
  Rank double DEFAULT NULL,
  Title text
) ;


select * from reviews

