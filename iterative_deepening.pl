


%First Maze
/*
row_num(5).
col_num(5).

startPosition(pos(3,3)).
finalPosition(pos(5,1)).

occupied(pos(3,4)).
occupied(pos(4,4)).

occupied(pos(4,3)).

occupied(pos(3,2)).
occupied(pos(2,2)).
occupied(pos(4,2)).*/


%Second Maze

row_num(10).
col_num(10).

startPosition(pos(1,1)).
finalPosition(pos(6,8)).

occupied(pos(4,2)).
occupied(pos(4,3)).
occupied(pos(4,4)).
occupied(pos(4,5)).
occupied(pos(4,6)).
occupied(pos(4,7)).
occupied(pos(4,8)).
occupied(pos(4,9)).
occupied(pos(4,10)).

occupied(pos(5,6)).
occupied(pos(6,6)).
occupied(pos(7,6)).
occupied(pos(8,6)).
occupied(pos(9,6)).

occupied(pos(7,7)).
occupied(pos(7,8)).
occupied(pos(7,9)).


% allowed predicate checks if actions, that could
% be 'up', 'down', 'right' and 'left' are possible
% or not in position 'pos(R,C)'. This why positions
% must be in order row, column.
allowed(down, pos(R,C)) :-
    R>1,
    R1 is R-1,
    not(occupied(pos(R1,C))).
  
allowed(up, pos(R,C)) :-
    not(row_num(R)),
    R1 is R+1,
    not(occupied(pos(R1,C))).
  
allowed(left, pos(R,C)) :-
    C>1,
    C1 is C-1,
    not(occupied(pos(R,C1))).
  
allowed(right, pos(R,C)) :-
    not(col_num(C)),
    C1 is C+1,
    not(occupied(pos(R,C1))).
  

  % move predicate provides a new state by modifying
  % the older position 'pos(R,C)' with a new one.

move(right, pos(R,C), pos(R, CAdjacent)) :-
    CAdjacent is C+1.
move(left, pos(R,C), pos(R, CAdjacent)) :-
    CAdjacent is C-1.
move(down, pos(R,C), pos(RUp,C)) :-
    RUp is R-1.
move(up, pos(R,C), pos(RDown,C)) :-
    RDown is R+1.
  

  % maxDepth predicate provides a max depth bound
  % within which ID search will stop.

maxDepth(D) :-
    row_num(R),
    col_num(L),
    D is R * L.
  

% Iterative Deepening algorithm.

start:-
    id(S).
  
  id(Sol):-
    maxDepth(D),
    startPosition(S),
    length(_, L),
    L =< D,
    id_search(S, Sol, [S], L),
    write(Sol).
  
 
  % id_search predicate provides the ID search.
 
  id_search(S, [], _, _):- 
    finalPosition(S).
  id_search(S, [Action|OtherActions], VisitedNodes, N):-
    N>0,
    allowed(Action, S),
    move(Action, S, NewS),
    not(member(NewS, VisitedNodes)),
    N1 is N-1,
    id_search(NewS, OtherActions, [NewS|VisitedNodes], N1).