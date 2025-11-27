module PrettyIRB
  class CheatSheet
    class << self
      # Get Ruby cheat sheet
      def show(topic = nil)
        return general_cheatsheet if topic.nil?

        case topic.downcase
        when "array"
          array_cheatsheet
        when "hash"
          hash_cheatsheet
        when "string"
          string_cheatsheet
        when "enumerable"
          enumerable_cheatsheet
        when "file"
          file_cheatsheet
        when "regex"
          regex_cheatsheet
        when "date"
          date_cheatsheet
        else
          "Unknown topic. Available: array, hash, string, enumerable, file, regex, date"
        end
      end

      private

      def general_cheatsheet
        <<~SHEET
          📋 Ruby General Cheat Sheet

          Variables & Constants:
            var = value          # Local variable
            @var = value         # Instance variable
            @@var = value        # Class variable
            $var = value         # Global variable
            CONST = value        # Constant

          Conditionals:
            if condition; code; end
            unless condition; code; end
            case var
            when value; code
            else code
            end

          Loops:
            while condition; code; end
            until condition; code; end
            for item in array; code; end
            array.each { |item| code }

          Methods:
            def method_name(args)
              code
            end

          Classes:
            class ClassName
              def initialize(args)
                @var = args
              end
            end

          Operators:
            Arithmetic: + - * / % **
            Comparison: == != < > <= >=
            Logical: && || !
            Bitwise: & | ^ ~ << >>

          String Methods:
            upcase, downcase, capitalize, length, reverse,
            split(sep), gsub(pattern, replacement), strip

          Array Methods:
            push(x), pop, shift, unshift(x), 
            map, select, reduce, sort, reverse, join, length

          Hash Methods:
            keys, values, each, merge, delete,
            has_key?, fetch, to_a

          Common Patterns:
            array.map { |x| x * 2 }      # Transform
            array.select { |x| x > 5 }   # Filter
            array.reduce(:+)              # Combine
            string.gsub(/pattern/, "sub") # Replace
            hash.each { |k, v| ... }     # Iterate
        SHEET
      end

      def array_cheatsheet
        <<~SHEET
          📚 Array Cheat Sheet

          Creating Arrays:
            arr = [1, 2, 3]
            arr = Array.new(5)
            arr = Array.new(5, 0)
            arr = (1..5).to_a

          Accessing:
            arr[0]       # First element
            arr[-1]      # Last element
            arr[1..3]    # Range
            arr.first    # First element
            arr.last     # Last element
            arr.at(2)    # Element at index

          Modifying:
            arr << 4                    # Push
            arr.push(5, 6)              # Push multiple
            arr.unshift(0)              # Add to front
            arr.pop                     # Remove last
            arr.shift                   # Remove first
            arr.delete(2)               # Delete value
            arr.delete_at(1)            # Delete at index
            arr[0] = 10                 # Replace

          Querying:
            arr.length / arr.size       # Length
            arr.empty?                  # Is empty?
            arr.include?(2)             # Contains?
            arr.index(2)                # Index of
            arr.count                   # Count

          Iteration:
            arr.each { |x| puts x }
            arr.map { |x| x * 2 }
            arr.select { |x| x > 2 }
            arr.find { |x| x > 2 }
            arr.reduce(:+)
            arr.any? { |x| x > 5 }
            arr.all? { |x| x > 0 }

          Combining:
            arr1 + arr2                 # Concatenate
            arr1 | arr2                 # Union
            arr1 & arr2                 # Intersection
            arr1 - arr2                 # Difference
            arr.flatten                 # Flatten
            arr.compact                 # Remove nils
            arr.uniq                    # Remove duplicates

          Sorting:
            arr.sort                    # Ascending
            arr.sort.reverse            # Descending
            arr.sort { |a, b| b <=> a } # Custom
        SHEET
      end

      def hash_cheatsheet
        <<~SHEET
          📚 Hash Cheat Sheet

          Creating Hashes:
            hash = {a: 1, b: 2}
            hash = {"a" => 1, "b" => 2}
            hash = Hash.new
            hash = Hash.new(0)

          Accessing:
            hash[:a]                # Get by key
            hash.fetch(:a, default) # Get with default
            hash.dig(:a, :b)        # Nested access

          Adding/Updating:
            hash[:c] = 3
            hash.store(:d, 4)
            hash.merge(other_hash)
            hash.update(other_hash)

          Removing:
            hash.delete(:a)
            hash.clear
            hash.reject { |k, v| k == :a }

          Querying:
            hash.keys
            hash.values
            hash.length / hash.size
            hash.empty?
            hash.has_key?(:a)
            hash.has_value?(1)
            hash.key?(a)
            hash.value?(1)

          Iteration:
            hash.each { |k, v| ... }
            hash.map { |k, v| ... }
            hash.select { |k, v| ... }
            hash.reject { |k, v| ... }

          Transforming:
            hash.invert                 # Swap keys/values
            hash.merge(other)           # Combine
            hash.select { |k, v| ... }  # Filter
            hash.map { |k, v| ... }     # Transform
            hash.to_a                   # Convert to array

          Special Methods:
            hash.flatten                # Flatten to array
            hash.values_at(:a, :b)      # Get multiple
            hash.slice(:a, :b)          # Get subset
            hash.except(:a)             # Remove keys
        SHEET
      end

      def string_cheatsheet
        <<~SHEET
          📚 String Cheat Sheet

          Creating Strings:
            str = "double quotes"
            str = 'single quotes'
            str = %q{alternative}
            str = <<HEREDOC
            Multiple
            Lines
            HEREDOC

          Interpolation:
            "Hello #{name}"
            "Result: #{2 + 2}"

          Case Methods:
            str.upcase              # UPPERCASE
            str.downcase            # lowercase
            str.capitalize          # Capitalized
            str.swapcase            # SwAp CaSe

          Querying:
            str.length / str.size
            str.empty?
            str.include?("substring")
            str.start_with?("He")
            str.end_with?("lo")

          Extracting:
            str[0]                  # First char
            str[-1]                 # Last char
            str[0..4]               # Range
            str.chars               # Array of chars
            str.split(" ")          # Split by delimiter

          Searching/Replacing:
            str.index("substring")
            str.sub(pattern, replacement)      # Replace first
            str.gsub(pattern, replacement)     # Replace all
            str.scan(regex)         # Find all

          Whitespace:
            str.strip               # Remove leading/trailing
            str.lstrip              # Remove leading
            str.rstrip              # Remove trailing
            str.chomp               # Remove newline

          Conversion:
            str.to_i                # To integer
            str.to_f                # To float
            str.to_sym              # To symbol
            str.to_a                # To array

          Formatting:
            str.center(10)
            str.ljust(10)
            str.rjust(10)
            str.reverse
        SHEET
      end

      def enumerable_cheatsheet
        <<~SHEET
          📚 Enumerable Cheat Sheet

          Basic Iteration:
            each { |x| ... }        # Iterate all
            each_with_index { |x, i| ... }
            each_with_object(obj) { |x, o| ... }

          Transformation:
            map { |x| ... }         # Transform elements
            collect { |x| ... }     # Alias for map
            flat_map { |x| ... }    # Map then flatten

          Selection/Filtering:
            select { |x| ... }      # Keep matching
            filter { |x| ... }      # Alias for select
            reject { |x| ... }      # Remove matching
            find { |x| ... }        # First match
            find_all { |x| ... }    # All matches (select)

          Reduction:
            reduce(:+)              # Sum
            reduce(0, :+)           # Sum with default
            reduce { |acc, x| acc + x }
            inject { |acc, x| acc + x }  # Alias

          Checking:
            any? { |x| ... }        # Any match?
            all? { |x| ... }        # All match?
            none? { |x| ... }       # None match?
            one? { |x| ... }        # Exactly one?

          Grouping:
            group_by { |x| ... }    # Group by key
            partition { |x| ... }   # Split into 2 groups
            chunk { |x| ... }       # Consecutive groups

          Sorting:
            sort                    # Ascending
            sort { |a, b| ... }     # Custom sort
            sort_by { |x| ... }     # Sort by value
            max, min                # Extreme values
            max_by, min_by          # By value

          Other:
            count                   # Count elements
            first(n)                # First n
            last(n)                 # Last n
            take(n)                 # Take first n
            drop(n)                 # Skip first n
            zip(*arrays)            # Combine arrays
            cycle(n) { |x| ... }    # Repeat n times
        SHEET
      end

      def file_cheatsheet
        <<~SHEET
          📚 File I/O Cheat Sheet

          Reading Files:
            File.read("file.txt")               # Read entire file
            File.readlines("file.txt")          # Read as array
            File.open("file.txt") { |f| ... }  # Read with block

          Writing Files:
            File.write("file.txt", content)
            File.open("file.txt", "w") do |f|
              f.write("content")
            end

          Appending:
            File.write("file.txt", content, mode: "a")
            File.open("file.txt", "a") do |f|
              f.puts("new line")
            end

          Checking:
            File.exist?("file.txt")
            File.file?("path")
            File.directory?("path")
            File.size("file.txt")

          Paths:
            File.expand_path("file.txt")
            File.dirname("path/file.txt")
            File.basename("path/file.txt")
            File.join("path", "to", "file")

          Operations:
            File.delete("file.txt")
            File.rename("old.txt", "new.txt")
            File.copy("source.txt", "dest.txt")
            Dir.mkdir("directory")
            Dir.glob("*.txt")
        SHEET
      end

      def regex_cheatsheet
        <<~SHEET
          📚 Regular Expressions Cheat Sheet

          Matching:
            /pattern/.match(string)
            /pattern/ =~ string         # Returns index or nil
            string.match(/pattern/)
            string.scan(/pattern/)      # Find all

          Anchors:
            ^           # Start of line
            $           # End of line
            \\A          # Start of string
            \\Z          # End of string
            \\b          # Word boundary

          Character Classes:
            [abc]       # a, b, or c
            [^abc]      # Not a, b, or c
            [a-z]       # a to z
            .           # Any character
            \\d          # Digit [0-9]
            \\w          # Word [a-zA-Z0-9_]
            \\s          # Whitespace

          Quantifiers:
            *           # 0 or more
            +           # 1 or more
            ?           # 0 or 1
            {n}         # Exactly n
            {n,}        # n or more
            {n,m}       # n to m

          Groups:
            (pattern)   # Capture group
            (?:...)     # Non-capture
            \\1, \\2     # Backreference

          Flags:
            /pattern/i  # Case insensitive
            /pattern/m  # Multiline
            /pattern/x  # Extended

          Common Patterns:
            /\\d+/              # One or more digits
            /\\w+@\\w+\\.\\w+/   # Email-ish
            /^\\d{3}-\\d{4}$/    # Phone number-ish
            /https?:\\/\\/.+/    # URL-ish
        SHEET
      end

      def date_cheatsheet
        <<~SHEET
          📚 Date & Time Cheat Sheet

          Current Time:
            Time.now                # Current time
            Date.today              # Current date
            DateTime.now            # Current datetime

          Creating:
            Time.new(2025, 11, 26)
            Date.new(2025, 11, 26)
            DateTime.parse("2025-11-26")
            Time.parse("2025-11-26 10:30:00")

          Formatting:
            time.strftime("%Y-%m-%d")
            time.strftime("%H:%M:%S")
            time.to_s
            date.to_s

          Extracting:
            time.year
            time.month
            time.day
            time.hour
            time.min
            time.sec
            time.wday    # Day of week (0=Sunday)

          Arithmetic:
            time + 3600             # Add seconds
            time - 86400            # Subtract seconds
            date + 1                # Add days
            date - 1                # Subtract days

          Comparing:
            time1 < time2
            time1 > time2
            time1 == time2

          Ranges:
            (start_date..end_date).each { |d| ... }

          Conversion:
            time.to_date
            time.to_i               # Unix timestamp
            Time.at(timestamp)      # From timestamp
        SHEET
      end
    end
  end
end
