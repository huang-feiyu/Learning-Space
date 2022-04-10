; Programming Languages, Dan Grossman
; Section 5: Mutation With set!

#lang racket

(provide (all-defined-out))

; Assignment statements: (set! x e)
;   once you have side-effects, use (begin e1 e2 ... en) to avoid side-effects
;   BESIDES en, aka, the last is the result

(define b 3)
(define f (lambda (x) (* 1 (+ x b))))
(define c (+ b 4)) ; 7
(set! b 5) ; Probably a bad idea
(define z (f 4)) ; 9
(define w c) ; 7

; a safe version of f would make a local copy of b
; no need to call the local varaible b also, but no reason not to either
(define f
  (let ([b b]) ; strange idiom
    (lambda (x) (* 1 (+ x b)))))

; but maybe that is not good enough since + and * are also procedures
(define f
  (let ([b b]
        [+ +]
        [* +])
    (lambda (x) (* 1 (+ x b)))))

; it turns out:
;  1. this technique doesn't work if f calls a function that itself calls
;     things that might get mutated
;  2. we don't have to worry about this in Racket because +, * are immutable:
;     the general rule is a top-level binding is mutable only if /that/ module
;     contains a set! of it