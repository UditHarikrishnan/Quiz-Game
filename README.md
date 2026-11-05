# Terminal Quiz Game

A menu-driven multiple-choice quiz game written as a Unix shell script. I built it as team lead of a four-person group project for the Managing Enterprise Systems module at Dublin City University (April 2026, graded 80%).

## Features
- Pick a question category and a difficulty level (easy, medium or hard), or play ALL
- 46 questions across Science, Computing, Geography and Sport, loaded from a plain-text file (`questions.txt`)
- Scores are saved to `scores.txt`, and the Scores menu shows each player's percentage
- New questions can be added from the menu, and the correct answer is checked before saving
- Type `cancel` at any prompt to go back to the menu

## How to run
```sh
chmod +x quiz_game.sh
./quiz_game.sh
```
Works on macOS and Linux, or in any POSIX shell.

## Question file format
One question per line, with fields separated by `|`:
```
Category|difficulty|Question|Option A|Option B|Option C|Option D|Correct letter
```

## My role
I led the team: I divided the tasks, set deadlines and coordinated the work. I wrote the main body of the code and debugged and fixed errors across the team's code before submission.
