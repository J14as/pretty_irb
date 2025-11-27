# Pretty IRB - AI Helper Features

## 🤖 AI Help Commands

Pretty IRB now includes built-in AI-powered help features to make learning Ruby easier!

### Overview

Instead of searching the web or documentation, use these commands directly in Pretty IRB:

```ruby
?explain(method)    # Explain how a Ruby method works
?example(topic)     # Get code examples for concepts
?debug(code)        # Analyze your code for potential issues
?practices(topic)   # Learn best practices
?ref(keyword)       # Quick reference guides
```

---

## 📚 Available Commands

### 1. `?explain(method_name)` - Method Explanations

Learn how specific Ruby methods work with examples.

**Available methods:**
- `map` - Transform array elements
- `select` / `filter` - Filter array elements
- `each` - Iterate without transformation
- `reduce` / `inject` - Combine into single value
- `find` / `detect` - Find first matching element
- `merge` - Combine hashes
- `keys` / `values` - Get hash keys/values
- `gsub` / `sub` - Replace in strings
- `split` / `join` - String ↔ Array conversion

**Examples:**

```ruby
pretty_irb >> ?explain(map)
🎯 map method: Transforms each element of an array

Syntax: array.map { |item| transformation }

Example:
  [1, 2, 3].map { |x| x * 2 }
  => [2, 4, 6]

Key points:
• Returns a NEW array (doesn't modify original)
• Applies block to each element
• Commonly used for data transformation

pretty_irb >> ?explain(select)
🎯 select method: Filters array based on condition

Syntax: array.select { |item| condition }

Example:
  [1, 2, 3, 4, 5].select { |x| x > 2 }
  => [3, 4, 5]

Key points:
• Returns NEW array with matching elements
• Returns empty array if nothing matches
• Use for filtering/querying data
```

---

### 2. `?example(topic)` - Code Examples

Get code examples for learning concepts.

**Available topics:**
- `loop` - Iteration patterns
- `condition` - If/elsif/case statements
- `class` - Class definition
- `method` - Method definition
- `array` - Array operations
- `hash` - Hash operations
- `string` - String operations
- `error` - Error handling
- `block` - Blocks, procs, lambdas

**Examples:**

```ruby
pretty_irb >> ?example(class)
📚 Class Definition Example:

class Person
  attr_accessor :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def info
    "#{@name} is #{@age} years old"
  end
end

person = Person.new("Alice", 30)
puts person.info

pretty_irb >> ?example(error)
📚 Error Handling Examples:

Basic rescue:
  begin
    result = 10 / 0
  rescue ZeroDivisionError
    puts "Cannot divide by zero"
  end
  
Multiple rescue clauses:
  begin
    risky_operation
  rescue TypeError
    puts "Type error"
  rescue ArgumentError
    puts "Wrong arguments"
  end
```

---

### 3. `?debug(code)` - Code Analysis

Get suggestions for improving your code.

**What it checks:**
- Missing error handling
- Potential nil references
- Code complexity
- Risky operations

**Example:**

```ruby
pretty_irb >> ?debug("[1,2,3][0]")
📊 Code Analysis:

Complexity: Simple

⚠️  Potential Issues:
  • Missing error handling

💡 Suggestions:
  • Consider using safe navigation operator (&.) for chained calls
  • Add error handling with begin/rescue/end

pretty_irb >> ?debug("user.name.upcase")
📊 Code Analysis:

Complexity: Simple

⚠️  Potential Issues:
  • Potential nil reference

💡 Suggestions:
  • Consider using safe navigation operator (&.) for chained calls
```

---

### 4. `?practices(topic)` - Best Practices

Learn Ruby best practices and conventions.

**Available topics:**
- `naming` - Variable, method, class naming conventions
- `performance` - Performance optimization tips
- `readability` - Code readability tips
- `testing` - Testing best practices
- `security` - Security tips
- (default) - General best practices

**Examples:**

```ruby
pretty_irb >> ?practices(naming)
✨ Naming Conventions Best Practices:

Variables:
  • Use snake_case: user_name, total_price
  • Be descriptive: total_price instead of tp
  • Avoid single letters (except i, j for loops)

Methods:
  • Use snake_case: calculate_total(), user_exists?()
  • Predicates end with ?: valid?(), empty?()
  • Dangerous methods end with !: delete!(), save!()

Classes:
  • Use PascalCase: User, ShoppingCart, UserProfile
  • Nouns, not verbs

Avoid:
  ✗ Hungarian notation: strName, intAge
  ✗ Non-English: cena, utilisateur
  ✗ Misleading names: data, result, temp

pretty_irb >> ?practices(performance)
⚡ Performance Tips:

Array Operations:
  • Use each instead of map if you don't need results
  • Use find instead of select if you need first match
  • Avoid nested loops when possible

String Operations:
  • Use String#freeze for constants
  • Use single quotes for static strings
  • Avoid string concatenation in loops (use array join)
```

---

### 5. `?ref(keyword)` - Quick Reference

Get quick reference guides.

**Available references:**
- `operators` - All Ruby operators
- `symbols` - Symbols usage
- `variables` - Variable types
- `methods` - Common methods by type

**Examples:**

```ruby
pretty_irb >> ?ref(operators)
📋 Ruby Operators Reference:

Arithmetic:
  + (addition)      - (subtraction)      * (multiplication)
  / (division)      % (modulo)           ** (exponentiation)

Comparison:
  == (equal)        != (not equal)       < (less than)
  > (greater than)  <= (less than or equal)
  >= (greater than or equal)
  <=> (spaceship - comparison)

Logical:
  && (and)          || (or)              ! (not)
  and, or, not (lower precedence)

pretty_irb >> ?ref(variables)
📋 Variable Types Reference:

Local Variables:
  name = "Alice"
  # Scoped to current context

Instance Variables:
  @name = "Alice"
  # Scoped to object instance

Class Variables:
  @@count = 0
  # Shared by all instances of class

Global Variables:
  $global = "danger"
  # Avoid! Use sparingly

Constants:
  MAX_SIZE = 100
  # Should not be changed
```

---

## 🎯 Common Use Cases

### Learning a New Method

```ruby
# I want to learn about the map method
pretty_irb >> ?explain(map)

# I want to see an example of using blocks
pretty_irb >> ?example(block)
```

### Reviewing Best Practices

```ruby
# What's the best way to name variables?
pretty_irb >> ?practices(naming)

# How should I write more performant code?
pretty_irb >> ?practices(performance)
```

### Understanding Concepts

```ruby
# Show me how to handle errors
pretty_irb >> ?example(error)

# What are Ruby's operators?
pretty_irb >> ?ref(operators)
```

### Debugging Code

```ruby
# Is this risky code?
pretty_irb >> ?debug("user.profile.name.upcase")

# Does this follow best practices?
pretty_irb >> ?practices(security)
```

---

## 💡 Tips & Tricks

### Combine with Regular Code

```ruby
# Learn a method
pretty_irb >> ?explain(select)

# Try it immediately
pretty_irb >> [1, 2, 3, 4, 5].select { |x| x > 2 }
=> [3, 4, 5]

# Get more examples
pretty_irb >> ?example(array)
```

### Use for Self-Study

```ruby
# Follow a learning path:
pretty_irb >> ?example(method)       # Learn method syntax
pretty_irb >> ?explain(map)          # Learn a specific method
pretty_irb >> ?practices(readability) # Learn best practices
pretty_irb >> ?ref(operators)        # Check references
```

### Review Before Coding

```ruby
# Check best practices before starting
pretty_irb >> ?practices(naming)

# Get examples of similar code
pretty_irb >> ?example(class)

# Check for potential issues
pretty_irb >> ?debug(code_snippet)
```

---

## 🎨 Features

- ✅ **Interactive Learning** - Learn Ruby interactively
- ✅ **No Context Switching** - Stay in your REPL
- ✅ **Rich Examples** - Real code examples
- ✅ **Best Practices** - Industry-standard tips
- ✅ **Quick Reference** - Fast lookup
- ✅ **Code Analysis** - Spot potential issues
- ✅ **Beginner Friendly** - Great for learning

---

## 📖 Method Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `?explain()` | How a method works | `?explain(map)` |
| `?example()` | Code examples | `?example(class)` |
| `?debug()` | Analyze code | `?debug("code")` |
| `?practices()` | Best practices | `?practices(naming)` |
| `?ref()` | Quick reference | `?ref(operators)` |

---

## 🚀 Getting Started

1. Start Pretty IRB: `ruby bin/console`
2. Type `help` to see all commands
3. Try: `?explain(map)`
4. Learn and practice!

---

## 🤝 Feedback

Love the AI helper? Have suggestions?

- Try all the examples
- Combine with actual Ruby code
- Use for learning and reference
- Share your favorite features!

---

**Happy Learning! 🎓**
