SET SERVEROUTPUT ON;

/*
*	Description textuelle des requêtes de suppression 
*/


--	2 requêtes impliquant 1 table

--		Supprimer toutes les voitures qui CRASHED

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

ROLLBACK;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



--Description textuelle des requêtes de mise à jour 


-- 2 requêtes impliquant 1 table 

UPDATE carsracingstable
SET state = 'AVAILABLE'
WHERE idCar = 22;
ROLLBACK;

UPDATE racingstable
SET constructor = 'FERRARI'
WHERE idRacingstable = 11;
ROLLBACK;

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

-- update tous les status des voitures pour les pilotes qui n'ont pas fini une course

UPDATE carsracingstable
SET state = 'CRASHED'
WHERE carsracingstable.idCar IN (
    SELECT carracingstablepilote.idCar
    FROM carracingstablepilote
    INNER JOIN racingstablepilote ON racingstablepilote.idracingstablepilote = carracingstablepilote.idracingstablepilote
    INNER JOIN raceparticipant ON raceparticipant.idpilote = racingstablepilote.idpilote
    WHERE raceparticipant.idrace = 2
    AND extract(day from (raceparticipant.resulttimerace)*86400) = 0
);

ROLLBACK;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


--La description textuelles des requêtes de consultation 

--5 requêtes impliquant 1 table dont 1 avec un group By et une avec un Order By 

-- tous les pilote trier du plus jeune au plus vieux 


SELECT * 
FROM pilote 
ORDER BY datebirth DESC;


-- le nombre de voiture par ecurie


SELECT COUNT(*) as nbcar, idracingstable 
FROM carsracingstable
group by idracingstable;


-- les ecurie qui ont pour contructeur ferrari


SELECT *
FROM racingstable
WHERE racingstable.constructor LIKE 'FERRARI';


-- les participant d'une course qui ont fini premier  


SELECT *
FROM raceparticipant
WHERE raceparticipant.positionrace = 1;


-- les courses trier par leur kilometrage


SELECT *
FROM race
ORDER BY mileage;


--5 requêtes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri 

-- toutes les courses d'hamilton trier par position


SELECT raceparticipant.positionrace, raceparticipant.idrace
FROM pilote
INNER JOIN raceparticipant ON raceparticipant.idpilote = pilote.idpilote
WHERE pilote.name LIKE 'HAMILTON'
ORDER BY raceparticipant.positionrace;


-- le nombre de fois ou hamilton a fini a une certaine place


SELECT COUNT(raceparticipant.idrace) as nbtimeposition, raceparticipant.positionrace
FROM pilote
INNER JOIN raceparticipant ON raceparticipant.idpilote = pilote.idpilote
WHERE pilote.name LIKE 'HAMILTON'
GROUP BY raceparticipant.positionrace;


-- le nom des ecurie pour chaque pilote actuelle d'une écurie

SELECT racingstable.name, racingstablepilote.idPilote
FROM racingstablepilote
INNER JOIN racingstable ON racingstable.idracingstable = racingstablepilote.idracingstable;


-- toutes les courses pour chaque circuit. Un circuit peut avoir 0 ou plusieurs courses


SELECT *
FROM circuit
LEFT JOIN race ON race.idcircuit = circuit.idCircuit;


-- le pilote et l'ecurie qui ont fini premier lors de chaque courses


SELECT race.idrace, raceparticipant.idpilote, raceparticipant.idracingstable
FROM race
INNER JOIN raceparticipant ON raceparticipant.idRace = race.idRace
WHERE raceparticipant.positionrace = 1;


--5 requêtes impliquant plus de 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri)


-- le nom des voitures actuel pour chaque pilote


SELECT pilote.name, carsracingstable.name
FROM pilote
LEFT JOIN racingstablepilote ON racingstablepilote.idPilote = pilote.idPilote
LEFT JOIN carracingstablepilote ON carracingstablepilote.idracingstablepilote = racingstablepilote.idracingstable
LEFT JOIN carsracingstable ON carsracingstable.idcar = carracingstablepilote.idcar;


-- l'historique pour tous les pilotes avec leur nom et leur écurie et les dates de contrat 


SELECT pilote.name, racingstable.name as nameracingstable, racingstablepilotehistory.hadjoined, racingstablepilotehistory.hadleft
FROM pilote
INNER JOIN racingstablepilotehistory ON racingstablepilotehistory.idPilote = pilote.idPilote
INNER JOIN racingstable ON racingstable.idracingstable = racingstablepilotehistory.idracingstable
ORDER BY racingstablepilotehistory.hadjoined, racingstablepilotehistory.hadleft;


-- le nombre de fois qu'un pilote a fini a une position pour une equipe trier par position puis le nombre de fois descendant


SELECT pilote.name, racingstable.name, raceparticipant.positionrace, COUNT(raceparticipant.positionrace)as nbtimeposition
FROM raceparticipant
INNER JOIN pilote ON pilote.idpilote = raceparticipant.idpilote
INNER JOIN racingstable ON racingstable.idracingstable = raceparticipant.idracingstable
GROUP BY pilote.name, racingstable.name, raceparticipant.positionrace
ORDER BY raceparticipant.positionrace, nbtimeposition DESC;


-- la vitesse moyenne des participants pour chaque course trier par le plus rapide


SELECT circuit.name, race.dateendrace, pilote.name, racingstable.name, raceparticipant.positionrace, ROUND((race.mileage/timeraceparticipant.timeheure),3) as vitesse
FROM raceparticipant
INNER JOIN pilote ON pilote.idpilote = raceparticipant.idpilote
INNER JOIN racingstable ON racingstable.idracingstable = raceparticipant.idracingstable
INNER JOIN race ON race.idrace = raceparticipant.idrace
INNER JOIN circuit ON circuit.idcircuit = race.idcircuit
LEFT JOIN ( SELECT raceparticipant.idRaceParticipant, (extract(day from (raceparticipant.resulttimerace)*86400)/3600) as timeheure FROM raceparticipant) timeraceparticipant ON timeraceparticipant.idraceparticipant = raceparticipant.idraceparticipant
WHERE timeraceparticipant.timeheure != 0
AND raceparticipant.difloop = 0
ORDER BY race.dateendrace,  vitesse DESC;


-- nom du pilote et de l'ecurie pour tous les pilotes actuele d'une ecurie ainsi que le nom de leur voiture si ils en ont eune


SELECT pilote.name as pilotename, racingstable.name as racingstablename, carsracingstable.name as carname
FROM racingstablepilote
INNER JOIN racingstable ON racingstable.idracingstable = racingstablepilote.idracingstable
INNER JOIN pilote ON pilote.idPilote = racingstablepilote.idPilote 
LEFT JOIN carracingstablepilote ON carracingstablepilote.idracingstablepilote = racingstablepilote.idracingstablepilote
LEFT JOIN carsracingstable ON carsracingstable.idcar = carracingstablepilote.idcar AND carsracingstable.idRacingStable = racingstablepilote.idracingstable
ORDER BY racingstable.idRacingstable ;


