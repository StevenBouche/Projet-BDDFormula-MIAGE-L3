
--------------------------------------------------------
--  DDL for Package HANDLECIRCUIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLECIRCUIT" AS 

    FUNCTION get_mileage_of_circuit(circuit_id IN NUMBER) RETURN FLOAT;

END HANDLECIRCUIT;

/
--------------------------------------------------------
--  DDL for Package HANDLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLEPILOTE" AS 

    -- https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/rowtype_attribute.htm#LNPLS01342
  FUNCTION get_nb_race_of_pilote(p_id IN NUMBER) RETURN NUMBER;

END HANDLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLERACE" AS 

    FUNCTION get_nb_race_on_same_circuit_same_year(circuit_id IN NUMBER, startD IN DATE, endD IN DATE) RETURN NUMBER;
  
END HANDLERACE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACEPARTICIPANT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLERACEPARTICIPANT" AS 

  TYPE rpTYPE IS TABLE OF RACEPARTICIPANT%ROWTYPE INDEX BY BINARY_INTEGER;
  
  FUNCTION raceParticipant_inserer(id_rp IN NUMBER, position_race IN NUMBER, difloop IN NUMBER, id_race IN NUMBER, id_pilote IN NUMBER, id_racingStable IN NUMBER, bestTimeQ1 IN INTERVAL DAY TO SECOND, bestTimeQ2 IN INTERVAL DAY TO SECOND, bestTimeQ3 IN INTERVAL DAY TO SECOND, finalResult IN INTERVAL DAY TO SECOND) RETURN NUMBER;
  FUNCTION raceParticipant_supprimer(id_ligne_a_suppr IN NUMBER) RETURN NUMBER;
  PROCEDURE raceParticipant_lister;
  PROCEDURE raceParticipant_total;
  PROCEDURE raceParticipant_modifierTempsQ1(id_pilote IN NUMBER, id_race IN NUMBER, tempsAModifier IN INTERVAL DAY TO SECOND);
  PROCEDURE raceParticipant_modifierTempsFinal(id_pilote IN NUMBER, id_race IN NUMBER, tempsAModifier IN INTERVAL DAY TO SECOND); 
  PROCEDURE raceParticipant_nb_courses_par_pilote_sur_un_circuit(nom_p IN VARCHAR, nom_c IN VARCHAR);
  PROCEDURE raceParticipant_nb_courses_gagnees_par_tous_les_pilotes_par_ecurie (nom_ecurie IN VARCHAR2);
  PROCEDURE raceParticipant_pilotes_moins_x_annees_par_ecurie(age IN NUMBER, nom_ecurie IN VARCHAR);
  
  FUNCTION get_nb_race_of_pilote_between_dates(p_id IN NUMBER, rs IN NUMBER, startD IN DATE, endD IN DATE) RETURN NUMBER;
  FUNCTION get_nb_of_race(r_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_nb_pilote_of_racing_stable_in_race(id_race IN NUMBER,id_racing IN NUMBER) RETURN NUMBER;
  FUNCTION get_pos_by_id_pilote(id_race IN NUMBER, id_pilote IN NUMBER) RETURN NUMBER;
  FUNCTION check_pos_by_id_race(id_race IN NUMBER, pos IN NUMBER) RETURN BOOLEAN;
  
 
  
    
END HANDLERACEPARTICIPANT;

/
--------------------------------------------------------
--  DDL for Package HANDLERACINGSTABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLERACINGSTABLE" AS 

    FUNCTION get_nb_race_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_nb_pilote_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_nb_car_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION car_and_pilote_have_same_racing_stable(car_id IN NUMBER,pilote_id NUMBER) RETURN NUMBER;
    
END HANDLERACINGSTABLE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACINGSTABLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLERACINGSTABLEPILOTE" AS 

  TYPE rspTYPE IS TABLE OF RACINGSTABLEPILOTE%ROWTYPE INDEX BY BINARY_INTEGER;
    
    FUNCTION racing_stable_pilote_INSERER(id_rsp IN NUMBER, date_join IN DATE, id_rs IN NUMBER, id_pilote IN NUMBER) RETURN NUMBER;
    FUNCTION racing_stable_pilote_SUPPRIMER(id_suppr_line IN NUMBER) RETURN NUMBER;
    PROCEDURE racing_stable_pilote_LIST(date_join IN DATE);
    PROCEDURE racing_stable_pilote_LIST_ALL_PILOTE; 
    PROCEDURE racing_stable_pilot_UPDATE_DATE_JOIN(new_date IN DATE, idPilot IN NUMBER);
    
    FUNCTION pilote_is_current_pilote_of_racing_stable(p_id IN NUMBER,rs_id IN NUMBER) RETURN BOOLEAN;
    FUNCTION get_nb_car_available_for_pilote(idp IN NUMBER, idr IN NUMBER) RETURN NUMBER;
    

     
END HANDLERACINGSTABLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACINGSTABLEPILOTEHISTORY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HANDLERACINGSTABLEPILOTEHISTORY" AS 

    FUNCTION get_nb_pilote_history_between_date(p_id IN NUMBER, rs_id IN NUMBER, sda DATE, eda DATE) RETURN NUMBER;
    FUNCTION get_nb_pilote_history_with_on_same_plage_date(idPilote IN NUMBER,hadJoined IN DATE,hadLeft IN DATE) RETURN NUMBER;
END HANDLERACINGSTABLEPILOTEHISTORY;

/
--------------------------------------------------------
--  DDL for Package Body HANDLECIRCUIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLECIRCUIT" AS

  FUNCTION get_mileage_of_circuit(circuit_id IN NUMBER) RETURN FLOAT AS
    mil FLOAT;
  BEGIN
  
    SELECT mileage INTO mil
    FROM circuit 
    WHERE circuit.idCircuit = circuit_id;
   
    RETURN mil;
  END get_mileage_of_circuit;

END HANDLECIRCUIT;

/
--------------------------------------------------------
--  DDL for Package Body HANDLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLEPILOTE" AS

    FUNCTION get_nb_race_of_pilote(p_id IN NUMBER) RETURN NUMBER AS 
        number_race_pilote NUMBER;
    BEGIN
        SELECT COUNT(*) INTO number_race_pilote 
        FROM raceparticipant 
        WHERE raceparticipant.idpilote = p_id;
        RETURN number_race_pilote;
    END get_nb_race_of_pilote;
    
END HANDLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package Body HANDLERACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLERACE" AS

  FUNCTION get_nb_race_on_same_circuit_same_year(circuit_id IN NUMBER, startD IN DATE, endD IN DATE) RETURN NUMBER AS
    nb NUMBER;
  BEGIN
        SELECT COUNT(*) INTO nb
        FROM race
        WHERE race.idCircuit = circuit_id
        AND EXTRACT(YEAR FROM race.datestartrace) = EXTRACT(YEAR FROM startD)
        AND EXTRACT(YEAR FROM race.dateendrace) = EXTRACT(YEAR FROM endD);
    RETURN nb;
  END get_nb_race_on_same_circuit_same_year;

END HANDLERACE;

/
--------------------------------------------------------
--  DDL for Package Body HANDLERACEPARTICIPANT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLERACEPARTICIPANT" AS
    
--INSERT INTO FUNCTION 
  FUNCTION raceParticipant_inserer(id_rp IN NUMBER, position_race IN NUMBER, difloop IN NUMBER, id_race IN NUMBER, id_pilote IN NUMBER, id_racingStable IN NUMBER, bestTimeQ1 IN INTERVAL DAY TO SECOND, bestTimeQ2 IN INTERVAL DAY TO SECOND, bestTimeQ3 IN INTERVAL DAY TO SECOND, finalResult IN INTERVAL DAY TO SECOND) RETURN NUMBER AS
  BEGIN
    INSERT INTO RACEPARTICIPANT (POSITIONRACE,DIFLOOP,IDRACE,IDPILOTE,IDRACINGSTABLE,BESTTIMEQ1,BESTTIMEQ2,BESTTIMEQ3,RESULTTIMERACE) values (position_race, difloop, id_race, id_pilote, id_racingStable, bestTimeQ1, bestTimeQ2, bestTimeQ3, finalResult);
    COMMIT;
    RETURN id_rp; --INSERTION COMPLETED
  EXCEPTION WHEN OTHERS THEN
    RETURN 0; --INSERTION FAILED
  END raceParticipant_inserer;
  
  --DELETE FUNCTION
  FUNCTION raceParticipant_supprimer(id_ligne_a_suppr IN NUMBER) RETURN NUMBER AS
  BEGIN
    DELETE FROM RACEPARTICIPANT
    WHERE IDRACEPARTICIPANT = id_ligne_a_suppr;
    COMMIT;
    RETURN 1; --DELETION COMPLETED
  EXCEPTION WHEN OTHERS THEN    
    RETURN 0; --DELETION FAILED
  END raceParticipant_supprimer;  
  
  --LIST OF OCCURENCES OF RACEPARTICIPANT ORDERED BY RACE AND POSITION
  PROCEDURE raceParticipant_lister AS
    res rpTYPE; 
    BEGIN
      SELECT * BULK COLLECT INTO res 
      FROM RACEPARTICIPANT 
      ORDER BY IDRACE, POSITIONRACE;
      
      FOR i IN res.FIRST .. res.LAST 
        LOOP
          DBMS_OUTPUT.PUT_LINE('ID Race Participant : ' || res(i).IDRACEPARTICIPANT || ' | POSITION : ' || res(i).POSITIONRACE || ' | DIFLOOP : ' || res(i).DIFLOOP ||' | ID_Race : ' || res(i).IDRACE || ' | ID_PILOTE : ' || res(i).IDPILOTE || ' | ID Racing Stable : ' || res(i).IDRACINGSTABLE || ' | Best Time Q1 : ' || res(i).BESTTIMEQ1 || ' | Best Time Q2 : ' || res(i).BESTTIMEQ2 || ' | Best Time Q3 : ' || res(i).BESTTIMEQ3 || ' | Final Time : ' || res(i).RESULTTIMERACE);
        END LOOP;
      
   END raceParticipant_lister;
   
   --PRINTS THE EXACT NUMBER OF OCCURENCES IN RACEPARTICIPANT
   PROCEDURE raceParticipant_total AS
    res rpTYPE;
    BEGIN
      SELECT * BULK COLLECT INTO res FROM RACEPARTICIPANT;
      DBMS_OUTPUT.PUT_LINE('Occurences de la table RaceParticipant : ' || res.count);
    END raceParticipant_total;  
  
  --UPDATE 1  
  PROCEDURE raceParticipant_modifierTempsQ1(id_pilote IN NUMBER, id_race IN NUMBER, tempsAModifier IN INTERVAL DAY TO SECOND) AS
    BEGIN
      UPDATE RACEPARTICIPANT SET BESTTIMEQ1 = tempsAModifier
      WHERE RACEPARTICIPANT.IDPILOTE = id_pilote AND RACEPARTICIPANT.IDRACE = id_race;
      COMMIT;
    END raceParticipant_modifierTempsQ1;
   
   --UPDATE 2
   PROCEDURE raceParticipant_modifierTempsFinal(id_pilote IN NUMBER, id_race IN NUMBER, tempsAModifier IN INTERVAL DAY TO SECOND) AS
   BEGIN
      UPDATE RACEPARTICIPANT SET RESULTTIMERACE = tempsAModifier
      WHERE RACEPARTICIPANT.IDPILOTE = id_pilote AND RACEPARTICIPANT.IDRACE = id_race;
      COMMIT; 
   END raceParticipant_modifierTempsFinal;
   
   --PRINTS THE NUMBER OF RACES OF A PILOTE ON A CIRCUIT
   PROCEDURE raceParticipant_nb_courses_par_pilote_sur_un_circuit(nom_p IN VARCHAR, nom_c IN VARCHAR) AS 
   res NUMBER;
   nom_circuit CIRCUIT.NAME%TYPE;
   nom_pilote PILOTE.NAME%TYPE;
   BEGIN
      SELECT P.NAME, C.NAME, COUNT(*) INTO nom_pilote, nom_circuit, res FROM RACEPARTICIPANT RP 
      INNER JOIN PILOTE P ON (RP.IDPILOTE = P.IDPILOTE)
      INNER JOIN RACE R ON (RP.IDRACE = R.IDRACE)
      INNER JOIN CIRCUIT C ON (R.IDCIRCUIT = C.IDCIRCUIT)
      WHERE P.NAME = nom_p AND C.NAME = nom_c
      GROUP BY P.NAME, C.NAME, RP.IDPILOTE;
      
      IF res = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Le pilote ' || nom_pilote || ' n as participé à aucune course sur le circuit' || nom_circuit);
        RETURN;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('Nombre de courses : ' || res || ' par le pilote ' || nom_pilote || ' sur le circuit ' || nom_circuit);
   END raceParticipant_nb_courses_par_pilote_sur_un_circuit;
   
   --PRINTS ALL VICTORIES FOR ALL PILOTES IN A GIVEN RACINGSTABLE
   PROCEDURE raceParticipant_nb_courses_gagnees_par_tous_les_pilotes_par_ecurie(nom_ecurie IN VARCHAR2) AS
   type collection_id is table of NUMBER(20,0);
   type collection_var is table of PILOTE.NAME%TYPE;
   
   res collection_id := collection_id(10);
   nom_ecuri collection_var := collection_var(10);
   nom_pilote collection_var := collection_var(10);
   
   BEGIN
      SELECT P.NAME, RS.NAME, COUNT(*) BULK COLLECT INTO nom_pilote, nom_ecuri, res FROM RACEPARTICIPANT RP
      INNER JOIN RACINGSTABLE RS ON RP.IDRACINGSTABLE = RS.IDRACINGSTABLE
      INNER JOIN PILOTE P ON RP.IDPILOTE = P.IDPILOTE 
      WHERE RP.POSITIONRACE = 1 AND RS.NAME = nom_ecurie
      GROUP BY P.NAME, RS.NAME;
      
      IF res IS EMPTY THEN
        DBMS_OUTPUT.PUT_LINE('L ecurie ' || nom_ecurie || ' n as gagnée aucune course');
        RETURN;
      END IF;   
      
      FOR i IN res.FIRST .. res.LAST 
        LOOP
          DBMS_OUTPUT.PUT_LINE('Nombre de victoires : ' || res(i) || ' par ' || nom_pilote(i) || ' de l ecurie ' || nom_ecuri(i));
        END LOOP;
   END;
   
   --PRINTS THE NAMES OF PILOTES THAT ARE YOUNGER THAN A GIVEN AGE IN A GIVEN RACINGSTABLE
   PROCEDURE raceParticipant_pilotes_moins_x_annees_par_ecurie(age IN NUMBER, nom_ecurie IN VARCHAR) AS 
   type collection_var is table of PILOTE.NAME%TYPE;
   nom_pilote collection_var := collection_var(10);
   
   BEGIN
    SELECT DISTINCT P.NAME BULK COLLECT INTO nom_pilote FROM RACEPARTICIPANT RP
    INNER JOIN PILOTE P ON (RP.IDPILOTE = P.IDPILOTE)
    INNER JOIN RACINGSTABLE RS ON (RP.IDRACINGSTABLE = RS.IDRACINGSTABLE) 
    WHERE RS.NAME = nom_ecurie 
    AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM P.DATEBIRTH)) <= age;
    
    IF nom_pilote IS EMPTY THEN
        DBMS_OUTPUT.PUT_LINE('Il n y a pas de pilote de moins de ' || age || ' ans dans l écurie ' || nom_ecurie);
        RETURN;
    END IF;   
    
    FOR i IN nom_pilote.FIRST .. nom_pilote.LAST 
        LOOP
          DBMS_OUTPUT.PUT_LINE('Nom du pilote ayant au moins '|| age || ' ans : ' || nom_pilote(i) || ' dans l ecurie ' || nom_ecurie);
        END LOOP;
   END;
   
  FUNCTION get_nb_race_of_pilote_between_dates(p_id IN NUMBER, rs IN NUMBER, startD IN DATE, endD IN DATE) RETURN NUMBER AS
    nb NUMBER;
  BEGIN
    
    -- a verifier : toutes les course d'un pilote associer a une ecurie sur une certaine periode
    SELECT COUNT(*) 
    INTO nb 
    FROM raceparticipant 
    INNER JOIN race ON race.idRace = raceparticipant.idRace 
    WHERE raceparticipant.idPilote = p_id
    AND raceparticipant.idRacingStable = rs
    AND race.datestartrace >= startD
    AND race.dateendrace <= endD;
    
    RETURN nb;
  END get_nb_race_of_pilote_between_dates;
  
  
   FUNCTION get_nb_of_race(r_id IN NUMBER) RETURN NUMBER AS
    nb NUMBER;
   BEGIN
        SELECT COUNT(*) INTO nb
        FROM raceparticipant 
        WHERE raceparticipant.idRace = r_id;
    RETURN nb;
   END get_nb_of_race;
   
   FUNCTION get_nb_pilote_of_racing_stable_in_race(id_race IN NUMBER,id_racing IN NUMBER) RETURN NUMBER AS
    nb NUMBER;
   BEGIN
       SELECT COUNT(*) INTO nb 
        FROM raceparticipant rp
        WHERE rp.idRace = id_race
        AND rp.idRacingStable = id_racing;
    RETURN nb;
   END get_nb_pilote_of_racing_stable_in_race;
   
   
   FUNCTION get_pos_by_id_pilote(id_race IN NUMBER, id_pilote IN NUMBER) RETURN NUMBER AS 
   pos NUMBER;
   BEGIN
    SELECT positionrace INTO pos
    FROM raceparticipant 
    WHERE id_pilote = raceparticipant.IDPILOTE
    AND idrace = raceparticipant.IDRACE;
   RETURN pos;
   END get_pos_by_id_pilote;
   
   FUNCTION check_pos_by_id_race(id_race IN NUMBER, pos IN NUMBER) RETURN BOOLEAN AS 
   positionP NUMBER;
   BEGIN
    SELECT COUNT(*) INTO positionP
    FROM raceparticipant 
    WHERE raceparticipant.IDRACE = id_race
    AND raceparticipant.POSITIONRACE = pos;
   RETURN (positionP > 0);
   END check_pos_by_id_race;

END HANDLERACEPARTICIPANT;

/
--------------------------------------------------------
--  DDL for Package Body HANDLERACINGSTABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLERACINGSTABLE" AS

  FUNCTION get_nb_race_of_racingstable(rs_id IN NUMBER) RETURN NUMBER AS
    nb_have_participate_race NUMBER;
  BEGIN
        SELECT COUNT(*) 
        INTO nb_have_participate_race 
        FROM raceparticipant rp 
        WHERE rp.idRacingStable = rs_id;
    RETURN nb_have_participate_race;
  END get_nb_race_of_racingstable;
  
  FUNCTION get_nb_pilote_of_racingstable(rs_id IN NUMBER) RETURN NUMBER AS
    nb_pilote_stable NUMBER;
  BEGIN
        SELECT COUNT(*) INTO nb_pilote_stable 
        FROM racingstablePilote 
        WHERE racingstablePilote.idRacingStable = rs_id;
    RETURN nb_pilote_stable;
  END get_nb_pilote_of_racingstable;
  
  FUNCTION get_nb_car_of_racingstable(rs_id IN NUMBER) RETURN NUMBER AS
    nb_car_stable NUMBER;
  BEGIN
        SELECT COUNT(*) INTO nb_car_stable 
        FROM carsracingstable 
        WHERE carsracingstable.idRacingStable = rs_id;
    RETURN nb_car_stable;
  END get_nb_car_of_racingstable;
  
  FUNCTION car_and_pilote_have_same_racing_stable(car_id IN NUMBER,pilote_id NUMBER) RETURN NUMBER AS
   nb NUMBER;
  BEGIN
        SELECT COUNT(*) INTO nb
        FROM racingstable 
        INNER JOIN carsracingstable ON carsracingstable.idRacingStable = racingstable.IdRacingStable
        INNER JOIN racingStablePilote ON racingStablePilote.idRacingStable = racingstable.IdRacingStable
        WHERE carsracingstable.idCar = car_id
        AND racingStablePilote.idracingStablePilote = pilote_id;
    RETURN nb;
  END car_and_pilote_have_same_racing_stable;

END HANDLERACINGSTABLE;

/
--------------------------------------------------------
--  DDL for Package Body HANDLERACINGSTABLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLERACINGSTABLEPILOTE" AS


  --Function INSERT
  FUNCTION racing_stable_pilote_INSERER(id_rsp IN NUMBER, date_join IN DATE, id_rs IN NUMBER, id_pilote IN NUMBER) RETURN NUMBER AS 
  BEGIN
  INSERT INTO RACINGSTABLEPILOTE (IDRACINGSTABLEPILOTE,DATEHAVEJOIN,IDRACINGSTABLE,IDPILOTE) values (id_rsp, date_join, id_rs, id_pilote);
    COMMIT;
    RETURN id_rsp; -- NO ERROR
  EXCEPTION WHEN OTHERS THEN 
    RETURN 0; -- ERROR
  END racing_stable_pilote_INSERER;
  
  --Function DELETE
  FUNCTION racing_stable_pilote_SUPPRIMER(id_suppr_line IN NUMBER) RETURN NUMBER AS
   BEGIN
    DELETE FROM RACINGSTABLEPILOTE
    WHERE IDRACINGSTABLEPILOTE = id_suppr_line;
    COMMIT;
    RETURN 1; --DELETION COMPLETED
  EXCEPTION WHEN OTHERS THEN    
    RETURN 0; --DELETION FAILED
  END racing_stable_pilote_SUPPRIMER;
  
  
  --Function LIST : LIST all the pilote ordered by racing stable id and pilote id that join the racing stable before the date given
  PROCEDURE racing_stable_pilote_LIST (date_join IN DATE) AS
  res rspTYPE;
  BEGIN
    SELECT * BULK COLLECT INTO res
    FROM RACINGSTABLEPILOTE
    ORDER BY IDRACINGSTABLE, IDPILOTE;
    
    FOR i in res.FIRST .. res.LAST
      LOOP
        IF res(i).DATEHAVEJOIN < date_join THEN
          DBMS_OUTPUT.PUT_LINE('ID RACING STABLE : ' || res(i).IDRACINGSTABLE || ' | ID PILOT :' || res(i).IDPILOTE || ' | DATE THE PILOT JOIN THE STABLE : ' || res(i).DATEHAVEJOIN);
        END IF;
      END LOOP;
  END racing_stable_pilote_LIST;
  
  PROCEDURE racing_stable_pilote_LIST_ALL_PILOTE AS
  
  type collection_pilote IS TABLE OF PILOTE.NAME%TYPE;
  type collection_ecurie IS TABLE OF RACINGSTABLE.NAME%TYPE;
  type collection_date IS VARRAY(25) OF DATE;
  
  nom_pilote collection_pilote:= collection_pilote(20);
  nom_ecurie collection_ecurie:= collection_ecurie(15);
  date_join collection_date; 
  
  
  BEGIN
    SELECT P.NAME, RS.NAME, RSP.DATEHAVEJOIN BULK COLLECT INTO nom_pilote, nom_ecurie, date_join FROM RACINGSTABLEPILOTE RSP
    INNER JOIN PILOTE P ON (RSP.IDPILOTE = P.IDPILOTE) 
    INNER JOIN RACINGSTABLE RS ON (RSP.IDRACINGSTABLE = RS.IDRACINGSTABLE)
    ORDER BY RSP.IDRACINGSTABLE, RSP.IDPILOTE;
    
    
    FOR i IN date_join.FIRST .. date_join.LAST
    LOOP
      DBMS_OUTPUT.PUT_LINE('Le pilote : ' || nom_pilote(i) || ' appartient à l ecurie : ' || nom_ecurie(i) || ' depuis : ' || date_join(i));
    END LOOP;
  END racing_stable_pilote_LIST_ALL_PILOTE;
  
  PROCEDURE racing_stable_pilot_UPDATE_DATE_JOIN(new_date IN DATE, idPilot IN NUMBER) AS
  BEGIN
    UPDATE RACINGSTABLEPILOTE SET DATEHAVEJOIN = new_date
    WHERE IDPILOTE = idPilot;
    COMMIT;
  END racing_stable_pilot_UPDATE_DATE_JOIN;
  
  PROCEDURE racing_stable_pilote_TRANSFER_PILOTE(pilote_1 IN NUMBER, pilote_2 IN NUMBER) AS
  BEGIN
    UPDATE RACINGSTABLEPILOTE
    SET IDRACINGSTABLE = ( SELECT SUM(IDRACINGSTABLE)
                            FROM RACINGSTABLEPILOTE
                            WHERE IDPILOTE IN (pilote_1, pilote_2)) - IDRACINGSTABLE
    WHERE IDPILOTE IN (pilote_1, pilote_2);
    COMMIT;
  END racing_stable_pilote_TRANSFER_PILOTE;  

  
  
  FUNCTION pilote_is_current_pilote_of_racing_stable(p_id IN NUMBER,rs_id IN NUMBER) RETURN BOOLEAN AS
    nb NUMBER;
  BEGIN
    SELECT COUNT(*) INTO nb
    FROM racingstablepilote
    WHERE racingstablepilote.idRacingStable = rs_id
    AND racingstablepilote.idPilote = p_id;
    RETURN (nb = 1);
  END pilote_is_current_pilote_of_racing_stable;
  
  FUNCTION get_nb_car_available_for_pilote(idp IN NUMBER, idr IN NUMBER) RETURN NUMBER AS
    nb NUMBER;
  BEGIN 
        SELECT COUNT(*) INTO nb 
        FROM racingstablepilote rsp 
        INNER JOIN carracingstablepilote ON carracingstablepilote.idRacingStablePilote = rsp.idRacingStablePilote
        INNER JOIN carsracingstable ON carsracingstable.idCar = carracingstablepilote.idCar
        WHERE rsp.idPilote = idp
        AND rsp.idRacingStable = idr
        AND carsracingstable.state LIKE 'AVAILABLE';
    RETURN nb;
  END get_nb_car_available_for_pilote;

END HANDLERACINGSTABLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package Body HANDLERACINGSTABLEPILOTEHISTORY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HANDLERACINGSTABLEPILOTEHISTORY" AS

  FUNCTION get_nb_pilote_history_between_date(p_id IN NUMBER, rs_id IN NUMBER, sda DATE, eda DATE) RETURN NUMBER AS
    nb NUMBER;
    date_coherence EXCEPTION;
    PRAGMA EXCEPTION_INIT (date_coherence, -20001);
  BEGIN
    
    IF sda > eda THEN
        RAISE_APPLICATION_ERROR(-20001, 'Date coherence start > end');
    END IF;
    
    SELECT COUNT(*) INTO nb
    FROM racingstablepilotehistory rsph
    WHERE rsph.idPilote = p_id
    AND rsph.idRacingStable = rs_id
    AND rsph.hadjoined < sda
    AND rsph.hadleft > eda;
    
    RETURN nb;
    
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
            
  END get_nb_pilote_history_between_date;
  
  FUNCTION get_nb_pilote_history_with_on_same_plage_date(idPilote IN NUMBER,hadJoined IN DATE,hadLeft IN DATE) RETURN NUMBER AS
    nb NUMBER;
  BEGIN 
    SELECT COUNT(*) INTO nb
    FROM racingstablepilotehistory rsph 
    WHERE rsph.idPilote = idPilote
    AND (rsph.hadJoined < hadJoined AND rsph.hadLeft > hadJoined)
    OR (rsph.hadJoined < hadleft AND rsph.hadLeft > hadleft)
    OR (rsph.hadJoined > hadJoined AND rsph.hadLeft < hadleft) ;
  RETURN nb;
  END get_nb_pilote_history_with_on_same_plage_date;

END HANDLERACINGSTABLEPILOTEHISTORY;

/
COMMIT;