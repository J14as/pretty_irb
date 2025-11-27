# Pretty IRB - Enhanced Interactive Ruby Shell

[![Gem Version](https://badge.fury.io/rb/pretty_irb.svg)](https://badge.fury.io/rb/pretty_irb)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%202.7.0-red)](https://www.ruby-lang.org/)

A beautiful, feature-rich IRB alternative with:

✨ **Pretty Fonts & Colors** - Beautiful syntax highlighting with colorized output
🔧 **Auto-Correct** - Smart suggestions for common mistakes using `did_you_mean`
🤖 **AI Helper** - Learn Ruby methods, best practices, and get code analysis
📜 **History Manager** - Search and replay command history
💾 **Snippet Manager** - Save and reuse code snippets
🔍 **Variable Inspector** - Inspect and analyze variables
⚡ **Benchmarker** - Performance testing and comparison
📖 **Ruby Cheat Sheet** - Quick reference for syntax and methods
⚡ **Enhanced Readline** - Better line editing with history support
💡 **Helpful Hints** - Smart error messages with correction suggestions

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Commands](#commands)
- [Documentation](#documentation)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your Gemfile:

```ruby
gem 'pretty_irb'
```

Or install it yourself:

```bash
gem install pretty_irb
```

## Quick Start

**Launch Pretty IRB:**
```bash
irb1
# or
pretty_irb
```

**Try some commands:**
```ruby
# Basic evaluation
1 + 2                           # => 3

# String methods
"hello".upcase                  # => "HELLO"

# Array operations
[1, 2, 3].map { |x| x * 2 }    # => [2, 4, 6]

# Get help
help                            # Show all commands

# Learn Ruby
?explain(map)                   # Explain the map method
?example(class)                 # See class examples

# Save and reuse code
snippet save double "[1,2,3].map { |x| x * 2 }"
snippet load double

# Search your history
history search "map"

# Inspect variables
vars
```

## Features

### 1. Syntax Highlighting
Code is automatically syntax-highlighted with beautiful colors using the Rouge gem.

### 2. Auto-Correct
Common Ruby errors are automatically corrected and suggestions are provided:
- Method name typos (`.lenght` → `.length`)
- Variable name suggestions using `did_you_mean`
- Helpful error messages

### 3. Pretty Output
Different data types are displayed with appropriate colors:
- Strings in blue
- Numbers in green
- Booleans in cyan
- Nil in gray
- Arrays and Hashes formatted nicely

### 4. AI Helper - Learn Ruby Interactively! 🤖

Get instant help right in your REPL:

```ruby
# Learn how a method works
pretty_irb >> ?explain(map)

# Get code examples
pretty_irb >> ?example(class)

# Learn best practices
pretty_irb >> ?practices(naming)

# Analyze your code for issues
pretty_irb >> ?debug("[1,2,3][0]")

# Quick reference
pretty_irb >> ?ref(operators)
```

See [AI_HELP.md](AI_HELP.md) for detailed documentation.

### 5. History Manager 📜

Never lose your commands again:

```ruby
# Search previous commands
pretty_irb >> history search map

# View recent history
pretty_irb >> history last 10

# Export for sharing
pretty_irb >> history export my_session.rb
```

### 6. Snippet Manager 💾

Save and reuse code patterns:

```ruby
# Save a useful snippet
pretty_irb >> snippet save double_array "[1,2,3].map { |x| x * 2 }"

# Load it later
pretty_irb >> snippet load double_array

# Search your snippets
pretty_irb >> snippet search array
```

### 7. Variable Inspector 🔍

Understand your current state:

```ruby
# List all variables
pretty_irb >> vars

# Inspect specific variable
pretty_irb >> vars name

# Find by type
pretty_irb >> vars type:String

# Memory usage
pretty_irb >> vars memory
```

### 8. Benchmarker ⚡

Measure and compare code performance:

```ruby
# Benchmark code
pretty_irb >> bench "[1,2,3] * 100"

# Compare implementations
pretty_irb >> bench compare "(1..100).map { |x| x*2 }" vs "(1..100).collect { |x| x*2 }"

# Profile memory
pretty_irb >> bench memory "[1,2,3] * 1000"
```

### 9. Ruby Cheat Sheet 📖

Quick reference without leaving REPL:

```ruby
# General overview
pretty_irb >> cheat

# Array methods
pretty_irb >> cheat array

# String methods
pretty_irb >> cheat string

# Available topics: array, hash, string, enumerable, file, regex, date
```

### 10. Enhanced Error Messages
Errors include color-coded messages and helpful hints:
```
NameError: undefined local variable or method `foo'
💡 Did you mean?: for
```

## Commands

### Basic Commands
- `exit` or `quit` - Exit the shell
- `help` - Show available commands
- `clear` - Clear the screen

### History Management
- `history` - Show all command history
- `history search KEYWORD` - Search history
- `history last N` - Show last N commands
- `history export FILE` - Export to file
- `history clear` - Clear history

### Snippet Manager
- `snippet list` - List saved snippets
- `snippet save NAME CODE` - Save code
- `snippet load NAME` - Load and execute
- `snippet show NAME` - View snippet details
- `snippet delete NAME` - Delete snippet
- `snippet search KEYWORD` - Search snippets

### Variable Inspector
- `vars` - List all variables
- `vars VARNAME` - Inspect variable
- `vars type:TYPE` - Find by type
- `vars search:KEYWORD` - Search variables
- `vars memory` - Memory usage

### Benchmarker
- `bench CODE` - Benchmark code
- `bench compare CODE1 vs CODE2` - Compare
- `bench memory CODE` - Profile memory

### Cheat Sheet
- `cheat` - Show general cheat sheet
- `cheat TOPIC` - Topic cheat sheet (array, hash, string, enumerable, file, regex, date)

### AI Helper
- `?explain(method)` - Explain a method
- `?example(topic)` - Get code examples
- `?debug(code)` - Analyze code
- `?practices(topic)` - Learn best practices
- `?ref(keyword)` - Quick reference

## Documentation

- [AI_HELP.md](AI_HELP.md) - AI Helper features and examples
- [ADVANCED_FEATURES.md](ADVANCED_FEATURES.md) - Advanced features guide with workflows
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Command quick reference
- [CHANGELOG.md](CHANGELOG.md) - Version history and changes

## Development

**Setup:**
```bash
# Clone the repo
git clone https://github.com/j14as/pretty_irb.git
cd pretty_irb

# Install dependencies
bundle install
```

**Run tests:**
```bash
rake spec
```

**Try it locally:**
```bash
bin/console
# or
ruby -I lib exe/pretty_irb
```

**Build the gem:**
```bash
gem build pretty_irb.gemspec
```

## Contributing

We welcome bug reports, feature requests, and pull requests!

### How to contribute:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code standards:
- Follow Ruby style guide (use rubocop)
- Add tests for new features
- Update documentation as needed
- Keep commits atomic and well-described

### Reporting bugs:
- Use the [GitHub Issues](https://github.com/j14as/pretty_irb/issues)
- Include Ruby version and OS details
- Provide minimal reproduction steps

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Acknowledgments

This gem is inspired by:
- **Ruby's IRB** - Interactive Ruby Shell
- **Python's IPython** - Advanced interactive computing
- **Node.js REPL** - Autocomplete and code introspection
- **Pry** - Advanced Ruby debugging and exploration

Special thanks to:
- [Rouge](https://github.com/rouge-ruby/rouge) - Syntax highlighting
- [Reline](https://github.com/ruby/reline) - Enhanced readline
- [did_you_mean](https://github.com/ruby/did_you_mean) - Smart error suggestions
- [Colorize](https://github.com/fazibear/colorize) - Terminal colors

---

**Made with ❤️ by [Jayesh](https://github.com/j14as)**

If you find Pretty IRB helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting issues
- 💡 Suggesting features
- 📝 Improving documentation
