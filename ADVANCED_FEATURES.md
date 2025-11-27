# Pretty IRB - Advanced Features Guide

## 📜 History Manager

The History Manager keeps track of all commands you execute and provides powerful search and replay capabilities.

### Commands

#### View History
```ruby
history              # Show all command history
history last 5       # Show last 5 commands
history search map   # Search history for "map"
history export file.rb  # Export history to file
history clear        # Clear all history
```

### Examples

```ruby
# Execute some code
[1, 2, 3].map { |x| x * 2 }
=> [2, 4, 6]

# Search history for previous commands
history search map
# Output: Found 1 match:
#         1: [1, 2, 3].map { |x| x * 2 }
#         Time: 14:32:45

# Get last 3 commands
history last 3

# Export for reference
history export my_session.rb
```

---

## 💾 Snippet Manager

Save and reuse code snippets with tags and descriptions.

### Commands

```ruby
snippet list                           # List all saved snippets
snippet save NAME "CODE"               # Save a code snippet
snippet load NAME                      # Load and execute snippet
snippet show NAME                      # Show snippet details
snippet delete NAME                    # Delete snippet
snippet search KEYWORD                 # Search snippets by keyword
```

### Examples

```ruby
# Save a useful snippet
snippet save array_helpers "def double_array(arr); arr.map { |x| x * 2 }; end"
# Output: ✓ Snippet 'array_helpers' saved

# Load and use it later
snippet load array_helpers
# Output: 📌 Loaded snippet: array_helpers
#         def double_array(arr); arr.map { |x| x * 2 }; end
#         => :double_array

# Show all details
snippet show array_helpers
# Output: 📌 array_helpers
#         Description: 
#         Created: 2025-11-26 14:35:22 +0000
#         Tags: method, array
#         Code:
#         def double_array(arr); arr.map { |x| x * 2 }; end

# Search for snippets
snippet search array

# Delete when done
snippet delete array_helpers
```

**Features:**
- Automatic tag detection (class, method, loop, string, array, hash, error-handling)
- JSON-based storage in `~/.pretty_irb_snippets/`
- Search by name, code content, or tags
- Description support for documentation

---

## 🔍 Variable Inspector

Inspect, search, and analyze all variables in your current REPL session.

### Commands

```ruby
vars                        # List all variables
vars VARNAME                # Inspect specific variable
vars type:String            # Find all String variables
vars type:Array             # Find all Array variables
vars search:pattern         # Search variable names
vars memory                 # Memory usage report
```

### Examples

```ruby
# Create some variables
name = "Ruby"
numbers = [1, 2, 3, 4, 5]
config = {host: "localhost", port: 3000}

# List all variables
vars
# Output: 📦 Local Variables (3):
#         name: String (5 bytes)
#         = "Ruby"
#         numbers: Array (40 bytes)
#         = [1, 2, 3, 4, 5]
#         config: Hash (80 bytes)
#         = {:host=>"localhost", :port=>3000}

# Inspect specific variable
vars name
# Output: 📦 Variable: name
#         Type: String
#         Size: ~5 bytes
#         Value: "Ruby"
#         String Info:
#           Length: 4
#           Encoding: UTF-8

# Find all String variables
vars type:String
# Output: 📦 Variables of type String (1):
#           name: String (5 bytes)
#           = "Ruby"

# Memory usage
vars memory
# Output: 💾 Memory Usage:
#         Total: ~0 KB
#         name: ~5 bytes
#         numbers: ~40 bytes
#         config: ~80 bytes
```

**Features:**
- Detailed variable inspection
- Type-based filtering
- Keyword search
- Memory usage estimation
- Shows first/last for collections
- Encoding info for strings
- Even/odd detection for numbers

---

## ⚡ Benchmarker

Measure code performance and compare implementations.

### Commands

```ruby
bench CODE                  # Benchmark code (1000 iterations)
bench compare CODE1 vs CODE2  # Compare two snippets
bench memory CODE           # Profile memory allocation
```

### Examples

```ruby
# Benchmark array creation
bench "[1, 2, 3, 4, 5] * 100"
# Output: ⏱️  Benchmark Results:
#         Code: [1, 2, 3, 4, 5] * 100
#         Iterations: 1000
#         Total Time: 23.45 ms
#         Per Iteration: 23.45 µs
#         Rate: 42625 ops/sec

# Compare map vs each_with_object
bench compare "(1..100).map { |x| x * 2 }" vs "(1..100).each_with_object([]) { |x, arr| arr << x * 2 }"
# Output: ⚡ Comparison Results:
#         Iterations: 1000
#         Code 1 ((1..100).map { |x| x * 2 }):
#           Time: 34.56 ms
#         Code 2 ((1..100).each_with_object([]) { |x, ar):
#           Time: 45.67 ms
#         Winner: Code 1 is 24.5% faster

# Profile memory usage
bench memory "[1, 2, 3, 4, 5] * 1000"
# Output: 💾 Memory Profile:
#         Iterations: 100
#         Objects Allocated: 500
#         Objects Freed: 450
#         Net Objects: 50
#         Per Iteration: 0.5 objects
```

**Features:**
- Configurable iterations
- Real time measurements in milliseconds
- Per-iteration metrics
- Operations per second rate
- Comparison mode with winner calculation
- Memory profiling with GC statistics

---

## 📖 Ruby Cheat Sheet

Quick reference for Ruby syntax and methods.

### Commands

```ruby
cheat                    # Show general cheat sheet
cheat array              # Array methods cheat sheet
cheat hash               # Hash methods cheat sheet
cheat string             # String methods cheat sheet
cheat enumerable         # Enumerable methods cheat sheet
cheat file               # File I/O operations
cheat regex              # Regular expressions
cheat date               # Date & Time operations
```

### Topics Covered

**General:**
- Variables & Constants
- Conditionals (if/unless/case)
- Loops (while/until/for/each)
- Methods & Classes
- Operators
- String/Array/Hash methods

**Array Cheat Sheet:**
- Creating arrays
- Accessing elements
- Modifying arrays
- Querying arrays
- Iteration methods
- Combining arrays
- Sorting

**Hash Cheat Sheet:**
- Creating hashes
- Accessing/adding values
- Removing values
- Querying hashes
- Iteration methods
- Transforming hashes

**String Cheat Sheet:**
- Creating strings
- Interpolation
- Case methods
- Querying strings
- Extracting substrings
- Searching & replacing
- Whitespace handling
- Conversion methods
- Formatting methods

**Enumerable Cheat Sheet:**
- Iteration (each, map, select)
- Reduction (reduce)
- Checking (any?, all?, none?)
- Grouping methods
- Sorting methods
- Other utilities

**File I/O Cheat Sheet:**
- Reading files
- Writing files
- Appending
- File checking
- Path operations
- File operations

**Regex Cheat Sheet:**
- Matching patterns
- Anchors
- Character classes
- Quantifiers
- Groups
- Flags
- Common patterns

**Date & Time Cheat Sheet:**
- Getting current time
- Creating dates
- Formatting
- Extracting components
- Arithmetic
- Comparing
- Conversion

### Examples

```ruby
# Get general overview
cheat
# Shows all basic Ruby syntax

# Quick reference for arrays
cheat array
# Shows all array methods with examples

# Reference for string manipulation
cheat string
# Shows string methods and examples

# Learn about regex
cheat regex
# Patterns and matching examples
```

---

## 🎯 Integration with AI Helper

All new features work seamlessly with the AI Helper:

```ruby
# Explain a method you found in cheatsheet
?explain(map)

# Get example of array processing
?example(array)

# Debug code before benchmarking
?debug("arr.map { |x| x / 0 }")

# Learn best practices for performance
?practices(performance)

# Quick reference for operators
?ref(operators)
```

---

## 💡 Pro Tips

1. **Save Common Patterns**: Use snippets to save frequently used code blocks
2. **Compare Implementations**: Use benchmarker to find the fastest solution
3. **Track History**: Export history for reference or sharing
4. **Inspect Variables**: Use `vars` to understand your current state
5. **Learn as You Go**: Use cheatsheet as quick reference without leaving REPL

---

## 📊 Advanced Usage Examples

### Performance Optimization Workflow

```ruby
# 1. Load a snippet
snippet load expensive_algorithm

# 2. Benchmark current implementation
bench my_function([1,2,3,4,5])

# 3. Try optimized version
snippet save optimized_v1 "def fast_function(arr); arr.map { |x| x * 2 }; end"

# 4. Compare
bench compare my_function([1,2,3,4,5]) vs fast_function([1,2,3,4,5])

# 5. Analyze memory
bench memory my_function([1,2,3,4,5])

# 6. Check variables
vars memory

# 7. Export session
history export optimization_session.rb
```

### Learning Workflow

```ruby
# 1. View cheatsheet for topic
cheat array

# 2. Try code from cheatsheet
[1, 2, 3].map { |x| x * 2 }

# 3. Get detailed explanation
?explain(map)

# 4. See advanced example
?example(array)

# 5. Learn best practices
?practices(readability)

# 6. Benchmark different approaches
bench compare "[1,2,3].map { |x| x*2 }" vs "[1,2,3].collect { |x| x*2 }"

# 7. Save good patterns
snippet save array_doubling "[1,2,3].map { |x| x*2 }"
```

### Debugging Workflow

```ruby
# 1. Write code that might fail
code = "result = 10 / 0"

# 2. Analyze with AI helper
?debug(code)

# 3. Save working version
snippet save safe_division "result = 10 / 2 rescue 'Division by zero'"

# 4. Load and test
snippet load safe_division

# 5. Inspect resulting variables
vars result

# 6. View history of attempts
history search division
```

---

## 📁 File Storage

- **Snippets**: `~/.pretty_irb_snippets/` (JSON format)
- **History Exports**: Anywhere you specify

All files are human-readable for easy sharing and version control.
