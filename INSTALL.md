# Installation & Deployment Guide

## 🔧 Development Installation

### Prerequisites
- Ruby 2.7.0 or higher
- Bundler 2.0 or higher
- Git (optional, for version control)

### Steps

1. **Navigate to the project directory**
   ```powershell
   cd c:\Users\Jayesh\Music\ROR\pretty_irb
   ```

2. **Install dependencies**
   ```powershell
   bundle install
   ```
   This will install all gems specified in `Gemfile` including:
   - irb
   - rouge (syntax highlighting)
   - colorize (colored output)
   - did_you_mean (auto-correct)
   - reline (enhanced readline)

3. **Verify installation**
   ```powershell
   bundle list
   ```
   You should see all gems listed.

4. **Run the development console**
   ```powershell
   ruby bin/console
   ```
   Or start the executable:
   ```powershell
   ruby exe/pretty_irb
   ```

## 📦 Building the Gem

### Option 1: Build as a local gem

```powershell
cd c:\Users\Jayesh\Music\ROR\pretty_irb
gem build pretty_irb.gemspec
```

This creates `pretty_irb-0.1.0.gem`

### Option 2: Install locally from source

```powershell
gem install --local pretty_irb-0.1.0.gem
```

Then run from anywhere:
```powershell
pretty_irb
```

## 🌐 Publishing to RubyGems (Optional)

### Prerequisites
- RubyGems.org account
- Gem credentials configured

### Steps

1. **Update version in `lib/pretty_irb/version.rb`** (if needed)
   ```ruby
   VERSION = "0.2.0"
   ```

2. **Update gemspec with your information**
   Edit `pretty_irb.gemspec`:
   ```ruby
   spec.authors = ["Your Name"]
   spec.email = ["your.email@example.com"]
   spec.homepage = "https://github.com/yourusername/pretty_irb"
   ```

3. **Build the gem**
   ```powershell
   gem build pretty_irb.gemspec
   ```

4. **Push to RubyGems**
   ```powershell
   gem push pretty_irb-0.1.0.gem
   ```

5. **Verify**
   ```powershell
   gem search pretty_irb
   ```

## 🐛 Troubleshooting Installation

### Issue: `bundle install` fails with missing Rakefile

**Solution**: The Rakefile is already created. If it's missing:
```powershell
gem install rake
bundle install
```

### Issue: `irb` not found

**Solution**: Install bundled Ruby environment:
```powershell
bundle exec irb --version
```

### Issue: Colorize gem not working

**Solution**: Install manually:
```powershell
gem install colorize
bundle install
```

### Issue: Port already in use (if running server)

**Solution**: The gem doesn't use ports by default. If you customize it:
```powershell
lsof -i :3000  # Check which process uses the port
kill -9 <PID>   # Kill the process
```

## ✅ Verification Steps

After installation, verify everything works:

```powershell
# 1. Check Ruby version
ruby --version
# Expected: ruby 2.7.0 or higher

# 2. Check Bundler
bundler --version
# Expected: Bundler version 2.0 or higher

# 3. List installed gems
bundle list | grep -E "(irb|rouge|colorize|did_you_mean|reline)"
# Should show all dependencies

# 4. Run tests
bundle exec rspec
# Should show all tests passing

# 5. Test the shell
ruby bin/console
# Should start with Pretty IRB banner
```

## 🚀 First Run

```powershell
$ ruby bin/console
╔═══════════════════════════════════════════════════════════╗
║         🎨 Welcome to Pretty IRB 🎨                      ║
║                                                           ║
║  Enhanced Interactive Ruby Shell with Auto-Correct       ║
║  Type 'help' for commands or 'exit' to quit              ║
╚═══════════════════════════════════════════════════════════╝

pretty_irb >> puts "Hello, Pretty IRB!"
Hello, Pretty IRB!
=> nil

pretty_irb >> 5 + 3
=> 8

pretty_irb >> exit
Goodbye!
```

## 📚 Development Workflow

### Running Tests
```powershell
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/formatter_spec.rb

# Run with verbose output
bundle exec rspec -v

# Run with coverage
bundle exec rspec --coverage
```

### Adding Dependencies
```powershell
# Add a new gem to Gemfile
bundle add colorama

# Or manually edit Gemfile and install
bundle install
```

### Releasing a New Version
```powershell
# 1. Update version in lib/pretty_irb/version.rb
# 2. Update CHANGELOG (if you have one)
# 3. Commit changes
git add .
git commit -m "Release version 0.2.0"
git tag -a v0.2.0 -m "Version 0.2.0"

# 4. Build gem
gem build pretty_irb.gemspec

# 5. Push to RubyGems
gem push pretty_irb-0.2.0.gem
```

## 🔐 Security Notes

- Keep dependencies updated: `bundle update`
- Check for vulnerabilities: `bundle audit`
- Use `bundle lock` to lock versions
- Review dependencies before installing

## 🎯 Next Steps

1. ✅ Install the gem
2. ✅ Run `ruby bin/console`
3. ✅ Try some Ruby code
4. ✅ Read `EXAMPLES.md` for usage examples
5. ✅ Run tests: `bundle exec rspec`
6. ✅ Explore the code in `lib/pretty_irb/`

## 📞 Support

For issues or questions:
1. Check `README.md` for documentation
2. Review `EXAMPLES.md` for usage examples
3. Run `bundle exec rspec` to verify installation
4. Check `SETUP.md` for detailed setup information

---

**Installation complete! Enjoy using Pretty IRB! 🎉**
