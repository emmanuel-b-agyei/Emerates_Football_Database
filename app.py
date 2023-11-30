import streamlit as st
import mysql.connector

# Database connection (Connect to MySQL )
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="GH57.,fa",
    database="AFA_Database"
)
cursor = conn.cursor()

# Query 1: Display players and their respective teams
def display_players_teams():
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name, Teams.team_name FROM Players INNER JOIN Teams ON Players.team_id = Teams.team_id")
    return cursor.fetchall()

# Query 2: Display all players in a given team
def display_players_in_team(team_id):
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name FROM Players WHERE Players.team_id = %s", (team_id,))
    return cursor.fetchall()

# Query 3: Display the contract duration, in months, of each player in their respective teams
def display_contract_duration():
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name, Teams.team_name, Contracts.start_date, Contracts.end_date, TIMESTAMPDIFF(MONTH, Contracts.start_date, Contracts.end_date) AS contract_duration_months FROM Players INNER JOIN Contracts ON Players.player_id = Contracts.player_id INNER JOIN Teams ON Players.team_id = Teams.team_id")
    return cursor.fetchall()

# Query 4: Display the total goals of a player
def display_total_goals():
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name, COUNT(Goals.goal_id) AS total_goals FROM Players LEFT JOIN Goals ON Players.player_id = Goals.player_id GROUP BY Players.player_id, Players.first_name, Players.last_name")
    return cursor.fetchall()

# Query 5: Display the total wins a team has
def display_total_wins(team_id):
    cursor.execute("SELECT team_name, COUNT(match_id) AS total_wins FROM Teams INNER JOIN Matches ON Teams.team_id = Matches.winner_id WHERE Teams.team_id = %s GROUP BY team_name", (team_id,))
    return cursor.fetchall()

# Query 6: Display all male and female players in a team
def display_male_female_players(team_id):
    cursor.execute("SELECT gender, COUNT(player_id) AS total_players FROM Players WHERE team_id = %s GROUP BY gender", (team_id,))
    return cursor.fetchall()

# Query 7: Display the player with the highest rating
def display_highest_rated_player():
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name, COALESCE(GoalKeeper.Overall_rating, Midfielder.Overall_rating, Forward.Overall_rating, Defender.Overall_rating) AS highest_rating FROM Players LEFT JOIN GoalKeeper ON Players.player_id = GoalKeeper.player_id LEFT JOIN Midfielder ON Players.player_id = Midfielder.player_id LEFT JOIN Forward ON Players.player_id = Forward.player_id LEFT JOIN Defender ON Players.player_id = Defender.player_id ORDER BY highest_rating DESC LIMIT 1")
    return cursor.fetchall()

# Query 8: Display the total goals of a player in a given competition
def display_total_goals_in_competition(player_id, competition_id):
    cursor.execute("SELECT Players.player_id, Players.first_name, Players.last_name, COUNT(Goals.goal_id) AS total_goals FROM Players LEFT JOIN Goals ON Players.player_id = Goals.player_id LEFT JOIN Matches ON Goals.match_id = Matches.match_id WHERE Players.player_id = %s AND Matches.competition_id = %s GROUP BY Players.player_id, Players.first_name, Players.last_name", (player_id, competition_id))
    return cursor.fetchall()

# Query 9: Display the team with the best goal difference
def display_best_goal_difference_team():
    cursor.execute("SELECT Teams.team_name, SUM(Matches.home_team_score) - SUM(Matches.away_team_score) AS goal_difference FROM Teams INNER JOIN Matches ON Teams.team_id = Matches.home_team OR Teams.team_id = Matches.away_team GROUP BY Teams.team_name ORDER BY goal_difference DESC LIMIT 1")
    return cursor.fetchall()

# Query 10: Display coaches with the most wins
def display_coaches_with_most_wins():
    cursor.execute("SELECT Coaches.coach_id, Coaches.first_name, Coaches.last_name, Teams.team_name, COUNT(Matches.match_id) AS total_wins FROM Coaches INNER JOIN Teams ON Coaches.coach_id = Teams.coach_id INNER JOIN Matches ON Teams.team_id = Matches.winner_id WHERE Matches.winner_id IS NOT NULL GROUP BY Coaches.coach_id, Coaches.first_name, Coaches.last_name, Teams.team_name ORDER BY total_wins DESC LIMIT 1")
    return cursor.fetchall()

# Query 11: Display coaches and their teams
def display_coaches_and_teams():
    cursor.execute("SELECT Coaches.coach_id, Coaches.first_name, Coaches.last_name, Teams.team_name FROM Coaches LEFT JOIN Teams ON Coaches.coach_id = Teams.coach_id")
    return cursor.fetchall()

# Streamlit app
def main():
    
    st.title("AFA Football Database ")

    # Sidebar with query selection
    query_option = st.sidebar.selectbox('Select Query', [
        'Display Players and Their Teams',
        'Display All Players in a Team',
        'Display Contract Duration of Each Player',
        'Display Total Goals of a Player',
        'Display Total Wins of a Team',
        'Display All Male and Female Players in a Team',
        'Display Highest Rated Player',
        'Display Total Goals of a Player in a Given Competition',
        'Display Team with Best Goal Difference',
        'Display Coaches with Most Wins',
        'Display Coaches and Their Teams',
    ])

    if query_option == 'Display Players and Their Teams':
        st.header('Display Players and Their Teams')
        results_query_1 = display_players_teams()
        st.table(results_query_1)

    elif query_option == 'Display All Players in a Team':
        st.markdown("""
            :dart: Display All Players in a Team 
        """)
        st.warning(" Available Options (1: Kasanoma | 2 : Red army | 3 : Northside | 4 : ELite | 5 : Highlanders | 6 : Legends)")
        team_id = st.text_input('Enter Team ID:')
        if st.button('Retrieve Players'):
            results_query_2 = display_players_in_team(team_id)
            st.table(results_query_2)

    elif query_option == 'Display Contract Duration of Each Player':
        st.header('Display Contract Duration of Each Player')
        results_query_3 = display_contract_duration()
        st.table(results_query_3)

    elif query_option == 'Display Total Goals of a Player':
        st.header('Display Total Goals of a Player')
        results_query_4 = display_total_goals()
        st.table(results_query_4)

    elif query_option == 'Display Total Wins of a Team':
        st.markdown("""
            :dart: Display Total Wins of a Team 
        """)
        st.warning(" Available Options (1: Kasanoma | 2 : Red army | 3 : Northside | 4 : ELite | 5 : Highlanders | 6 : Legends)")
        team_id_wins = st.text_input('Enter Team ID:')
        if st.button('Retrieve Wins'):
            results_query_5 = display_total_wins(team_id_wins)
            st.table(results_query_5)

    elif query_option == 'Display All Male and Female Players in a Team':
        st.markdown("""
            :dart: Display All Male and Female Players in a Team 
        """)
        st.warning(" Available Options (1: Kasanoma | 2 : Red army | 3 : Northside | 4 : ELite | 5 : Highlanders | 6 : Legends)")
        team_id_gender = st.text_input('Enter Team ID:')
        if st.button('Retrieve Players'):
            results_query_6 = display_male_female_players(team_id_gender)
            st.table(results_query_6)

    elif query_option == 'Display Highest Rated Player':
        st.header('Display Highest Rated Player')
        results_query_7 = display_highest_rated_player()
        st.table(results_query_7)

    elif query_option == 'Display Total Goals of a Player in a Given Competition':
        st.markdown("""
            :dart: Display Total Goals of a Player in a Given Competition 
        """)
        st.warning(" Available Options  (1: Emmanuel_Soumahoro | 2 : Faisal_Alidu | 3 : Willams_Boateng | 4 : Grace_Adeleke | 5 : Samuel_Ofori | 6 : Amina_Suleman | 7 : Daniel_Asante | 8 : Hannah_Kwame | 9 : Isaac_Mensah | 10 : Abigail_Annan | 11 : Kwesi_Appiah | 12 : Sarah_Darko | 13 :  Frank_Osei)")
        player_id_comp = st.text_input('Enter Player ID:')
        st.warning(" Available Options (1: FA_Cup | 2 : Champions_League)")
        competition_id_comp = st.text_input('Enter Competition ID:')
        if st.button('Retrieve Goals'):
            results_query_8 = display_total_goals_in_competition(player_id_comp, competition_id_comp)
            st.table(results_query_8)

    elif query_option == 'Display Team with Best Goal Difference':
        st.header('Display Team with Best Goal Difference')
        results_query_9 = display_best_goal_difference_team()
        st.table(results_query_9)

    elif query_option == 'Display Coaches with Most Wins':
        st.header('Display Coaches with Most Wins')
        results_query_10 = display_coaches_with_most_wins()
        st.table(results_query_10)

    elif query_option == 'Display Coaches and Their Teams':
        st.header('Display Coaches and Their Teams')
        results_query_11 = display_coaches_and_teams()
        st.table(results_query_11)

if __name__ == '__main__':
    main()

# Close connection to database (to MySQL) 
cursor.close()
conn.close()
