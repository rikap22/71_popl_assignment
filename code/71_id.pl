% P1: Department Assignment Puzzle, Reloaded
% CS F301 Principles of Programming Languages, Assignment 2
%
% A solution is a list of four terms p(Name, Dept, Lang, Project)
% in the fixed order Alex, Ben, Carla, Dana.

:- use_module(library(lists)).
:- use_module(library(apply)).

% ---------------------------------------------------------------
% Domains
% ---------------------------------------------------------------

depts([research, development, design, testing]).
langs([python, java, 'c++', javascript]).
projects(['AI', web, embedded, data]).

% solution(-S)
% S is a fully filled-in assignment: each attribute is a permutation
% of its domain, so every value is used exactly once.
solution([p('Alex',  D1, L1, P1),
          p('Ben',   D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana',  D4, L4, P4)]) :-
    depts(Ds),    permutation(Ds, [D1, D2, D3, D4]),
    langs(Ls),    permutation(Ls, [L1, L2, L3, L4]),
    projects(Ps), permutation(Ps, [P1, P2, P3, P4]).

% ---------------------------------------------------------------
% Clues: clue(N, S) holds when clue N is true in the ground S.
% ---------------------------------------------------------------

% 1. The friend who prefers the AI project does not work in
%    research and is not Dana.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    Dept \== research,
    Name \== 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    Dept \== development,
    Lang \== 'c++'.

% 3. The friend working in the testing department likes Python.
clue(3, S) :-
    member(p(_, testing, Lang, _), S),
    Lang == python.

% 4. Ben prefers web projects and does not work in testing.
clue(4, S) :-
    member(p('Ben', Dept, _, Project), S),
    Project == web,
    Dept \== testing.

% 5. The friend whose favorite language is Java works in design.
clue(5, S) :-
    member(p(_, Dept, java, _), S),
    Dept == design.

% 6. Carla's project is not embedded and her department is not
%    development.
clue(6, S) :-
    member(p('Carla', Dept, _, Project), S),
    Project \== embedded,
    Dept \== development.

% 7. Dana's favorite language is not Java, and she works in
%    research or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data projects works in research and
%    does not use JavaScript.
clue(8, S) :-
    member(p(_, Dept, Lang, data), S),
    Dept == research,
    Lang \== javascript.

% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
clue(9, S) :-
    member(p(_, _, java, Project), S),
    Project == embedded.

% ---------------------------------------------------------------
% Checking and solving
% ---------------------------------------------------------------

% satisfies(+Active, +S): every clue number in Active holds in S.
satisfies(Active, S) :-
    forall(member(N, Active), clue(N, S)).

% solve(+Active, -S): S is a solution satisfying all clues in Active.
solve(Active, S) :-
    solution(S),
    satisfies(Active, S).

% ---------------------------------------------------------------
% P1.a  main/0: print one solution of clues 1 to 8
% ---------------------------------------------------------------

main :-
    once(solve([1, 2, 3, 4, 5, 6, 7, 8], S)),
    print_solution(S).

print_solution(S) :-
    forall(member(p(Name, Dept, Lang, Project), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project])).

% ---------------------------------------------------------------
% P1.b  count_solutions(+Active, -N)
% ---------------------------------------------------------------

count_solutions(Active, N) :-
    findall(S, solve(Active, S), Solutions),
    length(Solutions, N).
