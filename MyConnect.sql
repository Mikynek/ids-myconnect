DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Prispevek CASCADE CONSTRAINTS;
DROP TABLE Akce CASCADE CONSTRAINTS;
DROP TABLE Alba CASCADE CONSTRAINTS;

CREATE TABLE Uzivatel (
    id_uzivatel INTEGER AUTO_INCREMENT=5000, -- create generated primary key
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_narozeni DATE NOT NULL,
    pohlavi ENUM('muz', 'zena'),
    ulice VARCHAR(20)
    mesto VARCHAR(20),
    zamestnani VARCHAR(30),
    mail VARCHAR(30) NOT NULL,
    skola VARCHAR(30),
    vztah BOOLEAN   --> BOOL 0-single / 1-in relationship
);

CREATE TABLE Konverzace (
    id_konverzace INTEGER,
    nazev VARCHAR(20) NOT NULL,
    seznam_clenu VARCHAR(40)    -- switch for VARBINARY(size) ?
);

CREATE TABLE Zprava (
    poradi_zpravy INTEGER,  -- Foreign Key
    obsah VARCHAR(256),
    datum DATETIME, -- time included
    misto VARCHAR(20)
);

CREATE TABLE Prispevek (
    id_prispevek INTEGER,
    datum DATETIME,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(1024)
);

CREATE TABLE Akce {
    id_akce INTEGER,
    nazev VARCHAR(50) NOT NULL,
    datum DATETIME NOT NULL,
    misto VARCHAR(20),
    typ_udalosti ENUM('virtualni', 'fyzicka')
}

CREATE TABLE Alba {
    id_alba INTEGER,
    nazev VARCHAR(40) NOT NULL,
    nastaveni_soukromi BOOLEAN, --> BOOL 0-public / 1-private
    popis VARCHAR(512)
}


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
    VALUES(42,'Dovolena Izreal',TRUE,'Dovolena super!');
INSERT INTO Alba
    VALUES(43,'Narozeniny Pepa',FALSE,'Syn 3 roky');