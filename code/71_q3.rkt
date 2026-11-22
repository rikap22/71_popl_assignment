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

;; (preorder t acc): preorder(t) = (value) ++ preorder(left) ++ preorder(right), then acc.
(define (preorder t acc)
  (if (null? t)
      acc
      (cons (tree-value t)
            (preorder (tree-left t)
                      (preorder (tree-right t) acc)))))

;; (postorder t acc): postorder(t) = postorder(left) ++ postorder(right) ++ (value), then acc.
(define (postorder t acc)
  (if (null? t)
      acc
      (postorder (tree-left t)
                 (postorder (tree-right t)
                            (cons (tree-value t) acc)))))

;; ---------- height and leaves ----------

;; height of '() is 0; height of a node is 1 + max of the subtree heights.
(define (height t)
  (if (null? t)
      0
      (+ 1 (max (height (tree-left t))
                (height (tree-right t))))))

;; (count-leaves t acc): acc plus the number of leaves in t.
;; A leaf is a node whose two subtrees are both '().
(define (count-leaves t acc)
  (cond ((null? t) acc)
        ((and (null? (tree-left t)) (null? (tree-right t))) (+ acc 1))
        (else (count-leaves (tree-right t)
                            (count-leaves (tree-left t) acc)))))

;; ---------- printing helper ----------

(define (display-line x)
  (display x)
  (newline))

;; ---------- S1.a ----------

(define (print-inorder tree)
  (display-line (inorder tree '())))


;; ---------- S1.b ----------

(define (print-all-traversals tree)
  (display-line (inorder tree '()))
  (display-line (preorder tree '()))
  (display-line (postorder tree '())))

;; ---------- S1.c ----------

(define (print-height-and-leaves tree)
  (display-line (list (height tree) (count-leaves tree 0))))
