# Introduction

[TOC]

## PL and Static Analysis

* PL: Theory, Environment, Application
    * 命令型、函数式、逻辑型
* Static Analysis: Reliability, Security, Understanding, Compiler Optimization...

## Static Analysis

Analyses a program **before** running it.

没有任何一种［完美的］途径去确切检查一个程序的正确性, 除了编译器.

Perfect = Sound AND Complete

* Sound: **包含所有**需要的信息, Overapproximate
* Complete: 所有信息都是**被包含**的, Underapproximate

* <s>Compromise soundness, false negatives: 存在漏报</s>
* Compromise completeness, false positives: 存在误报

In general, **Sound** aka. Compromise completeness, not precise.

---

* Transfer Function: <s>Abstract Function in [Software Construction](https://github.com/huang-feiyu/Learning-Space/tree/master/Software-Construction)</s>
* Control Flows
