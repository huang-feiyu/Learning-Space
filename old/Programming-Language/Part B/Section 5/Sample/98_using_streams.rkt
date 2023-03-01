; Programming Languages, Dan Grossman
; Section 5: Using and Defining Streams

; [same code for segments on using streams and defining streams]

#lang racket

(provide (all-defined-out))

; streams:
;   - an *infinite* sequence of values
;     - cannot make a stream by making all the values
;     - key idea: use a thunk to delay creating most of the sequence
;   - a powerful concept for division of labor
;     - stream producer knows how create any number of values
;     - stream consumer decides how many values to ask for

;(define ones-really-bad (cons 1 ones-really-bad))
(define ones-bad (lambda () (cons 1 (ones-bad))))

(define ones (lambda () (cons 1 ones)))

(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define powers-of-two ; a stream
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

(define (stream-maker fn arg)
  (letrec ([f (lambda (x)
                (cons x (lambda () (f (fn x arg)))))])
    (lambda () (f arg))))
(define nats2  (stream-maker + 1))
(define powers2 (stream-maker * 2))

;; code that uses streams

(define (number-until stream tester)
  (letrec ([f (lambda (stream ans)
                (let ([pr (stream)])
                  (if (tester (car pr))
                      ans
                      (f (cdr pr) (+ ans 1)))))])
    (f stream 1)))

(define four (number-until powers-of-two (lambda (x) (= x 16))))
