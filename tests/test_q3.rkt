#lang racket
;; Tests for S1. Run from the repository root:
;;   racket tests/test_q3.rkt
;; Loads code/*_q3.rkt unchanged in a sandbox and compares printed output.

(require racket/sandbox racket/runtime-path)
(define-runtime-path code-dir "../code")

(define code-file
  (for/first ([f (directory-list code-dir #:build? #t)]
              #:when (regexp-match? #rx"_q3\\.rkt$" (path->string f)))
    f))

(define (run calls)
  (parameterize ([sandbox-output 'string]
                 [sandbox-eval-limits #f]
                 [sandbox-memory-limit #f])
    (define ev (make-module-evaluator (file->string code-file)))
    (for ([c calls]) (ev c))
    (begin0 (get-output ev) (kill-evaluator ev))))

(define pass 0)
(define fail 0)
(define (check name calls expected)
  (define got (run calls))
  (if (equal? got expected)
      (set! pass (add1 pass))
      (begin (set! fail (add1 fail))
             (printf "FAIL ~a\n  expected: ~s\n  got:      ~s\n" name expected got))))

(define t1 ''(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 ''(1 () (2 () (3 () ()))))
(define t3 ''(a (b () ()) (c () ())))

;; ---- examples from the assignment ----
(check "inorder t1" `((print-inorder ,t1)) "(1 2 3 4 5 6 7)\n")
(check "all t1" `((print-all-traversals ,t1))
       "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check "hl t1" `((print-height-and-leaves ,t1)) "(3 4)\n")
(check "all t2" `((print-all-traversals ,t2)) "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check "hl t2" `((print-height-and-leaves ,t2)) "(3 1)\n")
(check "all t3" `((print-all-traversals ,t3)) "(b a c)\n(a b c)\n(b c a)\n")
(check "hl t3" `((print-height-and-leaves ,t3)) "(2 2)\n")
(check "inorder empty" '((print-inorder '())) "()\n")
(check "all empty" '((print-all-traversals '())) "()\n()\n()\n")
(check "hl empty" '((print-height-and-leaves '())) "(0 0)\n")

;; ---- edge cases ----
(check "single node" '((print-all-traversals '(9 () ()))
                       (print-height-and-leaves '(9 () ())))
       "(9)\n(9)\n(9)\n(1 1)\n")
(check "left chain" '((print-all-traversals '(3 (2 (1 () ()) ()) ()))
                      (print-height-and-leaves '(3 (2 (1 () ()) ()) ())))
       "(1 2 3)\n(3 2 1)\n(1 2 3)\n(3 1)\n")
(check "unbalanced" '((print-height-and-leaves '(1 (2 () (4 () ())) (3 () ()))))
       "(3 2)\n")
(check "loading prints nothing" '() "")

;; deep tree: a right chain of 5000 nodes
(define deep
  (let loop ([i 5000] [t '()])
    (if (= i 0) t (loop (sub1 i) (list i '() t)))))
(check "deep chain" `((print-height-and-leaves ',deep)) "(5000 1)\n")

(printf "S1: ~a passed, ~a failed\n" pass fail)
