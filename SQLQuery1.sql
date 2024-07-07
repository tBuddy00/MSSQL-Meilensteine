--Meilenstein 3 
--Name: Taylan Özer
--Matrikelnummer: 53054

USE Trommelhelden;


CREATE TABLE Mitarbeiter(
	
	MitID char(3) NOT NULL,
	Nachnanme varchar(20) NOT NULL,
	Vorname varchar(20) NULL,
	GebDatum Date NOT NULL,
	Job varchar(20) NOT NULL,
	Stundensatz smallmoney NULL,
	Einsatzort varchar(20) NULL

	CONSTRAINT PK_Mitarbeiter PRIMARY KEY (MitID)

);

CREATE TABLE Kunde(

	KundenNr int NOT NULL,
	Nachname varchar(20) NOT NULL,
	Ort varchar(20) NOT NULL,
	PLZ char(5) NOT NULL,
	Strasse varchar(20) NOT NULL

	CONSTRAINT PK_Kunde PRIMARY KEY (KundenNr)

);

CREATE TABLE Ersatzteil(
	
	ID char(5) NOT NULL,
	Bezeichnung varchar(100) NOT NULL,
	Preis smallmoney NOT NULL,
	AnzahlLager int NOT NULL,
	Hersteller varchar(30) NOT NULL

	CONSTRAINT PK_Ersatzteil PRIMARY KEY (ID)

);

--Aufgabe 3.6)

INSERT INTO Mitarbeiter SELECT * FROM trommelhelden..quelleMitarbeiter
INSERT INTO Kunde SELECT * FROM trommelhelden..quelleKunde
INSERT INTO Ersatzteil SELECT * FROM trommelhelden..quelleErsatzteil

--Aufgabe 3.7)

SELECT * INTO Auftrag FROM trommelhelden..quelleAuftrag
SELECT * INTO Montage FROM trommelhelden..quelleMontage

--Aufgabe 3.8)

--Tabelle Auftrag
ALTER TABLE Auftrag ADD
--CONSTRAINT PK_Auftrag PRIMARY KEY (AufNr)
CONSTRAINT FK_Auftrag_MitID FOREIGN KEY (MitID) REFERENCES Mitarbeiter(MitID) --Verweis auf MitID in der Spalte Mitarbeiter und auf dessen Elternklasse

ALTER TABLE Auftrag ADD
CONSTRAINT FK_Auftrag_KunNr FOREIGN KEY (KunNr) REFERENCES Kunde (KundenNr)


--Tabelle Montage
ALTER TABLE Montage ADD
CONSTRAINT PK_Montage_EtID_AufNR PRIMARY KEY (EtID, AufNr), --Zusammengesetzter Primärschlüssel
CONSTRAINT FK_Montage_ID FOREIGN KEY (EtID) REFERENCES Ersatzteil (ID), --Verweis von Montage auf Ersatzteil
CONSTRAINT FK_Montage_AufNr FOREIGN KEY (AufNr) REFERENCES Auftrag (AufNr)

-- Wechsel in die richtige Datenbank: USE iw22s85500 

-- Aufgabe 3.10)
SELECT COUNT(*) FROM Auftrag --Zählung der vorhandenen Datensätze
SELECT COUNT(*) FROM Ersatzteil
SELECT COUNT(*) FROM Kunde
SELECT COUNT(*) FROM Mitarbeiter
SELECT COUNT(*) FROM Montage

-- Aufgabe 3.12)



--Aufgabe 3.13)
-- a.)
SELECT Ort = 'Radebeul' FROM Kunde
-- Anzahl Datensätze -> 501

-- b.)
--SELECT * FROM Kunde WHERE KunOrt NOT LIKE 'CHEMNITZ'
-- Beschreibung: gibt alle Datensätze aus, welche aus der Spalte KunOrt gefiltert nicht aus Chemnitz kommen 

-- c.) 
SELECT Bezeichnung FROM Ersatzteil WHERE Bezeichnung LIKE 'S%'
-- Anzahl Datensätze: 3

-- d.)
SELECT Dauer, Anfahrt FROM Auftrag WHERE DAUER BETWEEN 2 AND 3 OR Anfahrt >= 80
--Anzahl Datensätze: 367

-- e.) 
SELECT Nachnanme, Job FROM Mitarbeiter WHERE (Job = 'Monteur' OR Job = 'Azubi')
AND Einsatzort = 'Radebeul' ORDER BY Nachnanme
-- Anzahl Datensätze: 2 (Beinert, Azubi und Uhu, Monteur)

-- f.)
SELECT * FROM Auftrag WHERE Dauer IS NULL
--Anzahl Datensätze: 507

-- g.)
SELECT SUM(Anfahrt * 2.5) FROM Auftrag
--Anzahl Datensätze: 1 (67.115.00 EUR) 

-- h.)
-- Etpreis * EtAnzLager AS Lagerwert FROM Ersatzteil;
--Diese Abfrage multipliziert den Preis mit der im Lager vorhandenen Anzahl an Ersatzteilen,
-- demnach bildet sich unser Lagerwert und so trifft das Alias "Lagerwert" gut auf den Punkt.
---------------------------------------------------------------------------------------------


--Meilenstein 4
--Name: Taylan Özer
--Matrikelnummer: 53054

--Was charakterisiert die Skalarfunktion?
-- Sie gibt einen numerischen Wert zurück.

-- a.)
SELECT Nachnanme, Vorname, GebDatum, 
DATEDIFF(year, GebDatum, GETDATE()) AS Alter_in_Jahren
FROM Mitarbeiter
--Anzahl der Datensätze: 12
-- Was fällt beim Abfrageergebnis auf?
-- Es wird nicht beachtet, ob die Person bereits Geburtstag hatte oder nicht.

-- b.)
SELECT AVG(DATEDIFF(DAY, AufDat, ErlDat)) AS Frist_in_Tage --ergibt uns einen Durchschnitt der Tage aus
FROM Auftrag
WHERE ErlDat IS NOT NULL AND DATEDIFF(MONTH, AufDat, GETDATE()) = 0
--Anzahl der Datensätze: 1

-- c.)
SELECT COALESCE(Dauer, '0') AS Dauer_ohne_NULL FROM Auftrag 
--COALESCE prüft auf NULL-Werte und gibt diese auf 'normalem' Weg zurück in der Tabelle, ansonsten als einen definierten Rückgabewert -
-- in dem Fall als die Zahl 0.
--Anzahl der Datensätze: 1030

-- Aufgabe 4.2)
-- Worauf ist beim Einsatz von Aggregatfunktionen zu achten?
-- Im GROUP BY müssen die Spalten-Namen auftauchen, welche auch im SELECT stehen. 

-- a.)
SELECT * FROM Kunde
--Anzahl der Datensätze: 501

-- b.) 
SELECT Ort, Count(Ort) FROM Kunde GROUP BY Ort
--Anzahl der Datensätze: 267

-- c.)
SELECT AVG(Dauer) AS DauerAlsDurchschnitt, MitID 
FROM Auftrag 
GROUP BY Dauer, MitID
--Anzahl der Datensätze: 57

--USE iw22s85500 

-- d.)
SELECT MitID,
	AVG(Dauer) AS DauerAlsDurchschnitt,
	MIN(Dauer) AS MINZeit,
	MAX(Dauer) AS MAXZeit,
	MIN(MitID) AS MINMitID,
	MAX(MitID) AS MAXMitID
FROM Auftrag
GROUP BY MitID
--Anzahl der Datensätze: 8


-- e.)
SELECT AVG(Dauer) AS DauerAlsDurchschnitt, COUNT(*) AS AnzahlAuftraege, ErlDat,
MitID
FROM Auftrag 
WHERE ErlDat IS NOT NULL
GROUP BY MitID, ErlDat
--Anzahl der Datensätze: 503

-- f.)
SELECT MIN(ErlDat) AS MinErledigungsdatum
FROM Auftrag
WHERE Anfahrt IS NULL AND ErlDat IS NOT NULL
--Datum: 16.03.2023


-- Aufgabe 4.3)
-- a.)
-- Die Abfrage gibt das durchschnittliche Alter der Mitarbeiter in Jahren aus und gruppiert diese dann in MitJob zu einer Berufsgruppe.

-- b.)
SELECT MitID, DATENAME(WEEKDAY, ErlDat), AVG(Dauer) AS ZeitProMitarbeiter -- DATENAME liefert einen genauen Wert zum ErlDat zurück
FROM Auftrag
GROUP BY MitID,DATENAME(WEEKDAY, ErlDat)
--Anzahl der Datensätze: 57

-- c.)
SELECT MitID, AVG(Anfahrt) AS DurchschnittlicherAnfahrtsWeg
FROM Auftrag
GROUP BY MitID
--Datensätze: 8

-- Aufgabe 4.4)

-- a.) 
--impliziter Join
SELECT Montage.AufNr, Ersatzteil.Bezeichnung, Montage.Anzahl, Ersatzteil.AnzahlLager,
Anzahl * Preis AS Warenwert
FROM Montage, Ersatzteil
WHERE Montage.EtID = Ersatzteil.ID
ORDER BY AufNr

--expliziter Join
SELECT Montage.AufNr, Ersatzteil.Bezeichnung, Montage.Anzahl, Ersatzteil.AnzahlLager,
Anzahl * Preis AS Warenwert
FROM Montage
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
ORDER BY AufNr
--Datensätze: 757


-- b.)
SELECT AufNr, Mitarbeiter.MitID ,FORMAT(Mitarbeiter.Stundensatz,'C') AS Stundensatz, FORMAT(Dauer * Stundensatz,'C') AS RechnungFürAuftrag --FORMAT erlaubt ein Währung anzuhängen an den Wert
FROM Mitarbeiter
JOIN Auftrag ON Mitarbeiter.MitID = Auftrag.MitID
WHERE Dauer IS NOT NULL
ORDER BY MitID

-- c.)
SELECT Kunde.Nachname,Kunde.Ort, Auftrag.Anfahrt
FROM Kunde
JOIN Auftrag ON Kunde.KundenNr = Auftrag.KunNr
WHERE Anfahrt >= 50 
ORDER BY Aufnr
--Datensätze: 267


-- d.)
SELECT KunNr 
FROM Auftrag
JOIN Montage ON Auftrag.AufNr = Montage.AufNr
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
WHERE ID = 'H0230'
ORDER BY KunNr
-- Datensätze: 37

-- e.)
SELECT Auftrag.Aufnr, FORMAT(Anfahrt * Stundensatz, 'C') AS Fahrtkosten, FORMAT(Stundensatz * Dauer, 'C') AS Lohnkosten,
FORMAT(SUM(Preis * Anzahl), 'C') AS Materialkosten
FROM Auftrag
JOIN Montage ON Auftrag.Aufnr = Montage.AufNr
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID
WHERE Dauer IS NOT NULL
GROUP BY Auftrag.Aufnr, FORMAT(Anfahrt * Stundensatz, 'C'), FORMAT(Stundensatz * Dauer, 'C') --die Gruppierung erlaubt mir einzelne Kosten noch einmal als eine Summe zusammenzufassen
ORDER BY Aufnr
--Datensätze: 397


-- f.)
-- DISTINCT lässt alle Duplikate raus und durch die Aufnr, welche niemals doppelt vergeben wird kann auf DISTINCT verzichtet werden
SELECT Nachnanme, Aufnr
FROM Auftrag
LEFT JOIN Mitarbeiter ON Auftrag.MitID = AUftrag.MitID
WHERE  DATEDIFF(MONTH, AufDat, GETDATE()) = 0 -- Die Null sagt uns, dass wir im DATEDIFF in dem aktuellen Monat landen wollen. 
--Datensätze: 2.160

-- g.)
SELECT EtID, Bezeichnung, COUNT(*)
FROM Montage
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
JOIN Auftrag ON Montage.AufNr = Auftrag.Aufnr
WHERE DATEDIFF(MONTH, AufDat, GETDATE()) = 1 --0 gibt uns den aktuellen Monat, die 1 den vorangegangenen Monat
GROUP BY EtID, Bezeichnung
--Datensätze: 16



-- Aufgabe 4.5)
-- a.)
SELECT DISTINCT Mitarbeiter.MitID
FROM Mitarbeiter 
JOIN Auftrag ON Mitarbeiter.MitID = Auftrag.MitID
WHERE Dauer IS NULL AND DATEDIFF(MONTH, AufDat, GETDATE()) = 0
ORDER BY MitID
--Datensätze: 7


-- b.)
SELECT *
FROM Mitarbeiter
JOIN Auftrag ON Mitarbeiter.MitID = Auftrag.MitID
LEFT JOIN Montage ON Auftrag.Aufnr = Montage.AufNr
WHERE EtID IS NULL
--Datensätze 340


-- c.)
SELECT AufDat, ErlDat, Dauer 
FROM Auftrag 
WHERE Dauer IS NULL AND ErlDat IS NULL
--Datensätze: 293


-- d.)
SELECT Nachname, AufDat
FROM Kunde
JOIN Auftrag ON Kunde.KundenNr = Auftrag.KunNr
WHERE AufDat IS NOT NULL AND DATEDIFF(MONTH, AufDat, GETDATE()) = 2
--Datensätze: 224

-- e.)
--korrelierte Unterabfrage
SELECT MitID, Dauer AS MAXAuftragsDauer
FROM Auftrag
WHERE Dauer = (SELECT MAX(Dauer) FROM Auftrag AS MAXDauer WHERE MAXDauer.MitID = Auftrag.MitID)
--Datensätze: 28

--unkorrelierte Unterabfrage
SELECT a.MitID, Dauer AS MAXAuftragsDauer
FROM Auftrag a, (SELECT MitID, MAX(Dauer) AS MAXDauer FROM Auftrag GROUP BY MitID) m 
WHERE a.MitID = m.MitID AND a.Dauer = m.MAXDauer
--Datensätze: 28

--Wann lassen sich Probleme nur mit Unterabfragen lösen?
-- einige Probleme lassen sich nur mittels einer Unterabfragen lösen, wenn das Ergebnis als ein einzelner Wert 
--oder in Form einer Tabelle ausgegeben werden kann.

SELECT * FROM Auftrag

--Aufgabe 4.6)
--Wann kommt in einer Abfrage HAVING zum Einsatz?
--Die HAVING-Klausel kommt nur zum Einsatz, da man
--in der WHERE-Klausel keine Aggregatfunktionen verwenden kann (HAVING = WHERE) - bei gruppierten Daten bzw. Abfragen.


-- a.) 
SELECT MitID, COUNT(Anfahrt) AS AnzahlFahrten, SUM(Anfahrt) AS GesamtfahrtenInKm
FROM Auftrag
WHERE MONTH(AufDat) = 4 AND Anfahrt IS NOT NULL
GROUP BY MitID
HAVING SUM(Anfahrt) >= 500
ORDER BY GesamtfahrtenInKm DESC
--Datensätze: 4


-- b.)
SELECT Bezeichnung, AnzahlLager, SUM(Anzahl) AS VerbauteTeile
FROM Montage
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
GROUP BY Bezeichnung, AnzahlLager
HAVING AnzahlLager >= SUM(Anzahl)
--Datensätze: 32


-- Aufgabe 4.7)

-- a.) 
INSERT INTO Kunde 
VALUES(100, 'Ali', 'Dresden', '01269', 'Ofen-Straße 1')
INSERT INTO Auftrag
VALUES(300, 101, 100, '2023-06-06', '2023-06-06', 5, 30, 'Rohr geplatzt') 
-- es müssen bereits vorhandene Mitarbeiter und Kunden gewählt werden, weil hier die Fremdschlüssel 
--schon existieren
--Datensätze: Ali 

-- b.)

BEGIN TRANSACTION -- Eine Transaktion ist eine Folge von SQL-Anweisungen
				  -- die als atomare Einheit verarbeitet werden. Alle Anweisungen in der Transaktion
				  -- werden entweder angewendet oder mittels ROLLBACK wieder rückgängig (Werkseinstellungen) gemacht.

UPDATE Mitarbeiter SET Job = 'Monteur' WHERE Job = 'Azubi'
UPDATE Mitarbeiter SET Stundensatz = 75 WHERE MitID = 108
UPDATE Mitarbeiter SET Stundensatz = 75 WHERE MitID = 112
 -- mit UPDATE ist es möglich bestimmte Zeilen in einer Tabelle anzusprechen und diese nach Wunsch zu ändern
--Datensätze: 2

ROLLBACK -- Mittels ROLLBACK kann man alle Datenänderungen löschen, die seit einer BEGIN TRANSACTION durchgeführt wurden
-- c.)
DELETE FROM Ersatzteil WHERE Hersteller = 'Mosch' 
--Datensätze: 8  


-- d.)
SELECT Nachname, KundenNr, EtID
FROM Kunde
JOIN Auftrag ON Kunde.KundenNr = Auftrag.KunNr
JOIN Montage ON Auftrag.Aufnr = Montage.AufNr
DELETE FROM Auftrag WHERE MONTH(ErlDat) = 3
--Datensätze: 


-- Aufgabe 4.8)

--Differenz 
SELECT Kunde.Ort
FROM Auftrag
JOIN Kunde ON Auftrag.KunNr = Kunde.KundenNr
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID
Except
SELECT Mitarbeiter.Einsatzort
FROM Mitarbeiter
--Datensätze: 213


--Durchschnitt
SELECT Kunde.Ort
FROM Auftrag
JOIN Kunde ON Auftrag.KunNr = Kunde.KundenNr
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID
INTERSECT
SELECT Mitarbeiter.Einsatzort
FROM Mitarbeiter
--Datensätze: 3

--Vereinigung
SELECT Kunde.Ort
FROM Auftrag
JOIN Kunde ON Auftrag.Aufnr = Kunde.KundenNr
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID
UNION
SELECT Mitarbeiter.Einsatzort
FROM Mitarbeiter
--Datensätze: 206


--Aufgabe 4.9)
CREATE VIEW Auftragswert 
AS
SELECT Auftrag.Aufnr, FORMAT(Anfahrt * Stundensatz, 'C') AS Fahrtkosten, FORMAT(Stundensatz * Dauer, 'C') AS Lohnkosten,
FORMAT(SUM(Preis * Anzahl), 'C') AS Materialkosten
FROM Auftrag
JOIN Montage ON Auftrag.Aufnr = Montage.AufNr
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID
WHERE Dauer IS NOT NULL
GROUP BY Auftrag.Aufnr, FORMAT(Anfahrt * Stundensatz, 'C'), FORMAT(Stundensatz * Dauer, 'C') --die Gruppierung erlaubt mir einzelne Kosten noch einmal als eine Summe zusammenzufassen

SELECT *
FROM Auftragswert

--Aufgabe 4.10)
SELECT Anfahrt,
CASE 
WHEN Anfahrt > 12 THEN Anfahrt * 2.50 -- RECHNUNG: 30/2.50, weil wenn die Anfahrt <= 12km ist dann mindestens 30 EUR abrechnen und sollte die Anfahrt > 12km dann 2.50 * Anfahrtsweg
WHEN Anfahrt <= 12 THEN 30
ELSE 0
END	AS Anfahrtspreis
FROM Auftrag
ORDER BY Anfahrt DESC
--Datensätze: 1.031

---------------------------------------------------
-- Meilenstein 5

-- Aufgabe 5.1) 
CREATE PROCEDURE AnzAuftraege 
AS --AS legt die PROCEDURE Definition fest als Rumpf
SELECT COUNT(*), MitID, AufNr FROM Auftrag
GROUP BY MitID, AufNr

DROP PROCEDURE AnzAuftraege -- löscht zunächst die PROCEDURE damit sie anschließend wieder angelegt werden kann.
EXECUTE AnzAuftraege
--Datensätze: 1.031

--Aufgabe 5.2)
CREATE PROCEDURE etVerbaut (@ersatzteile INT)
AS
SELECT EtID, SUM(Anzahl) AS Verbaut FROM Montage
GROUP BY EtID 
HAVING SUM(Anzahl) > @ersatzteile

DROP PROCEDURE etVerbaut
EXECUTE etVerbaut 80 --Die Variable prüft ob die Parametereingabe öfter verbaut wurde als der übergebene Parameter
--Datensätze: 3


--Aufgabe 5.3)
CREATE PROCEDURE tagArbeit (@tag INT)
AS
DECLARE @MinDat DATE
SELECT @MinDat = MIN(ErlDat)
FROM Auftrag
WHERE Dauer IS NULL AND MitID IS NOT NULL

while(@tag > 0)
BEGIN
	SELECT @MinDat = MIN(ErlDat)
	FROM Auftrag
	WHERE Dauer IS NULL AND MitID IS NOT NULL

	PRINT 'Tage: ' + convert(varchar(2), @tag)
	UPDATE Auftrag SET Dauer = (convert(int,rand()*9)+1)*0.5, Anfahrt = convert(int,rand()*95)+5, Beschreibung = 'VON MIR'
	WHERE ErlDat = @MinDat
	SELECT @tag = @tag - 1
END

DROP PROCEDURE tagArbeit
EXECUTE tagArbeit 5 
--Tage: 5 (auf Parameter 5)
--Ergebnis der Prozedur: Die erzeugten Randomwerte, werden für alle treffenden Datensätze übernommen.


-- Aufgabe 5.4)
CREATE PROCEDURE tagMitCursor (@tag INT)
AS
DECLARE @auftragsNr INT
DECLARE Auftraege_DD CURSOR FOR
	SELECT Aufnr
	FROM Auftrag
	WHERE Dauer IS NULL AND MitID IS NOT NULL AND ErlDat = (SELECT MIN(ErlDat)
	FROM Auftrag
	WHERE Dauer IS NULL AND MitID IS NOT NULL)

while(@tag > 0)
BEGIN
	OPEN Auftraege_DD
	FETCH Auftraege_DD INTO @auftragsNr -- FETCH gibt den Result in eine lokale Variable innerhalb eines Tupels

	while(@@FETCH_STATUS = 0) -- sobald ein FETCH funktioniert hat geht man in die Schleife
	BEGIN
		UPDATE Auftrag SET Dauer = (convert(int,rand()*9)+1)*0.5, Anfahrt = convert(int,rand()*95)+5, Beschreibung = 'VON MIR 2'
		WHERE AufNr = @auftragsNr

		FETCH Auftraege_DD INTO @auftragsNr
	END
	CLOSE Auftraege_DD

	PRINT 'Tage: '+ CONVERT(VARCHAR(10), @tag)
	SET @tag = @tag - 1
END
DEALLOCATE Auftraege_DD

DROP PROCEDURE tagMitCursor
EXECUTE tagMitCursor 10
-- CURSOR erlaubt uns durch die Ergebnisse zu laufen


--- Semester 3 
--Mat.Nr: 53054
--Name: Taylan Özer

 --- Meilenstein 1 

 --Skizze: ) Siehe PDF

 --a.)
 -- SUBSTRING gibt uns die 1. und 2. Stelle eine Strings aus -> Slicing
SELECT DISTINCT SUBSTRING(PLZ, 1, 2) AS PLZ_Bereiche
FROM Kunde

--b.)
SELECT * INTO Niederlassung 
FROM trommelhelden..quelleNiederlassung
ALTER TABLE Niederlassung
ADD CONSTRAINT PK_Niederlassung PRIMARY KEY (NLNr)



SELECT * INTO Gebiet 
FROM trommelhelden..quelleGebiet
ALTER TABLE Gebiet
ADD CONSTRAINT FK_Gebiet FOREIGN KEY (NLNr)

ALTER TABLE Gebiet ADD PRIMARY KEY (GebietID)
ALTER TABLE Gebiet ADD CONSTRAINT FK_NLNr_GebietID FOREIGN KEY (NLNr) REFERENCES Niederlassung(NLNr)


--c.)
-- Hinzufügen von einer Spalte in einer bereits existierenden Tabelle
ALTER TABLE Mitarbeiter
ADD NiederlassungsNr INT

--d.)
ALTER TABLE Mitarbeiter ADD CONSTRAINT FK_NiederlassungsNr_NLNr FOREIGN KEY (NiederlassungsNr) REFERENCES Niederlassung(NLNr) 
--SP_HELP Mitarbeiter, ist eine Hilfe zur Betrachtung von Tabellen und deren Schlüssel u. a. 

SELECT * FROM Mitarbeiter
UPDATE Mitarbeiter SET NiederlassungsNr = (SELECT NiederlassungsNr FROM Niederlassung WHERE Mitarbeiter.Einsatzort = Ort)
 
UPDATE Mitarbeiter
SET NiederlassungsNr = (SELECT NLNr FROM Niederlassung WHERE Ort = Mitarbeiter.Einsatzort)

SELECT * FROM Mitarbeiter


--e.)
ALTER TABLE Mitarbeiter DROP COLUMN Einsatzort

--f.)
ALTER TABLE Mitarbeiter ADD FOREIGN KEY (NiederlassungsNr) REFERENCES Niederlassung (NLNr)


--3. Datenmodell)
-- -- d.)
SELECT Mitarbeiter.Vorname, Mitarbeiter.Nachnanme, Gebiet.GebietID
FROM Gebiet
JOIN Niederlassung ON Gebiet.NLNr = Niederlassung.NLNr
JOIN Mitarbeiter ON Niederlassung.NLNr = Mitarbeiter.NiederlassungsNr


SELECT Auftrag.Aufnr, Mitarbeiter.Vorname, Mitarbeiter.Nachnanme, Ersatzteil.ID
FROM Auftrag
JOIN Montage ON Montage.AufNr = Auftrag.Aufnr
JOIN Ersatzteil ON Montage.EtID = Ersatzteil.ID
JOIN Mitarbeiter ON Auftrag.MitID = Mitarbeiter.MitID


--4. Daten importieren)
INSERT INTO Auftrag SELECT * FROM trommelhelden..quelledbs2Auftrag
--"SELECT * INTO" gilt für noch nicht bestehende Tabellen ansonsten wie oben.
--Anzahl Datensätze: 2900

INSERT INTO Montage SELECT * FROM trommelhelden..quelledbs2Montage
--Anzahl Datensätze: 1950

--5 Tablle Rechnung)
CREATE TABLE Rechnung(

KunNr INT NOT NULL,
AufNr INT NOT NULL,
RechDat DATE NOT NULL,
RechBetrag SMALLMONEY NOT NULL

CONSTRAINT PK_KunNr_AufNr PRIMARY KEY (KunNr, AufNr) 

ALTER TABLE Rechnung ADD CONSTRAINT FK_KunNr_AufNr FOREIGN KEY (KunNr) REFERENCES Kunde(KundenNr)
ALTER TABLE Rechnung ADD CONSTRAINT FK_KunNr_AufNr2 FOREIGN KEY (AufNr) REFERENCES Auftrag(AufNr)

);

--6 Sicht / View
CREATE VIEW View_MA
AS
SELECT Auftrag.Aufnr, Kunde.KundenNr, Mitarbeiter.MitID
FROM Kunde
JOIN Auftrag ON Auftrag.KunNr = Kunde.KundenNr
JOIN Gebiet ON SUBSTRING(Kunde.PLZ, 1,2) = Gebiet.GebietID 
JOIN Mitarbeiter ON Gebiet.NLNr = Mitarbeiter.NiederlassungsNr

SELECT * FROM View_MA

--7. Datenmodell)
--Datenbankdiagramm angelegt


--Meilenstein 2 

--Aufgabe 4.)
--a.)
CREATE TABLE Artikel(

Artikel_ID INT PRIMARY KEY,
Bezeichnung VARCHAR(30),
Bestand INT CHECK(Bestand >= 0),
Preis DECIMAL(10, 2) CHECK(Preis >= 0)

)

INSERT INTO Artikel VALUES(111, 'Stuhl', 1200, 23.60)
INSERT INTO Artikel VALUES(112, 'Sofa', 100, 223.60)
INSERT INTO Artikel VALUES(113, 'Sessel', 66, 123.60)
INSERT INTO Artikel VALUES(115, 'Tisch', 20, 20.00)
INSERT INTO Artikel VALUES (117, 'Regal', 12, 3.99)


--b.)
--Mit Rollback
BEGIN TRANSACTION
	UPDATE Artikel SET Bezeichnung = 'Couch' WHERE Bezeichnung = 'Sofa'
ROLLBACK

--Mit Commit
BEGIN TRANSACTION
	UPDATE Artikel SET Bezeichnung = 'Couch' WHERE Bezeichnung = 'Sofa'
COMMIT


--c.)
BEGIN TRANSACTION 
	DECLARE @menge_sessel INT = 10
	DECLARE @menge_tisch INT = 20 --ursprünglich 25

	UPDATE Artikel SET Bestand -= @menge_sessel
	WHERE Artikel_ID = 113

	UPDATE Artikel SET Bestand -= @menge_tisch
	WHERE Artikel_ID = 115
--Die Anweisung für Bestand welche 25 Tische abziehen soll, scheitert aufgrund der Check-Funktion (>= 0)
-- dahingehend muss bei @menge_tisch auf = 20 gesetzt werden und nicht @menge_tisch = 25

COMMIT 

SELECT * FROM Artikel


--d.)
SELECT * FROM Artikel 

SET XACT_ABORT ON --Setzt die Transaktion zurück, sofern ein Fehler in der Anweisung auftaucht und so den Fehler abfängt und verhindert
				  --Hier gilt, dass entweder beide Transaktionen erfolgreich sind, oder keine und demnach beide Transaktionen zurückgeworfen werden.
BEGIN TRANSACTION 
	DECLARE @menge_sessel INT = 10
	DECLARE @menge_tisch INT = 25 --hierfür von 25, wieder auf 20 gesetzt 

	UPDATE Artikel SET Bestand -= @menge_sessel
	WHERE Artikel_ID = 113

	UPDATE Artikel SET Bestand -= @menge_tisch
	WHERE Artikel_ID = 115
--Die Anweisung für Bestand welche 25 Tische abziehen soll, scheitert aufgrund der Check-Funktion (>= 0)
-- dahingehend muss bei @menge_tisch = 20 gesetzt werden und nicht @menge_tisch = 25

COMMIT 

--e.)
--In manchen Fällen ist das in d.) SET XACT_ABORT ON nicht sinnvoll, da sofern mal nur 
--ein Artikel gewünscht ist, gleich beide geprüft werden und dies direkt fehlschläft


--f.)
BEGIN TRANSACTION 
	
		UPDATE Artikel SET Bestand = 2000 
		WHERE Artikel_ID = 111

	IF (SELECT SUM(Bestand) FROM Artikel) > 2000 --IF NOT EXITS -> wenn es nicht existiert
	BEGIN 
		ROLLBACK
		PRINT('Transaktion nicht erfolgreich! Lager voll.')
		END
	ELSE
		BEGIN 
			COMMIT
			PRINT('Transaktion erfolgreich!')
		END
	


--Aufgabe 5.)

--T1:
SET TRANSACTION ISOLATION LEVEL
REPEATABLE READ

--<Isolations-Level>
--a.) READ UNCOMMITTED 
--b.) READ COMMITTED
--c.) REPEATABLE READ

--d.)
BEGIN TRANSACTION: SET DEADLOCK_PRIORITY HIGH  
 
--r1(A)
SELECT Artikel_ID, Preis FROM Artikel
WHERE Artikel_ID = 111

WAITFOR DELAY '00:00:10'

--w1(B)
UPDATE Artikel SET Bestand = 500 

COMMIT
--a.), b.), c.)

--Beobachtung a.): Es entstand kein Deadlock, da wir in der Tabelle Artikel nicht exakt die gleiche
-- Artikel-ID abrufen und so werden beide gerufenenen Transaktionen wieder zurückgeworfen.

-- Beobachtung b.): - // -

--Deadlock: Ein Deadlock entsteht, wenn zwei Anwendungen Daten sperren, 
--auf den die jeweils andere Anwendung Daten benötigt -> So kann weder die Eine noch die andere Anwendung
-- die Datenausführung fortsetzen


-- Beobachtung .c):
-- Die T1 wurde durchgeführt und die T2 wurde abgebrochen und blockiert.

--T2:
SET TRANSACTION ISOLATION LEVEL
REPEATABLE READ

--<Isolations-Level>
--a.) READ UNCOMMITTED
--b.) READ COMMITTED
--c.) REPEATABLE READ

BEGIN TRANSACTION: SET DEADLOCK_PRIORITY NORMAL
--r2(B)
SELECT Artikel_ID, Bestand FROM Artikel
WHERE Artikel_ID = 113

WAITFOR DELAY '00:00:10'

--w2(A)
UPDATE Artikel SET Preis = 350 
WHERE Artikel_ID = 111

COMMIT

--Die BEGIN TRANSACTION: SET DEADLOCK_PRIORITY {} gibt stand darüber aus, ob eine Transaktion das Deadlockopfer werden soll oder nicht.
--Demnach kann man steuern, welche Transaktion mittels der Priorität fehlschlagen und zurückgeworfen werden soll und die andere Transaktion dann erfolgreich ist. 


--Meilenstein 3

--Aufgabe 1.1)
CREATE FUNCTION Anfahrtspreis (@Preis_Anfahrt INT)
RETURNS DECIMAL(5, 2) -- 5 Stellen und 2 Nachkommastellen
AS 
	BEGIN 
	DECLARE @Anfahrtspreis DECIMAL(5,2)
	
	IF (@Preis_Anfahrt * 2.5 > 30)
		RETURN @Preis_Anfahrt * 2.5
	
	RETURN 30
	
	END

	SELECT *, dbo.Anfahrtspreis (Anfahrt) AS Anfahrtspreis  FROM Auftrag 

--Aufgabe 1.2)
CREATE FUNCTION Lagerbestand (@lager_bestand INT)
RETURNS @Ersatzteile TABLE (

	AnzahlLager INT,
	ID CHAR(5) NOT NULL
)
AS 
BEGIN
	
	INSERT INTO @Ersatzteile
	SELECT AnzahlLager, ID
	FROM Ersatzteil
	WHERE AnzahlLager < @lager_bestand
  RETURN 


END

SELECT * FROM dbo.Lagerbestand (50)
--Datensätze: 2 auf Lagerbestand(50)

--Aufgabe 2.)
--Test 1 zu 1.1):
CREATE FUNCTION Anfahrtspreis2 (@Preis_Anfahrt2 INT)
RETURNS DECIMAL(5, 2) -- 5 Stellen und 2 Nachkommastellen
AS 
	BEGIN 
	DECLARE @Anfahrtspreis DECIMAL(5,2)
	
	IF (@Preis_Anfahrt2 * 2.5 > 30)
		RETURN @Preis_Anfahrt2 * 2.5
	
	RETURN 30
	
	END

	SELECT *, dbo.Anfahrtspreis2 (Anfahrt) AS Anfahrtspreis  FROM Auftrag 

--Test 2 zu 1.2):
CREATE FUNCTION Lagerbestand (@lager_bestand2 INT)
RETURNS @Ersatzteile TABLE (

	AnzahlLager INT,
	ID CHAR(5) NOT NULL
)
AS 
BEGIN
	
	INSERT INTO @Ersatzteile
	SELECT AnzahlLager, ID
	FROM Ersatzteil
	WHERE AnzahlLager < @lager_bestand2
  RETURN 


END
SELECT * FROM Ersatzteil

SELECT * FROM dbo.Lagerbestand (35)

--Aufgabe 2.1 Default:
--a.)
ALTER TABLE Mitarbeiter ADD CONSTRAINT  NEU_Mitarbeiter DEFAULT 'Monteur' FOR Job
INSERT INTO Mitarbeiter(MitID, Nachnanme, Vorname, GebDatum, Stundensatz, NiederlassungsNr) VALUES(113, 'Thiele', 'Maik', '1990-05-27', 100, 1)
--Datensätze hinzugefügt: 1

--b.)
ALTER TABLE Auftrag ADD CONSTRAINT Akt_Auftrag DEFAULT GETDATE() FOR AufDat  
INSERT INTO Auftrag(Aufnr, MitID, KunNr, ErlDat, Dauer, Anfahrt, Beschreibung) VALUES(15, 113, 100, '2023-10-31', 15, 100, 'Die Welt gerettet')
--Datensätze hinzugefügt: 1


--Aufgabe 2.2 Check:
--a.)
ALTER TABLE Auftrag ADD CONSTRAINT CHECK_DATUM CHECK (AufDat <= ErlDat) 


--b.)
ALTER TABLE Mitarbeiter ADD CONSTRAINT CHECK_ZIFFER CHECK (MitID LIKE '[0-9][0-9][0-9]') --Prüfung auf die Zahlenstellen


--Aufgabe 2.3 Fremdschlüssel mit Löschweitergabe
--Neue Fremdschlüsselbeziehung mit Löschweitergabe:
ALTER TABLE Montage DROP CONSTRAINT FK_Montage_AufNr -- Löscht einen Fremdschlüsselbeziehung -> Montage und Auftrag
ALTER TABLE Montage ADD CONSTRAINT FK_Montage_AufNr_NEU FOREIGN KEY (AufNr) REFERENCES Auftrag (AufNr) ON DELETE CASCADE --Fremdschlüsselbeziehung mit Löschweitergabe

--a.)
DELETE FROM Auftrag WHERE AufDat = (SELECT MIN(AufDat) FROM Auftrag WHERE YEAR(AufDat) = YEAR(GETDATE()) AND MONTH(AufDat) = 5 --Soll zunächst auf den kleinsten Wert prüfen
--löscht alle Aufträge vom 01.05.2023 


--Aufgabe 3 Trigger

--Aufgabe 3.1 Stundensatz

--Bei einem INSERT INTO mit anschließend neuen VALUES, muss die Anzahl Spalten in der Tabelle in die eingefügt werden soll, den Werten entsprechen welche eingefügt werden sollen

CREATE TRIGGER Jobaenderung ON Mitarbeiter FOR INSERT, UPDATE AS

	IF EXISTS(SELECT * FROM Mitarbeiter WHERE (Job = 'Meister ' OR Job = 'Monteur') AND Stundensatz IS NULL)
		BEGIN 
			RAISERROR ('Achtung! MitID wurde geändert', 16, 10)
			ROLLBACK PRINT('Kein Stundensatz!')
		END
		
--ENABLE TRIGGER Befoerderung ON Mitarbeiter -- Ein Trigger ist zunächst immer aktiviert
--DISABLE TRIGGER Befoerderung ON Mitarbeiter 

--a.)
INSERT INTO Mitarbeiter(MitID, Nachnanme, Vorname, GebDatum, Job, Stundensatz, NiederlassungsNr) VALUES(114, 'Miersch', 'Danny', '2004-04-25','Azubi', NULL , 3)

--b.)
UPDATE Mitarbeiter SET Job = 'Monteur' WHERE MitID = 114 --Sollte eigentlich nicht gehen da Stundensatz NULL

--c.)
UPDATE Mitarbeiter SET Job = 'Monteur', Stundensatz = 80 WHERE MitID = 114

--3.2 Erledigte Aufträge
CREATE TRIGGER Auftrag_Pruefung ON Rechnung FOR INSERT, UPDATE AS

	IF EXISTS(
	SELECT * FROM Auftrag
	JOIN INSERTED ON Auftrag.Aufnr = INSERTED.AufNr
	WHERE ErlDat IS NULL OR Dauer IS NULL OR  Anfahrt IS NULL OR INSERTED.RechBetrag < Anfahrt * 2.5)
	
	BEGIN 
		RAISERROR ('Änderung!', 16, 10)
		ROLLBACK PRINT ('Fehler!')
	END

	DROP TRIGGER Auftrag_Pruefung

--a.)
INSERT INTO Rechnung(KunNr, AufNr, RechDat, RechBetrag) VALUES(1154, 1264, '15.10.2020', 154.50) -- funktioniert
INSERT INTO Rechnung(KunNr, AufNr, RechDat, RechBetrag) VALUES(1151, 1345, '15.10.2020', 180.00) -- geht nicht, da Trigger-Funktion
INSERT INTO Rechnung(KunNr, AufNr, RechDat, RechBetrag) VALUES(1151, 1263, '15.10.2020', 50.00) -- funktioniert


--b.) 
INSERT INTO Rechnung SELECT KunNr, AufNr, ErlDat, 80 FROM Auftrag WHERE Aufnr IN (1008, 1009,1010) 
--Beobachtung: Zu AufNr IN (1009, 1010) gilt, dass 80 < 52 * 2.5 = 130 UND 60 * 2.5 = 150 --> geht nicht

SELECT * FROM Auftrag WHERE Aufnr IN (1008, 1009, 1010) --> Prüfung

INSERT INTO Rechnung SELECT KunNr, AufNr, ErlDat, 175
FROM Auftrag WHERE Aufnr IN (1005, 1006, 1007)
--Beobachtung: Zu AufNr = 1006 gilt, 175 < Anfahrt * 2.5, da 90 * 2.5 = 225 --> geht nicht 

SELECT * FROM Auftrag WHERE Aufnr IN (1005, 1006, 1007) --> Prüfung

--c.)
--Welche weiteren semantischen Abhängigkeiten müssten darüber hinaus durch Trigger
--abgesichert werden? Nennen Sie drei Beispiele:

--1. Trigger: Sum-Trigger
--2. Trigger: AufNr-Vorhanden-Trigger
--3. Trigger: RechDat-Vorhanden-Trigger


--Aufgabe 3.)
--a.)
ALTER TABLE Auftrag ALTER COLUMN Beschreibung VARCHAR(200)

--b.)
--Welche Tabellen müssen archiviert werden?
--Mit der Tabelle "Auftrag" und dem vorhandenen Fremdschlüssel mit Löschweitergabe, würden wir die Fremdschlüsselbeziehung zu den Tabellen "Montage" und "Rechnung" auch 
-- gleich mit löschen. Dahingehend muss bei diesen beiden genannten Tabellen ebenfalls Protokoll geführt werden, im Falle einer Löschung.

--Bei einer Löschung müssen genannte Kriterien berücksichtigt werden, da sonst keine Nachvollziehbarkeit mehr besteht für die Löschung in den Logfiles.

CREATE TABLE Protokoll_Auftrag(
	AufNr INT NOT NULL,
	MitID CHAR(3) NULL,
	KunNr INT NOT NULL,
	AufDat DATE NOT NULL,
	ErlDat DATE NULL,
	Dauer DECIMAL(5, 1) NULL,
	Anfahrt INT NULL,
	Beschreibung VARCHAR(200) NULL,
	
	Orig_Daten_Zeitstempel DATE NOT NULL,
	DBS_Nutzer VARCHAR(50) NULL,
	Art_Aenderung VARCHAR(100) NULL

);

CREATE TABLE Protokoll_Montage(
	EtID CHAR(5) NOT NULL,
	AufNr INT NOT NULL,
	Anzahl INT NOT NULL,

	
	Orig_Daten_Zeitstempel DATE NOT NULL,
	DBS_Nutzer VARCHAR(50) NULL,
	Art_Aenderung VARCHAR(100) NULL

);

CREATE TABLE Protokoll_Rechnung(
	KunNr INT NOT NULL,
	AufNr INT NOT NULL,
	RechDat DATE NOT NULL,
	RechBetrag SMALLMONEY NOT NULL,

	
	Orig_Daten_Zeitstempel DATE NOT NULL,
	DBS_Nutzer VARCHAR(50) NULL,
	Art_Aenderung VARCHAR(100) NULL

);


--c.)
CREATE TRIGGER Protokoll_Tabelle ON Auftrag FOR DELETE AS 
			  BEGIN 
				  SELECT * FROM DELETED 
				  ROLLBACK
			  END
--Datensätze: 212

CREATE TRIGGER Protokoll_Tabelle_Montage ON Montage FOR DELETE AS

			  BEGIN 
				  SELECT * FROM DELETED 
				  ROLLBACK
			  END
--Datensätze: 158


CREATE TRIGGER Protokoll_Tabelle_Rechnung ON Rechnung FOR DELETE AS

		BEGIN 
			SELECT * FROM DELETED
			ROLLBACK
		END
--Datensätze: / -> Keine Einträge

--Beobachtung: Erfolgreiche Ausführung 

--Testung der temporären DELETED-Tabelle:
--BEGIN TRANSACTION 
DELETE FROM Auftrag WHERE MONTH(AufDat) = 5 
--Datensätze: 212


--d.)
--Schlussfolgerung: Es kann zu einem Rollback bei der Löschung von der Tabelle Auftrag an Tabelle Montage kommen 
-- und so verhindert dieser Rollback die Löschung von Daten und dementsprechend die Protokollierung in die Protokoll_Tabellen


--e.)
--Zu Tabelle Auftrag
ALTER TRIGGER Protokoll_Tabelle ON Auftrag FOR DELETE AS
		BEGIN 
			INSERT INTO Protokoll_Auftrag SELECT * , Orig_Daten_Zeitstempel = GETDATE(), DBS_Nutzer = SYSTEM_USER, Art_Aenderung = 'Löschung aller Datensätze' FROM DELETED
		END

--Zu Tabelle Montage
ALTER TRIGGER Protokoll_Tabelle_Montage ON Montage FOR DELETE AS
		
		BEGIN 
			INSERT INTO Protokoll_Montage SELECT * , Orig_Daten_Zeitstempel = GETDATE(), DBS_Nutzer = SYSTEM_USER, Art_Aenderung = 'Löschung aller Datensätze' FROM DELETED
		END


--Zu Tabelle Rechnung
ALTER TRIGGER Protokoll_Tabelle_Rechnung ON Rechnung FOR DELETE AS
		BEGIN 
			INSERT INTO Protokoll_Rechnung SELECT * , Orig_Daten_Zeitstempel = GETDATE(), DBS_Nutzer = SYSTEM_USER, Art_Aenderung = 'Löschung aller Datensätze' FROM DELETED
		END


--Aufgabe f.)
BEGIN TRANSACTION
DELETE FROM Auftrag WHERE MONTH(AufDat) = 5 

SELECT * FROM Protokoll_Auftrag
SELECT * FROM Protokoll_Montage

ROLLBACK

--Meilenstein 4.)
--a.) User B: Wechsel Sie in die Datenbank von User A (Versuch!)

--> Partner B loggt sich in meine Datenbank ein
-- Beobachtung: Geht nicht -> kein Zugriff

--b.)
--Schritt 2. Partner anlegen
CREATE USER s85625 FOR LOGIN s85625 
WITH DEFAULT_SCHEMA = extern
CREATE SCHEMA extern AUTHORIZATION s85625

--c.)
--Beobachtung: angelegt und autorisiert.

--f.)
--Erteile Leserechte an Partner B.
GRANT SELECT, INSERT ON Auftrag TO s85625

--h.)
--Hole Informationen über zugelassene Nutzer in der Datenbank und vergebene Zugriffsrechte ein
sp_who --> Gibt Informationen über alle Server-Benutzer und Prozesse
sp_helprotect --> Anzeige der Rechte eines Benutzers

--j.) Versuch einen Wert in meiner Tabelle Auftrag zu ändern
UPDATE Auftrag SET MitID = 2023 WHERE MitID = 114

--Beobachtung: Geht nicht, durch Holdlock ausgesperrt; dann als der Befehl durchging, abgelehnt durch FK_Auftrag_MitID

DELETE Auftrag WHERE MitID = 114
--Beobachtung: Erfolgreich angelegt 


--k.) Prüfung, ob jemand meinen Zugriff auf meine Tabelle Auftrag gesperrt hat und wer es war
sp_lock --> Gibt Informationen über Prozesse, die Sperren verursachen
sp_who 71 -- Ich und 76 Partner B --> - // -


--m.) Erneut einen Wert updaten in meiner Tabelle Auftrag
UPDATE Auftrag SET Aufnr = 23 WHERE AufNr = 15

-- Beobachtung: funktioniert

--o.) Erteilung von Löschrechten an Partner B für meine Tabelle Auftrag
GRANT DELETE ON Auftrag TO s85625

--q.) Kontrolle meiner Protokolltabellen
SELECT * FROM Protokoll_Auftrag -->Erkennbar
SELECT * FROM Protokoll_Montage --> - // - 
SELECT * FROM Protokoll_Rechnung --> - // - 

--r.) Erteile dem Partner B das Recht Tabellen anzulegen
GRANT CREATE TABLE TO s85625


--t.) Die Tabelle Auftrag vom Partner ansehen


--u.) Überprüfung der Objekte in meiner Datenbank
--Beobachtung: 

--w.) Entziehung der Rechte vom Partner
REVOKE CREATE TABLE, INSERT, DELETE  TO s85625 -- oder REVOKE ALL

-- Löschung des angelegten Users plus Schema
DROP SCHEMA extern
DROP USER s85625

--x.) Diskussion der Erkenntnisse in einer größeren Gruppe


--Meilenstein 4 Rolle B:
--a.) User B: Wechsel Sie in die Datenbank von User A (Versuch!)

--> Partner A lässt mich ein seine Datenbank einloggen

USE iw22s85556
-- Beobachtung: Geht nicht -> kein Zugriff

--d.)Wechsel in die Datenbank von Partner A nach Erstellung

--e.)Versuch die Tabelle Auftrag zu lesen
SELECT * FROM Auftrag
--Beobachtung: Keine Zugriffsberechtigung

--g.)Partner A erteilt mir als Partner B Leserechte auf seine Tabelle Auftrag
SELECT * FROM Auftrag
--Beobachtung: Funktioniert


--i.)
BEGIN TRANSACTION
SELECT * FROM Auftrag WITH (HOLDLOCK) --> Sperrt Zugriff eines Nutzers auf seine Datenbank ; Benötigt eine BEGIN TRANSACTION
--ROLLBACK deaktiviert wieder die Transaktion und so gilt ein HOLDLOCK nur während einer Transaction (COMMIT kann auch genutzt werden)

INSERT INTO Auftrag (Aufnr, MitID, KunNr, AufDat,ErlDat, Dauer, Anfahrt, Beschreibung) VALUES (100, 105, 5556, '2023-11-20', '2023-11-21', 12, 15, 'Partner B fügt etwas ein')
--Beobachtung: Funktioniert nicht - keine INSERT-Rechte und Nutzung von Holdlock

--l.)
BEGIN TRANSACTION 
INSERT INTO Auftrag (Aufnr, MitID, KunNr, AufDat,ErlDat, Dauer, Anfahrt, Beschreibung) VALUES (100, 105, 5556, '2023-11-20', '2023-11-21', 12, 15, 'Partner B fügt etwas ein')


SELECT * FROM Auftrag WITH LOCK_ESCALATION = DISABLE

--Beobachtung: Funktioniert, verfüge über die nötigen Rechte

--n.)Versuch einen Datensatz aus der Tabelle Auftrag von Partner A zu löschen 
DELETE Auftrag WHERE MitID = 105
--Beobachtung: DELETE-Rechte nicht vorhanden -> Fehler 

--p.) Erneuter Versuch etwas aus der Tabelle Auftrag von Partner A zu löschen
BEGIN TRANSACTION 
DELETE Auftrag WHERE MitID = 555

ROLLBACK
--Beobachtung: Hat funktioniert


--s.)Partner B soll eine Tabelle in der Datenbank von Tabelle A anlegen
CREATE TABLE Auftrag_Probe (

	Lieblings_Shisha CHAR(50) NOT NULL,
	Shisha_Geschmack CHAR(50) NOT NULL,
	Shisha_Bar CHAR(50) NOT NULL
)
--Beobachtung: Hat nicht funktioniert, fehlende Rechte (CREATE TABLE)
--2. Test: Hat funktioniert plus INSERT Befehl 

INSERT INTO Auftrag_Probe (Lieblings_Shisha, Shisha_Geschmack, Shisha_Bar) VALUES ('Love 66', 'Molocco', 'Habibi')

SELECT * FROM Auftrag_Probe

--v.)Löschung der eben erstellten Tabelle Auftrag_Probe
DROP TABLE Auftrag_Probe

--Wechsel in meine eigene Datenbank wieder
USE iw22s85500


--Meilenstein 5.
SELECT * INTO auftrag2 FROM trommelhelden..quelleAuftrag2011
SELECT * INTO montage2 FROM trommelhelden..quelleMontage2011

--Durch die Anzeige der beiden Tabellen des Execution Plans, kann man sich langsame Anfragen anzeigen lassen und warum diese so langsam sind

SELECT * FROM Auftrag OPTION (MAXDOP 1) --> Verzieht eine Anfrage mit Hinweisen


--Aufgabe 6.)

SELECT COUNT(*) FROM auftrag2

--a.)Führen Sie die Abfrage aus und lassen Sie sich den Abfrageplan anzeigen. Wie wird
--diese Abfrage beantwortet? (Welche Operatoren werden verwendet?)

--Verwendete Symbole:

--Symbold Compute Scalar Cost 0 %
--Stream Aggregate (Aggregate) Cost: 12% 0.020s [..]
--Table Scan [auftrag2] Cost: 88 % 0.015s 

--b.) Legen Sie einen Primärschlüssel (und damit einen Index) auf der Spalte AufNr an
SELECT COUNT(*) FROM auftrag2

ALTER TABLE auftrag2 ADD 
CONSTRAINT PK_Montage_AufNr PRIMARY KEY(AufNr)

SELECT * FROM auftrag2

--c.)
ALTER TABLE auftrag2 DROP CONSTRAINT PK_Montage_AufNr
--Bemerkung: Ohne Index sind es 0,98488 -> Estimated Subtree Cost Table Scan

ALTER TABLE auftrag2 ADD 
CONSTRAINT PK_Montage_AufNr PRIMARY KEY(AufNr)

SELECT COUNT(*) FROM auftrag2
--Bemerkung: Mit Index sind es: 0,98488 -> Estimated Subtree Cost und der Ablauf hat am Ende einen Clustered Index Scan anstatt eines Table Scan

--Clustered Index: Die Tabelle besitzt einen Primärschlüssel
--Table Scan: Die Tabelle hat keinen Primärschlüssel


--d.)
ALTER TABLE auftrag2 DROP CONSTRAINT PK_Montage_AufNr
--Beobachtung: Table Scan, da kein Primärschlüssel vorhanden ist


--Aufgabe 7.)

SELECT mitid, COUNT(*)
FROM auftrag2
WHERE anfahrt = 5 AND AufDat BETWEEN '2011-01-01' AND '2011-02-01'
GROUP BY mitid 
--a.)Beobachtung: Die Estimated Costs von SELECT sind: 1.11332

--b.)
CREATE INDEX Anfahrt_AufDat_Index ON auftrag2 (Anfahrt, AufDat)

--c.)
ALTER TABLE auftrag2 DROP CONSTRAINT PK_Montage_AufNr
--Bemerkung: Ohne Index sind es 0,98488 -> Estimated Subtree Cost

ALTER TABLE auftrag2 ADD 
CONSTRAINT PK_Montage_AufNr PRIMARY KEY(AufNr)

SELECT COUNT(*) FROM auftrag2
--Bemerkung: Mit Index sind es: 0,98488 -> Estimated Subtree Cost

--d.)
SELECT mitid, COUNT(*)
FROM auftrag2
WHERE anfahrt = 5 AND AufDat BETWEEN '2011-01-01' AND '2011-02-01'
GROUP BY mitid

--Ausgehend von der rechten Intervallgrenze: '2011-02-01'
--Beobachtung März: Für SELECT: ESTIMATED SUBTREE COST 0,525412; Nested Loops -> Index Seek (NonClustered)
--Beobachtung April: Für SELECT: ESTIMATED SUBTREE COST 0,760089; Nested Loops -> Index Seek (NonClustered)
--Beobachtung Mai: Für SELECT: ESTIMATED SUBTREE COST 0,883563; Nested Loops -> Index Seek (NonClustered)
--Beobachtung Juni: Für SELECT: ESTIMATED SUBTREE COST 0,964203; Nested Loops -> Index Seek (NonClustered)
--Beobachtung Juli: Für SELECT: ESTIMATED SUBTREE COST 1,04044; Nested Loops -> Index Seek (NonClustered)
--Beobachtung August: Für SELECT: ESTIMATED SUBTREE COST 1,11424; Nested Loops -> Index Seek (NonClustered)

--e.)
--Beobachtung September: Für SELECT: ESTIMATED SUBTREE COST 1,11424; Sort -> Table Scan 
-- -> August hat anscheinend keinen Nonclustered Index bzw. wird keiner verwendet

--f.)
DROP INDEX Anfahrt_AufDat_Index ON auftrag2


--Aufgabe 8.)

--Variante 1.:
SELECT k.KundenNr, k.Nachname
FROM kunde k, auftrag2 a
WHERE k.KundenNr=a.KunNr
AND a.anfahrt=80
--Struktur: SELECT -> Hash Math -> Clustered Index Scan (Clustered)

--Variante 2.:
SELECT k.KundenNr, k.Nachname
FROM kunde k, auftrag2 a
WHERE a.anfahrt=80
AND k.KundenNr=a.KunNr
--Struktur: SELECT -> Hash Match -> Clustered Index Scan (Clustered)

--Variante 3.:
SELECT k.KundenNr, k.Nachname
FROM kunde k JOIN auftrag2 a ON
k.KundenNr=a.KunNr
AND a.anfahrt=80
--Struktur: SELECT -> Hash Match -> Clustered Index Scan (Clustered)

--Variante 4.:
SELECT k.KundenNr, k.Nachname
FROM kunde k JOIN auftrag2 a ON
k.KundenNr=a.KunNr
AND a.anfahrt=80
--Struktur: SELECT -> Hash Match -> Clustered Index Scan (Clustered)

--Beobachtung: Die Laufzeit ist dahingehend und weil alle vier Abfragen die selbe Struktur haben, identisch.

--9.)
SET FORCEPLAN OFF
SELECT a.AufNr, erldat, k.Ort, SUM(Anzahl * Preis)
FROM auftrag2 a
 JOIN montage2 m ON a.AufNr = m.AufNr
 JOIN ersatzteil e ON m.EtID = e.ID
 JOIN mitarbeiter ma ON a.MitID = ma.MitID
 JOIN kunde k ON a.KunNr = k.KundenNr
GROUP BY a.AufNr, ErlDat, k.Ort
-- SET SHOWPLAN_ALL ON/OFF -> 

--Beobachtung der Struktur: SELECT <- Parallelism (Gather Streams) <- Hash Match (Aggregate) <- Parallelism (Repartition Streams) <- Hash Math (Inner Join) <- Parallelism (Distribute Streams) <- Clustered Index (Clustered)
--BEGONNEN MIT: Ersatzteil JOIN mit montage2 -> auftrag2 -> Kunde -> Mitarbeiter
--Strukturkosten: 3,49947

--b.)
--Bewertung: Die Reihenfolge ist wirklich teuer und nimmt viel Zeit in Anspruch, wenn SET FORCEPLAN ON aktiviert ist - 22 Minuten. Der Join von zwei größeren Tabellen, auftrag2 und montage ist demensprechend eher ein Kontra und sollte zum Ende hin erst gejoined werden.

--Optimierte Reihenfolge:
--1. Herausfinden, welche Tabelle die geringsten Tupel besitzt: 

SELECT COUNT(*) FROM auftrag2 AS Anzahl_Tupel_auftrag2 --Anzahl Datensätze: 200.068
SELECT COUNT(*) FROM montage2 AS Anzahl_Tupel_montage2 --Anzahl Datensätze: 300.325
SELECT COUNT(*) FROM ersatzteil AS Anzahl_Tupel_ersatzteil --Anzahl Datensätze: 16
SELECT COUNT(*) FROM Mitarbeiter AS Anzahl_Tupel_Mitarbeiter --Anzahl Datensätze: 14
SELECT COUNT(*) FROM Kunde AS Kunde --Anzahl Datensätze: 502

--2. optimierte Reihenfolge (theoretisches Gebilde):
SELECT a.AufNr, erldat, k.Ort, SUM(Anzahl * Preis)
FROM auftrag2 a
	JOIN mitarbeiter ma ON a.MitID = ma.MitID												
	JOIN ersatzteil e ON m.EtID = e.ID 
	JOIN kunde k ON a.KunNr = k.KundenNr
	JOIN montage2 m ON a.AufNr = m.AufNr
GROUP BY a.AufNr, ErlDat, k.Ort
--Meine Schätzung aus a.) stimmt mit der Annahme aus b.) überein. 


--c.)
SET FORCEPLAN ON --> Forciert den niedergeschriebenen Plan exakt in der Reihenfolge auszuführen, den der Entwickler eingetippt hat. 

--d.)
SELECT a.AufNr, erldat, k.Ort, SUM(Anzahl * Preis)
FROM auftrag2 a
 JOIN montage2 m ON a.AufNr = m.AufNr
 JOIN ersatzteil e ON m.EtID = e.ID
 JOIN mitarbeiter ma ON a.MitID = ma.MitID
 JOIN kunde k ON a.KunNr = k.KundenNr
GROUP BY a.AufNr, ErlDat, k.Ort
--Strukturkosten: 41530,10
--Laufzeit in Min: ~ 25 Min.

--Meilenstein 6

SELECT * FROM Mitarbeiter


--b.)
SELECT Aufnr, ErlDat, KundenNr, Nachname, Ort
FROM auftrag2
JOIN Kunde ON Kunde.KundenNr = auftrag2.KunNr
JOIN Mitarbeiter ON Mitarbeiter.MitID = auftrag2.MitID
WHERE DATEPART(WEEK, auftrag2.ErlDat) = DATEPART(WEEK, DATEADD(WEEK, 1, GETDATE())) AND DATEPART(YEAR, auftrag2.ErlDat) = DATEPART(YEAR, GETDATE()) AND Mitarbeiter.MitID = {p_mitnr}
ORDER BY auftrag2.ErlDat
--Beobachtung: 30 Datensätze

SELECT * FROM Auftrag WHERE ErlDat BETWEEN '2024-01-15' AND '2024-02-05' 

SELECT * FROM Montage



-------
--4. Semester
-- Business Intelligence


--Aufgabe 1.2:

CREATE TABLE Geografie(

	LandID VARCHAR(2),
	Bundesland VARCHAR(25),
	Region VARCHAR(25),
	Staat VARCHAR(25),

	CONSTRAINT PK_LandID PRIMARY KEY (LandID)
)

CREATE TABLE MitarbeiterShop(
	
	Mitarbeiter_ID VARCHAR(2),
	Name_MA VARCHAR(25),

	CONSTRAINT PK_MitarbeiterID PRIMARY KEY(Mitarbeiter_ID)

)

CREATE TABLE Produktkategorie(
	
	Kategorie_ID VARCHAR(2),
	Kategorie VARCHAR(25),
	Kategorie_Manager VARCHAR(25),

	CONSTRAINT PK_KategorieID PRIMARY KEY (Kategorie_ID)

)

CREATE TABLE Produktsubkategorie(

	Subkategorie_ID VARCHAR(3),
	Subkategorie VARCHAR(25),
	Subkategorie_Manager VARCHAR(25),
	Kategorie_ID VARCHAR(2),

	CONSTRAINT PK_SubkategorieID PRIMARY KEY(Subkategorie_ID),
	CONSTRAINT FK_Produktkategorie FOREIGN KEY(Kategorie_ID) REFERENCES Produktkategorie(Kategorie_ID)

)

CREATE TABLE Produkt(

	Produkt_ID VARCHAR(4),
	Markenname VARCHAR(25),
	Produktname VARCHAR(40),
	Preis MONEY,
	Subkategorie_ID VARCHAR(3),

	CONSTRAINT PK_ProduktID PRIMARY KEY(Produkt_ID),
	CONSTRAINT FK_SubkategorieID FOREIGN KEY(Subkategorie_ID) REFERENCES Produktsubkategorie(Subkategorie_ID)


)

CREATE TABLE Zeit(

	Mon_ID VARCHAR(6),
	Monatsname VARCHAR(20),
	Q_ID VARCHAR(6),
	Quartal VARCHAR(10),
	Jahr VARCHAR(4),

	CONSTRAINT PK_MonID PRIMARY KEY(Mon_ID),	
)

CREATE TABLE Umsatzdaten(
	
	Mon_ID VARCHAR(6) NOT NULL,
	Land_ID VARCHAR(2) NOT NULL,
	Produkt_ID VARCHAR(4) NOT NULL,
	Mitarbeiter_ID VARCHAR(2) NOT NULL,
	Umsatzbetrag MONEY,
	Umsatzmenge INTEGER,

	CONSTRAINT FK_MonID FOREIGN KEY(Mon_ID) REFERENCES Zeit(Mon_ID),
	CONSTRAINT FK_LandID FOREIGN KEY(Land_ID) REFERENCES Geografie(LandID),
	CONSTRAINT FK_Produkt_ID FOREIGN KEY(Produkt_ID) REFERENCES Produkt(Produkt_ID),
	CONSTRAINT FK_MitarbeiterID FOREIGN KEY(Mitarbeiter_ID) REFERENCES MitarbeiterShop(Mitarbeiter_ID)


)
--Hinzufügen des zusammengesetzten PRIMARY-KEY
	ALTER TABLE Umsatzdaten ADD CONSTRAINT PK_Mon_Land_Mit_Produkt_ID PRIMARY KEY(Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID)

	

-- Aufgabe 1.3
--Für die Tabelle Geografie dazugehörige Values aus Excel kopiert
INSERT INTO Geografie VALUES('01', 'Sachsen', 'Ost', 'Deutschland')
INSERT INTO Geografie VALUES('02', 'Bayern', 'Süd', 'Deutschland')
INSERT INTO Geografie VALUES('03', 'Saarland', 'West', 'Deutschland')
INSERT INTO Geografie VALUES('04', 'Nordrhein-Westfalen', 'West', 'Deutschland')
INSERT INTO Geografie VALUES('05', 'Baden-Württemberg', 'Süd', 'Deutschland')
INSERT INTO Geografie VALUES('06', 'Rheinland-Pfalz', 'West', 'Deutschland')
INSERT INTO Geografie VALUES('07', 'Niedersachsen', 'West', 'Deutschland')
INSERT INTO Geografie VALUES('08', 'Schleswig-Holstein', 'Nord', 'Deutschland')
INSERT INTO Geografie VALUES('09', 'Hamburg', 'Nord', 'Deutschland')
INSERT INTO Geografie VALUES('10', 'Bremen', 'Nord', 'Deutschland')
INSERT INTO Geografie VALUES('11', 'Mecklenburg-Vorpommern', 'Nord', 'Deutschland')
INSERT INTO Geografie VALUES('12', 'Brandenburg', 'Ost', 'Deutschland')
INSERT INTO Geografie VALUES('13', 'Berlin', 'Ost', 'Deutschland')
INSERT INTO Geografie VALUES('14', 'Sachsen-Anhalt', 'Ost', 'Deutschland')
INSERT INTO Geografie VALUES('15', 'Thüringen', 'Ost', 'Deutschland')
INSERT INTO Geografie VALUES('16', 'Hessen', 'West', 'Deutschland')
INSERT INTO Geografie VALUES('17', 'Valais', 'Süd', 'Schweiz')
INSERT INTO Geografie VALUES('18', 'Ticino', 'Süd', 'Schweiz')
INSERT INTO Geografie VALUES('19', 'Graubünden', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('20', 'Geneva', 'Süd', 'Schweiz')
INSERT INTO Geografie VALUES('21', 'Vaud', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('22', 'Fribourg', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('23', 'Bern', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('24', 'Neuchâtel', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('25', 'Jura', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('26', 'Basel', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('27', 'Solothurn', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('28', 'Aargau', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('29', 'Schaffhausen', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('30', 'Zürich', 'Nord', 'Schweiz')
INSERT INTO Geografie VALUES('31', 'Luzern', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('32', 'Unterwalden', 'West', 'Schweiz')
INSERT INTO Geografie VALUES('33', 'Appenzell', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('34', 'Sankt Gallen', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('35', 'Zug', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('36', 'Schwyz', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('37', 'Glarus', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('38', 'Uri', 'Ost', 'Schweiz')
INSERT INTO Geografie VALUES('39', 'Vorarlberg', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('40', 'Tirol', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('41', 'Salzburg', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('42', 'Oberösterreich', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('43', 'Niederösterreich', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('44', 'Burgenland', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('45', 'Steiermark', 'Österreich', 'Österreich')
INSERT INTO Geografie VALUES('46', 'Kärnten', 'Österreich', 'Österreich')

----Für die Tabelle Mitarbeiter  - // -
INSERT INTO MitarbeiterShop VALUES('01', 'Sybille Neubert')
INSERT INTO MitarbeiterShop VALUES('02', 'NULL')
INSERT INTO MitarbeiterShop VALUES('03', 'Maja Günther')
INSERT INTO MitarbeiterShop VALUES('04', 'Bärbel Blumberg')
INSERT INTO MitarbeiterShop VALUES('05', 'Jonas Müller')
INSERT INTO MitarbeiterShop VALUES('06', 'Rebecca Kunze')
INSERT INTO MitarbeiterShop VALUES('08', 'Horst Lehmann')
INSERT INTO MitarbeiterShop VALUES('09', 'Ralf Förster')
INSERT INTO MitarbeiterShop VALUES('10', 'Heidemarie Flügel')
INSERT INTO MitarbeiterShop VALUES('11', 'Lucie Heinrich')
INSERT INTO MitarbeiterShop VALUES('12', 'Gudrun Dammeier')
INSERT INTO MitarbeiterShop VALUES('14', 'Heinrich Gans')
INSERT INTO MitarbeiterShop VALUES('16', 'Lutz Öresund')
INSERT INTO MitarbeiterShop VALUES('17', 'Sven Klaus')
INSERT INTO MitarbeiterShop VALUES('18', 'Jens Meier')
INSERT INTO MitarbeiterShop VALUES('20', 'Dorit Gille')


--Für die Tabelle Kategorie  - // -
-- Kann aber erst eingefügt werden, wenn die Subkategorie -> Produktkategorie -> Produkt hinzugefügt wurde
INSERT INTO Produkt VALUES('1001', 'German', 'Leinsamen', 2.45, '007')
INSERT INTO Produkt VALUES('1002', 'German', 'Äpfel', 1.2, '006')
INSERT INTO Produkt VALUES('1003', 'German', 'Aubergine', 3, '005')
INSERT INTO Produkt VALUES('1004', 'German', 'Blumenkohl', 2.05, '005')
INSERT INTO Produkt VALUES('1005', 'German', 'Brokkoli', 1.1, '005')
INSERT INTO Produkt VALUES('1006', 'German', 'grüne Linsen', 0.26, '003')
INSERT INTO Produkt VALUES('1007', 'German', 'Berglinsen', 1.48, '003')
INSERT INTO Produkt VALUES('1008', 'German', 'rote Linsen', 3.05, '003')
INSERT INTO Produkt VALUES('1009', 'German', 'Kichererbsen', 2.49, '003')
INSERT INTO Produkt VALUES('1010', 'German', 'Räuchertofu', 2.04, '004')
INSERT INTO Produkt VALUES('1011', 'German', 'Wallnüsse', 2.15, '007')
INSERT INTO Produkt VALUES('1012', 'German', 'Birnen', 0.97, '006')
INSERT INTO Produkt VALUES('1013', 'German', 'Pinienkerne', 2.21, '007')
INSERT INTO Produkt VALUES('1101', 'Selfcooking', 'Wallnüsse', 1.4, '007')
INSERT INTO Produkt VALUES('1102', 'Selfcooking', 'Äpfel', 0.79, '006')
INSERT INTO Produkt VALUES('1103', 'Selfcooking', 'Aubergine', 1.15, '005')
INSERT INTO Produkt VALUES('1104', 'Selfcooking', 'Blumenkohl', 0.86, '005')
INSERT INTO Produkt VALUES('1105', 'Selfcooking', 'Brokkoli', 2.29, '005')
INSERT INTO Produkt VALUES('1106', 'Selfcooking', 'grüne Linsen', 1.68, '003')
INSERT INTO Produkt VALUES('1107', 'Selfcooking', 'Berglinsen', 0.66, '003')
INSERT INTO Produkt VALUES('1108', 'Selfcooking', 'rote Linsen', 2.51, '003')
INSERT INTO Produkt VALUES('1109', 'Selfcooking', 'Kichererbsen', 1.23, '003')
INSERT INTO Produkt VALUES('1110', 'Selfcooking', 'Räuchertofu', 1.02, '004')
INSERT INTO Produkt VALUES('1111', 'Selfcooking', 'Pinienkerne', 1.47, '007')
INSERT INTO Produkt VALUES('1112', 'Selfcooking', 'Birnen', 1.31, '006')
INSERT INTO Produkt VALUES('1113', 'Selfcooking', 'Leinsamen', 1.14, '007')
INSERT INTO Produkt VALUES('1201', 'Biomühle', 'Dinkelbrot', 1.36, '010')
INSERT INTO Produkt VALUES('1202', 'Biomühle', 'Vollkornbrot', 1.65, '010')
INSERT INTO Produkt VALUES('1203', 'Biomühle', 'Heidelbeermuffins', 1.96, '009')
INSERT INTO Produkt VALUES('1204', 'Biomühle', 'Bagels', 1.09, '001')
INSERT INTO Produkt VALUES('1205', 'Biomühle', 'Schokomuffins', 1.58, '009')
INSERT INTO Produkt VALUES('1206', 'Biomühle', 'Preiselbeermuffins', 1.5, '009')
INSERT INTO Produkt VALUES('1207', 'Biomühle', 'Roggenbrot', 3.49, '010')
INSERT INTO Produkt VALUES('1208', 'Biomühle', 'Pumpernickel', 2.01, '010')
INSERT INTO Produkt VALUES('1209', 'Biomühle', 'engl. Muffins', 1.42, '009')
INSERT INTO Produkt VALUES('1301', 'Carmens', 'Heidelbeerjoghurt', 2.58, '012')
INSERT INTO Produkt VALUES('1302', 'Carmens', 'Reisdrink', 0.85, '008')
INSERT INTO Produkt VALUES('1303', 'Carmens', 'Dinkeldrink', 1.03, '008')
INSERT INTO Produkt VALUES('1304', 'Carmens', 'Mandelmilch', 0.6, '008')
INSERT INTO Produkt VALUES('1305', 'Carmens', 'Cheddar, mild', 1.74, '002')
INSERT INTO Produkt VALUES('1306', 'Carmens', 'Sojamilch', 1.02, '008')
INSERT INTO Produkt VALUES('1307', 'Carmens', 'Naturjoghurt', 1.61, '012')
INSERT INTO Produkt VALUES('1308', 'Carmens', 'Hafermilch', 3.05, '008')
INSERT INTO Produkt VALUES('1309', 'Carmens', 'Creme fraiche', 0.52, '011')
INSERT INTO Produkt VALUES('1310', 'Carmens', 'Creme legere', 2.22, '011')
INSERT INTO Produkt VALUES('1311', 'Carmens', 'Leerdammer', 0.71, '002')
INSERT INTO Produkt VALUES('1312', 'Carmens', 'Münster Käse', 0.5, '002')
INSERT INTO Produkt VALUES('1313', 'Carmens', 'Cheddar, scharf', 1.35, '002')
INSERT INTO Produkt VALUES('1314', 'Carmens', 'Appenzeller', 1.64, '002')
INSERT INTO Produkt VALUES('1315', 'Carmens', 'Old Amsterdam', 0.78, '002')
INSERT INTO Produkt VALUES('1316', 'Carmens', 'Havarti Käse', 3.39, '002')
INSERT INTO Produkt VALUES('1317', 'Carmens', 'Leerdammer charactere', 1.83, '002')
INSERT INTO Produkt VALUES('1318', 'Carmens', 'Leerdammer lite', 3.55, '002')
INSERT INTO Produkt VALUES('1401', 'Ich Darf', 'Blumenkohl', 1.13, '005')
INSERT INTO Produkt VALUES('1402', 'Ich Darf', 'Aubergine', 1.81, '005')
INSERT INTO Produkt VALUES('1403', 'Ich Darf', 'Birnen', 1.22, '006')
INSERT INTO Produkt VALUES('1404', 'Ich Darf', 'Brokkoli', 0.9, '005')
INSERT INTO Produkt VALUES('1405', 'Ich Darf', 'Seidentofu', 2.34, '004')
INSERT INTO Produkt VALUES('1406', 'Ich Darf', 'Äpfel', 2.68, '006')
INSERT INTO Produkt VALUES('1407', 'Ich Darf', 'Leinsamen', 1.46, '007')
INSERT INTO Produkt VALUES('1408', 'Ich Darf', 'Berglinsen', 2.39, '003')
INSERT INTO Produkt VALUES('1409', 'Ich Darf', 'rote Linsen', 1.79, '003')
INSERT INTO Produkt VALUES('1410', 'Ich Darf', 'Kichererbsen', 2.3, '003')
INSERT INTO Produkt VALUES('1411', 'Ich Darf', 'Wallnüsse', 1.37, '007')
INSERT INTO Produkt VALUES('1412', 'Ich Darf', 'Pinienkerne', 0.53, '007')
INSERT INTO Produkt VALUES('1413', 'Ich Darf', 'grüne Linsen', 1.31, '003')
INSERT INTO Produkt VALUES('1501', 'Bioweide', 'Old Amsterdam', 0.96, '002')
INSERT INTO Produkt VALUES('1502', 'Bioweide', 'Appenzeller', 0.41, '002')
INSERT INTO Produkt VALUES('1503', 'Bioweide', 'Cheddar, scharf', 0.99, '002')
INSERT INTO Produkt VALUES('1504', 'Bioweide', 'Cheddar, mild', 0.62, '002')
INSERT INTO Produkt VALUES('1505', 'Bioweide', 'Havarti Käse', 2.55, '002')
INSERT INTO Produkt VALUES('1506', 'Bioweide', 'Mandelmilch', 0.41, '008')
INSERT INTO Produkt VALUES('1507', 'Bioweide', 'Leerdammer', 1.8, '002')
INSERT INTO Produkt VALUES('1508', 'Bioweide', 'Dinkeldrink', 2.16, '008')
INSERT INTO Produkt VALUES('1509', 'Bioweide', 'Reisdrink', 1.03, '008')
INSERT INTO Produkt VALUES('1510', 'Bioweide', 'Hafermilch', 2.53, '008')
INSERT INTO Produkt VALUES('1511', 'Bioweide', 'Leerdammer charactere', 1.11, '002')
INSERT INTO Produkt VALUES('1512', 'Bioweide', 'Münster Käse', 1.43, '002')
INSERT INTO Produkt VALUES('1513', 'Bioweide', 'Creme fraiche', 1.85, '011')
INSERT INTO Produkt VALUES('1514', 'Bioweide', 'Creme legere', 1.41, '011')
INSERT INTO Produkt VALUES('1515', 'Bioweide', 'Sojamilch', 2.93, '008')
INSERT INTO Produkt VALUES('1516', 'Bioweide', 'Naturjoghurt', 2.97, '012')
INSERT INTO Produkt VALUES('1517', 'Bioweide', 'Heidelbeerjoghurt', 3.12, '012')
INSERT INTO Produkt VALUES('1518', 'Bioweide', 'Leerdammer lite', 1.65, '002')
INSERT INTO Produkt VALUES('1601', 'Regiomühle', 'Vollkornbrot', 1.3, '010')
INSERT INTO Produkt VALUES('1602', 'Regiomühle', 'Dinkelbrot', 0.75, '010')
INSERT INTO Produkt VALUES('1603', 'Regiomühle', 'Pumpernickel', 2.69, '010')
INSERT INTO Produkt VALUES('1604', 'Regiomühle', 'engl. Muffins', 1.23, '009')
INSERT INTO Produkt VALUES('1605', 'Regiomühle', 'Preiselbeermuffins', 1.38, '009')
INSERT INTO Produkt VALUES('1606', 'Regiomühle', 'Schokomuffins', 0.59, '009')
INSERT INTO Produkt VALUES('1607', 'Regiomühle', 'Roggenbrot', 1.53, '010')
INSERT INTO Produkt VALUES('1608', 'Regiomühle', 'Bagels', 2.58, '001')
INSERT INTO Produkt VALUES('1609', 'Regiomühle', 'Heidelbeermuffins', 0.61, '009')
INSERT INTO Produkt VALUES('1701', 'Black Toast', 'engl. Muffins', 0.96, '009')
INSERT INTO Produkt VALUES('1702', 'Black Toast', 'Pumpernickel', 0.22, '010')
INSERT INTO Produkt VALUES('1703', 'Black Toast', 'Roggenbrot', 0.67, '010')
INSERT INTO Produkt VALUES('1704', 'Black Toast', 'Preiselbeermuffins', 2.05, '009')
INSERT INTO Produkt VALUES('1705', 'Black Toast', 'Schokomuffins', 1.22, '009')
INSERT INTO Produkt VALUES('1706', 'Black Toast', 'Bagels', 1.26, '001')
INSERT INTO Produkt VALUES('1707', 'Black Toast', 'Heidelbeermuffins', 2.3, '009')
INSERT INTO Produkt VALUES('1708', 'Black Toast', 'Dinkelbrot', 1.69, '010')
INSERT INTO Produkt VALUES('1709', 'Black Toast', 'Vollkornbrot', 2.75, '010')
INSERT INTO Produkt VALUES('1801', 'Freiland', 'engl. Muffins', 2.21, '009')
INSERT INTO Produkt VALUES('1802', 'Freiland', 'Dinkelbrot', 0.73, '010')
INSERT INTO Produkt VALUES('1803', 'Freiland', 'Heidelbeermuffins', 2.5, '009')
INSERT INTO Produkt VALUES('1804', 'Freiland', 'Bagels', 1.75, '001')
INSERT INTO Produkt VALUES('1805', 'Freiland', 'Schokomuffins', 2.6, '009')
INSERT INTO Produkt VALUES('1806', 'Freiland', 'Preiselbeermuffins', 2.58, '009')
INSERT INTO Produkt VALUES('1807', 'Freiland', 'Vollkornbrot', 3.03, '010')
INSERT INTO Produkt VALUES('1808', 'Freiland', 'Pumpernickel', 3.07, '010')
INSERT INTO Produkt VALUES('1809', 'Freiland', 'Roggenbrot', 2.31, '010')
INSERT INTO Produkt VALUES('1901', 'Dresdner', 'Leinsamen', 1.4, '007')
INSERT INTO Produkt VALUES('1902', 'Dresdner', 'Kichererbsen', 1.75, '003')
INSERT INTO Produkt VALUES('1903', 'Dresdner', 'Birnen', 2.6, '006')
INSERT INTO Produkt VALUES('1904', 'Dresdner', 'Äpfel', 2.35, '006')
INSERT INTO Produkt VALUES('1905', 'Dresdner', 'Aubergine', 2.61, '005')
INSERT INTO Produkt VALUES('1906', 'Dresdner', 'Räuchertofu', 0.66, '004')
INSERT INTO Produkt VALUES('1907', 'Dresdner', 'Pinienkerne', 0.59, '007')
INSERT INTO Produkt VALUES('1908', 'Dresdner', 'Blumenkohl', 2.76, '005')
INSERT INTO Produkt VALUES('1909', 'Dresdner', 'Brokkoli', 2.07, '005')
INSERT INTO Produkt VALUES('1910', 'Dresdner', 'grüne Linsen', 1.72, '003')
INSERT INTO Produkt VALUES('1911', 'Dresdner', 'Berglinsen', 1.54, '003')
INSERT INTO Produkt VALUES('1912', 'Dresdner', 'rote Linsen', 0.46, '003')
INSERT INTO Produkt VALUES('1913', 'Dresdner', 'Wallnüsse', 3.66, '007')
INSERT INTO Produkt VALUES('2001', 'Veggieland', 'Leinsamen', 2.68, '007')
INSERT INTO Produkt VALUES('2002', 'Veggieland', 'rote Linsen', 1.83, '003')
INSERT INTO Produkt VALUES('2003', 'Veggieland', 'Pinienkerne', 1.69, '007')
INSERT INTO Produkt VALUES('2004', 'Veggieland', 'Wallnüsse', 3.68, '007')
INSERT INTO Produkt VALUES('2005', 'Veggieland', 'Kichererbsen', 2.34, '003')
INSERT INTO Produkt VALUES('2006', 'Veggieland', 'Berglinsen', 1.26, '003')
INSERT INTO Produkt VALUES('2007', 'Veggieland', 'grüne Linsen', 1.52, '003')
INSERT INTO Produkt VALUES('2008', 'Veggieland', 'Brokkoli', 2.35, '005')
INSERT INTO Produkt VALUES('2009', 'Veggieland', 'Blumenkohl', 1.32, '005')
INSERT INTO Produkt VALUES('2010', 'Veggieland', 'Aubergine', 3.38, '005')
INSERT INTO Produkt VALUES('2011', 'Veggieland', 'Äpfel', 1.78, '006')
INSERT INTO Produkt VALUES('2012', 'Veggieland', 'Birnen', 1.29, '006')
INSERT INTO Produkt VALUES('2013', 'Veggieland', 'Seidentofu', 2.37, '004')
INSERT INTO Produkt VALUES('2101', 'Bergwiese', 'Appenzeller', 2.24, '002')
INSERT INTO Produkt VALUES('2102', 'Bergwiese', 'Hafermilch', 0.95, '008')
INSERT INTO Produkt VALUES('2103', 'Bergwiese', 'Heidelbeerjoghurt', 0.38, '012')
INSERT INTO Produkt VALUES('2104', 'Bergwiese', 'Havarti Käse', 3.07, '002')
INSERT INTO Produkt VALUES('2105', 'Bergwiese', 'Sojamilch', 0.54, '008')
INSERT INTO Produkt VALUES('2106', 'Bergwiese', 'Creme legere', 0.67, '011')
INSERT INTO Produkt VALUES('2107', 'Bergwiese', 'Reisdrink', 1.38, '008')
INSERT INTO Produkt VALUES('2108', 'Bergwiese', 'Dinkeldrink', 1.25, '008')
INSERT INTO Produkt VALUES('2109', 'Bergwiese', 'Mandelmilch', 3.75, '008')
INSERT INTO Produkt VALUES('2110', 'Bergwiese', 'Cheddar, mild', 2.96, '002')
INSERT INTO Produkt VALUES('2111', 'Bergwiese', 'Cheddar, scharf', 2.79, '002')
INSERT INTO Produkt VALUES('2112', 'Bergwiese', 'Old Amsterdam', 2.47, '002')
INSERT INTO Produkt VALUES('2113', 'Bergwiese', 'Leerdammer charactere', 2.95, '002')
INSERT INTO Produkt VALUES('2114', 'Bergwiese', 'Leerdammer lite', 1.54, '002')
INSERT INTO Produkt VALUES('2115', 'Bergwiese', 'Leerdammer', 3.12, '002')
INSERT INTO Produkt VALUES('2116', 'Bergwiese', 'Naturjoghurt', 2.06, '012')
INSERT INTO Produkt VALUES('2117', 'Bergwiese', 'Creme fraiche', 2.26, '011')
INSERT INTO Produkt VALUES('2118', 'Bergwiese', 'Münster Käse', 1.1, '002')
INSERT INTO Produkt VALUES('2201', 'Biowelt', 'Naturjoghurt', 3.94, '012')
INSERT INTO Produkt VALUES('2202', 'Biowelt', 'Old Amsterdam', 2.6, '002')
INSERT INTO Produkt VALUES('2203', 'Biowelt', 'Leerdammer lite', 0.95, '002')
INSERT INTO Produkt VALUES('2204', 'Biowelt', 'Havarti Käse', 1.04, '002')
INSERT INTO Produkt VALUES('2205', 'Biowelt', 'Heidelbeerjoghurt', 1.82, '012')
INSERT INTO Produkt VALUES('2206', 'Biowelt', 'Appenzeller', 0.74, '002')
INSERT INTO Produkt VALUES('2207', 'Biowelt', 'Sojamilch', 0.35, '008')
INSERT INTO Produkt VALUES('2208', 'Biowelt', 'Hafermilch', 0.89, '008')
INSERT INTO Produkt VALUES('2209', 'Biowelt', 'Reisdrink', 2.08, '008')
INSERT INTO Produkt VALUES('2210', 'Biowelt', 'Leerdammer', 1.74, '002')
INSERT INTO Produkt VALUES('2211', 'Biowelt', 'Mandelmilch', 3.19, '008')
INSERT INTO Produkt VALUES('2212', 'Biowelt', 'Cheddar, mild', 3.17, '002')
INSERT INTO Produkt VALUES('2213', 'Biowelt', 'Cheddar, scharf', 2.02, '002')
INSERT INTO Produkt VALUES('2214', 'Biowelt', 'Creme legere', 0.78, '011')
INSERT INTO Produkt VALUES('2215', 'Biowelt', 'Creme fraiche', 2.04, '011')
INSERT INTO Produkt VALUES('2216', 'Biowelt', 'Dinkeldrink', 0.9, '008')
INSERT INTO Produkt VALUES('2217', 'Biowelt', 'Leerdammer charactere', 1.27, '002')
INSERT INTO Produkt VALUES('2218', 'Biowelt', 'Münster Käse', 3.74, '002')
INSERT INTO Produkt VALUES('2301', 'Regionalvertrieb', 'Naturjoghurt', 0.62, '012')
INSERT INTO Produkt VALUES('2302', 'Regionalvertrieb', 'Sojamilch', 2.58, '008')
INSERT INTO Produkt VALUES('2303', 'Regionalvertrieb', 'Hafermilch', 1.18, '008')
INSERT INTO Produkt VALUES('2304', 'Regionalvertrieb', 'Reisdrink', 1.78, '008')
INSERT INTO Produkt VALUES('2305', 'Regionalvertrieb', 'Dinkeldrink', 0.62, '008')
INSERT INTO Produkt VALUES('2306', 'Regionalvertrieb', 'Cheddar, mild', 2.51, '002')
INSERT INTO Produkt VALUES('2307', 'Regionalvertrieb', 'Cheddar, scharf', 2.72, '002')
INSERT INTO Produkt VALUES('2308', 'Regionalvertrieb', 'Heidelbeerjoghurt', 3.5, '012')
INSERT INTO Produkt VALUES('2309', 'Regionalvertrieb', 'Mandelmilch', 0.68, '008')
INSERT INTO Produkt VALUES('2310', 'Regionalvertrieb', 'Old Amsterdam', 1.24, '002')
INSERT INTO Produkt VALUES('2311', 'Regionalvertrieb', 'Havarti Käse', 3.1, '002')
INSERT INTO Produkt VALUES('2312', 'Regionalvertrieb', 'Leerdammer charactere', 3.28, '002')
INSERT INTO Produkt VALUES('2313', 'Regionalvertrieb', 'Leerdammer lite', 1.48, '002')
INSERT INTO Produkt VALUES('2314', 'Regionalvertrieb', 'Münster Käse', 1.56, '002')
INSERT INTO Produkt VALUES('2315', 'Regionalvertrieb', 'Leerdammer', 3.22, '002')
INSERT INTO Produkt VALUES('2316', 'Regionalvertrieb', 'Creme legere', 1.93, '011')
INSERT INTO Produkt VALUES('2317', 'Regionalvertrieb', 'Appenzeller', 1.58, '002')
INSERT INTO Produkt VALUES('2318', 'Regionalvertrieb', 'Creme fraiche', 0.47, '011')
INSERT INTO Produkt VALUES('2401', 'Sachsenmühle', 'Dinkelbrot', 0.36, '010')
INSERT INTO Produkt VALUES('2402', 'Sachsenmühle', 'Pumpernickel', 0.67, '010')
INSERT INTO Produkt VALUES('2403', 'Sachsenmühle', 'Vollkornbrot', 0.65, '010')
INSERT INTO Produkt VALUES('2404', 'Sachsenmühle', 'Roggenbrot', 3.57, '010')
INSERT INTO Produkt VALUES('2405', 'Sachsenmühle', 'engl. Muffins', 1.5, '009')
INSERT INTO Produkt VALUES('2406', 'Sachsenmühle', 'Preiselbeermuffins', 2.45, '009')
INSERT INTO Produkt VALUES('2407', 'Sachsenmühle', 'Bagels', 3.2, '001')
INSERT INTO Produkt VALUES('2408', 'Sachsenmühle', 'Heidelbeermuffins', 1.1, '009')
INSERT INTO Produkt VALUES('2409', 'Sachsenmühle', 'Schokomuffins', 1.57, '009')


--Für die Tabelle Kategorie  - // -
-- Kann aber erst eingefügt werden, wenn die Subkategorie -> Produktkategorie -> Produkt hinzugefügt wurde
INSERT INTO Produktkategorie VALUES('01', 'Backwaren', 'NULL')
INSERT INTO Produktkategorie VALUES('02', 'Frischwaren', 'Horst Lehmann')
INSERT INTO Produktkategorie VALUES('03', 'Veggie', 'Maja Günther')



--Für die Tabelle Kategorie  - // -
-- Kann aber erst eingefügt werden, wenn die Subkategorie -> Produktkategorie -> Produkt hinzugefügt wurde
INSERT INTO Produktsubkategorie VALUES('001', 'Bagels', 'Heidemarie Flügel', '01')
INSERT INTO Produktsubkategorie VALUES('002', 'Käse', 'Ralf Förster', '02')
INSERT INTO Produktsubkategorie VALUES('003', 'Hülsenfrüchte', 'Bärbel Blumberg', '03')
INSERT INTO Produktsubkategorie VALUES('004', 'Sojaprodukte', 'Jonas Müller', '03')
INSERT INTO Produktsubkategorie VALUES('005', 'Gemüse', 'Lucie Heinrich', '03')
INSERT INTO Produktsubkategorie VALUES('006', 'Obst', 'Rebecca Kunze', '03')
INSERT INTO Produktsubkategorie VALUES('007', 'Nüsse und Ölsamen', 'Jens Meier', '03')
INSERT INTO Produktsubkategorie VALUES('008', 'pflanzliche Milch', 'Gudrun Dammeier', '02')
INSERT INTO Produktsubkategorie VALUES('009', 'Muffins', 'Lutz Öresund', '01')
INSERT INTO Produktsubkategorie VALUES('010', 'Brot', 'Heinrich Gans', '01')
INSERT INTO Produktsubkategorie VALUES('011', 'Sauerrahm', 'Sven Klaus', '02')
INSERT INTO Produktsubkategorie VALUES('012', 'Joghurt', 'Dorit Gille', '02')



--Aufgabe 1.4:

--Durch eine eigen erstellte XLS-Datei eingefügt
INSERT INTO Zeit VALUES('202101', 'Januar', '202101', '1. Quartal','2021')
INSERT INTO Zeit VALUES('202102', 'Februar', '202101', '1. Quartal','2021')
INSERT INTO Zeit VALUES('202103', 'März', '202101', '1. Quartal','2021')
INSERT INTO Zeit VALUES('202104', 'April', '202102', '2. Quartal','2021')
INSERT INTO Zeit VALUES('202105', 'Mai', '202102', '2. Quartal','2021')
INSERT INTO Zeit VALUES('202106', 'Juni', '202102', '2. Quartal','2021')
INSERT INTO Zeit VALUES('202107', 'Juli', '202103', '3. Quartal','2021')
INSERT INTO Zeit VALUES('202108', 'August', '202103', '3. Quartal','2021')
INSERT INTO Zeit VALUES('202109', 'September', '202103', '3. Quartal','2021')
INSERT INTO Zeit VALUES('202110', 'Oktober', '202104', '4. Quartal','2021')
INSERT INTO Zeit VALUES('202111', 'November', '202104', '4. Quartal','2021')
INSERT INTO Zeit VALUES('202112', 'Dezember', '202104', '4. Quartal','2022')
INSERT INTO Zeit VALUES('202201', 'Januar', '202201', '1. Quartal','2022')
INSERT INTO Zeit VALUES('202202', 'Feburar', '202201', '1. Quartal','2022')
INSERT INTO Zeit VALUES('202203', 'März', '202201', '1. Quartal','2022')
INSERT INTO Zeit VALUES('202204', 'April', '202202', '2. Quartal','2022')
INSERT INTO Zeit VALUES('202205', 'Mai', '202202', '2. Quartal','2022')
INSERT INTO Zeit VALUES('202206', 'Juni', '202202', '2. Quartal','2022')
INSERT INTO Zeit VALUES('202207', 'Juli', '202203', '3. Quartal','2022')
INSERT INTO Zeit VALUES('202208', 'August', '202203', '3. Quartal','2022')
INSERT INTO Zeit VALUES('202209', 'September', '202203', '3. Quartal','2022')
INSERT INTO Zeit VALUES('202210', 'Oktober', '202204', '4. Quartal','2022')
INSERT INTO Zeit VALUES('202211', 'November', '202204', '4. Quartal','2022')
INSERT INTO Zeit VALUES('202212', 'Dezember', '202204', '4. Quartal','2022')

--Aufgabe 1.5:
UPDATE MitarbeiterShop
SET Name_MA = 'Taylan Oezer'
WHERE Mitarbeiter_ID = 02

SELECT * FROM MitarbeiterShop

UPDATE Produktkategorie
SET Kategorie_Manager = 'Taylan Oezer'
WHERE Kategorie_ID = 01

ALTER TABLE MitarbeiterShop
ADD ManagerID VARCHAR(2)

--Hinzufügen der Values für Spalte ManagerID
--Hierarchiebildung
UPDATE MitarbeiterShop SET ManagerID = '02' WHERE ManagerID IN('04', '05', '06', '09', '10', '11', '12', '14', '16', '17', '18', '20')

--FK von ManagerID zu Mitarbeiter_ID
ALTER TABLE MitarbeiterShop ADD CONSTRAINT FK_ManagerID FOREIGN KEY(ManagerID) REFERENCES MitarbeiterShop(Mitarbeiter_ID)

--Aufgabe 1.6 Erstellung des Datenbankdiagramms 
--Aufgabe 1.7 Kopie der Beleg-CSVs in ein lokales Verzeichnis
-- Aufgabe 1.8 Transformation der CSV-Dateien durch Erstellung der TMP-Tabellen

--a.)
CREATE TABLE BelegeTMP(

	Bon_ID VARCHAR(4),
	Fil_ID VARCHAR(5),
	Datum DATE,
	Prod_ID VARCHAR(4),
	Preis SMALLMONEY,
	Anzahl INTEGER
)

CREATE TABLE UmsatzdatenTMP(

	Mon_ID VARCHAR(6),
	Land_ID VARCHAR(2),
	Produkt_ID VARCHAR(4),
	Mitarbeiter_ID VARCHAR(2),
	Umsatzbetrag MONEY,
	Umsatzmenge INTEGER,
)

--b.) Übernahme der Daten aus den CSV-Dateien in die Umsatzdaten-Tabelle
--1. Schritt jeweils acht mal BULK INSERT
BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2021_1.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2021_2.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2021_3.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2021_4.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2022_1.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2022_2.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2022_3.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)

BULK INSERT BelegeTMP
	FROM 'D:\BI\Belege_2022_4.csv' 
	WITH(
		
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)
-- Datensätze: 636.749

--2. Schritt Übernahme der Daten von BelegeTMP zu UmsatzdatenTMP
INSERT INTO UmsatzdatenTMP(Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID, Umsatzbetrag, Umsatzmenge)
SELECT 
																				--LEFT nimmt linksseitig die benötigte Spalte und die dazu gehörige Anzahl an Ziffern RIGHT - // - 
	CONVERT(VARCHAR(6), DATEPART(YEAR, Datum)*100 + DATEPART(MONTH, Datum)),  LEFT(Fil_ID, 2), Prod_ID, '01', SUM(Preis * Anzahl), SUM(Anzahl)
	FROM BelegeTMP
	GROUP BY CONVERT(VARCHAR(6), DATEPART(YEAR, Datum) * 100 + DATEPART(MONTH, Datum)),  LEFT(Fil_ID, 2), Prod_ID

--202101 = 2021 * 100 +1 -> ergibt das Datum im Format "YYYYMM"

--3. Schritt Setzung der richtigen MitarbeiterID durch Erweiterung der Tabellen
ALTER TABLE Produktsubkategorie ADD Mitarbeiter_ID VARCHAR(2)

--Ergänzung der richtigen Mitarbeiter_ID für Produktsubkategorie
--korrelierte  Unterabfrage
UPDATE Produktsubkategorie SET Mitarbeiter_ID =(SELECT Mitarbeiter_ID FROM MitarbeiterShop m WHERE m.Name_MA = Produktsubkategorie.Subkategorie_Manager )
--Setzen der Mitarbeiter_ID über eine korrelierte Unterabfrage
-- Setze Mitarbeiter_ID von der Produktsubkategorie und der Tabelle Produkt, wo die Subkategorie_ID und die Produktsubkategorie_ID UND die Produkt_ID mit UmsatzdatenTMP und der Produkt_ID übereinstimmen müssen
UPDATE UmsatzdatenTMP SET Mitarbeiter_ID =(SELECT Mitarbeiter_ID FROM Produktsubkategorie ps, Produkt p WHERE ps.Subkategorie_ID = p.Subkategorie_ID AND p.Produkt_ID = UmsatzdatenTMP.Produkt_ID )

--4. Schritt: Übernahme der Datensätze von BelegeTMP in UmsatzdatenTMP (bereits erledigt)

--Aufgabe 1.9 Überprüfung auf Richtigkeit
SELECT SUM(Umsatzbetrag) FROM Umsatzdaten
-- Summe im Umsatz: 9.125.929,37 €
-- Datensätze: 164.128

--Befüllen der Umsatzdaten-Tabelle mit den Datensätzen aus der UmsatzdatenTMP
INSERT INTO Umsatzdaten (Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID, Umsatzbetrag, Umsatzmenge)
SELECT Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID, Umsatzbetrag, Umsatzmenge
FROM UmsatzdatenTMP
GROUP BY Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID, Umsatzbetrag, Umsatzmenge

--Aufgabe 2 in VS-Code Cube erstellen)


--Aufgabe 6.)
--Erstellung einer neuen Tabelle und die Einbindung von Plandaten

CREATE TABLE Plandaten(

	MonID VARCHAR(6) NOT NULL,
	Land_ID VARCHAR(2) NOT NULL,
	ProduktID VARCHAR(4) NOT NULL,
	Umsatzplan SMALLMONEY NOT NULL,

	CONSTRAINT FK_MonID_II FOREIGN KEY(MonID) REFERENCES Zeit(Mon_ID),
	CONSTRAINT FK_ProduktID FOREIGN KEY(ProduktID) REFERENCES Produkt(Produkt_ID),
	CONSTRAINT FK_LandID_II FOREIGN KEY(Land_ID) REFERENCES Geografie(LandID)
)

BULK INSERT Plandaten

	FROM 'D:\BI\Plandaten.csv' 

	WITH(
		
		FIELDTERMINATOR = ';', --Individuelles Trennzeichen
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	)
--Datensätze: 164.128

--Aufgabe A7
-- Aufgabe A7.1
SELECT Umsatzdaten.Umsatzbetrag, MitarbeiterShop.Name_MA, Produkt.Produktname, Geografie.Bundesland, Zeit.Monatsname
FROM Geografie , Zeit, Produkt, MitarbeiterShop, Umsatzdaten
WHERE Umsatzdaten.Mon_ID = Zeit.Mon_ID AND Produkt.Produkt_ID = Umsatzdaten.Produkt_ID AND 
Umsatzdaten.Mitarbeiter_ID = MitarbeiterShop.Mitarbeiter_ID AND Umsatzdaten.Land_ID = Geografie.LandID
AND (Geografie.Bundesland = 'Sachsen' OR Geografie.Bundesland = 'Thüringen')
--Datensätze: 8838

--Aufgabe A7.2
SELECT Umsatzdaten.Umsatzbetrag, Umsatzdaten.Umsatzmenge, Geografie.Bundesland
FROM Umsatzdaten, Geografie
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND (Geografie.Bundesland = 'Sachsen' OR Geografie.Bundesland = 'Thüringen')
--Datensätze: 8838

--Aufgabe A7.3
SELECT Umsatzdaten.Umsatzbetrag, Umsatzdaten.Umsatzmenge, Zeit.Q_ID, Geografie.Bundesland
FROM Umsatzdaten, Geografie, Zeit
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND Umsatzdaten.Mon_ID = Zeit.Mon_ID AND (Geografie.Bundesland = 'Sachsen' OR Geografie.Bundesland = 'Thüringen')
--Datensätze: 8838

--Aufgabe A7.4
SELECT Umsatzdaten.Umsatzbetrag, Produktsubkategorie.Subkategorie, Geografie.Staat
FROM Umsatzdaten, Geografie, Zeit, Produkt, Produktsubkategorie
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND Umsatzdaten.Mon_ID = Zeit.Mon_ID AND Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID
--Datensätze: 164.128

--Aufgabe A7.5 (mit Ausgabe von Teilsummen)
SELECT SUM(Umsatzdaten.Umsatzbetrag) AS KummulierterUmsatz, Produkt.Produktname, Produktsubkategorie.Subkategorie, Geografie.Staat
FROM Umsatzdaten, Geografie, Zeit, Produkt, Produktsubkategorie
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND Umsatzdaten.Mon_ID = Zeit.Mon_ID AND Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID
GROUP BY CUBE (Produkt.Produktname, Produktsubkategorie.Subkategorie, Geografie.Staat)
--CUBE ist hilfreich - wenn man aus Sicht eines mehrdimensionalen Datenwürfels spricht - bei Tabellenspalten aus verschiedenen Tabellen, so dass man zwangsläufig aus mehreren Blickwinkeln auf die Daten blickt.
--ROLLUP (immer nur dann, wenn man Tabellenspalten aus einer Tabelle ruft) gibt eine Hierarchie in der Reihenfolge der Nennung der Spalten wieder und die Bildung von Teilsummen wieder - bsp.: ROLLUP (c1, c2) --> c1 > c2
--Datensätze: 380


--Aufgabe A7.6 (mit Einbeziehung der Jahre)
SELECT SUM(Umsatzdaten.Umsatzbetrag) AS Umsatz, Produkt.Produktname, Produktsubkategorie.Subkategorie, Geografie.Staat, Zeit.Jahr
FROM Umsatzdaten, Geografie, Zeit, Produkt, Produktsubkategorie
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND Umsatzdaten.Mon_ID = Zeit.Mon_ID AND Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID
GROUP BY CUBE (Produktsubkategorie.Subkategorie, Produkt.Produktname, Geografie.Staat, Zeit.Jahr)
--Datensätze: 246

--Aufgabe A7.7 (Ausgabe der Umsatzbeträge je Staat, Region und Bundesland)
SELECT SUM(Umsatzdaten.Umsatzbetrag) AS Geografischer_Umsatz, Geografie.Region, Geografie.Bundesland, Geografie.Staat
FROM Umsatzdaten, Geografie,Produkt, Produktsubkategorie
WHERE Umsatzdaten.Land_ID = Geografie.LandID AND Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID
GROUP BY ROLLUP (Geografie.Region, Geografie.Bundesland, Geografie.Staat)
--Datensätze: 98

--Aufgabe A7.8 (Ausgabe der Umsatzbeträge je Kategorie, Subkategorie und Produktname)
SELECT SUM(Umsatzdaten.Umsatzbetrag) AS Produktumsatz, Produkt.Produktname, Produktsubkategorie.Subkategorie, Produktkategorie.Kategorie
FROM Umsatzdaten, Produkt, Produktsubkategorie, Produktkategorie
WHERE Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID AND Produktsubkategorie.Kategorie_ID = Produktkategorie.Kategorie_ID
GROUP BY ROLLUP (Produktsubkategorie.Subkategorie, Produkt.Produktname, Produktkategorie.Kategorie)
--Datensätze: 124

--Aufgabe A7.9 (Ausgabe von der Kombination aus Markennamen und Produktnamen)
SELECT SUM(Umsatzdaten.Umsatzbetrag) AS Produktumsatz, CONCAT(Produkt.Produktname,'-',Produkt.Markenname) AS Produktname_Markenname, Produktsubkategorie.Subkategorie, Produktkategorie.Kategorie
FROM Umsatzdaten, Produkt, Produktsubkategorie, Produktkategorie
WHERE Umsatzdaten.Produkt_ID = Produkt.Produkt_ID AND Produkt.Subkategorie_ID = Produktsubkategorie.Subkategorie_ID AND Produktsubkategorie.Kategorie_ID = Produktkategorie.Kategorie_ID
GROUP BY ROLLUP (Produktsubkategorie.Subkategorie, Produkt.Produktname, Produktkategorie.Kategorie, Produkt.Markenname)
--Datensätze: 295

--Aufgabe A8 (Erstellung von MDX-Ausdrücken)




