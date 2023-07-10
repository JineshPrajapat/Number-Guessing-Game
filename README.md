# Number Guessing Game

This script is a number guessing game where users try to guess a randomly generated secret number between 1 and 1000 and saves user information.

## Prerequisites

-PostgreSQL: Ensure that PostgreSQL is installed and running on your system.
-Database Setup: Create a database named "periodic_table" with the necessary tables and data for the periodic table elements.

## Script Overview

- The script begins by setting up the `PSQL` variable to connect to the PostgreSQL database using the `psql` command-line tool.

- The `USER` function handles user interaction. It generates a random number as the secret number and prompts the user to enter their username. It then checks if the user has played before by querying the database.

- If the user is playing for the first time, the script displays a welcome message and asks the user to guess the secret number. It calls the `PLAY` function to handle the game logic.

- If the user has played before, the script retrieves their game information from the database and displays a welcome back message. It then asks the user to guess the secret number and calls the `PLAY` function.

- The `PLAY` function handles the game logic. It reads the user's guess and checks if it's an integer. If not, it displays an error message and recursively calls the `PLAY` function. If it's an integer, it compares the guess with the secret number and provides feedback. If the guess is correct, it calls the `INSERT` function to update the user's game information in the database and displays a success message.

These provide a concise summary of the code's functionality, focusing on the key points of each section.
