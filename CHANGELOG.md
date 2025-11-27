# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-27

### Added
- **Pretty Syntax Highlighting** - Beautiful colorized output using Rouge gem
- **Auto-Correct Suggestions** - Smart suggestions for common Ruby errors using `did_you_mean`
- **Pretty Formatting** - Type-aware colored output for strings, numbers, arrays, hashes, and more
- **AI Helper** - Interactive learning features:
  - `?explain(method)` - Get detailed explanations of Ruby methods
  - `?example(topic)` - View code examples for topics
  - `?debug(code)` - Analyze code for issues and improvements
  - `?practices(topic)` - Learn Ruby best practices
  - `?ref(keyword)` - Quick reference lookup
- **History Manager** - Command history features:
  - `history` - View all commands
  - `history search KEYWORD` - Search previous commands
  - `history last N` - Show last N commands
  - `history export FILE` - Export history to file
  - `history clear` - Clear history
- **Snippet Manager** - Save and reuse code patterns:
  - `snippet save NAME CODE` - Save code snippets
  - `snippet load NAME` - Execute saved snippets
  - `snippet list` - View all snippets
  - `snippet show NAME` - View snippet details
  - `snippet delete NAME` - Remove snippet
  - `snippet search KEYWORD` - Search snippets
- **Variable Inspector** - Introspect your runtime state:
  - `vars` - List all variables
  - `vars VARNAME` - Inspect specific variable
  - `vars type:TYPE` - Find variables by type
  - `vars search:KEYWORD` - Search variables
  - `vars memory` - Show memory usage
- **Benchmarker** - Performance testing and comparison:
  - `bench CODE` - Benchmark code execution
  - `bench compare CODE1 vs CODE2` - Compare two implementations
  - `bench memory CODE` - Profile memory usage
- **Ruby Cheat Sheet** - Quick reference without leaving REPL:
  - `cheat` - General cheat sheet
  - `cheat array` - Array methods and operations
  - `cheat hash` - Hash methods and operations
  - `cheat string` - String methods and operations
  - `cheat enumerable` - Enumerable and iteration methods
  - `cheat file` - File I/O operations
  - `cheat regex` - Regular expression syntax and methods
  - `cheat date` - Date and time operations
- **Enhanced Error Messages** - Color-coded errors with helpful hints
- **Multiline Input Support** - Handle code blocks, conditionals, and heredocs:
  - Automatic detection of incomplete code
  - Continuation prompts for multiline blocks
  - Support for `do...end` blocks and class/method definitions
- **`irb1` Command** - Convenient shorthand to launch Pretty IRB
- **`pretty_irb` Command** - Primary launcher for the shell

### Fixed
- Multiline input handling for incomplete code blocks and heredocs
- Dependency conflicts with `did_you_mean` gem version mismatches
- Gem file inclusion in built packages (fallback glob when git unavailable)
- Safer syntax highlighting without relying on internal Rouge token constants

### Changed
- Relaxed `did_you_mean` dependency constraint to `>= 1.5, < 3.0` for better Ruby version compatibility
- Enhanced readline integration using Reline for better line editing experience
- Improved shell startup stability across Windows, macOS, and Linux

### Technical Highlights
- Modular architecture with separate concerns:
  - `Shell` - REPL loop and command routing
  - `Formatter` - Type-aware output formatting
  - `AutoCorrector` - Error suggestion and correction
  - `AIHelper` - Interactive learning content
  - `HistoryManager` - Persistent command history
  - `SnippetManager` - Code snippet persistence
  - `VariableInspector` - Runtime introspection
  - `Benchmarker` - Performance measurement
  - `CheatSheet` - Reference content
- Cross-platform support (Windows, macOS, Linux with WSL)
- Ruby 2.7.0+ compatibility

## Future Roadmap

- Code formatting/beautification features
- Additional AI learning modules
- Performance profiling improvements
- Custom theme support
- Plugin system for extending functionality

