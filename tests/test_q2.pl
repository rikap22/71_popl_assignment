% Tests for P2. Run from the repository root:
%   swipl -q -g run_tests -t halt tests/test_q2.pl

:- use_module(library(plunit)).

:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/../code/*_q2.pl', Pattern),
   expand_file_name(Pattern, [File|_]),
   consult(File).

:- begin_tests(p2).

% ---- examples from the assignment ----

test(all_4253) :-
    all_equations([4,2,5,3], Es),
    assertion(Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                     "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

test(generate_4253) :-
    generate_equation([4,2,5,3], E),
    assertion(string(E)),
    all_equations([4,2,5,3], Es),
    assertion(memberchk(E, Es)).

test(generate_234_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(all_234_empty) :-
    all_equations([2,3,4], Es),
    assertion(Es == []).

test(all_248) :-
    all_equations([2,4,8], Es),
    assertion(Es == ["2*4=8"]).

test(count_4253) :-
    count_equations([4,2,5,3], N),
    assertion(N == 7).

% ---- edge cases ----

test(empty_fails, [fail]) :-
    generate_equation([], _).

test(single_fails, [fail]) :-
    generate_equation([5], _).

test(empty_all) :-
    all_equations([], Es),
    assertion(Es == []).

test(two_equal) :-
    all_equations([7,7], Es),
    assertion(Es == ["7=7"]).

% Division by zero is never allowed: 0/0 must not appear.
test(zeros) :-
    all_equations([0,0,0], Es),
    assertion(Es == ["0*0=0", "0+0=0", "0-0=0", "0=0*0", "0=0+0", "0=0-0"]).

% Inexact division is rejected, also inside sub-expressions.
test(inexact_division) :-
    all_equations([7,2,3], Es),
    assertion(\+ memberchk("7/2=3", Es)),
    assertion(Es == []).

% Negative intermediate values with exact division: (1-7)/3 = -2 = 0-2.
test(negative_division) :-
    all_equations([1,7,3,0,2], Es),
    assertion(memberchk("(1-7)/3=0-2", Es)).

% Parenthesisation rule: different trees give different strings.
test(parens_rule) :-
    all_equations([1,2,3,2], Es),
    assertion(memberchk("1-(2-3)=2", Es)),
    assertion(\+ memberchk("1-2-3=2", Es)),
    all_equations([6,2,3,1], Es2),
    assertion(memberchk("6/(2*3)=1", Es2)),
    assertion(memberchk("6/2/3=1", Es2)).

% Output is sorted and has no duplicates.
test(sorted_unique) :-
    all_equations([1,2,3,4,5], Es),
    sort(Es, Sorted),
    assertion(Es == Sorted).

:- end_tests(p2).
