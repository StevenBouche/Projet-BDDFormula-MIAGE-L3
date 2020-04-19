
DROP TABLE RaceParticipant;
DROP TABLE TeamRacingStable;
DROP TABLE Cars;
DROP TABLE RacingStablePilote;
DROP TABLE Race;
DROP TABLE Circuit;
DROP TABLE Pilote;
DROP TABLE RacingStable;

------------------------------------------------------------
-- Table: RacingStable
------------------------------------------------------------
CREATE TABLE RacingStable(
	id  NUMBER NOT NULL ,
	CONSTRAINT RacingStable_PK PRIMARY KEY (id)
);

------------------------------------------------------------
-- Table: Pilote
------------------------------------------------------------
CREATE TABLE Pilote(
	id  NUMBER NOT NULL ,
	CONSTRAINT Pilote_PK PRIMARY KEY (id)
);

------------------------------------------------------------
-- Table: Circuit
------------------------------------------------------------
CREATE TABLE Circuit(
	id  NUMBER NOT NULL ,
	CONSTRAINT Circuit_PK PRIMARY KEY (id)
);

------------------------------------------------------------
-- Table: Race
------------------------------------------------------------
CREATE TABLE Race(
	id          NUMBER NOT NULL ,
	dateRace    DATE  NOT NULL  ,
	id_Circuit  NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT Race_PK PRIMARY KEY (id)

	,CONSTRAINT Race_Circuit_FK FOREIGN KEY (id_Circuit) REFERENCES Circuit(id)
);

------------------------------------------------------------
-- Table: RacingStablePilote
------------------------------------------------------------
CREATE TABLE RacingStablePilote(
	id                  NUMBER NOT NULL ,
	startContratPilote  DATE  NOT NULL  ,
	endContratPilote    DATE  NOT NULL  ,
	id_RacingStable     NUMBER(10,0)  NOT NULL  ,
	id_Pilote           NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT RacingStablePilote_PK PRIMARY KEY (id)

	,CONSTRAINT RacingStablePilote_RacingStable_FK FOREIGN KEY (id_RacingStable) REFERENCES RacingStable(id)
	,CONSTRAINT RacingStablePilote_Pilote0_FK FOREIGN KEY (id_Pilote) REFERENCES Pilote(id)
);

------------------------------------------------------------
-- Table: Cars
------------------------------------------------------------
CREATE TABLE Cars(
	id                     NUMBER NOT NULL ,
	state                  VARCHAR2(11) ,
	id_RacingStable        NUMBER(10,0)  NOT NULL  ,
	id_RacingStablePilote  NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT Cars_PK PRIMARY KEY (id),
	CONSTRAINT CHK_TYPE_state CHECK (state IN ('AVAILABLE','MAINTENANCE','CRASHED'))

	,CONSTRAINT Cars_RacingStable_FK FOREIGN KEY (id_RacingStable) REFERENCES RacingStable(id)
	,CONSTRAINT Cars_RacingStablePilote0_FK FOREIGN KEY (id_RacingStablePilote) REFERENCES RacingStablePilote(id)
);

------------------------------------------------------------
-- Table: TeamRacingStable
------------------------------------------------------------
CREATE TABLE TeamRacingStable(
	id              NUMBER NOT NULL ,
	idRacingStable  NUMBER(10,0) NOT NULL  ,
	id_Pilote       NUMBER(10,0)  NOT NULL  ,
	id_Pilote_One   NUMBER(10,0)  NOT NULL  ,
    id_Pilote_Two   NUMBER(10,0)  NOT NULL  ,
	CONSTRAINT TeamRacingStable_PK PRIMARY KEY (id) ,
	CONSTRAINT TeamRacingStable_AK UNIQUE (idRacingStable)
	,CONSTRAINT TeamRacingStable_Pilote_One_FK FOREIGN KEY (id_Pilote_One) REFERENCES Pilote(id)
    ,CONSTRAINT TeamRacingStable_Pilote_Two_FK FOREIGN KEY (id_Pilote_Two) REFERENCES Pilote(id)
);

------------------------------------------------------------
-- Table: RaceParticipant
------------------------------------------------------------

CREATE TABLE RaceParticipant(
	id                   NUMBER NOT NULL ,
	id_Race              NUMBER(10,0)   ,
	id_TeamRacingStable  NUMBER(10,0)   ,
	CONSTRAINT RaceParticipant_PK PRIMARY KEY (id)

	,CONSTRAINT RaceParticipant_Race_FK FOREIGN KEY (id_Race) REFERENCES Race(id)
	,CONSTRAINT RaceParticipant_TeamRacingStable0_FK FOREIGN KEY (id_TeamRacingStable) REFERENCES TeamRacingStable(id)
);

DROP SEQUENCE Seq_RacingStable_id;
CREATE SEQUENCE Seq_RacingStable_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_Pilote_id;
CREATE SEQUENCE Seq_Pilote_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_Circuit_id;
CREATE SEQUENCE Seq_Circuit_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_Race_id;
CREATE SEQUENCE Seq_Race_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_RacingStablePilote_id;
CREATE SEQUENCE Seq_RacingStablePilote_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_Cars_id;
CREATE SEQUENCE Seq_Cars_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_TeamRacingStable_id;
CREATE SEQUENCE Seq_TeamRacingStable_id START WITH 1 INCREMENT BY 1 NOCYCLE;
DROP SEQUENCE Seq_RaceParticipant_id;
CREATE SEQUENCE Seq_RaceParticipant_id START WITH 1 INCREMENT BY 1 NOCYCLE;

CREATE OR REPLACE TRIGGER RacingStable_id
	BEFORE INSERT ON RacingStable 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_RacingStable_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER Pilote_id
	BEFORE INSERT ON Pilote 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_Pilote_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER Circuit_id
	BEFORE INSERT ON Circuit 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_Circuit_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER Race_id
	BEFORE INSERT ON Race 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_Race_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER RacingStablePilote_id
	BEFORE INSERT ON RacingStablePilote 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_RacingStablePilote_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER Cars_id
	BEFORE INSERT ON Cars 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_Cars_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER TeamRacingStable_id
	BEFORE INSERT ON TeamRacingStable 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_TeamRacingStable_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;
CREATE OR REPLACE TRIGGER RaceParticipant_id
	BEFORE INSERT ON RaceParticipant 
  FOR EACH ROW 
	WHEN (NEW.id IS NULL) 
	BEGIN
		 select Seq_RaceParticipant_id.NEXTVAL INTO :NEW.id from DUAL; 
	END;

