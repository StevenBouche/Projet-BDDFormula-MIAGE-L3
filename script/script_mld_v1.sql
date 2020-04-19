#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


#------------------------------------------------------------
# Table: RacingStable
#------------------------------------------------------------

CREATE TABLE RacingStable(
        id Int  Auto_increment  NOT NULL
	,CONSTRAINT RacingStable_PK PRIMARY KEY (id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Pilote
#------------------------------------------------------------

CREATE TABLE Pilote(
        id Int  Auto_increment  NOT NULL
	,CONSTRAINT Pilote_PK PRIMARY KEY (id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Circuit
#------------------------------------------------------------

CREATE TABLE Circuit(
        id Int  Auto_increment  NOT NULL
	,CONSTRAINT Circuit_PK PRIMARY KEY (id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Race
#------------------------------------------------------------

CREATE TABLE Race(
        id         Int  Auto_increment  NOT NULL ,
        dateRace   Date NOT NULL ,
        id_Circuit Int NOT NULL
	,CONSTRAINT Race_PK PRIMARY KEY (id)

	,CONSTRAINT Race_Circuit_FK FOREIGN KEY (id_Circuit) REFERENCES Circuit(id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: RacingStablePilote
#------------------------------------------------------------

CREATE TABLE RacingStablePilote(
        id                 Int  Auto_increment  NOT NULL ,
        startContratPilote Date NOT NULL ,
        endContratPilote   Date NOT NULL ,
        id_RacingStable    Int NOT NULL ,
        id_Pilote          Int NOT NULL
	,CONSTRAINT RacingStablePilote_PK PRIMARY KEY (id)

	,CONSTRAINT RacingStablePilote_RacingStable_FK FOREIGN KEY (id_RacingStable) REFERENCES RacingStable(id)
	,CONSTRAINT RacingStablePilote_Pilote0_FK FOREIGN KEY (id_Pilote) REFERENCES Pilote(id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: Cars
#------------------------------------------------------------

CREATE TABLE Cars(
        id                    Int  Auto_increment  NOT NULL ,
        state                 Enum ("AVAILABLE","MAINTENANCE","CRASHED") NOT NULL ,
        id_RacingStable       Int NOT NULL ,
        id_RacingStablePilote Int NOT NULL
	,CONSTRAINT Cars_PK PRIMARY KEY (id)

	,CONSTRAINT Cars_RacingStable_FK FOREIGN KEY (id_RacingStable) REFERENCES RacingStable(id)
	,CONSTRAINT Cars_RacingStablePilote0_FK FOREIGN KEY (id_RacingStablePilote) REFERENCES RacingStablePilote(id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: TeamRacingStable
#------------------------------------------------------------

CREATE TABLE TeamRacingStable(
        id             Int  Auto_increment  NOT NULL ,
        idRacingStable Int NOT NULL ,
        id_Pilote      Int NOT NULL ,
        id_2_Pilote    Int NOT NULL
	,CONSTRAINT TeamRacingStable_AK UNIQUE (idRacingStable)
	,CONSTRAINT TeamRacingStable_PK PRIMARY KEY (id)

	,CONSTRAINT TeamRacingStable_Pilote_FK FOREIGN KEY (id_Pilote,id_2_Pilote) REFERENCES Pilote(id,id)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: RaceParticipant
#------------------------------------------------------------

CREATE TABLE RaceParticipant(
        id                  Int  Auto_increment  NOT NULL ,
        id_Race             Int ,
        id_TeamRacingStable Int
	,CONSTRAINT RaceParticipant_PK PRIMARY KEY (id)

	,CONSTRAINT RaceParticipant_Race_FK FOREIGN KEY (id_Race) REFERENCES Race(id)
	,CONSTRAINT RaceParticipant_TeamRacingStable0_FK FOREIGN KEY (id_TeamRacingStable) REFERENCES TeamRacingStable(id)
)ENGINE=InnoDB;

