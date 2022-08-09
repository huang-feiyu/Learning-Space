# Double Dispatch

> Open-Closed Principle: Keep your APIs open for extensibility and closed for
> modification.

Double Dispatch usually appears with
[Visitor Design Pattern](https://refactoringguru.cn/design-patterns/visitor).
This blog gonna only cover Double Dispatch. But in general, somewhat explains
why there is `accept(visitor)` in every ConcreteElement Class.

Single dispatch: We just need the run-time type of receiver to distinguish
which method to choose, it is polymorphism.

Double dispatch: We need not only the run-time type of receiver, but also
the run-time type of argument to determine which method to use.

That is: We have already used polymorphism, and want to use one more argument to
use different methods.

```ruby
# hierarchy
interface Graphic is
    method draw()

class Shape implements Graphic is
    field id
    method draw()
    # ...

class Dot extends Shape is
    field x, y
    method draw()
    # ...

class Circle extends Dot is
    field radius
    method draw()
    # ...

# class Exporter
class Exporter is
    method export(s: Shape) is
        print("Export Shape")
    method export(d: Dot)
        print("Export Dot")
    method export(c: Circle)
        print("Export Circle")

# client
class App() is
    method export(shape: Shape) is
        Exporter exporter = new Exporter()
        exporter.export(shape);

app.export(new Circle()); # => "Export Shape", not "Export Circle"
```

What we want to do here is to use `Circle`, but the polymorphism method
`App.export(shape)` only knows that it is a `Shape` and only passes the `Shape`
to `Exporter`.

If we use Double Dispatch, we can know something from the method argument.
In some programming language, we do not have Double Dispatch but Visitor Pattern.

If we want to use `Graphic.accept(visitor)`, we first enter `Graphic.accept(v)`.
Compiler knows what `this` is (In our case, it is `Circle`), so we enter
`Circle.accept()`. Then we step into `Visitor.visit(Circle)`, output is "Export
Circle". That is: **We use `this` to know what exactly which `accept` is, then
visit it**.

```ruby
class Visitor is
    method visit(s: Shape) is
        print("Visit Shape")
    method visit(c: Circle)
        print("Visit Circle")

interface Graphic is
    method accept(v: Visitor)

class Shape implements Graphic is
    method accept(v: Visitor)
        # 编译器明确知道 `this` 的类型是 `Shape`。
        # 因此可以安全地调用 `visit(s: Shape)`。
        v.visit(this)

class Circle extends Shape is
    method accept(v: Visitor)
        # 编译器明确知道 `this` 的类型是 `Circle`。
        # 因此可以安全地调用 `visit(s: Circle)`。
        v.visit(this)

Visitor v = new Visitor();
Graphic g = new Circle();

# `accept` 方法是重写而不是重载的。编译器可以进行动态绑定。
# 因此在对象调用某个方法时，将执行其所属类中的 `accept`
# 方法（在本例中是 `Circle` 类）。
g.accept(v);

# => "Visit Circle"

```

```
Visitor Design Pattern - GoF

   ┌─────────┐       ┌───────────────────────┐
   │ Client  │─ ─ ─ >│        Visitor        │
   └─────────┘       ├───────────────────────┤
        │            │visitElementA(ElementA)│
                     │visitElementB(ElementB)│
        │            └───────────────────────┘
                                 ▲
        │                ┌───────┴───────┐
                         │               │
        │         ┌─────────────┐ ┌─────────────┐
                  │  VisitorA   │ │  VisitorB   │
        │         └─────────────┘ └─────────────┘
        ▼
┌───────────────┐        ┌───────────────┐
│ObjectStructure│─ ─ ─ ─>│    Element    │
├───────────────┤        ├───────────────┤
│handle(Visitor)│        │accept(Visitor)│
└───────────────┘        └───────────────┘
                                 ▲
                        ┌────────┴────────┐
                        │                 │
                ┌───────────────┐ ┌───────────────┐
                │   ElementA    │ │   ElementB    │
                ├───────────────┤ ├───────────────┤
                │accept(Visitor)│ │accept(Visitor)│
                │doA()          │ │doB()          │
                └───────────────┘ └───────────────┘
```

