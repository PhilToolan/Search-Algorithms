# Search-Algorithms

Diagrams and screenshots can be found in the pdf, code in each Prolog file.

## Design Considerations
For the maze I decided to represent it as simple as possible. This meant that making changes
to the maze would be simple for the user to do. The number of rows and columns are stored 
in a variable. Then the start position of the maze is recorded and the final position or goal. 
The final part of the maze is recording all the positions in the maze that are occupied by a 
wall. The positions are in the maze are treated as pos(row, column). And the final output of 
the algorithm is a list of steps needed to be taken to solve the maze, e.g. Up, up, left, down.
To run the algorithm, set up prolog to consult the desired algorithm then type start. 
To change the maze, you can edit the beginning of the files to have different start and final 
positions, obstacles and overall size. Ensuring to put row first followed by column. 

## Common Predicates
Each algorithm has several predicates that are the same across all 3. These are allowed(), 
move(), maxDepth() and cost(). 
Allowed lets the algorithm check if a move in a certain direction is possible, it will not be 
possible if the position is outside the maze or is occupied by a wall. Move allows the algorithm 
to move to the new position.
Iterative Deepening specific: MaxDepth holds the maximum depth allowed in the current 
domain. 
Astar specific: heuristic() is used to calculate the heuristic value. Manhattan distance is used 
in this case. A_star_comparator is used to sort the costs of moving to new nodes for the astar 
algorithm. Cost is used as a function that calculates the cost of moving from the current 
position to the new position.May 4, 2021 3


## Depth-First Search
The algorithm gets the first node and checks what actions can be performed with this node. 
It then moves (action) in the direction it can, a new node is taken in. This node is checked 
against the list of nodes that have already been visited, if it has not then the algorithm will 
continue to the next node. The node is added to the list of visited nodes. 

## Iterative deepening Search
This acts very similar to the depth first search. The only difference is it takes the depth into 
account. It goes to one level tried all the actions at that level then moves to the next depth 
level. 

## A* Search
The A* implementation consists of 3 main parts. 
Astar: starts the search and fills a list with moves to reach the goal.
Astar_search: these are the predicates that implements the search. It takes 3 parameters, 
the first is a list of nodes that are at the front of the current path, the second is the list of 
positions that have already been visited, the third is the list of actions that lead to the 
solution. 
Generatechildren: generates the children of a particular position, checks all the allowed 
actions (moves) for that position. 
