#!/bin/bash

# PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Function to handle user interaction
USER() {
  # Generate a random number between 1 and 1000
  RAND_NUMBER=$(( $RANDOM % 1000 + 1 ))
  Count=1

  echo -e "\nEnter your username:"
  read USERNAME

  # Check if the user has played before
  USER=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME';")

  # Check if the user has not played before
  if [[ -z $USER ]]
  then
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    echo -e "\nGuess the secret number between 1 and 1000:"
    PLAY $RAND_NUMBER $USERNAME
  else
    # If the user has played before, retrieve game information
    echo "$USER" | while IFS="|" read -r USERNAME GAMES BEST
    do
      echo -e "\nWelcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
    done
    echo -e "\nGuess the secret number between 1 and 1000:"
    PLAY $RAND_NUMBER $USERNAME
  fi
}

# Function to handle the game logic
PLAY() {
  read NUMBER
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    PLAY $RAND_NUMBER $USERNAME
  elif [[ "$NUMBER" -lt $RAND_NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    ((Count=$Count+1))
    PLAY $RAND_NUMBER $USERNAME
  elif [[ "$NUMBER" -gt $RAND_NUMBER ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    ((Count=$Count+1))
    PLAY $RAND_NUMBER $USERNAME
  else
    INSERT $USERNAME $Count
    echo -e "\nYou guessed it in $Count tries. The secret number was $RAND_NUMBER. Nice job!"
  fi
}

# Function to insert/update user information in the database
INSERT() {
  # Check if the user already exists
  if [[ -z $USER ]]
  then
    INSERT_RESULT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 1, $Count);")
  else
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")
    if [[ $BEST_GAME -gt $Count ]]
    then 
      BEST_GAME=Count
    fi
    INSERT_RESULT_USER=$($PSQL "UPDATE users SET (games_played, best_game) = (games_played + 1, $BEST_GAME) WHERE username='$USERNAME';")
  fi
}

# Call the USER function to start the game
USER
