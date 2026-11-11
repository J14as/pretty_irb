module PrettyIRB
  class AIHelper
    class << self
      # Explain a Ruby method
      def explain_method(method_name)
        case method_name.downcase
        when "map"
          explain_map
        when "select", "filter"
          explain_select
        when "each"
          explain_each
        when "reduce", "inject"
          explain_reduce
        when "find", "detect"
          explain_find
        when "merge"
          explain_merge
        when "keys", "values"
          explain_keys_values
        when "gsub", "sub"
          explain_gsub
        when "split", "join"
          explain_split_join
        else
          suggest_available_methods
        end
      end

      # Get code example for a concept
      def get_example(concept)
        case concept.downcase
        when "loop", "iteration"
          example_loops
        when "condition", "if"
          example_conditions
        when "class"
          example_class
        when "method"
          example_method
        when "array"
          example_array
        when "hash"
          example_hash
        when "string"
          example_string
        when "error", "exception"
          example_error_handling
        when "block", "proc"
          example_blocks
        else
          suggest_available_examples
        end
      end

      # Debug code snippet
      def debug_code(code_snippet)
        analysis = {
          potential_issues: [],
          suggestions: [],
          complexity: analyze_complexity(code_snippet)
        }

        # Check for common issues
        analysis[:potential_issues] << "Missing error handling" if code_snippet.include?("begin") == false && has_risky_operations(code_snippet)
        analysis[:potential_issues] << "Potential nil reference" if code_snippet.include?(".") && !code_snippet.include?("&.")
        analysis[:suggestions] << "Consider using safe navigation operator (&.) for chained calls" if code_snippet.include?(".") && !code_snippet.include?("&.")
        analysis[:suggestions] << "Add error handling with begin/rescue/end" if analysis[:potential_issues].include?("Missing error handling")

        format_analysis(analysis)
      end

      # Suggest best practices
      def best_practices(topic)
        case topic.downcase
        when "naming"
          naming_conventions
        when "performance"
          performance_tips
        when "readability"
          readability_tips
        when "testing"
          testing_tips
        when "security"
          security_tips
        else
          general_best_practices
        end
      end

      # Quick reference
      def quick_reference(keyword)
        case keyword.downcase
        when "operators"
          operators_reference
        when "symbols"
          symbols_reference
        when "variables"
          variables_reference
        when "methods"
          methods_reference
        else
          "Available references: operators, symbols, variables, methods"
        end
      end

      private

      def explain_map
        <<~EXPLANATION
          🎯 map method: Transforms each element of an array
          
          Syntax: array.map { |item| transformation }
          
          Example:
            [1, 2, 3].map { |x| x * 2 }
            => [2, 4, 6]
            
          Key points:
          • Returns a NEW array (doesn't modify original)
          • Applies block to each element
          • Commonly used for data transformation
        EXPLANATION
      end

      def explain_select
        <<~EXPLANATION
          🎯 select method: Filters array based on condition
          
          Syntax: array.select { |item| condition }
          
          Example:
            [1, 2, 3, 4, 5].select { |x| x > 2 }
            => [3, 4, 5]
            
          Key points:
          • Returns NEW array with matching elements
          • Returns empty array if nothing matches
          • Use for filtering/querying data
        EXPLANATION
      end

      def explain_each
        <<~EXPLANATION
          🎯 each method: Iterates over elements (no transformation)
          
          Syntax: array.each { |item| action }
          
          Example:
            [1, 2, 3].each { |x| puts x }
            => [1, 2, 3]
            
          Key points:
          • Returns ORIGINAL array (not transformed)
          • Use for side effects (printing, saving, etc.)
          • Better than map when you don't need new array
        EXPLANATION
      end

      def explain_reduce
        <<~EXPLANATION
          🎯 reduce method: Combines array elements into single value
          
          Syntax: array.reduce(:+) or array.reduce { |acc, item| acc + item }
          
          Example:
            [1, 2, 3, 4].reduce(:+)
            => 10
            
          Key points:
          • Accumulates value across iterations
          • Great for sum, product, or combining values
          • Can use symbol as shorthand (:+, :*, etc.)
        EXPLANATION
      end

      def explain_find
        <<~EXPLANATION
          🎯 find method: Returns first element matching condition
          
          Syntax: array.find { |item| condition }
          
          Example:
            [1, 2, 3, 4, 5].find { |x| x > 3 }
            => 4
            
          Key points:
          • Returns first match (not array!)
          • Returns nil if no match found
          • Stops searching after finding first match
        EXPLANATION
      end

      def explain_merge
        <<~EXPLANATION
          🎯 merge method: Combines hashes
          
          Syntax: hash1.merge(hash2)
          
          Example:
            {a: 1, b: 2}.merge({b: 3, c: 4})
            => {a: 1, b: 3, c: 4}
            
          Key points:
          • Returns NEW hash (doesn't modify original)
          • Later values override earlier ones
          • Use merge! to modify original hash
        EXPLANATION
      end

      def explain_keys_values
        <<~EXPLANATION
          🎯 keys & values methods: Extract hash components
          
          Syntax: hash.keys or hash.values
          
          Example:
            {name: "Ruby", age: 30}.keys
            => [:name, :age]
            
            {name: "Ruby", age: 30}.values
            => ["Ruby", 30]
            
          Key points:
          • keys returns array of all keys
          • values returns array of all values
          • Order may not be guaranteed in older Ruby versions
        EXPLANATION
      end

      def explain_gsub
        <<~EXPLANATION
          🎯 gsub method: Global string substitution (replace all)
          
          Syntax: string.gsub(pattern, replacement)
          
          Example:
            "hello world".gsub("l", "L")
            => "heLLo worLd"
            
          Key points:
          • Replaces ALL occurrences (use sub for first only)
          • Pattern can be string or regex
          • Returns new string (doesn't modify original)
        EXPLANATION
      end

      def explain_split_join
        <<~EXPLANATION
          🎯 split & join methods: String ↔ Array conversion
          
          Syntax: string.split(delimiter) / array.join(delimiter)
          
          Example:
            "a,b,c".split(",")
            => ["a", "b", "c"]
            
            ["x", "y", "z"].join("-")
            => "x-y-z"
            
          Key points:
          • split: breaks string into array
          • join: combines array into string
          • Perfect inverse operations
        EXPLANATION
      end

      def suggest_available_methods
        <<~AVAILABLE
          Available method explanations:
          🔸 map       - Transform array elements
          🔸 select    - Filter array elements
          🔸 each      - Iterate without transformation
          🔸 reduce    - Combine into single value
          🔸 find      - Find first matching element
          🔸 merge     - Combine hashes
          🔸 keys      - Get hash keys
          🔸 values    - Get hash values
          🔸 gsub      - Replace all in string
          🔸 split     - String to array
          🔸 join      - Array to string
          
          Usage: ?explain_method(name)
        AVAILABLE
      end

      def example_loops
        <<~EXAMPLES
          📚 Loops and Iteration Examples:
          
          Using each:
            [1, 2, 3].each { |x| puts x }
            
          Using times:
            5.times { |i| puts "Number \#{i}" }
            
          Using while:
            i = 0
            while i < 5
              puts i
              i += 1
            end
            
          Using for:
            for x in [1, 2, 3]
              puts x
            end
        EXAMPLES
      end

      def example_conditions
        <<~EXAMPLES
          📚 Conditional Examples:
          
          If/elsif/else:
            if age < 13
              puts "Child"
            elsif age < 18
              puts "Teen"
            else
              puts "Adult"
            end
            
          Ternary operator:
            age >= 18 ? "Adult" : "Minor"
            
          Unless:
            puts "Not admin" unless user.admin?
            
          Case/when:
            case day
            when 1
              puts "Monday"
            when 2
              puts "Tuesday"
            end
        EXAMPLES
      end

      def example_class
        <<~EXAMPLES
          📚 Class Definition Example:
          
          class Person
            attr_accessor :name, :age
            
            def initialize(name, age)
              @name = name
              @age = age
            end
            
            def info
              "#{@name} is #{@age} years old"
            end
          end
          
          person = Person.new("Alice", 30)
          puts person.info
        EXAMPLES
      end

      def example_method
        <<~EXAMPLES
          📚 Method Definition Examples:
          
          Simple method:
            def greet(name)
              "Hello, #{name}!"
            end
            
          With default parameter:
            def greet(name = "Friend")
              "Hello, #{name}!"
            end
            
          With multiple parameters:
            def add(a, b)
              a + b
            end
            
          With splat operator:
            def sum(*numbers)
              numbers.reduce(:+)
            end
        EXAMPLES
      end

      def example_array
        <<~EXAMPLES
          📚 Array Examples:
          
          Creating arrays:
            arr = [1, 2, 3]
            arr = Array.new(5, 0)  # [0, 0, 0, 0, 0]
            
          Accessing elements:
            arr[0]      # First element
            arr[-1]     # Last element
            arr[0..2]   # Range
            
          Adding elements:
            arr << 4           # Push
            arr.push(5, 6)     # Add multiple
            
          Removing elements:
            arr.pop            # Remove last
            arr.shift          # Remove first
        EXAMPLES
      end

      def example_hash
        <<~EXAMPLES
          📚 Hash Examples:
          
          Creating hashes:
            hash = {name: "Ruby", age: 30}
            hash = {"a" => 1, "b" => 2}
            
          Accessing values:
            hash[:name]     # Using symbol key
            hash["a"]       # Using string key
            
          Adding/updating:
            hash[:city] = "New York"
            
          Iterating:
            hash.each { |k, v| puts "#{k}: #{v}" }
            
          Merging:
            hash1.merge(hash2)
        EXAMPLES
      end

      def example_string
        <<~EXAMPLES
          📚 String Examples:
          
          Creating strings:
            str = "Hello"
            str = 'Single quotes'
            str = %q{Alternative syntax}
            
          String interpolation:
            name = "Ruby"
            "Hello, #{name}!"
            
          String methods:
            "hello".upcase       # "HELLO"
            "HELLO".downcase     # "hello"
            "ruby".capitalize    # "Ruby"
            "hello world".length # 11
            
          String splitting/joining:
            "a,b,c".split(",")    # ["a", "b", "c"]
            ["a", "b"].join(",")  # "a,b"
        EXAMPLES
      end

      def example_error_handling
        <<~EXAMPLES
          📚 Error Handling Examples:
          
          Basic rescue:
            begin
              result = 10 / 0
            rescue ZeroDivisionError
              puts "Cannot divide by zero"
            end
            
          Multiple rescue clauses:
            begin
              risky_operation
            rescue TypeError
              puts "Type error"
            rescue ArgumentError
              puts "Wrong arguments"
            end
            
          Ensure (always runs):
            begin
              file = File.open("data.txt")
              process(file)
            ensure
              file.close
            end
        EXAMPLES
      end

      def example_blocks
        <<~EXAMPLES
          📚 Block, Proc & Lambda Examples:
          
          Block:
            [1, 2, 3].each { |x| puts x }
            
          Proc:
            my_proc = Proc.new { |x| x * 2 }
            my_proc.call(5)  # => 10
            
          Lambda:
            my_lambda = lambda { |x| x * 2 }
            my_lambda.call(5)  # => 10
            
          Key differences:
            • Procs are more flexible
            • Lambdas check argument count
            • Both can be passed to methods
        EXAMPLES
      end

      def suggest_available_examples
        <<~AVAILABLE
          Available code examples:
          📖 loop       - Iteration patterns
          📖 condition  - If/elsif/case statements
          📖 class      - Class definition
          📖 method     - Method definition
          📖 array      - Array operations
          📖 hash       - Hash operations
          📖 string     - String operations
          📖 error      - Error handling
          📖 block      - Blocks, procs, lambdas
          
          Usage: ?example(topic)
        AVAILABLE
      end

      def analyze_complexity(code)
        case code.length
        when 0..50
          "Simple"
        when 51..200
          "Moderate"
        when 201..500
          "Complex"
        else
          "Very Complex"
        end
      end

      def has_risky_operations(code)
        risky_patterns = [
          /\[\d+\]/,        # Array indexing without check
          /\.\w+\(/,        # Method calls
          /File\./,         # File operations
          /require/         # Require statements
        ]
        risky_patterns.any? { |pattern| code.match?(pattern) }
      end

      def format_analysis(analysis)
        output = "📊 Code Analysis:\n\n"
        output += "Complexity: #{analysis[:complexity]}\n\n"
        
        if analysis[:potential_issues].any?
          output += "⚠️  Potential Issues:\n"
          analysis[:potential_issues].each { |issue| output += "  • #{issue}\n" }
          output += "\n"
        end
        
        if analysis[:suggestions].any?
          output += "💡 Suggestions:\n"
          analysis[:suggestions].each { |suggestion| output += "  • #{suggestion}\n" }
        end
        
        output
      end

      def naming_conventions
        <<~TIPS
          ✨ Naming Conventions Best Practices:
          
          Variables:
            • Use snake_case: user_name, total_price
            • Be descriptive: total_price instead of tp
            • Avoid single letters (except i, j for loops)
            
          Methods:
            • Use snake_case: calculate_total(), user_exists?()
            • Predicates end with ?: valid?(), empty?()
            • Dangerous methods end with !: delete!(), save!()
            
          Constants:
            • Use CONSTANT_NAME (all caps)
            • MAX_USERS, DEFAULT_TIMEOUT
            
          Classes:
            • Use PascalCase: User, ShoppingCart, UserProfile
            • Nouns, not verbs
            
          Avoid:
            ✗ Hungarian notation: strName, intAge
            ✗ Non-English: cena, utilisateur
            ✗ Misleading names: data, result, temp
        TIPS
      end

      def performance_tips
        <<~TIPS
          ⚡ Performance Tips:
          
          Array Operations:
            • Use each instead of map if you don't need results
            • Use find instead of select if you need first match
            • Avoid nested loops when possible
            
          String Operations:
            • Use String#freeze for constants
            • Use single quotes for static strings
            • Avoid string concatenation in loops (use array join)
            
          Hash Operations:
            • Use symbols for keys, not strings
            • Consider using frozen strings for string keys
            
          General:
            • Avoid unnecessary object creation
            • Cache expensive computations
            • Use map/select/reduce instead of manual loops
            • Consider lazy evaluation for large datasets
        TIPS
      end

      def readability_tips
        <<~TIPS
          📖 Readability Tips:
          
          Code Style:
            • Keep methods short (under 15 lines)
            • One responsibility per method
            • Clear variable names
            
          Comments:
            • Write code that's self-documenting
            • Comments explain WHY, not WHAT
            • Keep comments in sync with code
            
          Structure:
            • Group related methods
            • Alphabetize methods
            • Constants at top of file
            
          Control Flow:
            • Use guard clauses at start of methods
            • Prefer early return over nested if
            • Keep nesting level low (max 3)
        TIPS
      end

      def testing_tips
        <<~TIPS
          🧪 Testing Best Practices:
          
          Test Structure:
            • One assertion per test
            • Test happy path and edge cases
            • Use descriptive test names
            
          What to Test:
            • Public methods
            • Edge cases: nil, empty, zero
            • Error conditions
            • Boundary conditions
            
          What NOT to Test:
            • Standard library code
            • Third-party gems
            • Dependencies (use mocks)
            
          Example Structure:
            describe "User" do
              describe "#valid?" do
                it "returns true for valid user" do
                  user = User.new(name: "Alice")
                  expect(user.valid?).to be true
                end
              end
            end
        TIPS
      end

      def security_tips
        <<~TIPS
          🔒 Security Tips:
          
          Input Validation:
            • Always validate user input
            • Use whitelisting over blacklisting
            • Sanitize strings before use
            
          Data Protection:
            • Never commit secrets to repo
            • Use environment variables for config
            • Hash passwords, don't encrypt
            
          SQL/Database:
            • Use parameterized queries
            • Avoid string interpolation in queries
            • Use ORM (ActiveRecord) when possible
            
          Common Vulnerabilities:
            • SQL Injection: Use parameterized queries
            • XSS: Escape HTML output
            • CSRF: Use CSRF tokens
        TIPS
      end

      def general_best_practices
        <<~PRACTICES
          ✅ General Ruby Best Practices:
          
          Code Quality:
            • DRY: Don't Repeat Yourself
            • KISS: Keep It Simple, Stupid
            • YAGNI: You Aren't Gonna Need It
            
          Design Patterns:
            • Use composition over inheritance
            • Prefer small classes and modules
            • Follow SOLID principles
            
          Maintenance:
            • Write tests first (TDD)
            • Keep dependencies minimal
            • Document complex logic
            • Review code with teammates
        PRACTICES
      end

      def operators_reference
        <<~REFERENCE
          📋 Ruby Operators Reference:
          
          Arithmetic:
            + (addition)
            - (subtraction)
            * (multiplication)
            / (division)
            % (modulo)
            ** (exponentiation)
            
          Comparison:
            == (equal)
            != (not equal)
            < (less than)
            > (greater than)
            <= (less than or equal)
            >= (greater than or equal)
            <=> (spaceship - comparison)
            
          Logical:
            && (and)
            || (or)
            ! (not)
            and, or, not (lower precedence)
            
          Bitwise:
            & (and)
            | (or)
            ^ (xor)
            ~ (not)
            << (left shift)
            >> (right shift)
        REFERENCE
      end

      def symbols_reference
        <<~REFERENCE
          📋 Symbols Reference:
          
          Creating symbols:
            :symbol
            :"symbol with spaces"
            Symbol.new(:symbol)
            
          Characteristics:
            • Immutable
            • Lightweight (interned strings)
            • Same symbol has same object_id
            • Great for hash keys
            
          Usage:
            hash = {name: "Ruby", age: 30}
            hash[:name]  # => "Ruby"
            
          Benefits:
            • Faster than strings as keys
            • More memory efficient
            • Convention for hash keys
        REFERENCE
      end

      def variables_reference
        <<~REFERENCE
          📋 Variable Types Reference:
          
          Local Variables:
            name = "Alice"
            # Scoped to current context
            
          Instance Variables:
            @name = "Alice"
            # Scoped to object instance
            
          Class Variables:
            @@count = 0
            # Shared by all instances of class
            
          Global Variables:
            $global = "danger"
            # Avoid! Use sparingly
            
          Constants:
            MAX_SIZE = 100
            # Should not be changed
        REFERENCE
      end

      def methods_reference
        <<~REFERENCE
          📋 Common Methods Reference:
          
          String Methods:
            upcase, downcase, capitalize, length, reverse,
            split, gsub, include?, start_with?, end_with?
            
          Array Methods:
            push, pop, shift, unshift, map, select, each,
            find, reduce, sort, reverse, join, length
            
          Hash Methods:
            keys, values, each, merge, delete, has_key?,
            fetch, select, map, to_a
            
          Numeric Methods:
            abs, round, floor, ceil, even?, odd?, times,
            upto, downto
        REFERENCE
      end
    end
  end
end
