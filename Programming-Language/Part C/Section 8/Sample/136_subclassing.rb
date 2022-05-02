# Programming Languages, Dan Grossman
# Section 7: Subclassing

# subclassing, inheritance, overriding

# subclass: class MySubClass < MyClass
# * inherits all method definitions from superclass
# * can override methods
# * subclass is purely about what methods are defined in a class

# Why use subclass?
# * Add more methods
# * Reuse methods without copy
# * Cast above

class Point
  attr_accessor :x, :y # defines methods: x, y, x=, y=

  def initialize(x,y)
    @x = x
    @y = y
  end
  def distFromOrigin
    Math.sqrt(@x * @x  + @y * @y) # why a module method? Less OOP :-(
  end
  def distFromOrigin2
    Math.sqrt(x * x + y * y) # uses getter methods
  end

end

class ColorPoint < Point
  attr_accessor :color

  def initialize(x,y,c="clear") # or could skip this and color starts unset
    super(x,y) # keyword super calls same method in superclass
    @color = c
  end
end

# example uses with reflection
p  = Point.new(0,0)
cp = ColorPoint.new(0,0,"red")
p.class                         # Point
p.class.superclass              # Object
cp.class                        # ColorPoint
cp.class.superclass             # Point
cp.class.superclass.superclass  # Object
cp.is_a? Point                  # true
cp.instance_of? Point           # false
cp.is_a? ColorPoint             # true
cp.instance_of? ColorPoint      # true
