; Programming Languages, Dan Grossman
; Section 5: Racket Introduction

; Racket:
; * mostly functional programming language
; * eroors do not occur until run-time
; * Advanced features: macros, modules, quoting/eval, continuations, contracts

; always make this the first (non-comment, non-blank) line of your file
#lang racket

; not needed here, but a workaround so we could write tests in a second file
; see getting-started-with-Racket instructions for more explanation
(provide (all-defined-out))

; basic definitions
(define s "hello") ; clare s with "hello"
