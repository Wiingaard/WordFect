
## WordFect Dictionary 
_Consider a game of scrable_

**Board:** is the playing field without in brickes places on top

**Bricks:** is a map of all the places bricks is put on top of the board

**List:** is the dictionary of all accepted words

**Trat:** is the bricks in your hand that you can place on the board

## The Algorithm

The `PositionWorker` runs on every position position of the board. 
**Search:** tries all combinations of the tray, by placing them on the board position. Places Bricks are merged into existing bricks on the board.

For every position on the board it does (should):
1. Find all the permutations on the tray also considering jokers.
2. Find the minimum and maximum length a word can be by considering which bricks are places on the board including rows in close proximity to search position.
3. Make all potential words matching the length requirements by merging tray bricks with placed bricks.
