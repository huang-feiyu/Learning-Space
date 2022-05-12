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


## Reading 6: Specifications

> Specifications are the linchpin of teamwork.

* Behavioral equivalence: in the client's eyes, that is: two programs should behave the same under the same(specific) conditions
* Why specifications
  * to make sure the team mates are working on the same thing
  * give the freedom to change the implementation without telling clients
* Specification structure: form the *precondition* and *postcondition*
  * a method signature
  * a requires clause: additional restrictions on the parameters
  * an effects clause: return value, exceptions, and other effects
* Specifications in Java: javadoc
* `null` references: an unfortunate hole in Java
  * `@NonNull` to forbid `null` directly
  * in fp, we use `Optional<T>` to represent `null`
* Testing and specifications
  * glass box test must follow the specification
  * Testing units: A test unit is focused on just a signle spec; integration test must make sure out different methods have compatible specs
* Specifications for mutating methods: add one more line `effects`
* Exceptions
  * for signaling bugs: indicate bugs
  * for special results: imporeve the structure of the code that involves functions with special results
  * checked and unchecked exceptions: handle or not, compiler accepts or not, !runtime or not
* Exceptions in Specification
  * checked exception: `@throws` AND the method signature
  * unchecked exception: only `@throws`
  * special: `NullPointerException` will never be mentioned in a spec, it is an implicit precodition

## Reading 7: Designing Sepcifications

> 3D: deterministic, declarative, strong

Trade-off

* Deterministic vs. Undetermined: a deterministic program behave in exactly one way
* Declarative vs. Operational:
  * Declarative: just give properties of the final outcome, and no code
  * Operational: give a series of steps that the method performs
* Strong vs. Weak: Comes from predicate logic
* Designing good specifications:
  * coherent
  * result should be informative
  * strong
  * weak enough to avoid that sth is not guaranteed
  * use `abstract` types where possible
* Precondition or postcondition:
  * precondition: to demand a property(hard/expensive for a method to check) precisely
  * postcondition: it's better to **fail fast**
* Access control: keep internal things `private`; anyway use `private` when possible
* `static` or instance:
  * `static` are not associated with any object
  * `instance` are associated with objects

## Reading 8: Mutability and Immutability

* Immutability: once created, always the same value
* Mutability: once created, can be changed
  * Optimizing performance to use mutable objects
  * Convenient sharing: 2 parts of program can communicate by sharing mutable objects
* Risks of mutation: Aliasing is what makes mutable types risky
  * passing mutable values
  * returning mutable values
* Spec for mutating methods: only if explicitly say that input can be mutated, you can mutate it
* Iterating: `Interator<>().next()` is a mutator method
* Mutation and contracts
  * Mutable objects can make simple contracts very complex
  * Mutable objects reduce changeability
* Immutability
  * Optimization: sharing the unchanged object to avoid copying all
  * Useful immutable types: avoid so many pitfalls

## Reading 9: Avoiding Debugging

* make bugs impossible by design
  * static checking
  * dynamic checking
  * Immutability
  * use `final` or as many local variables as possible
* localize bugs
  * fail fast
  * defensive programming
* Assertions
  * `assert x >= 0 : "x is " + x`
  * `java -ea` to enable assertion
  * In programs and UnitTests
  * assert: argument requirements and return value requirements
  * external failures are not bugs
  * have no *side-effects*
* Incremental development: build only a bit of program at a time, and test that bit thoroughly before moving on to the next bit
* Modularity and encapsulation: access control, variable scope
  * Modularity: diving up a system into components/modules, each of which is independent and can be tested independently
  * Encapsulation: building walls around a module so that the module is responsible for its own internal bechavior

## Reading 10: Abstract Data Types

> Abstract data types: a type that is not concrete to avoid that clients making assumptions about the type's internal representation

* ADT
  * **Abstration**
  * Modularity
  * Encapsulation
  * Information hiding
  * Separation of concerns
* User-defined types
  * a type characterized by the operations you can perform on it
* Classifying types and operations
  * Creators: `t* -> T`
  * Producers: `T+, t* -> T`
  * Observers: `T+, t* -> t`
  * Mutators: `T+, t* -> void |t| T`
* ADT is defined by its opeartions
* Designing an abstract type: no domain-specific features; a few but adequate, simple and coherent operations;
* Representation independence: the use of an ADT is independent of the representation(actual data structure or data fields used to implement it) of the ADT
