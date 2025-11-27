# AI Helper - Quick Start Guide

## 🤖 What is Pretty IRB's AI Helper?

Pretty IRB now includes built-in AI-powered learning features! Instead of googling or reading documentation, get instant help right in your REPL.

## ⚡ 30-Second Quick Start

```ruby
# Start Pretty IRB
ruby bin/console

# Learn a method
pretty_irb >> ?explain(map)

# Get examples
pretty_irb >> ?example(class)

# Check best practices
pretty_irb >> ?practices(naming)

# Analyze code
pretty_irb >> ?debug("risky_code")

# Quick reference
pretty_irb >> ?ref(operators)
```

## 📚 5 AI Commands

### 1. Learn Methods: `?explain(name)`

```ruby
pretty_irb >> ?explain(map)
pretty_irb >> ?explain(select)
pretty_irb >> ?explain(reduce)
pretty_irb >> ?explain(merge)
```

Available methods: map, select, each, reduce, find, merge, keys, values, gsub, split, join

### 2. Code Examples: `?example(topic)`

```ruby
pretty_irb >> ?example(class)
pretty_irb >> ?example(loop)
pretty_irb >> ?example(error)
pretty_irb >> ?example(array)
```

Available topics: class, method, array, hash, string, loop, condition, error, block

### 3. Analyze Code: `?debug(code)`

```ruby
pretty_irb >> ?debug("1/0")
pretty_irb >> ?debug("user.name.upcase")
pretty_irb >> ?debug("File.read('path')")
```

Checks for: nil references, error handling, risky operations

### 4. Best Practices: `?practices(topic)`

```ruby
pretty_irb >> ?practices(naming)
pretty_irb >> ?practices(performance)
pretty_irb >> ?practices(testing)
pretty_irb >> ?practices(security)
```

Available topics: naming, performance, readability, testing, security

### 5. Quick Reference: `?ref(keyword)`

```ruby
pretty_irb >> ?ref(operators)
pretty_irb >> ?ref(symbols)
pretty_irb >> ?ref(variables)
pretty_irb >> ?ref(methods)
```

---

## 🎯 Real-World Examples

### Learning to Use map

```ruby
# Step 1: Learn about it
pretty_irb >> ?explain(map)

# Step 2: Try it
pretty_irb >> [1, 2, 3].map { |x| x * 2 }
=> [2, 4, 6]

# Step 3: Get more examples
pretty_irb >> ?example(array)
```

### Understanding Classes

```ruby
# Step 1: See an example
pretty_irb >> ?example(class)

# Step 2: Create your own
pretty_irb >> class Person
pretty_irb >>   attr_accessor :name
pretty_irb >>   def initialize(name)
pretty_irb >>     @name = name
pretty_irb >>   end
pretty_irb >> end

# Step 3: Test it
pretty_irb >> person = Person.new("Alice")
pretty_irb >> person.name
```

### Before Writing Code

```ruby
# Step 1: Check naming conventions
pretty_irb >> ?practices(naming)

# Step 2: Check operators you'll use
pretty_irb >> ?ref(operators)

# Step 3: Get example code
pretty_irb >> ?example(method)

# Step 4: Write confident code!
```

---

## 💡 Pro Tips

### 1. Learn While Coding

```ruby
# Get confused by a method?
pretty_irb >> ?explain(method_name)

# Try immediately in same session!
pretty_irb >> [1, 2, 3].method_name { ... }
```

### 2. Reference Before Coding

```ruby
# What operators are available?
pretty_irb >> ?ref(operators)

# How should I name things?
pretty_irb >> ?practices(naming)

# What are symbols?
pretty_irb >> ?ref(symbols)
```

### 3. Debug Safely

```ruby
# Is this code risky?
pretty_irb >> ?debug("array[0].method_name")

# How should I handle errors?
pretty_irb >> ?example(error)

# What are best practices?
pretty_irb >> ?practices(security)
```

### 4. Create Learning Sequences

```ruby
# Complete learning path:
pretty_irb >> ?example(method)           # Learn syntax
pretty_irb >> ?explain(map)              # Specific method
pretty_irb >> ?example(array)            # More examples
pretty_irb >> ?practices(readability)    # Best practices
pretty_irb >> ?practices(performance)    # Performance tips
```

---

## 🎓 Topics Covered

### Methods (11 total)
map, select, each, reduce, find, merge, keys, values, gsub, split, join

### Examples (9 categories)
class, method, array, hash, string, loop, condition, error, block

### Best Practices (5 topics)
naming, performance, readability, testing, security

### References (4 types)
operators, symbols, variables, methods

---

## 🚀 Getting Started

1. **Start Pretty IRB**
   ```bash
   ruby bin/console
   ```

2. **Type help to see all commands**
   ```ruby
   pretty_irb >> help
   ```

3. **Try your first AI command**
   ```ruby
   pretty_irb >> ?explain(map)
   ```

4. **Start learning!**
   ```ruby
   pretty_irb >> [1, 2, 3].map { |x| x * 2 }
   ```

---

## 📖 Learn More

See [AI_HELP.md](AI_HELP.md) for complete documentation with all available methods, examples, and tips.

---

## ✅ Key Features

- ✅ **No Internet Needed** - All content built-in
- ✅ **Context Aware** - Stay in your REPL
- ✅ **Multiple Learning Styles** - Explanations, examples, references
- ✅ **Interactive** - Learn and practice together
- ✅ **Beginner Friendly** - Great for learning Ruby
- ✅ **Always Available** - Fast lookup

---

**Happy Learning!** 🎓

Start with: `?explain(map)` or `?example(class)`
