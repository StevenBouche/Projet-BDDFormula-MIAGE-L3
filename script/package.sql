--------------------------------------------------------
--  Fichier créé - jeudi-avril-30-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package HANDLECIRCUIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLECIRCUIT" AS 

 -- FUNCTION create_circuit(ci_name VARCHAR2, ci_country VARCHAR2, ci_mileage FLOAT) return circuit%rowtype;
 -- FUNCTION update_circuit(ci_name VARCHAR2, ci_country VARCHAR2, ci_mileage FLOAT) return circuit%rowtype;
 -- FUNCTION get_circuit(ci_id NUMBER) return circuit%rowtype;
 -- FUNCTION get_all_circuit return CircuitsType;
 
    FUNCTION get_mileage_of_circuit(circuit_id IN NUMBER) RETURN FLOAT;

END HANDLECIRCUIT;

/
--------------------------------------------------------
--  DDL for Package HANDLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLEPILOTE" AS 

    -- https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/rowtype_attribute.htm#LNPLS01342
   
 -- PROCEDURE create_pilote(p_name IN VARCHAR2, p_nationality IN VARCHAR2, datebirth IN DATE, pilote_line out pilote%rowtype);
  
  FUNCTION get_nb_race_of_pilote(p_id IN NUMBER) RETURN NUMBER;
 -- FUNCTION update_pilote(p_name VARCHAR2, p_nationality VARCHAR2,datebirth IN DATE) RETURN pilote%rowtype;
 -- FUNCTION get_pilote(p_id NUMBER) RETURN pilote%rowtype;
  

END HANDLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLERACE" AS 

--  FUNCTION create_race(ci_id NUMBER, r_start_date DATE, r_start_end DATE, r_nb_loop NUMBER) return race%rowtype;
 -- FUNCTION update_race(ci_id NUMBER, r_start_date DATE, r_start_end DATE, r_nb_loop NUMBER) return race%rowtype;
 -- FUNCTION get_race(r_id NUMBER) return race%rowtype;
 
    FUNCTION get_nb_race_on_same_circuit_same_year(circuit_id IN NUMBER, startD IN DATE, endD IN DATE) RETURN NUMBER;
  
END HANDLERACE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACEPARTICIPANT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLERACEPARTICIPANT" AS 

  --  TYPE TeamOfRacingStable IS TABLE OF raceparticipant%rowtype;
    
 --   FUNCTION create_race_participant(rs_id NUMBER) return raceparticipant%rowtype;
 --   FUNCTION update_race_participant(timeq1 INTERVAL DAY TO SECOND, timeq2 INTERVAL DAY TO SECOND, timeq3 INTERVAL DAY TO SECOND, resultRace INTERVAL DAY TO SECOND) return raceparticipant%rowtype;
 --   FUNCTION get_race_participant(rs_id NUMBER) return TeamOfRacingStable;
  --  FUNCTION get_race_participant(p_id NUMBER) return raceparticipant%rowtype;
  
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

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLERACINGSTABLE" AS 

  --FUNCTION create_racing_stable(rs_name VARCHAR2, rs_constructor VARCHAR2, rs_creation DATE) return racingstable%rowtype;
  --FUNCTION update_racing_stable(rs_name VARCHAR2, rs_constructor VARCHAR2, rs_creation DATE) return racingstable%rowtype;
  --FUNCTION get_racing_stable (rs_id NUMBER) return racingstable%rowtype;
    FUNCTION get_nb_race_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_nb_pilote_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_nb_car_of_racingstable(rs_id IN NUMBER) RETURN NUMBER;
    FUNCTION car_and_pilote_have_same_racing_stable(car_id IN NUMBER,pilote_id NUMBER) RETURN NUMBER;
    
END HANDLERACINGSTABLE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACINGSTABLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLERACINGSTABLEPILOTE" AS 

  --  TYPE RacingStablePiloteType IS TABLE OF racingstablepilote%rowtype;
    
  --  FUNCTION create_racing_stable_pilote(rs_id NUMBER, p_id NUMBER) return racingstablepilote%rowtype;
  --  FUNCTION get_racing_stable_pilote(rsp_id NUMBER) return racingstablepilote%rowtype;
  --  FUNCTION get_racing_stable_pilotes(rs_id NUMBER) return RacingStablePiloteType;
  --  PROCEDURE delete_racing_stable_pilote(rsp_id NUMBER);
    
    FUNCTION pilote_is_current_pilote_of_racing_stable(p_id IN NUMBER,rs_id IN NUMBER) RETURN BOOLEAN;
    FUNCTION get_nb_car_available_for_pilote(idp IN NUMBER, idr IN NUMBER) RETURN NUMBER;
    
END HANDLERACINGSTABLEPILOTE;

/
--------------------------------------------------------
--  DDL for Package HANDLERACINGSTABLEPILOTEHISTORY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."HANDLERACINGSTABLEPILOTEHISTORY" AS 

   -- TYPE RacingStablePiloteHistoryType IS TABLE OF racingstablepilotehistory%rowtype;
    
   -- FUNCTION create_racing_stable_pilote_history(rs_id NUMBER, p_id NUMBER) return racingstablepilotehistory%rowtype;
  --  FUNCTION get_racing_stable_pilotes_history(rs_id NUMBER) return RacingStablePiloteHistoryType;
  --  FUNCTION get_racing_stable_pilote_history(p_id NUMBER) return racingstablepilotehistory%rowtype;
  
    FUNCTION get_nb_pilote_history_between_date(p_id IN NUMBER, rs_id IN NUMBER, sda DATE, eda DATE) RETURN NUMBER;
    FUNCTION get_nb_pilote_history_with_on_same_plage_date(idPilote IN NUMBER,hadJoined IN DATE,hadLeft IN DATE) RETURN NUMBER;
END HANDLERACINGSTABLEPILOTEHISTORY;

/
--------------------------------------------------------
--  DDL for Package MISEAJOUR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."MISEAJOUR" AS 

  /* TO DO enter package declarations (types, exceptions, methods etc) here
  
  (2 requêtes impliquant 1 table, 2 requêtes impliquant 2 tables, 2 requêtes impliquant plus de 2 tables)

  
  */ 

END MISEAJOUR;

/
--------------------------------------------------------
--  DDL for Package SUPPRESSION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "BS708164LM20"."SUPPRESSION" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here 
  
 (2 requêtes impliquant 1 table, 2 requêtes impliquant 2 tables, 2 requêtes impliquant plus de 2 tables)
  
  */ 

END SUPPRESSION;

/
--------------------------------------------------------
--  DDL for Package Body HANDLECIRCUIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLECIRCUIT" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLEPILOTE" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLERACE" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLERACEPARTICIPANT" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLERACINGSTABLE" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLERACINGSTABLEPILOTE" AS

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

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "BS708164LM20"."HANDLERACINGSTABLEPILOTEHISTORY" AS

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
