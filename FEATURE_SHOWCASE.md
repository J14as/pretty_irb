# 🎨 Pretty IRB - Complete Feature Showcase

## What's Included

Pretty IRB is a **powerful, feature-rich Ruby REPL** that transforms your interactive Ruby experience with 10+ advanced features.

---

## 📦 Features Overview

### 1️⃣ **Beautiful Output Formatting**
Automatically colorize and format all Ruby objects for beautiful display:
- **Strings** → Blue
- **Numbers** → Green  
- **Booleans** → Cyan
- **Nil** → Gray
- **Arrays/Hashes** → Formatted with indentation

```ruby
pretty_irb >> {name: "Ruby", version: 3.0}
=> {:name=>"Ruby", :version=>3.0}
   # Displays in colorized format
```

### 2️⃣ **Auto-Correct & Smart Suggestions**
Never lose time to typos - Pretty IRB automatically corrects common mistakes:
- `.lenght` → `.length` ✅
- `.sizze` → `.size` ✅
- Missing method suggestions
- Variable name recommendations

```ruby
pretty_irb >> "hello".lenght
# Auto-corrected to: "hello".length
=> 5
```

### 3️⃣ **AI Learning Helper** 🤖
Learn Ruby without leaving your REPL:

```ruby
?explain(map)           # Understand any method
?example(array)         # See code examples
?debug(code)            # Analyze for issues
?practices(naming)      # Learn conventions
?ref(operators)         # Quick syntax lookup
```

### 4️⃣ **History Manager** 📜
Track, search, and replay all commands:

```ruby
history                    # View all
history search map        # Find commands
history last 10           # Recent 10
history export work.rb    # Save session
history clear            # Start fresh
```

**Features:**
- Full command history with timestamps
- Powerful search capabilities
- Export sessions for reference/sharing
- Clear history when needed

### 5️⃣ **Snippet Manager** 💾
Save and reuse code patterns instantly:

```ruby
snippet save double_arr "[1,2,3].map { |x| x*2 }"
snippet load double_arr
snippet list            # View all
snippet show double_arr # Show details
snippet delete double_arr
snippet search array   # Find snippets
```

**Features:**
- JSON-based persistent storage
- Auto-tagging (class, method, array, hash, etc.)
- Searchable by name, content, or tags
- Description support
- Stored in `~/.pretty_irb_snippets/`

### 6️⃣ **Variable Inspector** 🔍
Understand your current REPL state:

```ruby
vars                    # List all variables
vars myvar             # Inspect specific
vars type:String       # Find by type
vars search:pattern    # Search names
vars memory            # Memory breakdown
```

**Features:**
- Detailed variable info (type, size, value)
- Type-based filtering
- Memory usage estimation
- Shows encoding for strings
- Special handling for collections

### 7️⃣ **Benchmarker** ⚡
Measure performance right in your REPL:

```ruby
bench "[1,2,3]*1000"
bench compare "[1,2,3].map" vs "[1,2,3].each"
bench memory "[1]*10000"
```

**Features:**
- Configurable iterations
- Real-time millisecond measurements
- Per-iteration metrics
- Operations per second rate
- Comparison mode with winner calculation
- Memory profiling with GC stats

### 8️⃣ **Ruby Cheat Sheet** 📖
Quick reference without leaving REPL:

```ruby
cheat              # General overview
cheat array       # Array methods
cheat hash        # Hash methods  
cheat string      # String methods
cheat enumerable  # Enumerable methods
cheat file        # File I/O
cheat regex       # Regular expressions
cheat date        # Date & Time
```

**Covers:**
- Method syntax & usage
- Common patterns
- Best practices
- Examples & variations

### 9️⃣ **Enhanced Error Messages**
Smart error handling with corrections:

```ruby
NameError: undefined local variable or method `foo'
💡 Suggestions: 'For', 'for', 'foo'
```

### 🔟 **Enhanced Readline**
Better line editing:
- History navigation
- Line editing capabilities
- Multi-line support
- Auto-completion ready

---

## 🎯 Real-World Workflows

### Workflow 1: Performance Optimization

```ruby
# 1. Load your function
snippet save expensive_func "result = heavy_computation"

# 2. Benchmark current version
bench expensive_func

# 3. Try optimized version
# ... write optimized code ...

# 4. Compare
bench compare "heavy_computation" vs "optimized_computation"

# 5. Check memory impact
bench memory "optimized_computation"

# 6. Save optimized version
snippet save optimized_func "result = optimized_computation"

# 7. Export everything
history export optimization_session.rb
```

### Workflow 2: Learning Ruby

```ruby
# 1. View reference
cheat array

# 2. Try methods from cheatsheet
[1, 2, 3].select { |x| x > 1 }

# 3. Get detailed explanation
?explain(select)

# 4. See real examples
?example(enumerable)

# 5. Learn best practices
?practices(readability)

# 6. Save patterns you like
snippet save select_example "[1,2,3].select { |x| x > 1 }"

# 7. Build your knowledge base
history export learning_session.rb
```

### Workflow 3: Debugging Session

```ruby
# 1. Define variables
user = {name: "Alice", age: 30}

# 2. Inspect state
vars

# 3. Try different approaches
user[:name].upcase

# 4. Analyze code
?debug("user[:name].upcase")

# 5. Track what works
history search upcase

# 6. Save working solutions
snippet save user_greeting "puts \"Hello #{user[:name].upcase}!\""

# 7. Review session
history export debug_session.rb
```

### Workflow 4: Code Snippet Library

```ruby
# Save common patterns
snippet save sum_array "arr.reduce(:+)"
snippet save group_by_type "arr.group_by { |x| x.class }"
snippet save flatten_hash "hash.values.flatten"

# Later, quickly load them
snippet load sum_array

# Search when you remember part of it
snippet search flatten

# Share with team
history export my_snippets.rb
```

---

## 🚀 Installation & Setup

```bash
# Install gem
gem install pretty_irb

# Or add to Gemfile
echo "gem 'pretty_irb'" >> Gemfile
bundle install

# Run
pretty_irb
```

---

## 📊 Command Reference Matrix

| Category | Command | What It Does |
|----------|---------|-------------|
| **Core** | `exit` | Leave REPL |
| | `help` | Show all commands |
| | `clear` | Clear screen |
| **History** | `history` | Show all commands |
| | `history search TERM` | Find commands |
| | `history last N` | Recent N commands |
| | `history export FILE` | Save to file |
| | `history clear` | Clear history |
| **Snippets** | `snippet list` | Show all snippets |
| | `snippet save NAME CODE` | Store code |
| | `snippet load NAME` | Run snippet |
| | `snippet show NAME` | View snippet |
| | `snippet delete NAME` | Remove snippet |
| | `snippet search TERM` | Find snippets |
| **Variables** | `vars` | List all vars |
| | `vars NAME` | Inspect var |
| | `vars type:TYPE` | Vars of type |
| | `vars search:TERM` | Find vars |
| | `vars memory` | Memory report |
| **Performance** | `bench CODE` | Benchmark code |
| | `bench compare A vs B` | Compare two |
| | `bench memory CODE` | Memory test |
| **Reference** | `cheat` | Show reference |
| | `cheat TOPIC` | Topic help |
| **Learning** | `?explain(method)` | Explain method |
| | `?example(topic)` | Code examples |
| | `?debug(code)` | Analyze code |
| | `?practices(topic)` | Best practices |
| | `?ref(keyword)` | Quick lookup |

---

## 💡 Pro Tips

### Tip 1: Build Your Snippet Library
```ruby
# Over time, save useful patterns
snippet save each_with_index "arr.each_with_index { |x, i| puts i, x }"
snippet save hash_select "hash.select { |k, v| v > 0 }"
snippet save safe_division "a / b rescue 'Division error'"
```

### Tip 2: Performance-Driven Development
```ruby
# Always benchmark before/after optimizations
bench "original_approach"
# ... make changes ...
bench compare "original_approach" vs "new_approach"
```

### Tip 3: Learn in Context
```ruby
# Use cheatsheet → try code → get explanation
cheat string
"hello".chars.reverse.join
?explain(chars)
?explain(reverse)
```

### Tip 4: Export Sessions
```ruby
# Save successful sessions for reference
history export successful_implementation.rb
# Later: cat successful_implementation.rb
```

### Tip 5: Type Exploration
```ruby
# Create test data
strings = ["a", "b", "c"]
numbers = [1, 2, 3]
hashes = [{x: 1}, {y: 2}]

# Explore by type
vars type:String
vars type:Array
vars memory  # See what takes space
```

---

## 🎓 Learning Resources

### Included Documentation
1. **README.md** - Main features overview
2. **ADVANCED_FEATURES.md** - Detailed feature guide (800+ lines)
3. **AI_HELP.md** - AI learning features
4. **AI_QUICK_START.md** - Quick AI examples
5. **QUICK_REFERENCE.md** - Fast lookup
6. **FEATURE_SHOWCASE.md** - This file!

### Quick Start Path
1. Run `pretty_irb`
2. Type `help` to see all commands
3. Try `cheat` for Ruby reference
4. Try `?explain(map)` to learn
5. Type `snippet save` to store code
6. Type `history` to see your work

---

## 🔧 Technical Details

### Storage Locations
- **Snippets**: `~/.pretty_irb_snippets/` (JSON files)
- **History**: Only in-memory during session (export to save)
- **Config**: Can be extended via configuration

### Dependencies
- **irb** - Interactive Ruby base
- **reline** - Enhanced readline
- **colorize** - Terminal colors
- **did_you_mean** - Smart suggestions
- **rouge** - Syntax highlighting

### Ruby Compatibility
- Ruby 2.7.0+
- Works on Linux, macOS, Windows
- WSL supported

---

## 🌟 Why Pretty IRB?

### vs Regular IRB
- ✅ Way more powerful
- ✅ Better organized
- ✅ Persistent snippets
- ✅ Performance tools
- ✅ Learning features
- ✅ Beautiful output

### vs IRB Plugins  
- ✅ Integrated experience
- ✅ No complex configuration
- ✅ All features built-in
- ✅ Active development

### Ideal For
- 🎓 **Learning Ruby** - Use AI helper & cheatsheet
- 🔧 **Debugging** - Inspect variables, search history
- ⚡ **Optimization** - Benchmark & compare code
- 📚 **Reference** - Cheatsheet always available
- 💾 **Prototyping** - Save & reuse snippets

---

## 🚀 Next Steps

1. **Install**: `gem install pretty_irb`
2. **Run**: `pretty_irb`
3. **Explore**: Type `help`
4. **Learn**: Try `?explain(map)`
5. **Create**: Build your snippet library
6. **Share**: `history export my_work.rb`

---

## 📞 Support

- 📖 See ADVANCED_FEATURES.md for detailed guides
- 💬 Type `help` in Pretty IRB for command list
- 🔍 Use `history search` to find past commands
- 💾 Save sessions with `history export`

---

**Happy Ruby coding with Pretty IRB!** 🎨✨
