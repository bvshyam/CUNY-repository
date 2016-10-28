-- crimedb.sql


DROP TABLE IF EXISTS crimedata;

DROP TABLE IF EXISTS monthtab;
DROP TABLE IF EXISTS daytab;
DROP TABLE IF EXISTS city;

-- TABLE CITY

CREATE TABLE city 
(
  citycode varchar(20) NOT NULL,
  cityname varchar(200) NOT NULL,
  PRIMARY KEY (citycode)
);

LOAD DATA INFILE 'F:/data/crime/city.csv' 
INTO TABLE city
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(citycode, cityname)
;



-- TABLE DAYTAB

CREATE TABLE daytab 
(
  daynum int NOT NULL,
  dayofweek varchar(200) NOT NULL,
  PRIMARY KEY (dayofweek)
);

LOAD DATA INFILE 'F:/data/crime/daytab.csv' 
INTO TABLE daytab
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(daynum, dayofweek)
;


-- TABLE MONTHTAB

CREATE TABLE monthtab 
(
  
  monthshort varchar(5) NOT NULL,
  monthnum int NOT NULL,
  monthdesc varchar(200) NOT NULL,
  PRIMARY KEY (monthshort)
);

LOAD DATA INFILE 'F:/data/crime/monthtab.csv' 
INTO TABLE monthtab
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(monthshort, monthnum, monthdesc)
;



-- TABLE CRIMEDATA


CREATE TABLE crimedata 
(
  citycode varchar(20) NOT NULL,
  offenseid varchar(200) NOT NULL,
  offense varchar(500) NOT NULL,
  offenselocaldate date NOT NULL,
  offenselocaltime time NOT NULL, 
  dayofweek varchar(200) NOT NULL,
  offensehour int,
  offensemonth varchar(5) NOT NULL,
  offensearea varchar(100),
   PRIMARY KEY (offenseid),
   CONSTRAINT FK_city FOREIGN KEY (citycode) 
    REFERENCES city(citycode)
    ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FK_dayofweek FOREIGN KEY (dayofweek) 
    REFERENCES daytab(dayofweek)
    ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FK_month FOREIGN KEY (offensemonth) 
    REFERENCES monthtab(monthshort)
    ON DELETE CASCADE ON UPDATE CASCADE
    
);




SELECT * FROM crimedata;
SELECT COUNT(*) FROM crimedata;
SELECT * FROM daytab;
SELECT COUNT(*) FROM daytab;
SELECT * FROM monthtab;
SELECT COUNT(*) FROM monthtab;
SELECT * FROM city;
SELECT COUNT(*) FROM city;


