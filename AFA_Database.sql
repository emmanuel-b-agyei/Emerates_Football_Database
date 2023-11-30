-- Drop the database if it exists
DROP DATABASE IF EXISTS AFA_Database;

-- Create the database
CREATE DATABASE AFA_Database;

-- Switch to the newly created database
USE AFA_Database;

-- Create the Coaches table
CREATE TABLE Coaches (
    coach_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    contact_number VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE
);

-- Create the Teams table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(255) NOT NULL,
    coach_id INT NOT NULL,
    FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id)
);

-- Create the Generalized Players table
CREATE TABLE Players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    contact_number VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE,
    address VARCHAR(255),
    academic_program VARCHAR(255) NOT NULL,
    academic_year INT NOT NULL CHECK (academic_year > 0 AND academic_year <= 4),
    team_id INT NOT NULL,
    age INT NOT NULL CHECK (age > 0),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Create the specialized Player table, GK
CREATE TABLE GoalKeeper (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    Overall_rating INT NOT NULL CHECK (Overall_rating >= 0 AND Overall_rating <= 100),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Create the specialized Player table, MD
CREATE TABLE Midfielder (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    Overall_rating INT NOT NULL CHECK (Overall_rating >= 0 AND Overall_rating <= 100),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Create the specialized Player table, FW
CREATE TABLE Forward (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    Overall_rating INT NOT NULL CHECK (Overall_rating >= 0 AND Overall_rating <= 100),
    FOREIGN KEY (player_id) REFERENCES Players(player_id) 
);

-- Create the specialized Player table, DF
CREATE TABLE Defender (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    Overall_rating INT NOT NULL CHECK (Overall_rating >= 0 AND Overall_rating <= 100),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Create the Competition table
CREATE TABLE Competition (
    competition_id INT PRIMARY KEY AUTO_INCREMENT,
    competition_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    details TEXT NOT NULL,
    prize_money DECIMAL(10,2) NOT NULL CHECK (prize_money >= 0)
);


-- Create the Matches table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    match_date DATE,
    venue VARCHAR(255) NOT NULL,
    home_team INT NOT NULL,
    away_team INT NOT NULL,
    home_team_score INT NOT NULL,
    away_team_score INT NOT NULL,
    winner_id INT,
    competition_id INT NOT NULL,
    FOREIGN KEY (home_team) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_id) REFERENCES Teams(team_id),
    FOREIGN KEY (competition_id) REFERENCES Competition(competition_id)
);

-- Create the Goals table
CREATE TABLE Goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Create the Assists table
CREATE TABLE Assists (
    assist_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT NOT NULL,
    goal_id INT NOT NULL,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (goal_id) REFERENCES Goals(goal_id)
);

-- Create the Contracts table
CREATE TABLE Contracts (
    contract_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    team_id INT NOT NULL,
    UNIQUE (player_id, team_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Coaches table
INSERT INTO Coaches (first_name, last_name, contact_number, email) VALUES
('Kofi', 'Kyeremanteng', '0597449382', 'kofi.kyere@gmail.com'),
('Kwesi', 'Tekyi', '0247654320', 'kwesi.Tekyi@gmail.com'),
('Eugene', 'Micah', '0248654020', 'Eugene.Micah@gmail.com'),
('Madoc', 'Kway', '0598674395', 'Madoc.Kway@gmail.com'),
('Kotaa', 'Ansah', '0594729473', 'Kotaa.Ansah@gmail.com'),
('Jason', 'Blay', '0235485736', 'Jason.Blay@gmail.com');

-- Teams table
INSERT INTO Teams (team_name, coach_id) VALUES
('Team Kasanoma', 5),
('Team Red army', 2),
('Team Northside', 1),
('Team ELite', 4),
('Team Highlanders', 3),
('Team Legends', 6);

-- Players table
INSERT INTO Players (first_name, last_name, gender, date_of_birth, contact_number, email, address, academic_program, academic_year, team_id, age) VALUES
('Emmanuel', 'Soumahoro', 'Male', '2003-09-06', '0597220511', 'emmanuel.soumahoro@gmail.com', 'Tema Main St', 'Computer Science', 2, 2, 19),
('Faisal', 'Alidu', 'Male', '2000-09-21', '0538475638', 'faisal.alidu@gmail.com', '456 Elm St', 'Computer Science', 2, 2, 20),
('Willams', 'Boateng', 'Male', '2000-07-01', '0244857363', 'william.boateng@gmail.com', '345 Elm St', 'Computer Engineering', 1, 5, 22),
('Grace', 'Adeleke', 'Female', '2002-03-15', '0578123496', 'grace.adeleke@gmail.com', '123 Oak St', 'Electrical Engineering', 3, 3, 21),
('Samuel', 'Ofori', 'Male', '2001-11-10', '0265987412', 'samuel.ofori@gmail.com', '789 Maple St', 'Mechanical Engineering', 2, 1, 22),
('Amina', 'Suleman', 'Female', '2004-05-03', '0546321789', 'amina.suleman@gmail.com', '234 Pine St', 'Computer Science', 1, 2, 19),
('Daniel', 'Asante', 'Male', '1999-08-20', '0209753184', 'daniel.asante@gmail.com', '567 Birch St', 'Mechanical Engineering', 3, 5, 24),
('Hannah', 'Kwame', 'Female', '2003-01-12', '0558963412', 'hannah.kwame@gmail.com', '890 Cedar St', 'Management Information Systems', 2, 3, 20),
('Isaac', 'Mensah', 'Male', '2000-06-25', '0274859632', 'isaac.mensah@gmail.com', '678 Spruce St', 'Computer Engineering', 1, 4, 23),
('Abigail', 'Annan', 'Female', '2002-09-18', '0568742901', 'abigail.annan@gmail.com', '345 Redwood St', 'Electrical Engineering', 3, 1, 21),
('Kwesi', 'Appiah', 'Male', '2001-04-08', '0236145789', 'kwesi.appiah@gmail.com', '456 Walnut St', 'Mechanical Engineering', 2, 6, 22),
('Sarah', 'Darko', 'Female', '2003-12-30', '0587432190', 'sarah.darko@gmail.com', '789 Fir St', 'Computer Science', 1, 6, 19),
('Frank', 'Osei', 'Male', '1998-07-14', '0269876543', 'frank.osei@gmail.com', '890 Pine St', 'Management Information Systems', 2, 4, 25);

-- GoalKeeper table
INSERT INTO GoalKeeper(player_id, Overall_rating) VALUES
(7, 85),
(8, 80),
(9, 88);

-- Midfielder table
INSERT INTO Midfielder(player_id, Overall_rating) VALUES
(2, 90),
(10, 80),
(3, 86),
(4, 75);

-- Forward table
INSERT INTO Forward (player_id, Overall_rating) VALUES
(1, 90),
(5, 79),
(6, 85);

-- Defender table
INSERT INTO Defender (player_id, Overall_rating) VALUES
(11, 80),
(12, 85),
(13, 80);

-- Competition table
INSERT INTO Competition (competition_name, start_date, end_date, details, prize_money) VALUES
('FA Cup', '2022-01-01', '2022-12-31', 'Annual league competition', 10000),
('Champions league', '2022-05-01', '2022-07-31', 'Cup competition', 50000);

-- Matches table
INSERT INTO Matches (match_date, venue, home_team, away_team, home_team_score, away_team_score, winner_id, competition_id) VALUES
('2022-01-05', 'Ash Pitch', 1, 2, 2, 1, 1, 1),
('2022-02-10', 'Ash Pitch', 2, 1, 0, 3, 2, 1),
('2022-03-15', 'Ash Pitch', 3, 1, 2, 2, NULL, 2),
('2022-04-20', 'Ash Pitch', 2, 3, 1, 1, NULL, 1),
('2022-05-25', 'Ash Pitch', 1, 3, 3, 0, 1, 2),
('2022-06-30', 'Ash Pitch', 3, 2, 2, 1, 3, 1),
('2022-08-05', 'Ash Pitch', 1, 2, 1, 2, 2, 2),
('2022-09-10', 'Ash Pitch', 2, 3, 0, 0, NULL, 1),
('2022-10-15', 'Ash Pitch', 3, 1, 2, 0, 3, 2),
('2022-11-20', 'Ash Pitch', 1, 3, 3, 1, 1, 1),
('2022-12-25', 'Ash Pitch', 2, 1, 1, 1, NULL, 2),
('2023-01-30', 'Ash Pitch', 3, 2, 0, 2, 2, 1);

-- Goals table
INSERT INTO Goals (match_id, player_id) VALUES
(1, 1),
(2, 4),
(2, 6),
(3, 9),
(3, 7),
(4, 5),
(5, 3),
(5, 2),
(6, 10),
(6, 1),
(7, 8),
(1, 2);

-- Assists table
INSERT INTO Assists (match_id, goal_id) VALUES
(1, 1),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(6, 11),
(7, 12),
(1, 2);

-- Contracts table
INSERT INTO Contracts (player_id, start_date, end_date, team_id) VALUES
(1, '2022-01-01', '2023-01-01', 1),
(4, '2022-01-01', '2023-01-01', 3),
(5, '2022-01-01', '2022-12-31', 2),
(6, '2022-01-01', '2023-01-01', 4),
(7, '2022-01-01', '2022-12-31', 4),
(8, '2022-01-01', '2023-01-01', 5),
(9, '2022-01-01', '2022-12-31', 6),
(10, '2022-01-01', '2023-01-01', 6),
(11, '2022-01-01', '2022-12-31', 2),
(12, '2022-01-01', '2023-01-01', 5),
(13, '2022-01-01', '2022-12-31', 2),
(2, '2022-01-01', '2022-12-31', 2);


-- CoachesView--
DROP VIEW IF EXISTS CoachesView;
CREATE VIEW CoachesView AS
SELECT coach_id, first_name, last_name, contact_number, email
FROM Coaches;
/* Explanation: This view provides a simple and readable way to access coach information. 
It encapsulates the details of the Coaches table, making queries involving coaches more straightforward. */

-- TeamsView--
DROP VIEW IF EXISTS TeamsView;
CREATE VIEW TeamsView AS
SELECT team_id, team_name, coach_id
FROM Teams;
/*Explanation: Similar to the Coaches view, the Teams view simplifies access to team information. 
It abstracts away the underlying table structure and can be particularly useful when dealing with team-related queries.*/

-- PlayersView--
DROP VIEW IF EXISTS PlayersView;
CREATE VIEW PlayersView AS
SELECT player_id, first_name, last_name, gender, date_of_birth, contact_number, email, address, academic_program, academic_year, team_id, age
FROM Players;
/*Explanation: This view provides a convenient way to retrieve player details without exposing the underlying table structure. 
It simplifies queries involving player information and enhances the readability of the database schema.*/

-- CompetitionsView--
DROP VIEW IF EXISTS CompetitionsView;
CREATE VIEW CompetitionsView AS
SELECT competition_id, competition_name, start_date, end_date, details, prize_money
FROM Competition;
/*Explanation: This view simplifies the retrieval of competition details, 
providing a clear and concise way to access information about different competitions.*/

-- MatchesView--
DROP VIEW IF EXISTS MatchesView;
CREATE VIEW MatchesView AS
SELECT match_id, match_date, venue, home_team, away_team, home_team_score, away_team_score, winner_id, competition_id
FROM Matches;
/*Explanation: This view encapsulates match details, 
simplifying queries related to matches and improving the overall structure of the database schema.*/

-- FUNCTIONALITITES --

-- 1. To display players and their respective teams
select
    Players.player_id,
    Players.first_name,
    Players.last_name,
    Players.team_id,
    Teams.team_name
from Players
inner join Teams on Players.team_id = Teams.team_id;
    
-- 2. To display all players in a given team
Select Teams.team_name,
Count(Players.player_id) AS total_players
From Teams
left join players on Teams.team_id = players.team_id
group by Teams.team_name;

/* 3. To display the contract duration, in months, of each player in their respective teams. 
To make this possible, we performed a research to find out how to calculate the difference in 
date and we discovererd TIMESTAMPDIFF which takes the starting date and the ending date and computes the difference */

select
    Players.player_id,
    Players.first_name,
    Players.last_name,
    Teams.team_name,
    Contracts.start_date,
    Contracts.end_date,
    timestampdiff(month, Contracts.start_date, Contracts.end_date) as contract_duration_months
from Players
inner join Contracts on Players.player_id = Contracts.player_id
inner join Teams on Players.team_id = Teams.team_id;

-- 4. To display the total goals of a player 
select
    Players.player_id,
    Players.first_name,
    Players.last_name,
    COUNT(Goals.goal_id) as total_goals
from Players
left join Goals on Players.player_id = Goals.player_id
group by Players.player_id, Players.first_name, Players.last_name;

-- 5. To display the total wins a team has
select
    Teams.team_id,
    Teams.team_name,
    COUNT(Matches.match_id) as total_wins
from Teams
inner join Matches on (Teams.team_id = Matches.home_team or Teams.team_id = Matches.away_team) and Teams.team_id = Matches.winner_id
group by Teams.team_id, Teams.team_name;

-- 6. To display all male and female players in a team
select
    Teams.team_id,
    Teams.team_name,
    SUM(case when Players.gender = 'Male' then 1 else 0 end) as male_players,
    SUM(case when Players.gender = 'Female' then 1 else 0 end) as female_players
from Teams
inner join Players on Teams.team_id = Players.team_id
group by Teams.team_id, Teams.team_name;

-- 7. To display the player with the highest rating
/* so here again, we need to return players with high ratings in their respective categories. 
Thus we disovered COALESCE. The COALESCE function helps find the first non-null rating 
among the specialized player tables, effectively giving you the highest rating for a player across all positions.*/

select
    Players.player_id,
    Players.first_name,
    Players.last_name,
    coalesce(GoalKeeper.Overall_rating, Midfielder.Overall_rating, Forward.Overall_rating, Defender.Overall_rating) AS highest_rating
from Players
left join GoalKeeper on Players.player_id = GoalKeeper.player_id
left join Midfielder on Players.player_id = Midfielder.player_id
left join Forward on Players.player_id = Forward.player_id
left join Defender on Players.player_id = Defender.player_id
order by highest_rating desc;

-- 8. To display the total goals of a player in a given competition
select
    Players.player_id,
    Players.first_name,
    Players.last_name,
    count(case when Matches.competition_id = 1 then Goals.goal_id end) as total_goals_fa,
    count(case when Matches.competition_id = 2 then Goals.goal_id end) as total_goals_champions_league
from Players
inner join Goals on Players.player_id = Goals.player_id
inner join Matches on Goals.match_id = Matches.match_id
where Matches.competition_id in (1, 2) -- passing the ID for both competitions
group by Players.player_id, Players.first_name, Players.last_name;

-- 9. To display the team with the best goal difference
select
    Teams.team_id,
    Teams.team_name,
    SUM(Matches.home_team_score) - SUM(Matches.away_team_score) as goal_difference
from Teams
inner join Matches on Teams.team_id = Matches.home_team
or Teams.team_id = Matches.away_team
group by Teams.team_id, Teams.team_name
order by goal_difference desc;


-- 10. To display coaches with the most wins
select
    Coaches.coach_id,
    Coaches.first_name,
    Coaches.last_name,
    count(Matches.match_id) as total_wins
from Coaches
inner join Teams on Coaches.coach_id = Teams.coach_id
inner join Matches on Teams.team_id = Matches.winner_id
where Matches.winner_id is not null
group by Coaches.coach_id, Coaches.first_name, Coaches.last_name
order by total_wins desc;

-- 11. To display coaches and their teams
select
    Coaches.coach_id,
    Coaches.first_name,
    Coaches.last_name,
    Teams.team_id,
    Teams.team_name
from Coaches
inner join Teams on Coaches.coach_id = Teams.coach_id;

