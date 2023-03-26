-- SQL Script
-- Authors: Jakub Mikysek (xmikys03), Gabriel Biel (xbielg00)
--
--
DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Pratelstvi CASCADE CONSTRAINTS;
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
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- create generated primary key
    mail VARCHAR(30) NOT NULL UNIQUE,
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    narozeni DATE NOT NULL,
    pohlavi CHAR(7) CHECK (pohlavi IN ('M', 'Z')),
    mesto VARCHAR(20),
    ulice VARCHAR(20),
    cislo_popisne INTEGER,
    zamestnani VARCHAR(30),
    skola VARCHAR(30),
    vztah CHAR(5) CHECK (vztah IN ('S', 'Z'))
);

CREATE TABLE Pratelstvi ( -- unary  
    zacatek TIMESTAMP DEFAULT SYSTIMESTAMP,
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
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id)
);

CREATE TABLE Konverzace_ucastnici (
    zacatek TIMESTAMP DEFAULT SYSTIMESTAMP,
    uzivatel_id INTEGER NOT NULL,
    konverzace_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, konverzace_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (konverzace_id) REFERENCES Konverzace(id) ON DELETE CASCADE
);

CREATE TABLE Zprava (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    obsah VARCHAR(255) NOT NULL,
    odeslana TIMESTAMP  DEFAULT SYSTIMESTAMP NOT NULL,
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id), -- Change user, when deleting user to <DELETED USER>
    id_konverzace INTEGER NOT NULL,
    FOREIGN KEY (id_konverzace) REFERENCES Konverzace(id) ON DELETE CASCADE
);

CREATE TABLE Akce (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(50) NOT NULL,
    datum DATE NOT NULL,
    misto VARCHAR(20),
    typ_udalosti VARCHAR(12) CHECK(typ_udalosti IN ('F', 'V')), -- | F -> physical | V -> Virual |
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Akce_ucastnici (
    zacatek TIMESTAMP DEFAULT SYSTIMESTAMP,
    uzivatel_id INTEGER NOT NULL,
    akce_id INTEGER NOT NULL,
    PRIMARY KEY (uzivatel_id, akce_id),
    FOREIGN KEY (uzivatel_id) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    FOREIGN KEY (akce_id) REFERENCES Akce(id) ON DELETE CASCADE
);

CREATE TABLE Alba (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(40) NOT NULL,
    nastaveni_soukromi CHAR(16) CHECK (nastaveni_soukromi IN ('public', 'private')),
    popis VARCHAR(255),
    id_uzivatel INTEGER NOT NULL,
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE
);

CREATE TABLE Prispevek (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE DEFAULT SYSDATE NOT NULL,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(511),
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

-- Fotky and Videa are specialization of Prispevek table.
-- Fotky/Videa have additional attributes specific the represented entity.
-- Specialization is done by Prispevek's id. The ID is also used to represent the Fotky/Videa entity.
CREATE TABLE Fotky (
    panorama CHAR(8) CHECK (panorama IN ('Y', 'N')),
    pomer_stran DECIMAL(4,2),
    id INTEGER,
    FOREIGN KEY (id) REFERENCES Prispevek(id) ON DELETE CASCADE, --INHERITANCE
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) ON DELETE CASCADE
);

CREATE TABLE Videa (
    kvalita INTEGER CHECK( kvalita IN (360, 480, 720, 1080) ),
    delka_sekund NUMBER,
    FPS INTEGER,
    id INTEGER,
    FOREIGN KEY (id) REFERENCES Prispevek(id) ON DELETE CASCADE, --INHERITANCE
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) ON DELETE CASCADE
);

-- Fill Tables with Example Data

-- Uzivatel
INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('johndoe@example.com', 'John', 'Doe', TO_DATE('1990-01-01','YYYY-MM-DD'), 'M', 'New York', 'Fifth Avenue', 10, 'Developer', 'MIT', 'S');

INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('janedoe@example.com', 'Jane', 'Doe', TO_DATE('1995-05-05','YYYY-MM-DD'), 'Z', 'Los Angeles', 'Hollywood Boulevard', 20, 'Designer', 'UCLA', 'S');

INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('johncena@example.com', 'John', 'Cena', TO_DATE('1977-04-23','YYYY-MM-DD'), 'M', 'West Newbury', 'Main Street', 15, 'Wrestler', NULL, 'Z');

-- Pratelstvi
INSERT INTO Pratelstvi (uzivatel_id, pritel_id)
VALUES ( 1, 2);

INSERT INTO Pratelstvi (uzivatel_id, pritel_id)
VALUES ( 2, 3);

INSERT INTO Pratelstvi (uzivatel_id, pritel_id)
VALUES ( 3, 1);

-- Konverzace
INSERT INTO Konverzace (nazev, id_uzivatel)
VALUES ('Hello world', 1);

INSERT INTO Konverzace (nazev, id_uzivatel)
VALUES ('Goodbye world', 2);

INSERT INTO Konverzace (nazev, id_uzivatel)
VALUES ('Testing 123', 3);

-- Konverzace_ucastnici
INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (1, 1);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (2, 1);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (3, 1);

-- Zprava
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Ahoj, jak se mas?', 1, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Nic noveho, a ty?', 2, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Taky nic zajimaveho', 1, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Tento uzivatel neexistuje', 3, 1);

-- Akce
INSERT INTO Akce (nazev, datum, misto, typ_udalosti, id_uzivatel)
VALUES ('Party u jezera', TO_DATE('2022-05-01', 'YYYY-MM-DD'), 'Jezero', 'F', 1);
INSERT INTO Akce (nazev, datum, misto, typ_udalosti, id_uzivatel)
VALUES ('Ples', TO_DATE('2022-02-14', 'YYYY-MM-DD'), 'Palac Zofin', 'F', 2);
INSERT INTO Akce (nazev, datum, misto, typ_udalosti, id_uzivatel)
VALUES ('Stream koncert', TO_DATE('2022-04-10', 'YYYY-MM-DD'), 'Online', 'V', 1);
INSERT INTO Akce (nazev, datum, misto, typ_udalosti, id_uzivatel)
VALUES ('Workshop', TO_DATE('2022-03-05', 'YYYY-MM-DD'), 'Domov', 'V', 3);

-- Akce_ucastnici
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id)
VALUES (1, 1);
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id)
VALUES (2, 1);
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id)
VALUES (2, 2);
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id)
VALUES (1, 3);

-- Alba
INSERT INTO Alba (nazev, nastaveni_soukromi, popis, id_uzivatel)
VALUES ('Moje dovolená 2022', 'private', 'Fotky z dovolené na Bali', 1);
INSERT INTO Alba (nazev, nastaveni_soukromi, popis, id_uzivatel)
VALUES ('Rodinné oslavy', 'private', 'Fotky z rodinných oslav', 2);
INSERT INTO Alba (nazev, nastaveni_soukromi, popis, id_uzivatel)
VALUES ('Mé oblíbené restaurace', 'public', 'Fotografie z mých oblíbených restaurací', 3);

-- Prispevek
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Praha', 'Můj výlet do Prahy', 'V Praze jsem si prohlédl staré město a navštívil několik muzeí.', 1);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-03-20', 'YYYY-MM-DD'), 'Brno', 'Návštěva v Brně', 'V Brně jsem navštívil krásnou zoologickou zahradu a ochutnal místní speciality.', 2);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-05-05', 'YYYY-MM-DD'), 'Plzeň', 'Pivní festival v Plzni', 'Na pivním festivalu v Plzni jsem ochutnal mnoho druhů piva a poznal zajímavé lidi.', 3);

-- Prispevek_zminil
INSERT INTO Prispevek_zminil (uzivatel_id, prispevek_id)
VALUES (1, 1);
INSERT INTO Prispevek_zminil (uzivatel_id, prispevek_id)
VALUES (2, 1);
INSERT INTO Prispevek_zminil (uzivatel_id, prispevek_id)
VALUES (1, 2);
INSERT INTO Prispevek_zminil (uzivatel_id, prispevek_id)
VALUES (2, 2);
INSERT INTO Prispevek_zminil (uzivatel_id, prispevek_id)
VALUES (3, 2);

-- Fotky
INSERT INTO Fotky (panorama, pomer_stran, id, id_alba)
VALUES ('N', 1.5, 1, 2);
INSERT INTO Fotky (panorama, pomer_stran, id, id_alba)
VALUES ('N', 1.33, 2, 1);
INSERT INTO Fotky (panorama, pomer_stran, id, id_alba)
VALUES ('Y', 2.5, 2, 2);

-- Videa
INSERT INTO Videa (kvalita, delka_sekund, FPS, id, id_alba)
VALUES (1080, 123123.1, 60, 1, 1);
INSERT INTO Videa (kvalita, delka_sekund, FPS, id, id_alba)
VALUES (720, 18.4, 30, 2, 2);
INSERT INTO Videa (kvalita, delka_sekund, FPS, id, id_alba)
VALUES (480, 72.1, 30, 1, NULL);

-- Select Test
/*
SELECT * FROM Uzivatel;
SELECT * FROM Pratelstvi;
SELECT * FROM Konverzace;
SELECT * FROM Konverzace_ucastnici;
SELECT * FROM Zprava;
SELECT * FROM Akce;
SELECT * FROM Akce_ucastnici;
SELECT * FROM Alba;
SELECT * FROM Prispevek;
SELECT * FROM Prispevek_zminil;
SELECT * FROM Fotky;
SELECT * FROM Videa;
*/
