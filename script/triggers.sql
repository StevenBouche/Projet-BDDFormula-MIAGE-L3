--------------------------------------------------------
--  Fichier créé - jeudi-avril-30-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger CARRACINGSTABLEPILOTE_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CARRACINGSTABLEPILOTE_BEFORE_INSERT" 
BEFORE INSERT OR UPDATE ON carracingstablepilote FOR EACH ROW
DECLARE
    id_car_rs NUMBER;
    id_rsp_rs NUMBER;
    nb NUMBER;
    not_same_racing_stable EXCEPTION;
    PRAGMA EXCEPTION_INIT(not_same_racing_stable,-20001);
BEGIN

    nb := handleracingstable.car_and_pilote_have_same_racing_stable(:new.idCar,:new.idracingStablePilote);
    -- la voiture et le pilote doivent avoir la même écurie
    IF nb != 1 THEN
          RAISE_APPLICATION_ERROR(-20001, 'NOT SAME RACING STABLE');
    END IF;
    
    EXCEPTION
            WHEN not_same_racing_stable THEN
                DBMS_OUTPUT.PUT_LINE('NOT SAME RACING STABLE');
                raise;
END;
/
ALTER TRIGGER "BS708164LM20"."CARRACINGSTABLEPILOTE_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CARRACINGSTABLEPILOTE_IDCARRACINGSTABLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CARRACINGSTABLEPILOTE_IDCARRACINGSTABLEPILOTE" 
	BEFORE INSERT ON CarRacingStablePilote 
  FOR EACH ROW 
	 WHEN (NEW.idCarRacingStablePilote IS NULL) BEGIN 
		 select Seq_CarRacingStablePilote_idCarRacingStablePilote.NEXTVAL INTO :NEW.idCarRacingStablePilote from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."CARRACINGSTABLEPILOTE_IDCARRACINGSTABLEPILOTE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CARSRACINGSTABLE_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CARSRACINGSTABLE_BEFORE_DELETE" 
BEFORE DELETE ON CARSRACINGSTABLE FOR EACH ROW
BEGIN
    -- delete le lien avec le pilote
  DELETE FROM carracingstablepilote crsp WHERE crsp.idCar = :old.idCar;
  
  UPDATE racingstable
  SET nbcarsavailable = nbcarsavailable-1
  WHERE racingstable.idRacingStable = :new.idRacingStable;
    
END;
/
ALTER TRIGGER "BS708164LM20"."CARSRACINGSTABLE_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CARSRACINGSTABLE_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CARSRACINGSTABLE_BEFORE_INSERT" 
BEFORE INSERT ON CARSRACINGSTABLE FOR EACH ROW
DECLARE
    nb_car NUMBER;
    have_already EXCEPTION;
    PRAGMA EXCEPTION_INIT( have_already,-20001);
BEGIN

    nb_car := handleracingstable.get_nb_car_of_racingstable(:new.idRacingStable);
    -- si l ecurie a plus ou 2 pilotes
    IF nb_car >= 2 THEN
         RAISE have_already;
    END IF;
    
    UPDATE racingstable
    SET nbcarsavailable = nbcarsavailable+1
    WHERE racingstable.idRacingStable = :new.idRacingStable;

    EXCEPTION
        WHEN have_already THEN
            DBMS_OUTPUT.PUT_LINE('RACING STABLE HAVE ALREADY 2 CARS.');
             RAISE;
                
END;
/
ALTER TRIGGER "BS708164LM20"."CARSRACINGSTABLE_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CARSRACINGSTABLE_IDCAR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CARSRACINGSTABLE_IDCAR" 
	BEFORE INSERT ON CarsRacingStable 
  FOR EACH ROW  
	 WHEN (NEW.idCar IS NULL) BEGIN
		 select Seq_Cars_idCar.NEXTVAL INTO :NEW.idCar from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."CARSRACINGSTABLE_IDCAR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CIRCUIT_IDCIRCUIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."CIRCUIT_IDCIRCUIT" 
	BEFORE INSERT ON Circuit 
  FOR EACH ROW 
	 WHEN (NEW.idCircuit IS NULL) BEGIN 
		 select Seq_Circuit_idCircuit.NEXTVAL INTO :NEW.idCircuit from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."CIRCUIT_IDCIRCUIT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PILOTE_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."PILOTE_BEFORE_DELETE" 
BEFORE DELETE ON PILOTE FOR EACH ROW
DECLARE
    number_race_pilote NUMBER;
    have_race EXCEPTION;
    PRAGMA EXCEPTION_INIT(have_race,-20001);
BEGIN
DBMS_OUTPUT.PUT_LINE('Try delete pilote');

    number_race_pilote := handlepilote.get_nb_race_of_pilote(:old.idpilote);
    IF number_race_pilote > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pilote referenced in race participant.');
    END IF;

    DELETE FROM racingstablepilotehistory rsph WHERE rsph.idPilote = :old.idpilote;
    DELETE FROM racingstablepilote rsp WHERE rsp.idPilote = :old.idpilote;

    EXCEPTION
        WHEN have_race THEN
            DBMS_OUTPUT.PUT_LINE('Pilote referenced in race participant.');
             RAISE;

END;
/
ALTER TRIGGER "BS708164LM20"."PILOTE_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PILOTE_IDPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."PILOTE_IDPILOTE" 
	BEFORE INSERT ON Pilote 
  FOR EACH ROW  
	 WHEN (NEW.idPilote IS NULL) BEGIN
		 select Seq_Pilote_idPilote.NEXTVAL INTO :NEW.idPilote from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."PILOTE_IDPILOTE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACE_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACE_BEFORE_DELETE" 
BEFORE DELETE ON RACE  FOR EACH ROW
DECLARE
    nb NUMBER;
    have_result EXCEPTION;
    PRAGMA EXCEPTION_INIT (have_result, -20001);
BEGIN

    nb := handleraceparticipant.get_nb_of_race(:old.idRace);
    IF nb > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'IS REFERENCED IN RACE PARTICIPANT');
    END IF;

  EXCEPTION
    WHEN have_result THEN 
        DBMS_OUTPUT.PUT_LINE('IS REFERENCED IN RACE PARTICIPANT');
        RAISE;
        
END;
/
ALTER TRIGGER "BS708164LM20"."RACE_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACE_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACE_BEFORE_INSERT" 
BEFORE INSERT ON RACE FOR EACH ROW
DECLARE
    date_clone DATE;
    date_coherence EXCEPTION;
    mileage_c NUMBER;
    nb_race NUMBER;
    already EXCEPTION;
    PRAGMA EXCEPTION_INIT (date_coherence, -20002);
    PRAGMA EXCEPTION_INIT (already, -20003);
BEGIN
 
  -- soit un vendredi et que fin soit 2 jours apres un dimanche
    date_clone := :new.datestartrace;
    date_clone := date_clone+2;
   IF to_char(:new.datestartrace,'DY') not in ('VEN.') 
   AND  date_clone != :new.dateendrace 
   THEN
        RAISE_APPLICATION_ERROR(-20002, 'DATE COHERENCE');
   END IF;
   ------------------------------------------------------------
   
   --savoir si il y une course la meme annee deja existante
    nb_race := HANDLERACE.get_nb_race_on_same_circuit_same_year(:new.idCircuit,:new.datestartrace,:new.dateendrace);
   
   IF nb_race > 0 THEN 
          RAISE_APPLICATION_ERROR(-20003, 'ALREADY RACE FOR CIRCUIT');
   END IF;
   ------------------------------------------------------------
   
   --calcule la longeur de la course
    mileage_c := HANDLECIRCUIT.get_mileage_of_circuit(:new.idCircuit);
    :new.mileage := :new.looprace * mileage_c;
   ------------------------------------------------------------
  
  EXCEPTION
    WHEN date_coherence THEN
        DBMS_OUTPUT.PUT_LINE('DATE COHERENCE');
        RAISE;
    WHEN already THEN
        DBMS_OUTPUT.PUT_LINE('ALREADY RACE FOR CIRCUIT');
        RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACE_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACE_IDRACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACE_IDRACE" 
	BEFORE INSERT ON Race 
  FOR EACH ROW  
	 WHEN (NEW.idRace IS NULL) BEGIN
		 select Seq_Race_idRace.NEXTVAL INTO :NEW.idRace from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."RACE_IDRACE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACEPARTICIPANT_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACEPARTICIPANT_BEFORE_INSERT" 
BEFORE INSERT ON RACEPARTICIPANT FOR EACH ROW
DECLARE
    nb NUMBER;
    pos BOOLEAN;
    currentP BOOLEAN;
    race_li Race%ROWTYPE;
    startD DATE;
    startE DATE;
    
    only_two_pilote EXCEPTION;
    current_pilote_and_have_car EXCEPTION;
    history_pilote EXCEPTION;
    position_already_exist EXCEPTION;
    
    PRAGMA EXCEPTION_INIT (only_two_pilote, -20001);
    PRAGMA EXCEPTION_INIT (current_pilote_and_have_car, -20002);
    PRAGMA EXCEPTION_INIT (history_pilote, -20003);
    PRAGMA EXCEPTION_INIT (position_already_exist, -20010);
BEGIN

    --NB PILOTE MAX PER RACE
    nb := handleraceparticipant.get_nb_pilote_of_racing_stable_in_race(:new.idRace,:new.idRacingStable);
    IF nb >= 2 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ALREADY 2 PILOTE FOR THIS RACE');
    END IF;
    
    --POSITION CHECK | CAN'T BE TWO PILOTES AT THE SAME POSITION
    pos := handleraceparticipant.check_pos_by_id_race(:new.IDRACE, :new.POSITIONRACE);
    IF pos THEN
      RAISE_APPLICATION_ERROR(-20010, 'THE NEW PILOTE HAS A WRONG POSITION (ALREADY EXISTS');
    END IF;  
      
    currentP := handleracingstablepilote.pilote_is_current_pilote_of_racing_stable(:new.idPilote,:new.idRacingStable);

    IF currentP THEN 
        --selectionne si le pilote a une voiture et si elle est available
        nb := handleracingstablepilote.get_nb_car_available_for_pilote(:new.idPilote,:new.idRacingStable);
        -- si pas de voiture available
        IF nb = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'PILOTE CURRENT PILOTE BUT HAVE NOT CAR AVAILABLE');
        END IF;
    
    ELSE
    -- is not in current pilote test un history
        -- select date_race
        SELECT * INTO race_li
        FROM race
        WHERE race.idRace = :new.idRace;
        
        startD := race_li.datestartrace;
        startE := race_li.dateendrace;
        --get nb history of pilote at date of race
        nb := handleracingstablepilotehistory.get_nb_pilote_history_between_date(:new.idPilote,:new.idRacingStable,startD,startE);
        
        IF nb != 1 THEN 
            RAISE_APPLICATION_ERROR(-20003, 'PILOTE NOT CURRENT PILOTE AND HAVE NOT HISTORY ON DATE RACE');
        END IF;
        
    END IF;  
    
    EXCEPTION
        WHEN only_two_pilote THEN
             DBMS_OUTPUT.PUT_LINE('ALREADY 2 PILOTE FOR THIS RACE');
             RAISE;
         WHEN current_pilote_and_have_car THEN
             DBMS_OUTPUT.PUT_LINE('PILOTE CURRENT PILOTE BUT HAVE NOT CAR AVAILABLE');
             RAISE;
        WHEN history_pilote THEN
             DBMS_OUTPUT.PUT_LINE('PILOTE NOT CURRENT PILOTE AND HAVE NOT HISTORY ON DATE RACE');
             RAISE;
         WHEN position_already_exist THEN
             DBMS_OUTPUT.PUT_LINE('POSITION ALREADY EXISTS');
             RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACEPARTICIPANT_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACEPARTICIPANT_IDRACEPARTICIPANT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACEPARTICIPANT_IDRACEPARTICIPANT" 
BEFORE INSERT ON RaceParticipant 
FOR EACH ROW  
 WHEN (NEW.idRaceParticipant IS NULL) BEGIN
     select Seq_RaceParticipant_idRaceParticipant.NEXTVAL INTO :NEW.idRaceParticipant from DUAL; 
END;
/
ALTER TRIGGER "BS708164LM20"."RACEPARTICIPANT_IDRACEPARTICIPANT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLE_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLE_BEFORE_DELETE" 
BEFORE DELETE ON racingstable FOR EACH ROW
DECLARE
    nb_have_participate_race NUMBER;
    have_race EXCEPTION;
    PRAGMA EXCEPTION_INIT(have_race,-20001);
BEGIN
   
   nb_have_participate_race := handleracingstable.get_nb_race_of_racingstable(:old.idRacingStable);
   IF nb_have_participate_race > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Racing Stable have pilote referenced in race participant');
   END IF;

    DELETE FROM racingstablepilotehistory rsph WHERE rsph.idRacingStable = :old.idRacingStable;
    DELETE FROM racingstablepilote rsp WHERE rsp.idRacingStable = :old.idRacingStable;
    DELETE FROM carsracingstable crs WHERE crs.idRacingStable = :old.idRacingStable;

    EXCEPTION
        WHEN have_race THEN
            DBMS_OUTPUT.PUT_LINE('Racing Stable have pilote referenced in race participant');
             RAISE;


END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLE_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLE_IDRACINGSTABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLE_IDRACINGSTABLE" 
	BEFORE INSERT ON RacingStable 
  FOR EACH ROW  
	 WHEN (NEW.idRacingStable IS NULL) BEGIN
		 select Seq_RacingStable_idRacingStable.NEXTVAL INTO :NEW.idRacingStable from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLE_IDRACINGSTABLE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTE_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_BEFORE_DELETE" 
BEFORE DELETE ON RACINGSTABLEPILOTE FOR EACH ROW
DECLARE 
    nb NUMBER;
    weekend EXCEPTION;
    PRAGMA EXCEPTION_INIT(weekend,-20002);
BEGIN

  IF to_char(SYSDATE,'DY') in ('VEN.','SAM.','DIM.') THEN
    RAISE_APPLICATION_ERROR(-20002, 'CANNOT REMOVE PLAYER OF RACING STABLE WEEK END'|| to_char(SYSDATE,'DY'));
  END IF;

  INSERT INTO racingstablepilotehistory (hadJoined, hadLeft, idRacingStable, IdPilote) VALUES (:old.dateHaveJoin, SYSDATE, :old.idRacingStable, :old.idPilote);
  DELETE FROM carracingstablepilote crsp WHERE crsp.idRacingStablePilote = :old.idRacingStablePilote;
  
   EXCEPTION
        WHEN weekend THEN
            DBMS_OUTPUT.PUT_LINE('CANNOT REMOVE PLAYER OF RACING STABLE WEEK END '|| to_char(SYSDATE,'DY'));
            RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTE_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_BEFORE_INSERT" 
BEFORE INSERT ON racingstablePilote FOR EACH ROW
DECLARE
    nb_car_rs NUMBER;
    nb_pilote_stable NUMBER;
    have_race EXCEPTION;
    weekend EXCEPTION;
    PRAGMA EXCEPTION_INIT(have_race,-20001);
    PRAGMA EXCEPTION_INIT(weekend,-20002);
BEGIN
  
  IF :new.datehavejoin = NULL THEN
    :new.datehavejoin := SYSDATE;
  END IF;
  
  IF to_char(:new.datehavejoin,'DY') in ('VEN.','SAM.','DIM.') THEN
    RAISE_APPLICATION_ERROR(-20002, 'CANNOT ADD PLAYER IN RACING STABLE WEEK END');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(to_char(:new.datehavejoin,'DY'));
  nb_pilote_stable := handleracingstable.get_nb_pilote_of_racingstable(:new.idracingstable);
  IF nb_pilote_stable  >= 2 THEN
    RAISE_APPLICATION_ERROR(-20001, 'RACING STABLE HAVE ALREADY 2 PILOTE.');
  END IF;
  
    EXCEPTION
        WHEN have_race THEN
            DBMS_OUTPUT.PUT_LINE('RACING STABLE HAVE ALREADY 2 PILOTE.');
            RAISE;
        WHEN weekend THEN
            DBMS_OUTPUT.PUT_LINE('CANNOT ADD PLAYER IN RACING STABLE WEEK END');
            RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTE_IDRACINGSTABLEPILOTE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_IDRACINGSTABLEPILOTE" 
	BEFORE INSERT ON RacingStablePilote 
  FOR EACH ROW  
	 WHEN (NEW.idRacingStablePilote IS NULL) BEGIN
		 select Seq_RacingStablePilote_idRacingStablePilote.NEXTVAL INTO :NEW.idRacingStablePilote from DUAL; 
	END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTE_IDRACINGSTABLEPILOTE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTEHISTORY_BEFORE_DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_BEFORE_DELETE" 
BEFORE DELETE ON RACINGSTABLEPILOTEHISTORY FOR EACH ROW
DECLARE
    nb_race NUMBER;
    have_race EXCEPTION;
    PRAGMA EXCEPTION_INIT(have_race,-20002);
BEGIN

    nb_race := handleraceparticipant.get_nb_race_of_pilote_between_dates(:old.idPilote,:old.idRacingStable,:old.hadJoined,:old.hadLeft); --verifier
    IF nb_race > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'PILOTE REFERENCED IN RACE');
    END IF;
    
    EXCEPTION
        WHEN have_race THEN
            DBMS_OUTPUT.PUT_LINE('PILOTE REFERENCED IN RACE');
             RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_BEFORE_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTEHISTORY_BEFORE_INSERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_BEFORE_INSERT" 
BEFORE INSERT ON RACINGSTABLEPILOTEHISTORY FOR EACH ROW
DECLARE
    nb NUMBER;
    date_coerence EXCEPTION;
    pilote_can_not_have_two_rs EXCEPTION;
    date_week_end EXCEPTION;
    already EXCEPTION;
    PRAGMA EXCEPTION_INIT(date_coerence,-20001);
    PRAGMA EXCEPTION_INIT(date_week_end,-20002);
    PRAGMA EXCEPTION_INIT(already,-20003);
BEGIN
    
    -- date de depart inferieur a la date de fin
    IF :new.hadjoined > : new.hadleft THEN
        RAISE_APPLICATION_ERROR(-20001, 'START DATE > END DATE');
    END IF;
    
    -- les deux dates ne peuvent pas être le week end
    IF to_char(:new.hadLeft,'DY') in ('VEN.','SAM.','DIM.') OR to_char(:new.hadJoined,'DY') in ('VEN.','SAM.','DIM.') THEN
        RAISE_APPLICATION_ERROR(-20002, 'CANNOT ADD PLAYER IN RACING STABLE WEEK END  ' || to_char(:new.hadLeft,'DY') || '    ' || to_char(:new.hadJoined,'DY'));
    END IF;
    
    -- selectionne tous les historiques concernant un pilote et selectionne ceux dont la periode de contrats s'entrecroise
    nb := handleracingstablepilotehistory.get_nb_pilote_history_with_on_same_plage_date(:new.idPilote,:new.hadJoined,:new.hadLeft);
    IF nb > 0 THEN
         RAISE_APPLICATION_ERROR(-20003, 'PILOTE IS ALREADY DEFINE ON SAME DATE');
    END IF;
  
  EXCEPTION 
    WHEN date_coerence THEN 
         DBMS_OUTPUT.PUT_LINE('START DATE > END DATE');
          RAISE;
    WHEN date_week_end THEN 
         DBMS_OUTPUT.PUT_LINE('CANNOT ADD PLAYER IN RACING STABLE WEEK END');
        RAISE;
    WHEN already THEN 
         DBMS_OUTPUT.PUT_LINE('PILOTE IS ALREADY DEFINE ON SAME DATE');
        RAISE;
END;
/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_BEFORE_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RACINGSTABLEPILOTEHISTORY_IDRACINGSTABLEPILOTEHISTORY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_IDRACINGSTABLEPILOTEHISTORY" 
	BEFORE INSERT ON RacingStablePiloteHistory 
  FOR EACH ROW 
	 WHEN (NEW.idRacingStablePiloteHistory IS NULL) BEGIN
		 select Seq_RacingStablePiloteHistory_idRacingStablePiloteHistory.NEXTVAL INTO :NEW.idRacingStablePiloteHistory from DUAL; 
	END;

/
ALTER TRIGGER "BS708164LM20"."RACINGSTABLEPILOTEHISTORY_IDRACINGSTABLEPILOTEHISTORY" ENABLE;
