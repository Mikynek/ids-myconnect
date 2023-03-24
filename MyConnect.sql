-- SQL Script
-- Authors: Jakub Mikysek (xmikys03), Gabriel Biel (xbielg00)
--
--
DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Zprava CASCADE CONSTRAINTS;
DROP TABLE Prispevek CASCADE CONSTRAINTS;
DROP TABLE Akce CASCADE CONSTRAINTS;
DROP TABLE Alba CASCADE CONSTRAINTS;
DROP TABLE Fotky CASCADE CONSTRAINTS;
DROP TABLE Videa CASCADE CONSTRAINTS;

CREATE TABLE Uzivatel (
    id_uzivatel NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- create generated primary key
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_narozeni DATE NOT NULL,
    pohlavi CHAR(1) CHECK (pohlavi IN ('M', 'Z')),
    ulice VARCHAR(20),
    mesto VARCHAR(20),
    zamestnani VARCHAR(30),
    mail VARCHAR(30) NOT NULL,
    skola VARCHAR(30),
    vztah CHAR(1) CHECK (vztah IN ('S', 'Z'))

);

CREATE TABLE Konverzace (
    id_konverzace NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(20) NOT NULL,
    poradi_zpravy INTEGER,  -- Foreign Key
    seznam_clenu VARCHAR(40)    -- switch for VARBINARY(size) ?
);

CREATE TABLE Zprava (
    poradi_zpravy INTEGER,  -- Foreign Key
    obsah VARCHAR(255),
    datum TIMESTAMP, -- time included
    misto VARCHAR(20)
);

CREATE TABLE Akce (
    id_akce NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(50) NOT NULL,
    datum DATE NOT NULL,
    misto VARCHAR(20),
    typ_udalosti VARCHAR(10) CHECK(typ_udalosti IN ('fyzicka', 'virtualni'))   
);

CREATE TABLE Alba (
    id_alba NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(40) NOT NULL,
    nastaveni_soukromi CHAR(1) CHECK (nastaveni_soukromi IN ('Y', 'N')),
    popis VARCHAR(255)
);

CREATE TABLE Prispevek (
    id_prispevek NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(3071)
);

CREATE TABLE Fotky (
    id_fotky NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    panorama CHAR(1) CHECK (panorama IN ('Y', 'N')),
    pomer_stran DECIMAL(4,2),
    id_prispevek NUMBER,
    FOREIGN KEY (id_prispevek) REFERENCES Prispevek(id_prispevek)
);


CREATE TABLE Videa (
    id_videa NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    delka TIMESTAMP,
    kvalita INTEGER CHECK( kvalita IN (360, 480, 720, 1080) ),
    FPS INTEGER,
    id_prispevek NUMBER,
    FOREIGN KEY (id_prispevek) REFERENCES Prispevek(id_prispevek)
);

