DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Prispevek CASCADE CONSTRAINTS;

CREATE TABLE Uzivatel (
    id_uzivatel INTEGER,
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_narozeni DATE NOT NULL,
    pohlavi ENUM('muz', 'zena'),
    ulice VARCHAR(20)
    mesto VARCHAR(20),
    zamestnani VARCHAR(30),
    mail VARCHAR(30) NOT NULL,
    skola VARCHAR(30),
    vztah VARCHAR(10)
);

CREATE TABLE Konverzace (
    id_konverzace INTEGER,
    nazev VARCHAR(20) NOT NULL,
    seznam_clenu VARCHAR(40)    -- TODO jak udelat?
);

CREATE TABLE Zprava (
    poradi_zpravy INTEGER,  -- Foreign Key
    obsah VARCHAR(20),
    datum DATE, -- time included
    misto VARCHAR(20)
);

CREATE TABLE Prispevek (
    id_prispevek INTEGER,
    datum DATE,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(1024)
);

ALTER TABLE Uzivatel ADD CONSTRAINT PK_uzivatel PRIMARY KEY (id_uzivatel);
ALTER TABLE Konverzace ADD CONSTRAINT PK_konverzace PRIMARY KEY (id_konverzace);
ALTER TABLE Zprava ADD CONSTRAINT PK_zprava FOREIGN KEY (poradi_zpravy);
ALTER TABLE Prispevek ADD CONSTRAINT PK_prispevek PRIMARY KEY (id_prispevek);
