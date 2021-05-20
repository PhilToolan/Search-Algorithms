
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
  
 
  % cost predicate returns the cost of each feasible
  % domain action; each of them has a unit cost.
 
cost(pos(_,_), pos(_, _), Cost) :-
    Cost is 1.


%% Manhattan hueristic
heuristic(pos(X1, Y1), [], L) :-
    finalPosition(pos(X2, Y2)),
    L is abs(X1-X2) + abs(Y1-Y2).


% a_star_comparator predicate provides a comparator
% used to sort A* frontier after each new expansion.
a_star_comparator(R, node(_, _, G_Cost_1, H_Cost_1), node(_, _, G_Cost_2, H_Cost_2)) :-
    F1 is G_Cost_1 + H_Cost_1,
    F2 is G_Cost_2 + H_Cost_2,
    F1 >= F2 -> R = > ; R = < .


% A* algorithm.
% Node is represent by node predicate and its structure is:
% S, current configuration's state
% ActionsListForS, list of action to reach S state
% ActualPathCost, cost of path to reach S state from initial state
% HeuristicCost, cost of heuristic for S state configuration.

start:-
    astar(S).
  
astar(Solution) :-
    startPosition(S),
    heuristic(S, _, HeuristicS),
    astar_search([node(S, [], 0, HeuristicS)], [], Solution),
    write(Solution).
  

astar_search([node(S, ActionsListForS, _, _)|_], _, ActionsListForS):-
    finalPosition(S).

astar_search([node(S, ActionsListForS, ActualPathCost, HeuristicCost)|Frontier], ExpandedNodes, Solution):-
    findall(Az, allowed(Az, S), AllowedActionsList),
    generateChildren(node(S, ActionsListForS, ActualPathCost, HeuristicCost), AllowedActionsList, ExpandedNodes, SChilderenList),
    append(SChilderenList, Frontier, NewFrontier),
    predsort(a_star_comparator, NewFrontier, OrderedResult),
    astar_search(OrderedResult, [S|ExpandedNodes], Solution).

generateChildren(_, [], _, []).
generateChildren(node(S, ActionsListForS, PathCostForS, HeuristicOfS),
               [Action|OtherActions],
               ExpandedNodes,
               [node(NewS, ActionsListForNewS, PathCostForNewS, HeuristicCostForNewS)|OtherChildren]):-
    move(Action, S, NewS),
    not(member(NewS, ExpandedNodes)),
    cost(S, NewS, Cost),
    PathCostForNewS is PathCostForS + Cost,
    heuristic(NewS, _, HeuristicCostForNewS),
    append(ActionsListForS, [Action], ActionsListForNewS),
    generateChildren(node(S, ActionsListForS, PathCostForS, HeuristicOfS), OtherActions, ExpandedNodes, OtherChildren),
    !.
  
  % Used to backtrack on any other possible action in case of fail.
  
generateChildren(Node, [_|OtherActions], ExpandedNodes, ChildNodesList) :-
    generateChildren(Node, OtherActions, ExpandedNodes, ChildNodesList),
    !.