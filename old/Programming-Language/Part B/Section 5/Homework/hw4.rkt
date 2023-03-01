#lang racket

(provide (all-defined-out))

;;1
; low:integer, high:integer, stride:positive integer
; return integer-list
(define (sequence low high stride)
  (if (<= low high)
    (cons low (sequence (+ low stride) high stride))
    '()))

;;2
; xs:string-list, suffix:string
; return string-list
(define (string-append-map xs suffix)
  (map (lambda (x) (string-append x suffix)) xs))

;;3
; xs:list, n:integer
; return ith element
(define (list-nth-mod xs n)
  (cond
      [(> 0 n) (error "list-nth-mod: negative number")]
      [(= 0 (length xs)) (error "list-nth-mod: empty list")]
      [#t (let  ([i (remainder n (length xs))])
                (car (list-tail xs i)))]))

;;4
; s:stream, n:integer
; return list
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([pr (s)])
      (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))

;;5
; a stream producer '(1,2,3,4,-5,6,7,8,9,-10,...)
(define funny-number-stream
  (letrec ([f (lambda (x)
              (cons (if (= (remainder x 5) 0) (- x) x)
                    (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

;;6
; a stream producer '("dan.jpg", "dog.jpg", "dan.jpg", "dog.jpg",...)
(define dan-then-dog
  (letrec ( [dan-func (lambda () (cons "dan.jpg" (lambda () (dog-func))))]
            [dog-func (lambda () (cons "dog.jpg" (lambda () (dan-func))))])
    (lambda () (dan-func))))

;;7
; s:stream
; return stream
(define (stream-add-zero s)
  (lambda ()
  (cons (cons 0 (car (s))) (stream-add-zero (cdr (s))))))

;;8
; xs:list, ys:list
; return stream
(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
              (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
                    (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

;;9
; v, vec:vector
; return vector
(define (vector-assoc v vec)
  (letrec ([f (lambda (n)
              (cond
                  [(= n (vector-length vec)) #f]
                  [(pair? (vector-ref vec n))
                    (if (equal? (car (vector-ref vec n)) v)
                      (vector-ref vec n)
                      (f (+ n 1)))]
                  [#t (f (+ n 1))]))])
    (f 0)))

;;10
; xs:list, n:integer
; return (lambda (v) (assoc v xs))
(define (cached-assoc xs n)
  (letrec ([pos 0]
          [memo (make-vector n #f)])
    (lambda (v)
      (letrec ([ans (vector-assoc v memo)])
        (if ans ans ; in cache
                (letrec ([new-ans (assoc v xs)]) ; otherwise, search in list
                        (if new-ans
                          (begin ; add into cache
                            (vector-set! memo pos new-ans)
                            (set! pos (if (= pos (- n 1)) 0 (+ pos 1)))
                            new-ans)
                          #f)))))))
