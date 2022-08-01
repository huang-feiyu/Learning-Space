; Programming Languages, Dan Grossman
; Section 5: mcons

#lang racket

(provide (all-defined-out))

; cons cells are immutable -- this does not change a cell's contents
(define x (cons 14 null)) ; '(14)
(define y x) ; '(14)
(set! x (cons 42 null)) ; '(42)
(define fourteen (car y)) ; '(14), cons cells are immutable

; but since mutable pairs are useful, Racket has them too:
;  mcons, mcar, mcdr, set-mcar!, set-mcdr!
(define mpr (mcons 1 (mcons #t "hi"))) ; (mcons 1 (mcons #t "hi"))
(set-mcdr! (mcdr mpr) "bye") ; (mcons 1 (mcons #t "bye"))
(define bye (mcdr (mcdr mpr))) ; "bye", mcons is mutable

; Note: run-time error to use mcar on a cons or car on an mcons