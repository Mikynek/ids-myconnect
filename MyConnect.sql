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
    id_uzivatel INTEGER, -- create generated primary key
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_narozeni DATE NOT NULL,
    pohlavi CHAR(4),   --muz/zena
    ulice VARCHAR(20),
    mesto VARCHAR(20),
    zamestnani VARCHAR(30),
    mail VARCHAR(30) NOT NULL,
    skola VARCHAR(30),
    vztah CHAR(1)   --> BOOL Y-in relationship/N-single
);

CREATE TABLE Konverzace (
    id_konverzace INTEGER,
    nazev VARCHAR(20) NOT NULL,
    seznam_clenu VARCHAR(40)    -- switch for VARBINARY(size) ?
);

CREATE TABLE Zprava (
    poradi_zpravy INTEGER,  -- Foreign Key
    obsah VARCHAR(255),
    datum TIMESTAMP, -- time included
    misto VARCHAR(20)
);

CREATE TABLE Prispevek (
    id_prispevek INTEGER,
    datum DATE,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(3071)
);

CREATE TABLE Akce (
    id_akce INTEGER,
    nazev VARCHAR(50) NOT NULL,
    datum DATE NOT NULL,
    misto VARCHAR(20),
    typ_udalosti VARCHAR(10) CHECK( typ_udalosti IN ('fyzicka', 'virtualni'))
);

CREATE TABLE Alba (
    id_alba INTEGER,
    nazev VARCHAR(40) NOT NULL,
    nastaveni_soukromi CHAR(1), --> BOOL Y-public / N-private
    popis VARCHAR(255)
);

-- INHERITANCE information-src: https://www.sql.org/sql-database/postgresql/manual/tutorial-inheritance.html
CREATE TABLE Fotky (
    panorama CHAR(1),   -- Y/N
    pomer_stran DECIMAL(4,2)
) INHERITS (Alba);

CREATE TABLE Videa (
    delka TIMESTAMP,
    kvalita INTEGER CHECK( kvalita IN (360, 480, 720, 1080) ),
    FPS INTEGER
) INHERITS (Alba);


ALTER TABLE Uzivatel 
    ADD CONSTRAINT PK_uzivatel PRIMARY KEY (id_uzivatel);
ALTER TABLE Konverzace 
    ADD CONSTRAINT PK_konverzace PRIMARY KEY (id_konverzace);
-- FOREIGN KEY Zprava
ALTER TABLE Konverzace
    ADD CONSTRAINT FK_zprava
    FOREIGN KEY (poradi_zpravy) REFERENCES Zprava(poradi_zpravy) ON DELETE CASCADE;
ALTER TABLE Prispevek
    ADD CONSTRAINT PK_prispevek PRIMARY KEY (id_prispevek);
ALTER TABLE Akce
    ADD CONSTRAINT PK_akce PRIMARY KEY (id_akce);
ALTER TABLE Alba
    ADD CONSTRAINT PK_alba PRIMARY KEY (id_alba);


-- Priklad naplneni tabulky daty
INSERT INTO Alba
    VALUES(42,'Dovolena Izreal','Y','Dovolena super!');
INSERT INTO Alba
    VALUES(43,'Narozeniny Pepa','N','Syn 3 roky');