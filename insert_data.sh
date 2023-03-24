#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")

LINENR=1
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
if [[ $LINENR -gt 1 ]]
  then
    #insert both winner and opponent into teams table if not found
    TEAM1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM1 ]]
      then INSERT1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    
    TEAM2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM2 ]]
      then INSERT2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    #complete the games table
    #year, round, winner_id, opponent_id, winner_goals, opponent_goals
    INSERTGAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES($YEAR, '$ROUND', $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'"), $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'"), $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
  LINENR=$(($LINENR+1))
done
