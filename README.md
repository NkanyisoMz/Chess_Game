# Command Line Chess Game

Welcome to my command line Chess game! This project is part of [The Odin Project](https://www.theodinproject.com)'s Ruby curriculum, where I've built a chess game that two players can play against each other.

## Features
- **Two Player Mode:** Players alternate turns, moving their pieces on the board.
- **Legal Moves Only:** The game prevents illegal moves and enforces the rules of chess.
- **Check & Checkmate Detection:** The game correctly identifies when a player is in check or checkmate.
- **Save & Load Game:** You can save your progress at any time and load it later, thanks to serialization.
- **Simple Command Line Interface:** The game is played entirely in the terminal using chess notation for moves (e.g., `e2 to e4`).
- **Unicode Chess Pieces:** To give the game a classic feel, I've used Unicode characters to represent the chess pieces on the board.

## How to Play
1. Clone the repository.
2. Run the game with the command:
   ```bash
   ruby chess_game.rb
