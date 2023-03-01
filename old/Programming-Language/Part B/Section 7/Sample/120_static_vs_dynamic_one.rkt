; Programming Languages, Dan Grossman
; Section 6: Static Versus Dyanamic Typing, Part 1

#lang racket

; difference between Racket and SML:
; * Biggest difference: ML's type system and Racket's lack of type system

; type-checking:
;   * Static typing: compile time
;     * anything done to reject a program after it parses but before it runs
;     * common way: via a type system
;     * purpose: preventing misuse of primitives, enforcing abstration,
;                preventing certain behaviors from happenning at run-time, etc.
;   * Dynamic typing: runtime
;     * if the implementation can analyze the code to ensure somee checks are not needed,
;       then it can optimize them away
;   * static/dynamic checking are two points on a continuum, a language design choice

; Type stystem's correctness:
;   * Soundness: prevents the thing that was supposed to prevent
;     No false negatives
;   * Completeness: never rejects a program that, no matter what input it is run with
;     No false positives
;   * SML Why incompleteness: Almost anything to be checked statically is undecidable

; Weak typing: unsoundness, C/C++
;   * there exist programs that must pass static checking
;   * weak typing is a poor name: really about doing neither static nor dynamic checks
;   * arrays bound: most PLs check dynamicly
;   * Why: ~~strong types for weak minds~~
;   * Racket is NOT weakly typed

; Dynamic vs. Static typing:
;   * Static/Dynamic checking are two points on a continuum, a language design choice
;   * Claim1:
;     * Dynamic is more convenient: different return values, etc.
;     * Static is more convenient: no need to check the arguments, etc.
;   * Claim2:
;     * Static prevents useful programs
;     * Static lets you tag as needed
;   * Claim3:
;     * Static catches bugs earlier
;     * Static catches EASY bugs
;   * Claim4:
;     * Static typing is faster: fewer checks
;     * Dynamic typing is faster: optimization to remove some unnecessary tags and tests
;   * Claim5:
;     * Code reuse easier with dynamic: any kind of data
;     * Code reuse easier with static: generic, subtyping
;   * Claim6:
;     * Dynamic better for prototyping
;     * Static better for prototyping
;   * Claim7:
;     * Dynamic better for evolution
;     * Static better for evolution

; Racket: ignore syntax, ML is subset of Racket
; SML: Racket's type is a HUGE type of SML, except struct-definition

(define (f y)
  (if (> y 0) (+ y y) "hi"))

(define a (let ([ans (f 7)])
      (if (number? ans) (number->string ans) ans)))

(define (cube x)
  (if (not (number? x))
      (error "bad arguments")
      (* x x x)))

(define b (cube 7))

(define (f2 g)
  (cons (g 7) (g #t)))

(define pair_of_pairs
  (f2 (lambda (x) (cons x x))))

(define (pow-bad-type x) ; curried
  (lambda (y)
    (if (= y 0)
        1
        (* x (pow-bad-type x (- y 1)))))) ; oops

(define (pow-bad-algorithm x) ; curried
  (lambda (y)
    (if (= y 0)
        1
        (+ x ((pow-bad-algorithm x) (- y 1)))))) ; oops
