---------------------------------------------------------------
 --        Script Oracle.  
 ---------------------------------------------------------------

DROP TABLE RacingStablePiloteHistory;
DROP TABLE CarsRacingStable;
DROP TABLE RacingStablePilote;
DROP TABLE RaceParticipant;
DROP TABLE Race;
DROP TABLE Circuit;
DROP TABLE Pilote;
DROP TABLE RacingStable;

DROP SEQUENCE Seq_RacingStablePiloteHistory_idRacingStablePiloteHistory;
DROP SEQUENCE Seq_RacingStable_idRacingStable;
DROP SEQUENCE Seq_Pilote_idPilote;
DROP SEQUENCE Seq_Circuit_idCircuit;
DROP SEQUENCE Seq_Race_idRace;
DROP SEQUENCE Seq_RaceParticipant_idRaceParticipant;
DROP SEQUENCE Seq_RacingStablePilote_idRacingStablePilote;
DROP SEQUENCE Seq_Cars_idCar;

--DROP TRIGGER Pilote_idPilote;
--DROP TRIGGER RacingStablePiloteHistory_idRacingStablePiloteHistory;
--DROP TRIGGER CarsRacingStable_idCar;
--DROP TRIGGER RacingStablePilote_idRacingStablePilote;
--DROP TRIGGER RaceParticipant_idRaceParticipant;
--DROP TRIGGER Race_idRace;
--DROP TRIGGER Circuit_idCircuit;
--DROP TRIGGER RacingStable_idRacingStable;

------------------------------------------------------------
-- Table: RacingStable
------------------------------------------------------------
CREATE TABLE RacingStable(
	idRacingStable   NUMBER NOT NULL ,
	name             VARCHAR2 (50) NOT NULL  ,
	constructor      VARCHAR2 (50) NOT NULL  ,
	dateOfCreation   DATE  NOT NULL  ,
	nbCarsAvailable  NUMBER(10,0) DEFAULT 0 NOT NULL  ,
	timeInRace       INTERVAL DAY TO SECOND DEFAULT '00 00:00:00.000' NOT NULL  ,
	CONSTRAINT RacingStable_PK PRIMARY KEY (idRacingStable)
);

------------------------------------------------------------
-- Table: Pilote
------------------------------------------------------------
CREATE TABLE Pilote(
	idPilote     NUMBER NOT NULL ,
	name         VARCHAR2 (50) NOT NULL  ,
	dateBirth    DATE  NOT NULL  ,
	nationality  VARCHAR2(11) ,
	CONSTRAINT Pilote_PK PRIMARY KEY (idPilote),
	CONSTRAINT CHK_TYPE_nationality CHECK (nationality IN ('ITALIAN','AMERICA','AUSTRALIA','UK','GERMANY','CANADA','FINLAND','FRANCE','MEXICO','MONACO','DENMARK','THAILAND','RUSSIA','NETHERLANDS','SPAIN','ITALY'))
);

------------------------------------------------------------
-- Table: Circuit
------------------------------------------------------------
CREATE TABLE Circuit(
	idCircuit  NUMBER NOT NULL ,
	name       VARCHAR2 (50) NOT NULL  ,
	country    VARCHAR2 (50) NOT NULL  ,
	mileage    FLOAT  NOT NULL  ,
	CONSTRAINT Circuit_PK PRIMARY KEY (idCircuit)
);

------------------------------------------------------------
-- Table: Race
------------------------------------------------------------
CREATE TABLE Race(
	idRace         NUMBER NOT NULL ,
	loopRace       NUMBER(10,0)  NOT NULL  ,
	dateStartRace  DATE  NOT NULL  ,
	dateEndRace    DATE  NOT NULL  ,
	mileage        FLOAT  NOT NULL  ,
	idCircuit      NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT Race_PK PRIMARY KEY (idRace)

	,CONSTRAINT Race_Circuit_FK FOREIGN KEY (idCircuit) REFERENCES Circuit(idCircuit)
);

------------------------------------------------------------
-- Table: RaceParticipant
------------------------------------------------------------
CREATE TABLE RaceParticipant(
	idRaceParticipant  NUMBER NOT NULL ,
	bestTimeQ1         INTERVAL DAY TO SECOND DEFAULT '00 00:00:00.000' NOT NULL ,
	bestTimeQ2         INTERVAL DAY TO SECOND DEFAULT '00 00:00:00.000' NOT NULL ,
	bestTimeQ3         INTERVAL DAY TO SECOND DEFAULT '00 00:00:00.000' NOT NULL ,
	resultTimeRace     INTERVAL DAY TO SECOND DEFAULT '00 00:00:00.000' NOT NULL ,
	idRace             NUMBER(10,0)  NOT NULL  ,
	idPilote           NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT RaceParticipant_PK PRIMARY KEY (idRaceParticipant)

	,CONSTRAINT RaceParticipant_Race_FK FOREIGN KEY (idRace) REFERENCES Race(idRace)
	,CONSTRAINT RaceParticipant_Pilote0_FK FOREIGN KEY (idPilote) REFERENCES Pilote(idPilote)
	,CONSTRAINT RaceParticipant_Pilote_AK UNIQUE (idPilote)
);

------------------------------------------------------------
-- Table: RacingStablePilote
------------------------------------------------------------
CREATE TABLE RacingStablePilote(
	idRacingStablePilote  NUMBER NOT NULL ,
	dateHaveJoin          DATE  NOT NULL  ,
	idRacingStable        NUMBER(10,0)  NOT NULL  ,
	idPilote              NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT RacingStablePilote_PK PRIMARY KEY (idRacingStablePilote)

	,CONSTRAINT RacingStablePilote_RacingStable_FK FOREIGN KEY (idRacingStable) REFERENCES RacingStable(idRacingStable)
	,CONSTRAINT RacingStablePilote_Pilote0_FK FOREIGN KEY (idPilote) REFERENCES Pilote(idPilote)
	,CONSTRAINT RacingStablePilote_Pilote_AK UNIQUE (idPilote)
);

------------------------------------------------------------
-- Table: Cars
------------------------------------------------------------
CREATE TABLE CarsRacingStable(
	idCar                 NUMBER NOT NULL ,
	name                  VARCHAR2 (50) NOT NULL  ,
	state                 VARCHAR2(11) ,
	idRacingStable        NUMBER(10,0)  NOT NULL  ,
	idRacingStablePilote  NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT Cars_PK PRIMARY KEY (idCar),
	CONSTRAINT CHK_TYPE_state CHECK (state IN ('AVAILABLE','MAINTENANCE','CRASHED'))

	,CONSTRAINT Cars_RacingStable_FK FOREIGN KEY (idRacingStable) REFERENCES RacingStable(idRacingStable)
	,CONSTRAINT Cars_RacingStablePilote0_FK FOREIGN KEY (idRacingStablePilote) REFERENCES RacingStablePilote(idRacingStablePilote)
);

------------------------------------------------------------
-- Table: RacingStablePiloteHistory
------------------------------------------------------------
CREATE TABLE RacingStablePiloteHistory(
	idRacingStablePiloteHistory  NUMBER NOT NULL ,
	hadJoined                    DATE  NOT NULL  ,
	hadLeft                      DATE  NOT NULL  ,
	idRacingStable               NUMBER(10,0)  NOT NULL  ,
	idPilote                     NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT RacingStablePiloteHistory_PK PRIMARY KEY (idRacingStablePiloteHistory)

	,CONSTRAINT RacingStablePiloteHistory_RacingStable_FK FOREIGN KEY (idRacingStable) REFERENCES RacingStable(idRacingStable)
	,CONSTRAINT RacingStablePiloteHistory_Pilote0_FK FOREIGN KEY (idPilote) REFERENCES Pilote(idPilote)
);

CREATE SEQUENCE Seq_RacingStable_idRacingStable START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_Pilote_idPilote START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_Circuit_idCircuit START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_Race_idRace START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_RaceParticipant_idRaceParticipant START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_RacingStablePilote_idRacingStablePilote START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_Cars_idCar START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_RacingStablePiloteHistory_idRacingStablePiloteHistory START WITH 1 INCREMENT BY 1 NOCYCLE;

CREATE OR REPLACE TRIGGER RacingStable_idRacingStable
	BEFORE INSERT ON RacingStable 
  FOR EACH ROW 
	WHEN (NEW.idRacingStable IS NULL) 
	BEGIN
		 select Seq_RacingStable_idRacingStable.NEXTVAL INTO :NEW.idRacingStable from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER Pilote_idPilote
	BEFORE INSERT ON Pilote 
  FOR EACH ROW 
	WHEN (NEW.idPilote IS NULL) 
	BEGIN
		 select Seq_Pilote_idPilote.NEXTVAL INTO :NEW.idPilote from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER Circuit_idCircuit
	BEFORE INSERT ON Circuit 
  FOR EACH ROW 
	WHEN (NEW.idCircuit IS NULL) 
	BEGIN
		 select Seq_Circuit_idCircuit.NEXTVAL INTO :NEW.idCircuit from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER Race_idRace
	BEFORE INSERT ON Race 
  FOR EACH ROW 
	WHEN (NEW.idRace IS NULL) 
	BEGIN
		 select Seq_Race_idRace.NEXTVAL INTO :NEW.idRace from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER RaceParticipant_idRaceParticipant
	BEFORE INSERT ON RaceParticipant 
  FOR EACH ROW 
	WHEN (NEW.idRaceParticipant IS NULL) 
	BEGIN
		 select Seq_RaceParticipant_idRaceParticipant.NEXTVAL INTO :NEW.idRaceParticipant from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER RacingStablePilote_idRacingStablePilote
	BEFORE INSERT ON RacingStablePilote 
  FOR EACH ROW 
	WHEN (NEW.idRacingStablePilote IS NULL) 
	BEGIN
		 select Seq_RacingStablePilote_idRacingStablePilote.NEXTVAL INTO :NEW.idRacingStablePilote from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER CarsRacingStable_idCar
	BEFORE INSERT ON CarsRacingStable 
  FOR EACH ROW 
	WHEN (NEW.idCar IS NULL) 
	BEGIN
		 select Seq_Cars_idCar.NEXTVAL INTO :NEW.idCar from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER RacingStablePiloteHistory_idRacingStablePiloteHistory
	BEFORE INSERT ON RacingStablePiloteHistory 
  FOR EACH ROW 
	WHEN (NEW.idRacingStablePiloteHistory IS NULL) 
	BEGIN
		 select Seq_RacingStablePiloteHistory_idRacingStablePiloteHistory.NEXTVAL INTO :NEW.idRacingStablePiloteHistory from DUAL; 
	END;
/
