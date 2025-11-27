# Pretty IRB Examples

## Basic Examples

### Arithmetic
```ruby
pretty_irb >> 1 + 2 + 3
=> 6

pretty_irb >> 10 * 5
=> 50

pretty_irb >> 100 / 4
=> 25
```

### String Operations
```ruby
pretty_irb >> "hello world".upcase
=> "HELLO WORLD"

pretty_irb >> "Ruby".reverse
=> "ybuR"

pretty_irb >> "pretty_irb".length
=> 9
```

### Arrays
```ruby
pretty_irb >> [1, 2, 3, 4, 5].map { |x| x * 2 }
=> [2, 4, 6, 8, 10]

pretty_irb >> [1, 2, 3].sum
=> 6

pretty_irb >> ["a", "b", "c"].join("-")
=> "a-b-c"
```

### Hashes
```ruby
pretty_irb >> { name: "Ruby", version: 3.0, year: 1995 }
=> {:name=>"Ruby", :version=>3.0, :year=>1995}

pretty_irb >> { a: 1, b: 2 }.merge({ c: 3 })
=> {:a=>1, :b=>2, :c=>3}

pretty_irb >> { x: 10, y: 20 }.values
=> [10, 20]
```

### Conditionals
```ruby
pretty_irb >> if 5 > 3; "yes"; else "no"; end
=> "yes"

pretty_irb >> [1, 2, 3].all? { |x| x > 0 }
=> true
```

## Auto-Correct Examples

### Method Name Typos
```ruby
pretty_irb >> "hello".lenght
↻ Auto-corrected: "hello".length
=> 5

pretty_irb >> [1, 2, 3].sizze
↻ Auto-corrected: [1, 2, 3].size
=> 3
```

### Error Suggestions
```ruby
pretty_irb >> foo
NameError: undefined local variable or method `foo'
💡 Did you mean?: for

pretty_irb >> "hello".upcase_x
NoMethodError: undefined method `upcase_x' for "hello":String
💡 Did you mean?: upcase
```

## Pretty Output Examples

```ruby
# Strings (Light Blue)
pretty_irb >> "hello"
=> "hello"

# Numbers (Light Green)
pretty_irb >> 42
=> 42

# Booleans (Light Cyan)
pretty_irb >> true
=> true

# Nil (Light Gray)
pretty_irb >> nil
=> nil

# Arrays (Formatted)
pretty_irb >> [1, "two", 3.0]
=> [1, "two", 3.0]

# Hashes (Formatted)
pretty_irb >> { a: 1, b: 2, c: 3 }
=> {:a=>1, :b=>2, :c=>3}
```

## Advanced Examples

### Class Definition
```ruby
pretty_irb >> class Person
pretty_irb >>   attr_accessor :name, :age
pretty_irb >>   def initialize(name, age)
pretty_irb >>     @name = name
pretty_irb >>     @age = age
pretty_irb >>   end
pretty_irb >> end
=> :initialize

pretty_irb >> person = Person.new("Alice", 30)
=> #<Person:0x00007f... @name="Alice", @age=30>

pretty_irb >> person.name
=> "Alice"
```

### Method Definition
```ruby
pretty_irb >> def greet(name)
pretty_irb >>   "Hello, #{name}!"
pretty_irb >> end
=> :greet

pretty_irb >> greet("World")
=> "Hello, World!"
```

### Lambda/Proc
```ruby
pretty_irb >> double = lambda { |x| x * 2 }
=> #<Proc:0x00007f...>

pretty_irb >> double.call(5)
=> 10

pretty_irb >> [1, 2, 3].map(&double)
=> [2, 4, 6]
```

## Commands

```ruby
pretty_irb >> help
=== Pretty IRB Commands ===

exit, quit          Exit the shell
help                Show this help message
clear               Clear the screen
history             Show command history
reset               Reset the context

You can type any valid Ruby code and it will be executed!

pretty_irb >> exit
Goodbye!
```

## Tips & Tricks

1. **Multi-line input**: Just continue typing, the shell handles it
2. **Tab completion**: Use Tab to complete method and variable names
3. **History**: Use arrow keys to navigate command history
4. **Last result**: The result of the last command is automatically stored

## Syntax Highlighting

The shell automatically highlights your code with beautiful colors:
- Keywords: Light Magenta
- Classes: Light Blue
- Methods: Light Cyan
- Strings: Light Green
- Numbers: Light Yellow
- Comments: Light Black
- Operators: Light White

## Color Scheme Reference

| Output Type | Color | Hex Code |
|-------------|-------|----------|
| Strings | Light Blue | #5F87FF |
| Numbers | Light Green | #00FF00 |
| Booleans | Light Cyan | #00FFFF |
| Nil | Light Black | #808080 |
| Keywords | Light Magenta | #FF00FF |
| Classes | Light Blue | #5F87FF |
| Methods | Light Cyan | #00FFFF |
| Success | Green | #00AA00 |
| Errors | Red | #FF0000 |
| Warnings | Yellow | #FFAA00 |
