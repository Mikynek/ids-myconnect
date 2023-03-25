-- SQL Script
-- Authors: Jakub Mikysek (xmikys03), Gabriel Biel (xbielg00)
--
--
DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Pritelstvi CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Konverzace_ucastnici CASCADE CONSTRAINTS;
DROP TABLE Zprava CASCADE CONSTRAINTS;
DROP TABLE Akce CASCADE CONSTRAINTS;
DROP TABLE Akce_ucastnici CASCADE CONSTRAINTS;
DROP TABLE Alba CASCADE CONSTRAINTS;
DROP TABLE Prispevek CASCADE CONSTRAINTS;
DROP TABLE Prispevek_zminil CASCADE CONSTRAINTS;
DROP TABLE Fotky CASCADE CONSTRAINTS;
DROP TABLE Videa CASCADE CONSTRAINTS;

CREATE TABLE Uzivatel (
    id INTEGER GENERATED ALWAYS 
    AS IDENTITY PRIMARY KEY, -- create generated primary key
    mail VARCHAR(30) NOT NULL UNIQUE,
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_narozeni DATE NOT NULL,
    pohlavi CHAR(1) CHECK (pohlavi IN ('M', 'Z')),
    mesto VARCHAR(20),
    ulice VARCHAR(20),
    cislo_popisne INTEGER,
    zamestnani VARCHAR(30),
    skola VARCHAR(30),
    vztah CHAR(1) CHECK (vztah IN ('S', 'Z'))
);

CREATE TABLE Pritelstvi ( -- unary  
    zacatek TIMESTAMP,
    uzivatel_id INTEGER NOT NULL,
    pritel_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, pritel_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (pritel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Konverzace (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(20) NOT NULL,
    id_uzivatel INTEGER NOT NULL, --author
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Konverzace_ucastnici ( -- unary  
    zacatek TIMESTAMP,
    uzivatel_id INTEGER NOT NULL,
    konverzace_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, konverzace_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (konverzace_id) REFERENCES Konverzace(id) ON DELETE CASCADE
);

CREATE TABLE Zprava (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    obsah VARCHAR(255) NOT NULL,
    datum TIMESTAMP NOT NULL, -- time included
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    id_konverzace INTEGER NOT NULL,
    FOREIGN KEY (id_konverzace) REFERENCES Konverzace(id) ON DELETE CASCADE
);

CREATE TABLE Akce (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(50) NOT NULL,
    datum DATE NOT NULL,
    misto VARCHAR(20),
    typ_udalosti VARCHAR(1) CHECK(typ_udalosti IN ('F', 'V')), -- | F -> physical | V -> Virual |
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Akce_ucastnici (
    zacatek TIMESTAMP,
    uzivatel_id INTEGER NOT NULL,
    akce_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, akce_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (akce_id) REFERENCES Akce(id) ON DELETE CASCADE
);

CREATE TABLE Alba (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(40) NOT NULL,
    nastaveni_soukromi CHAR(1) CHECK (nastaveni_soukromi IN ('Y', 'N')),
    popis VARCHAR(255),
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Prispevek (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(3071),
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Prispevek_zminil (
    uzivatel_id INTEGER NOT NULL,
    prispevek_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, prispevek_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (prispevek_id) REFERENCES Prispevek(id) ON DELETE CASCADE
);

CREATE TABLE Fotky (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    panorama CHAR(1) CHECK (panorama IN ('Y', 'N')),
    pomer_stran DECIMAL(4,2),
    id_prispevek INTEGER,
    FOREIGN KEY (id_prispevek) REFERENCES Prispevek(id) ON DELETE CASCADE, --INHERITANCE
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) ON DELETE CASCADE
);


CREATE TABLE Videa (
    kvalita INTEGER CHECK( kvalita IN (360, 480, 720, 1080) ),
    delka TIMESTAMP,
    FPS INTEGER,
    id_prispevek INTEGER,
    FOREIGN KEY (id_prispevek) REFERENCES Prispevek(id) ON DELETE CASCADE, --INHERITANCE
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) 
);

-- ADD possible cover photo, after table Fotky is created
ALTER TABLE Alba ADD (
    id_fotky INTEGER,
    CONSTRAINT fk_fotky_id_fotky FOREIGN KEY (id_fotky) REFERENCES Fotky(id)
);