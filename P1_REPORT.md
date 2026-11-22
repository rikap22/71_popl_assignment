# P1 Report: Department Assignment Puzzle, Reloaded

## P1.b: number of solutions for clues 1 to 8

```
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

**N = 3.** For comparison, `count_solutions([], N)` gives 13,824 (= 24 × 24 × 24 ways to permute departments, languages and projects), so clues 1–8 cut the search space down to three assignments.

The three solutions (in order Alex, Ben, Carla, Dana; each entry is dept, lang, project):

| # | Alex | Ben | Carla | Dana |
|---|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## What this tells us about the puzzle

- The puzzle as given is **under-constrained**: it has more than one solution, so it is not a well-posed logic puzzle. `main` can only print *one* solution of clues 1–8, and which one you get depends on search order.
- Some facts are forced: Ben is always in development with JavaScript and web, and the C++ person always works in research on data. The clues do pin down part of the answer.
- Solutions 1 and 3 use **the same four (department, language, project) triples** and differ only in that Alex and Carla swap roles. So no clue that talks only about attribute values (and not names) can tell 1 and 3 apart. Any name-free clue that keeps one of them also keeps the other.
- So a name-free repair can only keep **solution 2**, the one whose triples differ (Java goes with embedded instead of AI).

## P1.c: repair

```prolog
% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
clue(9, S) :-
    member(p(_, _, java, Project), S),
    Project == embedded.
```

- True in solution 2 (Alex: java, embedded).
- False in solutions 1 and 3 (the Java person prefers AI).
- It mentions no friend by name.

```
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

The unique solution is Alex = [design, java, embedded], Ben = [development, javascript, web], Carla = [testing, python, AI], Dana = [research, c++, data].
