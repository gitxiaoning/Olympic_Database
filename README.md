# Olympic Database

This is my final project for *CSC343H1: Introduction to Databases*

Me and my partner have designed, cleaned, implemented, and investigated with this database. 

## Raw Data

Kaggle: https://www.kaggle.com/the-guardian/olympic-games?select=summer.csv

## General Information about this database

The domain of our project is te information regarding the previous Olympic games, participant countries, events, and medal winning athletes.



## Investigative Questions

1. The performance of countries for medals?
2. Trying to find the relationship for the number of medals an Olympian earns?
3. How many times has a player served for more than one team?



## Schema

We designed the schema firstly without any knowledge of design and redundancy of data, so we in this section I will state the origional schema we designed and the reasoning behind of changes.

---

Originoal Schema:

1. **Athelete**: contains the unique id of athlete, athlete's first name, middle name and last name.

   **Athlete(<u>athleteID</u>, athleteFirstName, athleteLastName,athleteMiddleName)**

   

2. **Country**: contains the unique id of a country and country name (not necessarily a country name, e.g. a team name).

   **Country(<u>countryID</u>,countryName)**

   

3. **SportsEvent**: contains the medalist of a event, sport name of the event,  discipline name of the event, event name, unique id of an Olympic game, and medal type that medalist earns.

   **SportsEvent(<u>medalists</u>,sportsName, disciplineName, eventName, gameID, medalType)**

   

4. **Game**: contains the unique code of the country, the rank of the country, total medal a country earned in one session of Olympic, year of Olympic.

   **Game(<u>countryID</u>,rank, totalMedal, gameID, year)**

   

5. **PlayersAtGames**: contains unique ID of the athlete, session of Olympic, the event name, sex of a player, height of the player, weight of a player

   **PlayersAtGames(athleteID, gameID, eventName, countryID, sex, height, medals, weight)**

---

As you may notice, there are a lot of redundancy of this schema, combines our findings newly-learnt knowledge of database design and advice from our TAs, we made following changes:

1. **Athelete**: no changes.
2. **Country**: The whole table is removed.
3. **SportEvent**: The original SportsEventtable has an attribute called disciplineName, which is unclear in our table, so the disciplineNameis removed. Since every eventName can only have unique sportsName, which eventName→ sportsName. Since eventNameis not a super key, I split the table into two small tables: Sport and Event. Two new tables that share the same attribute eventName solved the problem of redundancy.
4. **Game**: The original has the redundancy of attribute year. Each game(gameID) has a unique year, which gameID→ year. Thus, the Gametable splits into two small tables: Gameand Team, sharing the attribute of gameID. Also, a new attribute is added to the new table of Game: city. The cityindicates where the Olympic game took place
5. **PlayersAtGames**: The initial table has a lot of redundancy: sex and medals. Since sex will not change for an athlete, so moved the attribute to the **Athlete** table. The medals are redundant since one athlete can only win one medal in an event; since the medal information can be retrieved easily by the Eventtable, the attribute of medalist is removed. The weightand heightinformation are not retrievable, so those two attributes are also removed. The new table is used to solve an athlete's problem that may change the team in different Olympic games.

---



## Revised Schema

1. **Athlete(<u>athleteID</u>, firstName, lastName, middleName, yearOfBirth, sex)**
   - ΠsexAthlete= {‘Male', ‘Female’}
2. **Sport(<u>eventName</u>, sportName)**
3. **Event(<u>eventName, gameID, medalists</u>, medalType)**
   - Event[eventName]⊆Sport[eventName]
   - Event[gameID]⊆Games[gameID]
   - ΠmedalTypeAthlete= {‘Gold’, ‘Silver’, ‘Bronze’}
4. **Game(<u>gameID</u>, year, city)**
5. **Team(<u>teamName, gameID</u>, rank, totalMedal)**
6. **TeamPlayFor(<u>athleteID, gameID</u>, teamName)**
   - TeamPlayFor[athleteID]⊆Althletes[athleteID]
   - TeamPlayFor[gameID]⊆Game[gameID]
   - TeamPlayFor[teamName]⊆Team[teamName]
