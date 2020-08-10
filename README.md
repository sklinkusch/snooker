# snooker

This is a script evaluating the chances of players to win the current frame in a
Snooker match.

## Usage

`./snooker.pl 69 55 3 1 1 1 1 1 1`

### Arguments

- scores of current player
- scores of his opponent
- number of remaining red balls on the table (0...15)
- number of remaining yellow balls on the table (0...1)
- number of remaining green balls on the table (0...1)
- number of remaining brown balls on the table (0...1)
- number of remaining blue balls on the table (0...1)
- number of remaining pink balls on the table (0...1)
- number of remaining black balls on the table (0...1)

## Output

The output is a table with six columns. It shows the hypothetical future
scoreboard if the current player scores as many points as possible from now on.

### Columns

- scores of the current player
- scores of his opponent (constant)
- difference of scores
- number of remaining points on the table
- the letter "S" if the opponent needs foul points to win the frame
- the color of the currently played ball
