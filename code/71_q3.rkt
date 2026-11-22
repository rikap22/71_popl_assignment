#lang racket/base
;; S1: Binary Tree Traversals
;; CS F301 Principles of Programming Languages, Assignment 2
;;
;; A tree is either '() or a three-element list (value left right).
;; Every traversal threads an accumulator list through the recursion,
;; so lists are built with cons only (no append, no reverse).

;; ---------- tree accessors ----------

(define (tree-value t) (car t))
(define (tree-left t) (cadr t))
(define (tree-right t) (caddr t))

;; ---------- traversals ----------

;; (inorder t acc): the inorder values of t, followed by acc.
;; Reading: inorder(t) = inorder(left) ++ (value) ++ inorder(right).
;; We visit right first so each value is consed in front of what comes after it.
(define (inorder t acc)
  (if (null? t)
      acc
      (inorder (tree-left t)
               (cons (tree-value t)
                     (inorder (tree-right t) acc)))))

;; ---------- printing helper ----------

(define (display-line x)
  (display x)
  (newline))

;; ---------- S1.a ----------

(define (print-inorder tree)
  (display-line (inorder tree '())))
