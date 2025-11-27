# Pretty IRB - Quick Feature Reference

## 🚀 Quick Start Commands

### History Management (Search & Replay)
```ruby
history                    # Show all commands
history search keyword     # Find past commands
history last 5            # View recent 5 commands
history export file.rb    # Save session
```

### Snippet Manager (Save Code)
```ruby
snippet save name "code"   # Store code snippet
snippet list              # Show all snippets
snippet load name         # Execute snippet
snippet search term       # Find snippets
```

### Variable Inspector (Inspect State)
```ruby
vars                      # List all variables
vars name                # Details on variable
vars type:String         # Find String variables
vars memory              # Memory usage report
```

### Benchmarker (Performance Testing)
```ruby
bench "code"             # Benchmark code
bench compare "a" vs "b" # Compare two approaches
bench memory "code"      # Memory profiling
```

### Ruby Cheat Sheet (Quick Reference)
```ruby
cheat                    # General reference
cheat array             # Array methods
cheat hash              # Hash methods
cheat string            # String methods
```

---

## 💡 Real-World Examples

### Example 1: Finding Performance Issues

```ruby
# 1. Load a function
snippet save my_func "[1,2,3].each { |x| puts x }"

# 2. Benchmark it
bench "my_func"

# 3. Try faster version
bench compare "[1,2,3].each { |x| puts x }" vs "[1,2,3].map { puts _1 }"

# 4. Check memory
bench memory "[1,2,3].each { |x| puts x }"
```

### Example 2: Learning New Methods

```ruby
# 1. View cheatsheet
cheat array

# 2. Try different methods
[1,2,3].map { |x| x * 2 }

# 3. Get explanation
?explain(map)

# 4. See best practices
?practices(performance)
```

### Example 3: Session Management

```ruby
# 1. Work on code
name = "Ruby"
scores = [95, 87, 92]

# 2. Inspect variables
vars

# 3. Search history
history search scores

# 4. Export everything
history export my_work.rb
```

---

## 📋 All New Features Matrix

| Feature | Command | Purpose |
|---------|---------|---------|
| **History** | `history` | Search & replay commands |
| **History Search** | `history search TERM` | Find past commands |
| **History Export** | `history export FILE` | Save session to file |
| **Snippet Save** | `snippet save NAME CODE` | Store code patterns |
| **Snippet List** | `snippet list` | View all saved snippets |
| **Snippet Load** | `snippet load NAME` | Execute saved snippet |
| **Variable List** | `vars` | See all variables |
| **Variable Detail** | `vars NAME` | Inspect specific var |
| **Variable Search** | `vars search:TERM` | Find variables by name |
| **Type Filter** | `vars type:String` | Find by type |
| **Memory Report** | `vars memory` | Usage breakdown |
| **Benchmark** | `bench CODE` | Performance test |
| **Compare** | `bench compare A vs B` | Performance comparison |
| **Memory Profile** | `bench memory CODE` | Memory allocation |
| **Cheat Sheet** | `cheat` | General reference |
| **Topic Reference** | `cheat TOPIC` | Topic-specific help |

---

## 🎯 Pro Tips & Tricks

### 1. Fast Learning Loop
```ruby
cheat array              # See reference
[1,2,3].select { |x| x > 1 }  # Try it
?explain(select)         # Understand it
?practices(readability)  # Learn best way
```

### 2. Performance Optimization
```ruby
snippet save original "slow_code"
bench original
# Make changes...
bench compare "slow_code" vs "new_code"
snippet save optimized "new_code"
```

### 3. Session Export
```ruby
# Work on something
x = 5
y = x * 2

# Save everything
history export work_session.rb
# Now you have all commands in a file!
```

### 4. Code Reuse
```ruby
# Save useful patterns
snippet save sum_array "arr.reduce(:+)"
snippet save double_array "arr.map { |x| x * 2 }"

# Later, just load them
snippet load sum_array
```

### 5. Memory Analysis
```ruby
# Create data
big_array = (1..10000).to_a
big_hash = big_array.each_with_index.to_h

# Analyze
vars memory
# See which takes more space
```

---

## 🔍 Troubleshooting

### Snippets not saving?
- Check `~/.pretty_irb_snippets/` directory exists
- Ensure write permissions in home directory

### History not showing?
- History only records during REPL session
- Export before exiting to save permanently

### Benchmark results vary?
- First run may be slower (optimization)
- Try multiple benchmarks for average
- Close other applications for consistent results

### Variables disappearing?
- They only exist during current session
- Use `history export` to save code
- Use `snippet save` to preserve code

---

## 📊 Feature Comparison

### vs Regular IRB
- ✅ Pretty colored output
- ✅ History search & export
- ✅ Snippet management
- ✅ Variable inspection
- ✅ Performance benchmarking
- ✅ AI learning features
- ✅ Ruby cheat sheets

### vs Python IPython
- ✅ Ruby-specific features
- ✅ Snippet management
- ✅ AI helper for learning
- ✅ Cheat sheet integration
- ✅ Benchmarking built-in

---

## 🚀 Getting Started in 5 Minutes

1. **Start Pretty IRB**
   ```bash
   pretty_irb
   ```

2. **Try a command**
   ```ruby
   [1, 2, 3].map { |x| x * 2 }
   ```

3. **View history**
   ```ruby
   history
   ```

4. **Learn about methods**
   ```ruby
   ?explain(map)
   ```

5. **Save for later**
   ```ruby
   snippet save my_snippet "[1, 2, 3].map { |x| x * 2 }"
   ```

Done! You're now using Pretty IRB's advanced features!

---

## 📚 See Also

- [README.md](README.md) - Main documentation
- [ADVANCED_FEATURES.md](ADVANCED_FEATURES.md) - Detailed feature guide
- [AI_HELP.md](AI_HELP.md) - AI Helper documentation
- [AI_QUICK_START.md](AI_QUICK_START.md) - AI learning guide
