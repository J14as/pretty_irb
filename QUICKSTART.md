# Quick Start

## 🚀 Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
cd c:\Users\Jayesh\Music\ROR\pretty_irb
bundle install
```

### Step 2: Run Pretty IRB
```bash
ruby bin/console
# or for development
ruby exe/pretty_irb
```

### Step 3: Start Using It!
```ruby
pretty_irb >> 1 + 2
=> 3

pretty_irb >> "hello".upcase
=> "HELLO"

pretty_irb >> help  # See available commands
```

## 📚 Common Commands

| Command | Description |
|---------|-------------|
| `help` | Show available commands |
| `exit` | Quit the shell |
| `clear` | Clear the screen |
| `history` | Show command history |
| `reset` | Reset the context |

## 🎨 Features at a Glance

✨ **Beautiful Syntax Highlighting**
- Your Ruby code is automatically highlighted with vibrant colors

🔧 **Smart Auto-Correction**
- Common typos are automatically fixed
- Helpful suggestions for errors

💡 **Smart Error Messages**
- Get suggestions when you make mistakes
- Better error reporting than standard IRB

⚡ **Enhanced Readline**
- Command history with arrow keys
- Better line editing
- Tab completion

## 📖 Learn More

- See `README.md` for full documentation
- Check `EXAMPLES.md` for code examples
- Read `SETUP.md` for detailed setup instructions

## 🎯 Next Steps

1. **Explore the code**: Look at `lib/pretty_irb/` to understand how it works
2. **Run tests**: Execute `bundle exec rspec` to run tests
3. **Build the gem**: Run `gem build pretty_irb.gemspec`
4. **Customize**: Add your own auto-corrections and themes

Enjoy your Pretty IRB! 🎉
