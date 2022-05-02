# Programming Languages, Dan Grossman
# Section 7: Introduction to Ruby

# Ruby:
# * Pure OOP: everything is an object
# * Class-based
# * Dynamically typed
# * Convenient reflection: Run-time inspection of objects
# * scripting language

class Hello

  def my_first_method
    puts "Hello, World!"
  end

end

x = Hello.new
x.my_first_method
