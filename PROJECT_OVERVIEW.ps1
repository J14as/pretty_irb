#!/usr/bin/env powershell

# Pretty IRB Project Structure and Overview

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      Pretty IRB - Enhanced Interactive Ruby Shell         ║" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║  A beautiful, feature-rich IRB alternative with:          ║" -ForegroundColor Cyan
Write-Host "║  ✨ Pretty Fonts & Colors                                 ║" -ForegroundColor Cyan
Write-Host "║  🔧 Auto-Correct with Smart Suggestions                  ║" -ForegroundColor Cyan
Write-Host "║  ⚡ Enhanced Readline & History                           ║" -ForegroundColor Cyan
Write-Host "║  💡 Helpful Error Messages                                ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📁 Project Structure:" -ForegroundColor Green
Write-Host @"

pretty_irb/
├── 📄 .gitignore              - Git ignore file
├── 📄 .ruby-version           - Ruby version (2.7.0+)
├── 📄 Gemfile                 - Bundle dependencies
├── 📄 Rakefile                - Build tasks (test, build)
├── 📄 LICENSE.txt             - MIT License
├── 📄 README.md               - Main documentation
├── 📄 QUICKSTART.md           - Quick start guide
├── 📄 SETUP.md                - Detailed setup guide
├── 📄 EXAMPLES.md             - Usage examples
├── 📄 pretty_irb.gemspec      - Gem specification
│
├── 📁 bin/
│   └── console                - Development console entry point
│
├── 📁 exe/
│   └── pretty_irb             - Gem executable
│
├── 📁 lib/
│   ├── pretty_irb.rb          - Main gem file & requires
│   └── pretty_irb/
│       ├── version.rb         - Version info (0.1.0)
│       ├── formatter.rb       - Output formatting & syntax highlighting
│       ├── auto_corrector.rb  - Auto-correct & suggestions
│       └── shell.rb           - Main REPL shell implementation
│
└── 📁 spec/
    ├── spec_helper.rb         - RSpec configuration
    ├── pretty_irb_spec.rb     - Main gem tests
    ├── formatter_spec.rb      - Formatter tests
    └── auto_corrector_spec.rb - Auto-corrector tests

"@ -ForegroundColor Yellow

Write-Host "🔧 Key Files Description:" -ForegroundColor Green
Write-Host @"

1. pretty_irb.rb
   - Main gem entry point
   - Requires all dependencies and modules
   - Provides PrettyIRB.start method

2. formatter.rb
   - Syntax highlighting with Rouge
   - Colorized output for different data types
   - Pretty error messages with colors

3. auto_corrector.rb
   - Auto-fixes common method name typos
   - Provides smart suggestions using did_you_mean
   - Handles NameError, NoMethodError, SyntaxError

4. shell.rb
   - Main REPL loop
   - Command processing
   - Input/output handling
   - Enhanced prompts with colors

"@ -ForegroundColor Yellow

Write-Host "📦 Dependencies:" -ForegroundColor Green
Write-Host @"

Core:
  - irb >= 1.0           - Ruby's Interactive Shell
  - reline ~> 0.3        - Enhanced readline

Formatting:
  - rouge ~> 3.26        - Syntax highlighting
  - colorize ~> 0.8      - Color output

Features:
  - did_you_mean ~> 1.5  - Error suggestions

Development:
  - rspec ~> 3.0         - Testing framework
  - rake ~> 13.0         - Build tool
  - bundler ~> 2.0       - Dependency management

"@ -ForegroundColor Yellow

Write-Host "✨ Features:" -ForegroundColor Green
Write-Host @"

1. SYNTAX HIGHLIGHTING
   - Ruby code automatically highlighted with colors
   - Keywords, classes, methods, strings all color-coded
   - Based on Rouge gem

2. AUTO-CORRECT
   - Fixes common method typos (.lenght → .length)
   - Suggests corrections for undefined variables/methods
   - Helpful error messages with hints

3. PRETTY OUTPUT
   - Strings: Light Blue
   - Numbers: Light Green
   - Booleans: Light Cyan
   - Nil: Light Gray
   - Arrays/Hashes: Formatted and colored

4. ENHANCED REPL
   - Custom colored prompts
   - Command history
   - Better line editing
   - Tab completion support

"@ -ForegroundColor Yellow

Write-Host "🚀 Quick Start:" -ForegroundColor Green
Write-Host @"

1. Install dependencies:
   bundle install

2. Run the shell:
   ruby bin/console

3. Start coding:
   pretty_irb >> 1 + 2
   => 3

   pretty_irb >> 'hello'.upcase
   => 'HELLO'

"@ -ForegroundColor Yellow

Write-Host "🧪 Testing:" -ForegroundColor Green
Write-Host @"

Run all tests:
  bundle exec rspec

Run specific test:
  bundle exec rspec spec/formatter_spec.rb

"@ -ForegroundColor Yellow

Write-Host "📝 Future Enhancements:" -ForegroundColor Green
Write-Host @"

- More auto-corrections (Rails methods, string methods)
- Multiple theme support (dark mode, light mode)
- Code snippet manager
- Plugin system
- Performance optimizations
- Integration with Rails console

"@ -ForegroundColor Yellow

Write-Host "✅ Project Status:" -ForegroundColor Green
Write-Host @"

✓ Basic REPL shell
✓ Syntax highlighting
✓ Auto-correct functionality
✓ Pretty output formatting
✓ Error suggestions
✓ Command history
✓ Test suite
✓ Complete documentation
✓ Gem structure ready for publishing

"@ -ForegroundColor Yellow

Write-Host "🎉 Ready to use! Start with:" -ForegroundColor Cyan
Write-Host "   bundle install && ruby bin/console" -ForegroundColor Cyan
