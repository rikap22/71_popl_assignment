#lang racket/base
;; S2: Conditionally Insert into a Nested List
;; CS F301 Principles of Programming Languages, Assignment 2
;;
;; All helpers are tail recursive so that lists of 10,000 elements
;; do not build up deep stacks. Recursion into sublists goes only as
;; deep as the nesting (at most about 100 levels).

;; ---------- basic helpers ----------

;; An element is a list if it is '() or a pair; otherwise it is an atom.
(define (list-elem? e)
  (or (null? e) (pair? e)))

;; (my-reverse lst): lst reversed.
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))

;; (my-length lst): number of top-level elements of lst.
(define (my-length lst)
  (let loop ((rest lst) (n 0))
    (if (null? rest)
        n
        (loop (cdr rest) (+ n 1)))))

;; (my-map f lst): the list of (f e) for each e of lst, in order.
;; Builds the result backwards, then reverses it once.
(define (my-map f lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        (my-reverse acc)
        (loop (cdr rest) (cons (f (car rest)) acc)))))

;; ---------- S2.b: insert-if-short ----------

;; Insert x at the front of every list whose length is less than n.
;; Reading: process the sublists first, then cons x in front if the
;; original list is short enough.
(define (insert-if-short x lst n)
  (let ((new-lst (my-map (lambda (e)
                           (if (list-elem? e) (insert-if-short x e n) e))
                         lst)))
    (if (< (my-length lst) n)
        (cons x new-lst)
        new-lst)))

;; ---------- S2.a ----------

;; Reads x, lst and n (in that order) from standard input and prints the result.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
