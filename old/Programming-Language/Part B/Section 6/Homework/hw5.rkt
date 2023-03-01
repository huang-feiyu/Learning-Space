;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body)
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent)

;; Problem 1
; (a): use the given definition style
(define (racketlist->mupllist l)
  (if (null? l)
      (aunit)
      (apair (car l) (racketlist->mupllist (cdr l)))))

; (b): use the given definition style
(define (mupllist->racketlist l)
  (if (aunit? l)
      null
      (cons (apair-e1 l) (mupllist->racketlist (apair-e2 l)))))

;; Problem 2
; lookup a variable in an environment
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Following to the pdf order
; We will test eval-under-env by calling it directly even though
; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond ; evaluates to themselves
        [ (int? e) e]
        [ (closure? e) e]
        [ (aunit? e) e]
        [ (fun? e) (closure env e)]
        ; variable's value associate with env
        [ (var? e)
          (envlookup env (var-string e))]
        ; an addition
        [ (add? e)
          (let ([v1 (eval-under-env (add-e1 e) env)]
                [v2 (eval-under-env (add-e2 e) env)])
          (if (and  (int? v1)
                    (int? v2))
              (int (+ (int-num v1)
                      (int-num v2)))
              (error "MUPL addition applied to non-number")))]
        ; if e1 > e2 then e3 else e4
        [ (ifgreater? e)
          (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
                [v2 (eval-under-env (ifgreater-e2 e) env)])
          (if (and  (int? v1)
                    (int? v2))
              (if (>  (int-num v1)
                      (int-num v2))
                  (eval-under-env (ifgreater-e3 e) env)
                  (eval-under-env (ifgreater-e4 e) env))
              (error "MUPL ifgreater applied to non-number")))]
        ; a local binding (let var = e in body)
        [ (mlet? e)
          (let* ( [v (eval-under-env (mlet-e e) env)]
                  [new-env (cons (cons (mlet-var e) v) env)]) ; append the binding
          (eval-under-env (mlet-body e) new-env))]
        ; function call
        [ (call? e)
          (let ([clos (eval-under-env (call-funexp e) env)]
                [argu (eval-under-env (call-actual e) env)])
          (if (closure? clos)
              (let* ( [clos-fun (closure-fun clos)]
                      [clos-env (closure-env clos)]
                      ; fun-formal is bound to the(one) argument
                      [new-env (cons (cons (fun-formal clos-fun) argu) clos-env)] ; append the arguments
                      [new-env (if  (fun-nameopt clos-fun) ; if name is NOT #f
                                    (cons (cons (fun-nameopt clos-fun) clos) new-env) ; can be used by recursion
                                    new-env)]) ; append the function's binding
                    (eval-under-env (fun-body clos-fun) new-env))
              (error "MUPL call applied to non-closure")))]
        ; make a new pair with values
        [ (apair? e)
            (apair  (eval-under-env (apair-e1 e) env)
                    (eval-under-env (apair-e2 e) env))]
        ; get first part of a pair
        [ (fst? e)
          (let ([v (eval-under-env (fst-e e) env)])
          (if (apair? v)
              (apair-e1 v)
              (error "MUPL fst applied to non-pair")))]
        ; get second part of a pair
        [ (snd? e)
          (let ([v (eval-under-env (snd-e e) env)])
          (if (apair? v)
              (apair-e2 v)
              (error "MUPL fst applied to non-pair")))]
        ; evaluate to 1 if e is unit else 0
        [ (isaunit? e)
          (if (aunit? (eval-under-env (isaunit-e e) env)) (int 1) (int 0))]
        [#t (error (format "bad MUPL expression: ~v" e))]))


(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3
; (a)
(define (ifaunit e1 e2 e3) (ifgreater (isaunit e1) (int 0) e2 e3))

; (b)
; lstlst: list of (string, MUPL-expr)
(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (mlet (caar lstlst) (cdar lstlst) (mlet* (cdr lstlst) e2))))

; (c)
(define (ifeq e1 e2 e3 e4)
  (mlet*  (list (cons "_x" e1) (cons "_y" e2))
          (ifgreater (var "_x") (var "_y")
            e4
            (ifgreater (var "_y") (var "_x")
              e4
              e3))))

;; Problem 4
; (a)
; call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (aunit))
(define mupl-map
  (fun "map" "map-fun"
    (fun #f "lst"
      (ifaunit (var "lst")
        (aunit)
        (apair  (call (var "map-fun") (fst (var "lst")))
                (call (call (var "map") (var "map-fun")) (snd (var "lst"))))))))

; (b)
(define mupl-mapAddN
  (mlet "map" mupl-map
    (fun #f "i"
      (call (var "map") (fun #f "x"
                          (add (var "i") (var "x")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
