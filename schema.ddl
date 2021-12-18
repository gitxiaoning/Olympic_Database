DROP SCHEMA IF EXISTS Olympic CASCADE;
CREATE SCHEMA Olympic;
SET SEARCH_PATH TO Olympic;


-- An athlete that wins a medal in at least one olympic game
-- It has information associated with athletes (medal winners): athleteID, firstName, lastName, middleName, sex, and yearOfBirth
-- It has a unique id of an athlete, his/her first name, middle name, last name and sex
CREATE TABLE Athlete (
	athleteID INT NOT NULL,
	firstName TEXT,
    lastName TEXT,
    middleName TEXT DEFAULT NULL,
    sex TEXT NOT NULL, 
	PRIMARY KEY (athleteID),
    CONSTRAINT check_sex CHECK (sex IN ('Men', 'Women'))
);


-- A type of sport 
-- It has eventName, sportName
-- Sport Table contains every type of event
CREATE TABLE Sport (
	eventName TEXT NOT NULL,
    sportName TEXT NOT NULL,
    PRIMARY KEY (eventName)
);


-- A session of Olympic game
-- It has the information regarding the Olympic Game, It also have the year took place and city hold the game: gameID, year, city
-- Game ID is in the format of city + year such as: Beijing 2008 or Tokyo 2020
CREATE TABLE Game (
	gameID TEXT NOT NULL,
    "year" TEXT NOT NULL,
    city TEXT NOT NULL,
    PRIMARY KEY (gameID)
);


-- A Team in a session of Olympic game 
-- It has gameID, teamName, rank, totalMedal
-- It contains all information regarding the team
-- The team name is a 3 character words
CREATE TABLE Team (
	gameID TEXT NOT NULL,
    teamName TEXT NOT NULL,
    PRIMARY KEY (gameID, teamName)
);


-- An event that happens in a session of Olympic
-- It has eventName, gameID, medalists, medalType
-- A event is a game in a sport
-- medalistys and gameID reffereing to athlete and game tables
-- medalists are the id of athlete
-- medal types only are gold, silver and bronze
-- UPDATE: We are alowing multiple athletes to win a same event in a same event in a same year by removing the the (eventName, gameID, medalists) key.
-- Reasoning: There are team games which multipe medalists will win the same medal
CREATE TABLE Event (
	eventName TEXT NOT NULL,
    gameID TEXT NOT NULL,
    medalists INT NOT NULL,
    medalType TEXT NOT NULL CHECK (medalType IN ('Gold', 'Silver', 'Bronze')),
    -- PRIMARY KEY (eventName, gameID, medalists), This key is deleted since there are multiple athletes won the same medal

    FOREIGN KEY (eventName) REFERENCES Sport(eventName),
    FOREIGN KEY (gameID) REFERENCES Game(gameID),
    FOREIGN KEY (medalists) REFERENCES Athlete(athleteID)
);


-- A relation shows player and team
-- It has athleteID, gameID, team
-- It is a relation of athlete and game and his/her team
-- UPDATE: We have to remove the primary key of (athleteID, gameID) since there are circumstances that an althetes joins two teams in a year
-- Reasoning: A player who joined CUB and ZZX two teams in one year. ZZX is a very special team called mixed team
CREATE TABLE TeamPlayFor (
	athleteID INT NOT NULL,
    gameID TEXT NOT NULL,
    teamName TEXT NOT NULL,

    -- PRIMARY KEY (athleteID, gameID), This key is deleted since there are some circumstances that a player joins two teams
    FOREIGN KEY (athleteID) REFERENCES Athlete(athleteID),
    FOREIGN KEY (gameID) REFERENCES Game(gameID),
    FOREIGN KEY (gameID, teamName) REFERENCES Team(gameID, teamName)
    
);