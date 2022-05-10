# Note 1-10

[TOC]

## Reading 1: Static Checking

* Static typed language -> the use of static types is essential to building and maintaining a large software system
* Checking
  * static checking: syntax errors, type errors, and so on
  * dynamic checking: runtime errors, specific values
* Immutability: intentionally forbidding certain things from changing at runtime
* Documenting Assumptions: similar to `assert`
  * prograrms must communicate with computer and other people
* software engineering
  * Safe from bugs
  * Easy to understand
  * Ready for change

## Reading 2: Basic Java

* Snapshot diagrams
* Mutating values vs. reassigning values
* `==` vs. `equals()`
  * `==`: compares the values of primitives
  * `equals()`: compares the values of objects
* Java Collections
  * `List`
  * `Set`
  * `Map`
  * `enum`: the set of values is small and finite
  * Useful methods: `List.of()`...

## Reading 3: Testing

* Validation: to uncover problems in a program
  * Verification: constructs a formal proof that a program is correct
  * Code review: have someone review your code
  * Testing: running the program on carefully selected inputes and checking the results
* Testing is hard: Software is not like physical systems
* Test-first programming
  1. Spec
  2. Test
  3. Implement
* Systematic testing
  * Correct
  * Thorough
  * Small
* Choosing test cases by partitioning: Cartesian(Partition + Corner case)
* JUnit: `@Test`, `assertTrue()`, `assertFalse()`, `assertEquals()`
* Document
```java
public class MaxTest {
  /*
   * Testing strategy:
   *
   * partition:
   *   a < b
   *   a > b
   *   a = b
   */

  // covers a < b
  @Test
  public void testALessThanB() {
    assertEquals(2, Max.max(1, 2));
  }
  // code
}
```
* Box testing
  * Black box: choosing test cases only from the specification
  * Glass box: choossing test cases with knowledge of how the function is actually implemented
* Coverage: 100% coverage is infeasible, we normally use a tool to judge it
  * Statement coverage
  * Branch coverage
  * Path coverage
* Integration testing: test for a combination of modules
  * good unit tests will give you confidence in the correctness of individual modules, then you'll have much less searching to do to find the bug
* Automated regression testing
  * the code runs tests on a module is a *test driver*
  * running all the tests after every change is called *regression testing*
* Iterative test-first programming
  1. Write a specification for the function
  2. Write tests that exercise the spec, iterate *spec*, *tests* when find problems
  3. Write an implementation, iterate *spec* *tests* *implementation* when find bugs

**It doesn't make sense to devote enormous amounts of time making one step perfect before moving on to the next step.**


## Reading 4: Code review

> Code review is careful, systematic study of source code by people who are not the original author of the code.

* Purpose
  * improving the code
  * improving the programmer
* Style standards: [Google Java Style](https://google.github.io/styleguide/javaguide.html)

* Don't repeat yourself (DRY)
* Comments where needed: spec; use other's code; obscure code
* Failing fast: code should reveal its bugs as early as possible
* Avoid magic numbers
* One purpose for each variable: don't reuse variables
* Use good names
* Use whitespace to help the reader
* Don't use global variables
* Methods should return results, not print them
* Avoid special-case code
  * general case first, and it often works for the special case

## Reading 5: Version Control

> Version control system: essential tools of the software engineering world

* distributed VCS: all repositories are created equal, allow all sorts of different collaboration graphs

Use git, anyway.

