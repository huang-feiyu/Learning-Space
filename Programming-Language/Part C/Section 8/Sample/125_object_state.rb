# Programming Languages, Dan Grossman
# Section 7: Object State

# nil is an Object

# alias: creating an object returns a reference to a new object
#        variables assignment creates an alias

# Access:
# * Object state is always private
# * Access to object state is controlled by public methods (getters/setters)
#
# WHY private: change class without changing clients

# Method visibility:
# * private: object itself
# * protected: class or subclasses
# * public: avaiable to all code

class D
  def foo
    @foo
  end

  # e.foo = 42
  def foo= x
    @foo = x
  end

  attr_reader :foo, :bar, ... # getters
  attr_accessor :foo, :bar, ... # setters


class A
  def m1
    @foo = 0 # instance variables/fields
  end

  def m2 x
    @foo += x
  end

  def foo
    @foo
  end

end

class B
  # uses initialize method, which is better than m1
  # initialize can take arguments too (here providing defaults)
  def initialize(f=0)
    @foo = f
  end

  def m2 x
    @foo += x
  end

  def foo
    @foo
  end

end

class C
  # we now add in a class-variable, class-constant, and class-method

  Dans_Age = 38 # class-varibal e

  def self.reset_bar # class-method
    @@bar = 0
  end

  def initialize(f=0)
    @foo = f
  end

  def m2 x
    @foo += x
    @@bar += 1 # shared by all instances
  end

  def foo
    @foo
  end

  def bar
    @@bar
  end
end

# example uses
=begin
x = A.new
y = A.new # different object than x
z = x # alias to x
x.foo # get back nil because instance variable not initialized
x.m2 3 # error because try to add with nil object
x.m1 # creates @foo in object x refers to
z.foo # remember, x and z are aliases
z.m2 3
x.foo
y.m1
y.m2 4
y.foo
x.foo

w = B.new 3
v = B.new
w.foo + v.foo

d = C.new 17
d.m2 5
e = C.new
e.m2 6
d.bar
forty = C::Dans_Age + d.bar

=end
