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
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id),
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
CREATE TABLE Fotky (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE DEFAULT SYSDATE NOT NULL,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(511),
    id_uzivatel INTEGER NOT NULL, 
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    -- specialisation attributes
    panorama CHAR(8) CHECK (panorama IN ('Y', 'N')),
    pomer_stran DECIMAL(4,2),
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) ON DELETE CASCADE
);

CREATE TABLE Videa (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE DEFAULT SYSDATE NOT NULL,
    misto VARCHAR(20),
    nadpis VARCHAR(40) NOT NULL,
    popis VARCHAR(511),
    id_uzivatel INTEGER NOT NULL, 
    FOREIGN KEY (id_uzivatel) REFERENCES Uzivatel(id) ON DELETE CASCADE,
    -- specialisation attributes
    kvalita INTEGER CHECK( kvalita IN (360, 480, 720, 1080) ),
    delka_sekund NUMBER,
    FPS INTEGER,
    id_alba INTEGER,
    FOREIGN KEY (id_alba) REFERENCES Alba(id) ON DELETE CASCADE
);

-- Fill Tables with Example Data

-- Uzivatel
INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('adamdoe@example.com', 'Adam', 'Doe', TO_DATE('1990-01-01','YYYY-MM-DD'), 'M', 'New York', 'Fifth Avenue', 10, 'Developer', 'MIT', 'S');

INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('janefoster@example.com', 'Jane', 'Foster', TO_DATE('1995-05-05','YYYY-MM-DD'), 'Z', 'Los Angeles', 'Hollywood Boulevard', 20, 'Designer', 'UCLA', 'S');

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
VALUES ('IDS projekt', 1);

INSERT INTO Konverzace (nazev, id_uzivatel)
VALUES ('Bavime se', 2);

INSERT INTO Konverzace (nazev, id_uzivatel)
VALUES ('Fotbal', 3);

-- Konverzace_ucastnici
INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (1, 1);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (2, 1);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (1, 2);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (2, 2);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (3, 2);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (2, 3);

INSERT INTO Konverzace_ucastnici ( uzivatel_id, konverzace_id)
VALUES (3, 3);

-- Zprava
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Ahoj, jak se mas?', 1, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Nic noveho, a ty?', 2, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Taky nic zajimaveho', 1, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Hodne me bavi to IDS kluci.', 3, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Jo taky taky!! ', 1, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Budeme se opet ucit spolecne na to IDS?', 2, 1);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('ola, jak se mas?', 2, 2);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('olaola.. nic noveho, a ty?', 1, 2);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('olaolaola! Taky nic zajimaveho', 2, 2);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('Prestan spamovat kamarade, ucime se !!!.', 3, 2);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('morgen, jak se mas?', 3, 3);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('morgenmorgen.. nic noveho, a ty?', 2, 3);
INSERT INTO Zprava (obsah, id_uzivatel, id_konverzace)
VALUES ('morgenmorgenmorgen! Taky nic zajimaveho', 3, 3);

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
VALUES (3, 2);
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
VALUES (TO_DATE('2021-10-05', 'YYYY-MM-DD'), 'Tokyo, Japan', 'Exploring Tokyo', 'I spent a week exploring the vibrant city of Tokyo, trying new foods and visiting famous landmarks like the Shibuya Crossing and Tokyo Tower.', 1);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2021-05-01', 'YYYY-MM-DD'), 'Karlovy Vary', 'Wellness víkend v Karlových Varech', 'Strávil jsem zde tři dny v luxusním wellness hotelu a užil si relaxaci v termálních pramenech.', 3);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Praha', 'Můj výlet do Prahy', 'V Praze jsem si prohlédl staré město a navštívil několik muzeí.', 1);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-03-20', 'YYYY-MM-DD'), 'Brno', 'Návštěva v Brně', 'V Brně jsem navštívil krásnou zoologickou zahradu a ochutnal místní speciality.', 2);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (TO_DATE('2022-05-05', 'YYYY-MM-DD'), 'Plzeň', 'Pivní festival v Plzni', 'Na pivním festivalu v Plzni jsem ochutnal mnoho druhů piva a poznal zajímavé lidi.', 3);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (SYSDATE, 'Bratislava', 'Na výletě', 'Bratislava opět nesklamala.', 2);
INSERT INTO Prispevek (datum, misto, nadpis, popis, id_uzivatel)
VALUES (SYSDATE, 'Dolny Kubin', 'Muj život je jedna pohádka', 'Dnes na Oravě.Lepší lyžování jsme asi ješte nikdy nezažil.', 3);

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
INSERT INTO Fotky (datum, misto, nadpis, popis, id_uzivatel, panorama, pomer_stran, id_alba)
VALUES (TO_DATE('2023-04-06', 'YYYY-MM-DD'), 'Hory', 'Krasny vyhled na vrchol', 'Tento vrchol byl trosku narocny, ale stalo to zato', 2, 'N', 1.78, 3);

INSERT INTO Fotky (datum, misto, nadpis, popis, id_uzivatel, panorama, pomer_stran, id_alba)
VALUES (TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Jezero', 'Rano na brehu', 'Toto jezero bylo krasne klidne a ja jsem si zde uzil skvely ranni vychazku', 3, 'N', 1.5, 2);

INSERT INTO Fotky (datum, misto, nadpis, popis, id_uzivatel, panorama, pomer_stran, id_alba)
VALUES (SYSDATE, 'Praha', 'Krasny vyhled', 'Tento vyhled byl jednoduse kouzelny', 1, 'N', 1.33, 1);

-- Videa
INSERT INTO Videa (datum, misto, nadpis, popis, id_uzivatel, kvalita, delka_sekund, FPS, id_alba)
VALUES (SYSDATE, 'Plaz', 'Plavani s delfiny', 'Byla to nezapomenutelna zkusenost plavat s tak nadsenymi tvory', 2, 1080, 240, 60, 3);

INSERT INTO Videa (datum, misto, nadpis, popis, id_uzivatel, kvalita, delka_sekund, FPS, id_alba)
VALUES (TO_DATE('2023-04-04', 'YYYY-MM-DD'), 'Les', 'Pryc od civilizace', 'Vzal jsem si par dni volna, abych si uzil ticho a klid daleko od mesta', 3, 360, 120, 30, 1);

INSERT INTO Videa (datum, misto, nadpis, popis, id_uzivatel, kvalita, delka_sekund, FPS, id_alba)
VALUES (SYSDATE, 'Plaz', 'Surfovani', 'Prijel jsem si uzit slunicko a surf', 1, 720, 180, 30, 2);

-- 2x Joinig 2 tables
-- USER POSTED PRISPEVEK 
SELECT
  MAIL,
  CONCAT(CONCAT(JMENO,
  ' '),
  PRIJMENI)     AS JMENO,
  NAROZENI      AS NAROZEN,
  DATUM         AS DATUM_PUBLIKOVANI,
  NADPIS,
  NVL(POPIS,
  'BEZ POPISU') AS POPIS
FROM
  UZIVATEL
JOIN PRISPEVEK
  ON UZIVATEL.ID=PRISPEVEK.ID_UZIVATEL
ORDER BY DATUM DESC;

-- USER CREATED AKCE 
SELECT
  CONCAT(CONCAT(JMENO,
  ' '),
  PRIJMENI) AS JMENO_ZAKLADATELE,
  MAIL      AS MAIL_ZAKLADATELE,
  NAZEV     AS NAZEV_AKCE,
  MISTO     AS MISTO_AKCE,
  DATUM     AS DATUM_AKCE,
  CASE
    WHEN TYP_UDALOSTI = 'F' THEN 'FYZICKA'
    ELSE 'VIRTUALNI'
  END       AS TYP_AKCE
FROM
  UZIVATEL
  JOIN AKCE
  ON UZIVATEL.ID=ID_UZIVATEL
ORDER BY
  DATUM ASC;
  
-- 1x Joining 3 tables 

-- ALL ZPRAVY WITHIN EACH KONVERZACE & UZIVATEL INFO
--      NEWEST MESSAGES WITHIN EACH KONVERZACE ON TOP.

SELECT
  NAZEV     AS NAZEV_KONVERZACE,
  CONCAT(CONCAT(JMENO,
  ' '),
  PRIJMENI) AS JMENO_ODESILATELE,
  ODESLANA  AS ZPRAVA_ODESLANA,
  OBSAH
FROM
  ZPRAVA
  JOIN UZIVATEL
  ON ZPRAVA.ID_UZIVATEL=UZIVATEL.ID JOIN KONVERZACE
  ON ZPRAVA.ID_KONVERZACE=KONVERZACE.ID
ORDER BY
  KONVERZACE.ID,
  ZPRAVA_ODESLANA DESC;

-- 2x SELECTS with GROUP BY and Agreg fc
-- NUMBER OF ZPRAVY WITHIN A KONVEZACE

SELECT
  KONVERZACE.ID AS ID_KONVERZACE,
  NAZEV         AS NAZEV_KONVERZACE,
  COUNT(*)      AS POCET_ZPRAV
FROM
  ZPRAVA
  JOIN KONVERZACE
  ON ZPRAVA.ID_KONVERZACE=KONVERZACE.ID
GROUP BY
  KONVERZACE.ID, NAZEV
ORDER BY 
  POCET_ZPRAV DESC;

-- NUMBER OF PRISPEVEK POSTED BY EACH UZIVATEL

SELECT
  UZIVATEL.ID AS ID_UZIVATELE,
  MAIL,
  COUNT(*)    AS POCET_PRISPEVKU
FROM
  UZIVATEL
  JOIN PRISPEVEK
  ON UZIVATEL.ID=PRISPEVEK.ID_UZIVATEL
GROUP BY
  UZIVATEL.ID, MAIL
ORDER BY
  POCET_PRISPEVKU DESC;

-- 1x EXIST SELECT
-- SHOW LIST OF ATTENDERS FOR Akce PLES
SELECT
    ID AS ID_UZIVATEL,
    CONCAT(CONCAT(JMENO, ' '), PRIJMENI) AS JMENO,
    MAIL
FROM
    Uzivatel
WHERE EXISTS (
    SELECT *
    FROM 
        Akce_ucastnici
    JOIN Akce
        ON Akce.id = Akce_ucastnici.akce_id
    WHERE
        Akce_ucastnici.uzivatel_id = Uzivatel.id AND
        Akce.nazev = 'Ples'
)
ORDER BY ID;

-- 1x IN OPERATOR AND SELECT INSIDE
-- WHICH Uzivatel's HAVE POSTED Prispevek IN 2021?
SELECT
    DISTINCT CONCAT(CONCAT(UZIVATEL.JMENO, ' '), UZIVATEL.PRIJMENI) AS JMENO_UZIVATELE,
    CASE
        WHEN UZIVATEL.POHLAVI = 'M' THEN 'MUZ'
        ELSE 'ZENA'
    END AS POHLAVI,
    UZIVATEL.ZAMESTNANI AS ZAMESTNANI
FROM Prispevek
JOIN Uzivatel ON Prispevek.id_uzivatel = Uzivatel.id 
WHERE id_uzivatel IN
    (SELECT id_uzivatel FROM Prispevek
        WHERE datum BETWEEN TO_DATE('2021-01-01', 'YYYY-MM-DD') AND TO_DATE('2021-12-31', 'YYYY-MM-DD'));

-- 2x STORED PROCEDURES
-- PROCEDURE to CREATE a new event
CREATE OR REPLACE PROCEDURE pridat_akce(
  p_nazev IN Akce.nazev%TYPE,
  p_datum IN Akce.datum%TYPE,
  p_misto IN Akce.misto%TYPE,
  p_typ_udalosti IN Akce.typ_udalosti%TYPE,
  p_id_uzivatel IN Akce.id_uzivatel%TYPE
)
IS
BEGIN
  INSERT INTO Akce (nazev, datum, misto, typ_udalosti, id_uzivatel)
  VALUES (p_nazev, p_datum, p_misto, p_typ_udalosti, p_id_uzivatel);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

BEGIN
  pridat_akce('Narozeninová oslava', TO_DATE('2023-06-21', 'YYYY-MM-DD'), 'U Jindry', 'F', 3);
END;
/

-- PROCEDURE to demonstrate new data (DBMS_OUTPUT) with use of CURSOR
CREATE OR REPLACE PROCEDURE zakladetele_akce AS
BEGIN 
  DECLARE
    v_jmeno_zakladatele VARCHAR2(100);
    v_mail_zakladatele VARCHAR2(100);
    v_nazev_akce VARCHAR2(100);
    v_misto_akce VARCHAR2(100);
    v_datum_akce DATE;
    v_typ_akce VARCHAR2(20);
    
    -- Declare the cursor to hold the result set
    CURSOR c_akce IS
      SELECT
        CONCAT(CONCAT(u.JMENO, ' '), u.PRIJMENI) AS JMENO_ZAKLADATELE,
        u.MAIL AS MAIL_ZAKLADATELE,
        a.NAZEV AS NAZEV_AKCE,
        a.MISTO AS MISTO_AKCE,
        a.DATUM AS DATUM_AKCE,
        CASE
          WHEN a.TYP_UDALOSTI = 'F' THEN 'FYZICKA'
          ELSE 'VIRTUALNI'
        END AS TYP_AKCE
      FROM
        UZIVATEL u
        JOIN AKCE a ON u.ID = a.ID_UZIVATEL
      ORDER BY
        a.DATUM ASC;
  BEGIN
    OPEN c_akce;
    
    -- Loop through the cursor and fetch the data
    LOOP
      FETCH c_akce INTO
        v_jmeno_zakladatele,
        v_mail_zakladatele,
        v_nazev_akce,
        v_misto_akce,
        v_datum_akce,
        v_typ_akce;
      
      -- Exit the loop if there is no more data
      EXIT WHEN c_akce%NOTFOUND;
      
      -- Print or use the fetched data as needed
      DBMS_OUTPUT.PUT_LINE(
        v_jmeno_zakladatele || ', ' ||
        v_mail_zakladatele || ', ' ||
        v_nazev_akce || ', ' ||
        v_misto_akce || ', ' ||
        TO_CHAR(v_datum_akce, 'YYYY-MM-DD') || ', ' ||
        v_typ_akce
      );
    END LOOP;

    CLOSE c_akce;

  END;
END;
/

BEGIN
  zakladetele_akce;
END;
/

-- The trigger checks if the user is already participating in the event before being added to the Event_participants table.
-- If the user is already a participant in the event, the trigger prevents duplicate entries
CREATE OR REPLACE TRIGGER trg_akce_ucastnici_omezeni
BEFORE INSERT ON Akce_ucastnici
FOR EACH ROW
DECLARE
  pocet_ucasti INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO pocet_ucasti
  FROM Akce_ucastnici
  WHERE uzivatel_id = :NEW.uzivatel_id AND akce_id = :NEW.akce_id;
  
  IF pocet_ucasti > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Uživatel se již účastní této akce. Nelze přidat duplicitní záznam.');
  END IF;
END trg_akce_ucastnici_omezeni;
/

-- Create a new user
INSERT INTO Uzivatel (mail, jmeno, prijmeni, narozeni, pohlavi, mesto, ulice, cislo_popisne, zamestnani, skola, vztah)
VALUES ('tester@example.com', 'Tester', 'Fester', TO_DATE('1990-01-01','YYYY-MM-DD'), 'M', 'New York', 'Fifth Avenue', 10, 'Developer', 'MIT', 'S');

-- First insertion should succeed
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id) VALUES (1, (SELECT ID FROM UZIVATEL WHERE MAIL = 'tester@example.com'));

-- Second insertion should fail and raise an error
INSERT INTO Akce_ucastnici (uzivatel_id, akce_id) VALUES (1, (SELECT ID FROM UZIVATEL WHERE MAIL = 'tester@example.com'));


-- Automatic addition of the author of the conversation to the participants
CREATE OR REPLACE TRIGGER trg_konverzace_autor_ucastnik
AFTER INSERT ON Konverzace
FOR EACH ROW
BEGIN
  INSERT INTO Konverzace_ucastnici (uzivatel_id, konverzace_id)
  VALUES (:NEW.id_uzivatel, :NEW.id);
END trg_konverzace_autor_ucastnik;
/

-- Create a new conversation
INSERT INTO Konverzace (nazev, id_uzivatel) VALUES ('Plánování akce', 1);

-- Check if the author (user with id 1) is added as a participant
SELECT * FROM Konverzace_ucastnici WHERE konverzace_id = (SELECT ID FROM Konverzace WHERE nazev = 'Plánování akce');
