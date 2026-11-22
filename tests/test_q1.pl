% Tests for P1. Run from the repository root:
%   swipl -q -g run_tests -t halt tests/test_q1.pl

:- use_module(library(plunit)).

:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/../code/*_q1.pl', Pattern),
   expand_file_name(Pattern, [File|_]),
   consult(File).

:- begin_tests(p1).

% Clues 1..8 leave exactly three solutions.
test(count_1_to_8) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N == 3).

% Adding clue 9 leaves exactly one.
test(count_1_to_9) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N == 1).

% With no clues every combination counts: 24^3.
test(count_no_clues) :-
    count_solutions([], N),
    assertion(N == 13824).

% Clue 9 alone must not be enough to solve the puzzle.
test(clue9_alone_not_unique) :-
    count_solutions([9], N),
    assertion(N > 1).

% The kept solution.
test(unique_solution) :-
    findall(S, solve([1,2,3,4,5,6,7,8,9], S), [S]),
    assertion(S == [p('Alex', design, java, embedded),
                    p('Ben', development, javascript, web),
                    p('Carla', testing, python, 'AI'),
                    p('Dana', research, 'c++', data)]).

% Clue 9 is false in every other solution of clues 1..8.
test(clue9_false_elsewhere) :-
    findall(S, ( solve([1,2,3,4,5,6,7,8], S), \+ clue(9, S) ), Others),
    length(Others, 2).

% main prints four lines in the required format, and that answer
% satisfies all of clues 1..8.
test(main_output) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "", Lines0),
    exclude(==(""), Lines0, Lines),
    assertion(length(Lines, 4)),
    Lines = [LA, LB, LC, LD],
    assertion(sub_string(LA, 0, _, _, "Alex = [")),
    assertion(sub_string(LB, 0, _, _, "Ben = [")),
    assertion(sub_string(LC, 0, _, _, "Carla = [")),
    assertion(sub_string(LD, 0, _, _, "Dana = [")),
    findall(Line,
            ( solve([1,2,3,4,5,6,7,8], S),
              member(p(N, D, L, P), S),
              format(string(Line), "~w = [~w, ~w, ~w]", [N, D, L, P]) ),
            Valid),
    forall(member(Line, Lines), assertion(memberchk(Line, Valid))).

% A hand-written wrong assignment breaks some clue.
test(wrong_solution_rejected, [fail]) :-
    satisfies([1,2,3,4,5,6,7,8],
              [p('Alex', research, python, 'AI'),
               p('Ben', development, java, web),
               p('Carla', design, 'c++', embedded),
               p('Dana', testing, javascript, data)]).

:- end_tests(p1).
