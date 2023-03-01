; Programming Languages, Dan Grossman
; Section 5: The Truth About Cons

#lang racket

(provide (all-defined-out))

; cons just makes a pair
;   - often called a cons cell
; proper list: built from list, a series of nested cons cells end with null
;   - list? return true for proper lists, including empty lists
; improper list: built from cons
;   - '((1 . 2) . 3)
;   - when you need a small thing
;   - pair? return true for things made by cons

(define pr (cons 1 (cons #t "hi"))) ; (1, (true, "hi"))
(define lst (cons 1 (cons #t (cons "hi" null))))
(define hi (cdr (cdr pr)))
(define hi-again (car (cdr (cdr lst))))
(define hi-again-shorter (caddr lst))
(define no (list? pr))
(define yes (pair? pr))
(define of-course (and (list? lst) (pair? lst)))
; (define do-not-do-this (length pr))

