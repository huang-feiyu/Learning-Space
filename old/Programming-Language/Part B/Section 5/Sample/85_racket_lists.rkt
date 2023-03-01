; Programming Languages, Dan Grossman
; Section 5: Racket Lists

; List processing:
; * null: Empty list, ()
; * cons: constructor to create/link list
; * car: Access head of list
; * cdr: Access tail of list
; * null?: Test for empty list

; always make this the first (non-comment, non-blank) line of your file
#lang racket

; not needed here, but a workaround so we could write tests in a second file
; see getting-started-with-Racket instructions for more explanation
(provide (all-defined-out))

; list processing: null, cons, null?, car, cdr
; we won't use pattern-matching in Racket
(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs))))) ; head of xs + sum of tail of xs

(define (my-append xs ys) ; same as append already provided
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys)))) ; xs.append(ys)

(define (my-map f xs) ; same as map already provided
  (if (null? xs)
      null
      (cons (f (car xs)) (my-map f (cdr xs)))))

(define foo (my-map (lambda (x) (+ x 1)) (cons 3 (cons 4 (cons 5 null)))))

