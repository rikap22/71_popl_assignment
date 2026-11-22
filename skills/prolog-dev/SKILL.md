---
name: prolog-dev
description: Write, run and review SWI-Prolog 9.x code for the CS F301 assignment (P1 logic puzzle, P2 arithmetic equations). Use for any Prolog task in this repository.
---

# Prolog development (SWI-Prolog 9.x)

## Environment
- SWI-Prolog 9.x. Files: `code/<groupid>_q1.pl`, `code/<groupid>_q2.pl`.
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate`. Load them with `:- use_module(library(...))`.
- Forbidden: `assert*`, `retract*`, `b_setval`, `nb_setval`, any `initialization` directive, calling `halt/0`.
- P2 only: never build a string and parse it back into a term (no `term_to_atom`, `term_string`, `read_term` on built strings).
- A solution file contains only definitions and the allowed `use_module` directives. It prints nothing when loaded.

## Coding conventions
- Predicate names are `snake_case`; variables are `CamelCase`.
- Every predicate has a header comment with its mode (`+In`, `-Out`, `?Both`) and a **declarative reading**: one sentence saying what is true when it succeeds, e.g.
  `% expr(+Nums, -Tree, -Value): Tree uses every number in Nums once, in order, and evaluates to Value.`
- Prefer generate-and-test with small domains (`permutation/2`, `member/2`) and plain recursion over clever tricks.
- Use `==` / `\==` to compare ground values and `=:=` / `=\=` for arithmetic. Use `is` only to compute.
- Put each puzzle clue in its own clause `clue(N, S)` with the English sentence in a comment above it.
- Use `once/1` where exactly one answer is wanted; use `findall/3` + `sort/2` for "all answers without duplicates".

## How to run
```
swipl -q -f code/<id>_q1.pl -g main -t halt
swipl -q -f code/<id>_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N), print(N), nl" -t halt
swipl -q -f code/<id>_q2.pl -g "all_equations([4,2,5,3],E), print(E), nl" -t halt
```

## How to test
Tests use `plunit` and live in `tests/test_q1.pl` and `tests/test_q2.pl`. Run from the repo root:
```
swipl -q -g run_tests -t halt tests/test_q1.pl
swipl -q -g run_tests -t halt tests/test_q2.pl
```
Every example from the assignment is a test, and each problem also has edge cases (empty and one-element input, zeros, inexact division, negative intermediate values).

## Self-review checklist (apply before answering)
1. Does the file load with no warnings? (singleton variables, discontiguous clauses)
2. Is anything printed on load, or anything extra printed by `main`?
3. Are only allowed libraries used? No assert/retract/global variables/initialization/halt?
4. Does every predicate that must fail actually **fail** (not loop, not throw) on bad input, including `[]` and `[X]`?
5. Is every division checked for a zero divisor and exactness (`B =\= 0, A mod B =:= 0`)?
6. Are outputs the exact required type? (P2 needs SWI **strings**, not atoms or code lists: check with `string/1`.)
7. Is the output format exact (spacing, brackets, quoting of `'AI'` and `'c++'`)?
8. Does `findall` + `sort/2` give sorted output with no duplicates?
9. Has every example from the assignment been run, and does it give the stated result?

## Known AI failure modes in Prolog
- Writing `=` where `==` or `=:=` is needed, which unifies instead of comparing.
- Using negation (`\+`, `\==`) on variables that are not bound yet, so the check passes or fails for the wrong reason. Generate first, then test.
- Forgetting that `"abc"` is a string in SWI-Prolog 7+, or returning an atom where a string is required.
- Left recursion or unbounded `append/3` splits on unbound lists, which loop forever on failure instead of failing.
- Leaving extra choice points, so `main` prints twice or a "must fail" goal loops on backtracking.
- Using `/` instead of `//` and getting floats, or using `rem` versus `mod` without thinking about negative values.
- Inventing library predicates or using libraries that aren't allowed (e.g. `clpfd`).
- Hard-coding the puzzle answer instead of deriving it from the clues.
- Claiming tests pass without running them.
