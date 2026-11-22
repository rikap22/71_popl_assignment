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
