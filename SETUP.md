# Pretty IRB - Setup Guide

## 📦 Installation

### Option 1: Local Development

```bash
cd c:\Users\Jayesh\Music\ROR\pretty_irb
bundle install
```

### Option 2: Install as Gem (for production)

```bash
gem build pretty_irb.gemspec
gem install pretty_irb-0.1.0.gem
```

## 🚀 Running Pretty IRB

### Development Mode
```bash
ruby bin/console
```

### Installed as Gem
```bash
pretty_irb
```

## 📁 Project Structure

```
pretty_irb/
├── bin/
│   ├── console          # Development console
│   └── setup
├── exe/
│   └── pretty_irb       # Executable entry point
├── lib/
│   ├── pretty_irb.rb    # Main gem file
│   └── pretty_irb/
│       ├── version.rb   # Version info
│       ├── formatter.rb # Syntax highlighting & output formatting
│       ├── auto_corrector.rb  # Auto-correct functionality
│       └── shell.rb     # Main REPL shell
├── spec/
│   ├── spec_helper.rb
│   ├── pretty_irb_spec.rb
│   ├── formatter_spec.rb
│   └── auto_corrector_spec.rb
├── Gemfile              # Dependencies
├── Rakefile             # Build tasks
├── pretty_irb.gemspec   # Gem specification
├── README.md            # Documentation
└── LICENSE.txt          # MIT License
```

## ✨ Key Features

### 1. **Syntax Highlighting**
- Ruby code is automatically highlighted with beautiful colors
- Uses Rouge gem for lexing

### 2. **Auto-Correct**
- Common method name typos are fixed automatically
- `did_you_mean` provides smart suggestions for errors
- Helpful error messages with fix suggestions

### 3. **Pretty Output**
- Strings: Light Blue
- Numbers: Light Green
- Booleans: Light Cyan
- Nil: Light Black/Gray
- Arrays & Hashes: Formatted with colors

### 4. **Enhanced REPL**
- Customizable prompt
- Command history
- Better line editing with Reline
- `help` command for available commands

## 🔧 Dependencies

```ruby
irb >= 1.0              # Interactive Ruby shell base
rouge ~> 3.26           # Syntax highlighting
colorize ~> 0.8         # Colored output
did_you_mean ~> 1.5     # Auto-correct suggestions
reline ~> 0.3           # Enhanced readline
```

## 💡 Usage Examples

```ruby
# Start the shell
$ pretty_irb

pretty_irb >> 1 + 2
=> 3

pretty_irb >> "hello".upcase
=> "HELLO"

pretty_irb >> [1, 2, 3].map { |x| x * 2 }
=> [2, 4, 6]

pretty_irb >> { name: "Ruby", version: 2.7 }
=> {:name=>"Ruby", :version=>2.7}

# Commands
pretty_irb >> help        # Show available commands
pretty_irb >> exit        # Exit the shell
```

## 🧪 Running Tests

```bash
cd pretty_irb
bundle install
bundle exec rspec
```

## 📝 Development Notes

### Adding New Auto-Corrections

Edit `lib/pretty_irb/auto_corrector.rb`:

```ruby
def fix_method_names(code)
  code.gsub(/\.old_method/, ".new_method")
end
```

### Adding New Syntax Colors

Edit `lib/pretty_irb/formatter.rb`:

```ruby
def colorize_token(token_type, value)
  case token_type
  when Rouge::Token::YourToken
    value.your_color
  end
end
```

## 🐛 Troubleshooting

### Issue: Commands not found
**Solution**: Make sure the gem is properly installed:
```bash
gem list | grep pretty_irb
```

### Issue: Colors not showing
**Solution**: Try running with:
```bash
export TERM=xterm-256color
pretty_irb
```

### Issue: Auto-correct not working
**Solution**: Check that `did_you_mean` is properly installed:
```bash
gem list | grep did_you_mean
```

## 📚 Next Steps

### Future Enhancements

1. **More Auto-Corrections**
   - Common Rails methods
   - String method typos
   - Common logic errors

2. **Theme Support**
   - Dark mode
   - Light mode
   - Custom themes

3. **Enhanced Features**
   - Code search history
   - Snippet support
   - Plugin system

4. **Performance**
   - Faster startup time
   - Caching for frequently used methods
   - Lazy loading of modules

## 📜 License

MIT License - See LICENSE.txt for details

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Submit a pull request

---

For more information, see README.md or visit the GitHub repository.
