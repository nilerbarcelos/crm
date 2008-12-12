:- prolog_language('pop11').

false -> popmemlim;
false -> pop_prolog_lim;

:- prolog_language('prolog').
%-----------------------------------------------------------------------
% Start pop_callstack_lim * 2 -> pop_callstack_lim;
% começa pop_callstack_lim * 2 -> pop_callstack_lim;
%-----------------------------------------------------------------------

/*******************************************************************************/
/*                        Opções de Jogo                                   */
/*******************************************************************************/

diego_first(Game_Board, P, Depth, Next_Game_Board) :-
	first_move(Game_Board, P, Next_Game_Board).

diego_minimax(Board, P, Depth, Next_Game_Board) :-
	minimax(P, Depth, Board, (Pl, X, Y)),
	execute_move(P,X,Y, Board, Next_Game_Board),!.

diego_minimax(Game_Board, P, Depth, Game_Board).

diego_alphaBeta(Board, P, Depth, Next_Game_Board) :-
	minimax_alphaBeta(Player, Depth, Board, (Pl, X, Y)),
	execute_move(P,X,Y, Board, Next_Game_Board),!.

diego_alphaBeta(Game_Board, P, Depth, Game_Board).


/*******************************************************************************/
/*                        Opções do Jogo                                   */
/*******************************************************************************/


%-----------------------------------------------------------------------
% first_move()
% Pega o Primeiro Movimento
%-----------------------------------------------------------------------
first_move(Game_Board, P, Next_Game_Board) :-
	return_move(P, X, Y, Game_Board),
	execute_move(P,X,Y, Game_Board, Next_Game_Board),!.


/*******************************************************************************/
/*                   Jogador Inteligente com MiniMax                           */
/*                         Com poda Alfa Beta                                  */
/*******************************************************************************/


minimax_alpha_beta(P, Board, MaxDepth, Val) :-
	retractall(max_p(_)), assertz(max_p(P)),
	retractall(best_move(_)),
	assertz(best_move([-1000000, _,_])),
	%max_value(P,Board,-1000000, 1000000, 0, MaxDepth, Val).
	not(max_value_first(P,Board,-1000000, 1000000, 0, MaxDepth, _)),
	best_move([Val, Mov, Board1]),nl,
	write(Val),nl,
	write(Mov),nl,
	show_game_board(Board1).


update_best(Val, Mov, Successor):-
	best_move([Current_best, _,_]),
	nl,write(' Current '),write(Current_best),write(' , '),
	write(' Val '),write(Val),write(' , '),
	max(Current_best, Val, Better),
	nl,write(Better),write(' ;'),
	retractall(best_move(_)),
	assertz(best_move([Better, Mov, Successor])),!.

max_value_first(P,Board, Alfa, Beta, Depth, MaxDepth, _) :-
	D is Depth + 1,
	%best_move(Best),
	successor(P, Board, Mov-Successor),
	%read(Val),
	max_try_prune(P, Successor, Alfa, Beta, D, MaxDepth, Val),
	update_best(Val, Mov, Successor),
	fail.


max_value_first(P, Board, Alfa, Beta, Depth, MaxDepth, _) :-
	write('Fim'),nl,
	!,fail.


max_value(P, Board, Alfa, Beta, MaxDepth, MaxDepth, Val) :- 
	heuristic_board(P,Board, Val),!.

max_value(P,Board, Alfa, Beta, Depth, MaxDepth, Val_alfa) :-
	D is Depth + 1,%nl,write(D),nl,
	moves(P, Board, List_Boards),%num(List_Boards, N),nl,write(N),nl,
	for_all_successor(P, Alfa, Beta, Val_alfa, D, MaxDepth, List_Boards).

min_value(P,Board, Alfa, Beta,MaxDepth, MaxDepth, Val) :- %write('Entrouu'),
	heuristic_board(P,Board, Val),!.

min_value(P, Board, Alfa, Beta, Depth, MaxDepth, Val_alfa) :- 
	D is Depth + 1,%nl,write(D),nl,
	moves(P, Board, List_Boards),
	for_all_successor(P, Alfa, Beta, Val_alfa, D, MaxDepth, List_Boards).


for_all_successor(_,_,_,_,_,_,[]) :- !.

for_all_successor(P, Alfa, Beta, Val, Depth, MaxDepth, Successors) :-
	max_or_min(P, Successors, Alfa, Beta, Depth, MaxDepth, Val),!.


max_or_min(P, [Mov-Successor|T], Alfa, Beta, Depth, MaxDepth, Beta) :-
	max_p(P), %nl,write(' Min '),show_game_board(Successor),
	max_try_prune(P, Successor, Alfa, Beta, Depth, MaxDepth, New_alfa),%nl,write('   Cortou   ')
	is_greater(New_alfa, Beta),!.


max_or_min(P, [Mov-Successor|T], Alfa, Beta, Depth, MaxDepth, New_alfa) :-
	max_p(P), %nl,write(' Min '),show_game_board(Successor),
	max_try_prune(P, Successor, Alfa, Beta, Depth, MaxDepth, New_alfa),%nl,write('   Cortou   ')
	for_all_successor(P, New_alfa, Beta,_, Depth, MaxDepth, T),!.


max_or_min(P, [Mov-Successor|T], Alfa, Beta,Depth, MaxDepth, Alfa) :-
	not(max_p(P)),
	%nl,write(' Max '),show_game_board(Successor),
	min_try_prune(P, Successor, Alfa, Beta,Depth, MaxDepth, New_beta),%write('Aki 1'),
	is_lower(New_beta, Alfa),!.


max_or_min(P, [Mov-Successor|T], Alfa, Beta,Depth, MaxDepth, New_beta) :-
	not(max_p(P)),
	%nl,write(' Max '),show_game_board(Successor),
	min_try_prune(P, Successor, Alfa, Beta, Depth, MaxDepth, New_beta), %write('Aki 2'),
	for_all_successor(P, Alfa, New_beta, _, Depth, MaxDepth, T),!.


max_try_prune(P, Successor, Alfa, Beta,Depth, MaxDepth, New_alfa) :-
	other_player(P,P2),
	min_value(P2, Successor, Alfa, Beta, Depth, MaxDepth, Val_beta),
	max(Alfa, Val_beta, New_alfa),!.

min_try_prune(P, Successor, Alfa, Beta, Depth, MaxDepth, New_beta) :-
	other_player(P,P2),
	max_value(P2, Successor, Alfa, Beta, Depth, MaxDepth, Val_alfa),
	min(Beta, Val_alfa, New_beta),!.


max(X,Y,X) :- X > Y,!.
max(_,Y,Y).

min(X,Y,X) :- X < Y,!.
min(_,Y,Y).

is_greater(X, Y) :- X > Y,!.
is_greater(X, X).

is_lower(X, Y) :- X < Y,!.
is_lower(X, X).

%-----------------------------------------------------------------------
% game_board(B)
% Tabuleiro Inicial do jogo
%-----------------------------------------------------------------------

game_board([
	 [ *, *, *, *, *, *, *, * ],
	 [ *, *, *, *, *, *, *, * ],
	 [ *, *, *, *, *, *, *, * ],
	 [ *, *, *, b, p, *, *, * ],
	 [ *, *, *, p, b, *, *, * ],
	 [ *, *, *, *, *, *, *, * ],
	 [ *, *, *, *, *, *, *, * ],
	 [ *, *, *, *, *, *, *, * ]
	]).


printy([]).

printy([H|T]) :-
	write(H),nl,
	printy(T).

num([], 0).

num([H|T], X) :-
    num(T, Y),
    X is Y + 1.

%-------------------------------------------------------------------------------
% sucessor(Player, Game_Board, Value)
% Determina os Sucessores de um tabuleiro.
%-------------------------------------------------------------------------------

successor(Player, Game_Board, (Player,X,Y)-Successor) :-
	return_move(Player, X, Y, Game_Board),
	execute_move(Player,X, Y, Game_Board, Successor).

moves(Player, Game_Board, List) :-
	findall(S, successor(Player, Game_Board, S), List).

%-------------------------------------------------------------------------------
% moves_sorted(Player, Game_Board, Value)
% Retorna todos Sucessores Ordenados pela Função heurística
%-------------------------------------------------------------------------------

moves_sorted(Player, Game_Board, List_sorted) :-
	findall(Val-S, (successor(Player, Game_Board, S),
			heuristic_board(Player, S, Val)), List),
	sorted_list(List, List_sorted).

sorted_list([], []).
sorted_list([H|T], List_sorted) :-
	sorted_list(T, L),
	inser_ord(H, L, List_sorted).

% insere em uma lista ordenada
inser_ord(N,[],[N]).

inser_ord(Val_N-E, [Val-X|Y],  [Val-X|L]):-
	Val_N > Val, inser_ord(Val_N-E, Y, L),!.

inser_ord(Val_N-E,[Val-X|Y], [Val_N-E,Val-X|Y]):-
        Val_N =< Val.


%-------------------------------------------------------------------------------
% heurist_board(Player, Game_Board, Value)
% Calcula o valor Heuristico do tabuleiro.
% (Soma das do Valor Peças Max no Tabuleiro ) - (Soma do Valor das peças Min no Tabuleiro )
%-------------------------------------------------------------------------------

heuristic_board(Player, Game_Board, Value) :-
	calculate_value(Player, Game_Board, Value1),
	other_player(Player, Other),
	calculate_value(Other, Game_Board, Value2),
	Value is Value1 - Value2.

calculate_value(Player, Game_Board, Value):-
	findall(Val, (
	member_board(Player, X, Y, Game_Board), heuristic(X, Y, Val)), List),
	sum(List, Value).

sum([], 0).

sum([H|T], Sum) :-
	sum(T, S),
	Sum is S + H.

%-------------------------------------------------------------------------------
% Definição do valor heurístico,
% de acordo com a posição da jogada.
%-------------------------------------------------------------------------------

%	 [50, 5,10,10,10,10, 5, 50],
%	 [ 5, 1, 3, 3, 3, 3, 1, 5 ],
%	 [10, 3, 5, 5, 5, 5, 3, 10],
%	 [10, 3, 5, 5, 5, 5, 3, 10],
%	 [10, 3, 5, 5, 5, 5, 3, 10],
%	 [10, 3, 5, 5, 5, 5, 3, 10],
%	 [ 5, 1, 3, 3, 3, 3, 1, 5 ],
%	 [50, 5,10,10,10,10, 5, 50]


pos_50(1, 1). pos_50(8, 1). pos_50(1, 8). pos_50(8, 8).

pos_10(X, Y) :-
	X > 2, X < 7, (Y = 1, Y = 8).
pos_10(X, Y) :-
	Y > 2, Y < 7, (X = 1; X = 8).

pos_05(X, Y) :-
	X > 2, X < 7, Y > 2, Y < 7.

pos_05(1, 2). pos_05(2, 1). pos_05(1, 7). pos_05(2, 8).
pos_05(7, 1). pos_05(8, 2). pos_05(8, 7). pos_05(7, 8).

pos_03(X, Y) :-
	X > 2, X < 7, (Y = 2; Y = 7).

pos_03(X, Y) :-
	Y > 2, Y < 7, (X = 2; X = 7).

pos_01(2, 2). pos_01(2, 7). pos_01(7, 2). pos_01(7, 7).


heuristic(X,Y, 50) :- pos_50(X, Y).
heuristic(X,Y, 10) :- pos_10(X, Y).
heuristic(X,Y, 5) :- pos_05(X, Y).
heuristic(X,Y, 3) :- pos_03(X, Y).
heuristic(X,Y, 1) :- pos_01(X, Y).

%-------------------------------------------------------------------------------
% retun_move(J,X,Y, Game_Board)
% Verifica se um peça em X Y é membro do tabuleiro.
%-------------------------------------------------------------------------------

return_move(P,X,Y,Game_Board) :-
	member_board(*,X,Y,Game_Board),
	adjacent(X,Y,X2,Y2,N),
	other_player(P,P2),
	member_board(P2,X2,Y2,Game_Board),
	can_move_here(P,P2,X2,Y2,N,Game_Board).

%-------------------------------------------------------------------------------
% execute_move(J,X,Y, Game_Board)
% Realiza um movimento na coordenada X Y, e vira a sucessivas peças
%-------------------------------------------------------------------------------

execute_move(P,X,Y, Game_Board, New_Game_Board) :-
	change_game_board(P, X, Y, Game_Board, New_Game_Board1),
	turn_tiles(P, X, Y,New_Game_Board1, New_Game_Board),!.


turn_tiles(P, X, Y, Game_Board, New_Game_Board) :-
	% encontra todas as direções que pode comer as peças
	findall(D, direction_to_eat(X, Y, P, Game_Board, D), List_D),
	turn_directions(P, X, Y, List_D, Game_Board, New_Game_Board),!.


% retorna uma direção para a peça tentar comer.
direction_to_eat(X, Y, P, Game_Board, N) :-
	adjacent(X,Y,X2,Y2,N),
	other_player(P,P2),
	member_board(P2,X2,Y2,Game_Board),
	can_move_here(P,P2,X2,Y2,N,Game_Board).


turn_directions(P, X, Y, [], Game_Board, Game_Board).

turn_directions(P, X, Y, [D|T], Game_Board, New_Game_Board) :-
	adjacent(X,Y,X2,Y2,D),
	turn_direction(P, X2, Y2, D, Game_Board, New_Game_Board1),
	turn_directions(P, X, Y, T, New_Game_Board1, New_Game_Board),!.


turn_direction(P, X, Y, D, Game_Board, Game_Board) :- 
	member_board(P, X, Y, Game_Board),!.

turn_direction(P, X, Y, D, Game_Board, New_Game_Board) :- 
	other_player(P, P2),
	change_game_board(P, X, Y, Game_Board, New_Game_Board1),
	adjacent(X,Y,X2,Y2,D),
	turn_direction(P, X2, Y2, D, New_Game_Board1, New_Game_Board).

%------------------------------------------------------------------------
% change_game_board(New_Tile, X, Y, Game_Board)
% Muda a peça da posicao X Y para uma nova peca
%------------------------------------------------------------------------

change_game_board(New_Tile, X, Y, Game_Board, New_Game_Board) :-
	change_board(1,New_Tile, X, Y, Game_Board, New_Game_Board).

change_board(_,_, _, _, [], []).

change_board(Y, New_Tile, X, Y, [Line|T], [New_Line|T2]) :-
	change_line(New_Tile, X, Line, New_Line),
	N2 is Y + 1,
	change_board(N2,New_Tile, X, Y, T, T2).

change_board(N, New_Tile, X, Y, [H|T], [H|T2]) :-
	N2 is N + 1,
	change_board(N2,New_Tile, X, Y, T, T2).

%------------------------------------------------------------------------
% change_lile(New_Tile, X, Game_Board)
% Muda a peça da posicao X  para uma nova peca de uma linha
%------------------------------------------------------------------------

change_line(New_Tile, X, Line, New_Line) :-
	change_line2(1, New_Tile, X, Line, New_Line),!.

change_line2(_,_,_, [], []).

change_line2(X, New_Tile, X, [_|T],[New_Tile|T2]) :-
	N2 is X + 1,
	change_line2(N2, New_Tile, X, T, T2).

change_line2(N, New_Tile, X, [H|T],[H|T2]) :-
	N2 is N + 1,
	change_line2(N2, New_Tile, X, T, T2).

%-------------------------------------------------------------------------------
% member_board(Tile, X, Y, Game_Board)
% Verifica se um peça em X Y é membro do tabuleiro.
%-------------------------------------------------------------------------------

member_board(Tile, X, Y, Game_Board):-
	member_pos_list(Line, Y, Game_Board),
	member_pos_list(Tile, X, Line).

member_pos_list(Member, N, Lista):-
	member_pos_search(Member, 1, N, Lista).

member_pos_search(Member, N, N, [Member|_]).

member_pos_search(Member, P, N, [H|T]):-
	P2 is P+1,
	member_pos_search(Member, P2, N, T).

%-------------------------------------------------------------------------------
% other_player(Player, OherPlayer)
% Alterna o Jogador. 
%-------------------------------------------------------------------------------
  other_player(b, p).
  other_player(p, b).
  
%-------------------------------------------------------------------------------
% write_espace(P)
% Alterna o Jogador. 
%-------------------------------------------------------------------------------
write_with_espace(P):- write(' '), write(P).

%------------------------------------------------------------------------
% adjacent(X,Y,X2,Y2,1)
% Determina a posição de um vizinho, por backtracking é possível ter todos
% 8 vizinhos a uma posição X Y.
%------------------------------------------------------------------------

adjacent(X,Y,X2,Y2,1):-
	Y2 is Y-1,
	X2 is X-1.

adjacent(X,Y, X,Y2,2):-
	Y2 is Y-1.

adjacent(X,Y,X2,Y2,3):-
	Y2 is Y-1,
	X2 is X+1.

adjacent(X,Y,X2, Y,4):-
	X2 is X-1.

adjacent(X,Y,X2, Y,5):-
	X2 is X+1.

adjacent(X,Y,X2,Y2,6):-
	Y2 is Y+1,
	X2 is X-1.

adjacent(X,Y, X,Y2,7):-
	Y2 is Y+1.

adjacent(X,Y,X2,Y2,8):-
	Y2 is Y+1,
	X2 is X+1.

%------------------------------------------------------------------------
% can_move_here(J,J2,X,Y,N,Game_Board)
% Verifica se X,Y é uma coordenada válida de movimento
%------------------------------------------------------------------------

can_move_here(P,P2,X,Y,N,Game_Board):-
	adjacent(X,Y,X2,Y2,N),
	member_board(P,X2,Y2,Game_Board),!.

can_move_here(P,P2,X,Y,N,Game_Board):- !, % X<9, Y<9,
	adjacent(X,Y,X2,Y2,N),
	member_board(P2,X2,Y2,Game_Board),
	can_move_here(P,P2,X2,Y2,N,Game_Board),!.

%------------------------------------------------------------------------
% show_game_board(Game_Board)
% Mostra o Tabuleiro: Escreve a grelha superior e mostra cada uma das linhas. 
%------------------------------------------------------------------------

show_game_board(Game_Board):-
	nl, write('  1 2 3 4 5 6 7 8'), nl,
	show_lines(1,Game_Board),
	write('  1 2 3 4 5 6 7 8'), nl,!.

show_lines(_,[]).

show_lines(N,[Line|Rest]):-
	write(N),
	show_line(Line),
	write(' '), write(N), nl,
	N2 is N+1,
	show_lines(N2, Rest).

show_line([]).

show_line([El|Rest]):-
	write_with_espace(El),
	show_line(Rest).

