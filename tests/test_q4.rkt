#lang racket
;; Tests for S2. Run from the repository root:
;;   racket tests/test_q4.rkt
;; Loads code/*_q4.rkt unchanged in a sandbox, feeds standard input
;; and compares printed output.

(require racket/sandbox racket/runtime-path)
(define-runtime-path code-dir "../code")

(define code-file
  (for/first ([f (directory-list code-dir #:build? #t)]
              #:when (regexp-match? #rx"_q4\\.rkt$" (path->string f)))
    f))

(define (run input calls)
  (parameterize ([sandbox-output 'string]
                 [sandbox-input input]
                 [sandbox-eval-limits #f]
                 [sandbox-memory-limit #f])
    (define ev (make-module-evaluator (file->string code-file)))
    (define results (for/list ([c calls]) (ev c)))
    (begin0 (cons (get-output ev) results) (kill-evaluator ev))))

(define pass 0)
(define fail 0)
(define (ok! name ok? expected got)
  (if ok?
      (set! pass (add1 pass))
      (begin (set! fail (add1 fail))
             (printf "FAIL ~a\n  expected: ~s\n  got:      ~s\n" name expected got))))

;; print-insert-result with the given stdin
(define (check-io name input expected)
  (define got (car (run input '((print-insert-result)))))
  (ok! name (equal? got expected) expected got))

;; call a function directly and compare its value
(define (check-val name call expected)
  (define got (cadr (run "" (list call))))
  (ok! name (equal? got expected) expected got))

;; ---- examples from the assignment ----
(check-io "ex1" "42 ((1 2) (3 4 5) (6) ()) 3" "((42 1 2) (3 4 5) (42 6) (42))\n")
(check-io "ex2" "0 (((1) 2) (3) ((4 5 6) ())) 3" "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check-io "ex3" "7 () 3" "(7)\n")
(check-io "ex4" "7 () 0" "()\n")

;; ---- edge cases ----
(check-io "symbol x, newlines in input" "a\n(b (c) d)\n3\n" "(b (a c) d)\n")
(check-io "n = 0 never inserts" "x ((1) (()) ()) 0" "((1) (()) ())\n")
(check-io "length uses original list" "x (1 2) 3" "(x 1 2)\n")
(check-val "my-length" '(my-length '(1 (2 3) () 4)) 4)
(check-val "my-map" '(my-map (lambda (e) (* e e)) '(1 2 3)) '(1 4 9))
(check-val "my-map empty" '(my-map (lambda (e) e) '()) '())
(check-val "make-inserter even lengths"
           '((make-inserter 'z (lambda (n) (= n 2))) '((1 2) (3) (4 5 (6 7))))
           '((z 1 2) (3) (4 5 (z 6 7))))
(check-val "insert-if-short direct" '(insert-if-short 'q '(() (())) 2) '((q) (q (q))))
(ok! "loading prints nothing" (equal? (car (run "" '())) "") "" (car (run "" '())))

;; ---- hidden-test sizes: 10,000 elements and depth 100 ----
(define big-list (make-list 10000 1))
(define big-out (cadr (run "" (list `(insert-if-short 'x ',big-list 10001)))))
(ok! "10000 elements" (and (= (length big-out) 10001) (eq? (car big-out) 'x)) 10001 (length big-out))

(define (nest d) (if (= d 0) '() (list (nest (sub1 d)))))
(define (depth-x l)                       ; how many levels got an x
  (if (null? l) 0
      (+ (if (eq? (car l) 'x) 1 0)
         (let ([sub (filter list? l)]) (if (null? sub) 0 (depth-x (car sub)))))))
(define deep-out (cadr (run "" (list `(insert-if-short 'x ',(nest 100) 2)))))
(ok! "depth 100" (= (depth-x deep-out) 101) 101 (depth-x deep-out))

(printf "S2: ~a passed, ~a failed\n" pass fail)
