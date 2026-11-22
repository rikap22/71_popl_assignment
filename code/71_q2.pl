% P2: Form a Valid Arithmetic Equation
% CS F301 Principles of Programming Languages, Assignment 2
%
% Expressions are built as trees and evaluated while they are built:
%   num(N)          a single number
%   op(Op, L, R)    L Op R, with Op one of + - * /
% Strings are only produced from finished trees; nothing is parsed.

:- use_module(library(lists)).
:- use_module(library(apply)).

% ---------------------------------------------------------------
% Building expressions
% ---------------------------------------------------------------

% expr(+Nums, -Tree, -Value)
% Tree is an expression that uses every number of Nums once, in
% order, and Value is its integer value. Every division is exact.
expr([N], num(N), N).
expr(Nums, op(Op, L, R), V) :-
    split(Nums, LeftNums, RightNums),
    expr(LeftNums, L, VL),
    expr(RightNums, R, VR),
    member(Op, [+, -, *, /]),
    apply_op(Op, VL, VR, V).

% split(+List, -Left, -Right): List = Left ++ Right, both non-empty.
split(List, Left, Right) :-
    append(Left, Right, List),
    Left \== [],
    Right \== [].

% apply_op(+Op, +A, +B, -V): V is A Op B; / only when exact and B =\= 0.
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% equation(+Nums, -Equation)
% Equation is the canonical string "L=R" of a valid equation.
equation(Nums, Equation) :-
    split(Nums, LeftNums, RightNums),
    expr(LeftNums, L, V),
    expr(RightNums, R, V),
    tree_string(L, LS),
    tree_string(R, RS),
    atomic_list_concat([LS, '=', RS], EqAtom),
    atom_string(EqAtom, Equation).

% ---------------------------------------------------------------
% Printing trees (canonical form)
% ---------------------------------------------------------------

% prec(+Tree, -P): precedence of the top operator; numbers are highest.
prec(num(_), 3).
prec(op(Op, _, _), P) :- op_prec(Op, P).

op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% tree_string(+Tree, -Atom)
tree_string(num(N), A) :-
    atom_number(A, N).
tree_string(op(Op, L, R), A) :-
    op_prec(Op, P),
    tree_string(L, LA0),
    tree_string(R, RA0),
    prec(L, PL),
    prec(R, PR),
    (   PL < P  -> wrap(LA0, LA) ; LA = LA0 ),   % left: lower only
    (   PR =< P -> wrap(RA0, RA) ; RA = RA0 ),   % right: same or lower
    atomic_list_concat([LA, Op, RA], A).

wrap(A, W) :- atomic_list_concat(['(', A, ')'], W).
