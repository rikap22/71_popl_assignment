---
name: scheme-dev
description: Write, run and review restricted Racket/Scheme code (#lang racket/base, Racket 8.x) for the CS F301 assignment (S1 tree traversals, S2 nested insert). Use for any Scheme task in this repository.
---

# Scheme development (Racket 8.x, `#lang racket/base`)

## Environment and allowed built-ins
- Racket 8.x. Every solution file starts with `#lang racket/base`.
- **Only** these built-ins: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`), `cons`, `car`, `cdr`, `list`, `c[ad]{2,4}r` (`cadr`, `caddr`, ...), `null?`, `pair?`, `eq?`, `assq`, `assoc`, `+ - * < > <= >= =`, `max`, `display`, `newline`. S2 also allows `read`.
- **Forbidden**: `set!` and relatives, vectors, hash tables, strings, `do`, `for`, `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `when`, `unless`. If one is needed, write a helper (`my-length`, `my-map`, `my-reverse`).
- Files contain only definitions: no top-level calls and no output on load. The grader appends its own calls to the end of the file.

## Coding conventions
- Names are `kebab-case`; predicates end in `?` (`list-elem?`); helpers that replace built-ins start with `my-`.
- Each function has a comment giving its **recursive reading**, e.g.
  `;; inorder(t) = inorder(left) ++ (value) ++ inorder(right)`.
- Pass all state through arguments (accumulators). No mutation.
- Prefer tail recursion (named `let` loops) for walking long lists. Recursion that follows tree or nesting depth is fine.
- Build result lists with `cons` onto an accumulator, then reverse once with `my-reverse` if needed. Never append in a loop.
- Use small accessors (`tree-value`, `tree-left`, `tree-right`) instead of bare `car`/`cadr` chains.

## How to run
```
racket code/<id>_q3.rkt            ; must print nothing
echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket tmp_q4.rkt   ; tmp = file + (print-insert-result)
```
To try a call the way the grader does, copy the file, append the call at the end and run the copy.

## How to test
Tests in `tests/test_q3.rkt` and `tests/test_q4.rkt` load the solution file unchanged in `racket/sandbox`, capture what it prints and compare that output exactly. Run from the repo root:
```
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```
Tests cover every example in the assignment plus edge cases: empty tree or list, single node, chains, n = 0, 10,000-element lists and nesting depth 100.

## Self-review checklist (apply before answering)
1. Does the file start with `#lang racket/base`? Does `racket file.rkt` print nothing?
2. Grep the code (minus comments): is every identifier either allowed or defined in the file?
3. No `set!`, no loops, no strings, no forbidden list functions?
4. Does every printing function end with exactly one `newline`? Is the output format exactly `(1 2 3)`?
5. Empty input: does `'()` print `()`, and is height/leaves `(0 0)`?
6. S2: is the length measured on the **original** list, before inserting x? Is the top-level list treated like any other? Does `()` become `(x)` when `0 < n`?
7. Do long lists (10,000) run in a tail-recursive loop?
8. Has every example from the assignment been run with exact output compared?

## Known AI failure modes in Scheme
- Using `length`, `append`, `map` or `reverse` out of habit even though they're forbidden.
- Using `else` outside `cond`, or `when`/`unless`, which aren't allowed.
- Using `#lang racket` instead of `#lang racket/base`, or adding `provide`/`require`.
- Leaving test calls or `display` at the top level, so the file prints on load.
- Measuring the length after inserting x, or recursing into the inserted x.
- Treating `'()` as an atom (it is a list) or a symbol as a list. Test with `(or (null? e) (pair? e))`.
- Mixing up the accumulator order so traversals come out reversed.
- Using `display` with a string literal (strings are forbidden), e.g. `(display " ")`.
- Non-tail recursion over 10,000-element lists when a loop is easy.
- Off-by-one in height (empty tree is 0, a single node is 1) or counting `'()` as a leaf.
