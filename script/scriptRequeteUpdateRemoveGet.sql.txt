 --Description textuelle des requêtes de suppression 

--2 requêtes impliquant 1 table

--	Supprimer toutes les voitures qui CRASHED

DELETE FROM carsracingstable WHERE carsracingstable.state LIKE 'CRASHED';


--	Supprimer tous les pilotes actuelles de l'ecurie MIAGE

DELETE FROM racingstablepilote WHERE idracingstable = 11;


--2 requêtes impliquant 2 tables 

--	Supprimer tous les pilotes qui n’ont jamais effectuer de course 


DELETE
FROM pilote 
WHERE idPilote IN (SELECT pilote.idpilote 
		   FROM pilote
		   LEFT JOIN raceparticipant ON raceparticipant.idPilote = pilote.idPilote
		   WHERE raceparticipant.idPilote IS NULL)
;

--	Supprimer toutes les écuries qui n’ont jamais effectuer de course


DELETE 
FROM racingstable
WHERE idRacingStable IN (
    SELECT racingstable.idRacingStable
    FROM racingstable
    LEFT JOIN raceparticipant ON raceparticipant.idRacingStable = racingstable.idRacingStable
    WHERE raceparticipant.idRacingStable IS NULL);




--2 requêtes impliquant plus de 2 tables

--	Supprimer tous les pilotes qui n’ont jamais fait partie d’une écurie

DELETE
FROM pilote 
WHERE idPilote IN (SELECT pilote.idpilote 
    FROM pilote
    LEFT JOIN racingstablepilote ON racingstablepilote.idPilote = pilote.idPilote
    LEFT JOIN racingstablepilotehistory ON racingstablepilotehistory.idPilote = pilote.idPilote
    WHERE racingstablepilote.idPilote IS NULL
    AND racingstablepilotehistory.idPilote IS NULL);

--	Supprimer toutes les écuries qui n’ont pas de pilote et qui n’en ont jamais eu


DELETE
FROM racingstable 
WHERE idRacingStable IN (SELECT racingstable.idRacingStable 
    FROM racingstable
    LEFT JOIN racingstablepilote ON racingstablepilote.idRacingStable  = racingstable.idRacingStable
    LEFT JOIN racingstablepilotehistory ON racingstablepilotehistory.idRacingStable = racingstable.idRacingStable
    WHERE racingstablepilote.idRacingStable IS NULL
    AND racingstablepilotehistory.idRacingStable IS NULL);



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



--Description textuelle des requêtes de mise à jour 


-- 2 requêtes impliquant 1 table 

UPDATE carsracingstable
SET state = 'AVAILABLE'
WHERE idCar = 22;


UPDATE racingstable
SET constructor = 'FERRARI'
WHERE idCar = 11;


-- 2 requêtes impliquant 2 tables 


--	Update le nombre de kilomètre d’une course qui correspond au nombre de tour de la cource * par le nombre de kilomètre d’un circuit


UPDATE race
SET mileage = (
    SELECT (race.looprace*circuit.mileage )
    FROM circuit 
    WHERE circuit.idcircuit = race.idcircuit
);


--	Update nbCard available in racingstable
	

UPDATE racingstable
SET nbcarsavailable = (
    SELECT COUNT(*)
    FROM carsracingstable
    WHERE carsracingstable.idracingstable = racingstable.idracingstable
);



-- 2 requêtes impliquant plus de 2 tables

--  on veut update l’état de la voiture d’un participant d’une course qui a eu un accident


UPDATE carsracingstable
SET state = 'CRASHED'
WHERE carsracingstable.idCar = (
SELECT carracingstablepilote.idCar
FROM carracingstablepilote
INNER JOIN racingstablepilote ON racingstablepilote.idracingstablepilote = carracingstablepilote.idracingstablepilote
INNER JOIN raceparticipant ON raceparticipant.idpilote = racingstablepilote.idpilote
WHERE raceparticipant.idrace = 2
AND raceparticipant.idpilote = 1
);



