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

