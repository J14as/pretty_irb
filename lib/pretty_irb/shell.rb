require "irb"
require "reline"

module PrettyIRB
  class Shell
    BANNER = <<~BANNER
      ╔═══════════════════════════════════════════════════════════╗
      ║         🎨 Welcome to Pretty IRB 🎨                      ║
      ║                                                           ║
      ║  Enhanced Interactive Ruby Shell with Auto-Correct       ║
      ║  Type 'help' for commands or 'exit' to quit              ║
      ╚═══════════════════════════════════════════════════════════╝
    BANNER

    def initialize(config = {})
      @config = config
      @history_manager = HistoryManager.new
      @snippet_manager = SnippetManager.new
      @variable_inspector = VariableInspector.new(TOPLEVEL_BINDING)
      @input_buffer = ""
      @binding = TOPLEVEL_BINDING
    end

    def run
      puts BANNER.light_magenta
      start_repl
    end

    private

    def start_repl
      loop do
        begin
          input = read_input
          break if input.nil? || input.downcase == "exit"

          if input.downcase == "help"
            show_help
            next
          end

          # Handle special commands
          if input.downcase == "clear"
            system("clear") || system("cls")
            next
          end

          # Handle history commands
          if input.start_with?("history")
            handle_history_command(input)
            next
          end

          # Handle snippet commands
          if input.start_with?("snippet")
            handle_snippet_command(input)
            next
          end

          # Handle variable commands
          if input.start_with?("vars")
            handle_variable_command(input)
            next
          end

          # Handle benchmark commands
          if input.start_with?("benchmark") || input.start_with?("bench")
            handle_benchmark_command(input)
            next
          end

          # Handle cheatsheet commands
          if input.start_with?("cheat")
            handle_cheatsheet_command(input)
            next
          end

          # Handle AI help commands
          if input.start_with?("?")
            handle_ai_command(input)
            next
          end

          execute_code(input)
          @history_manager.add(input)

        rescue Interrupt
          puts "\n" + Formatter.format_warning("Interrupted. Type 'exit' to quit.")
        rescue EOFError
          puts "\n" + Formatter.format_success("Goodbye!")
          break
        rescue StandardError => e
          handle_error(e)
        end
      end
    end

    def read_input
      prompt = "pretty_irb".light_magenta + " >> ".light_magenta
      input = Reline.readline(prompt, true)
      return nil if input.nil?

      # If the line appears to start a block or otherwise is incomplete,
      # collect additional lines until the code is complete.
      if incomplete_code?(input)
        buffer = input + "\n"
        while (more = Reline.readline("... ".light_magenta, true))
          break if more.nil?
          buffer += more + "\n"
          break unless incomplete_code?(buffer)
        end

        return buffer
      end

      input
    end

    # Heuristic to detect incomplete Ruby code.
    # Returns true if there are unclosed block tokens, brackets, or quotes.
    def incomplete_code?(code)
      return true if code.nil? || code.strip.empty?

      # Count block starters and 'end'
      opens = 0
      opens += code.scan(/\b(do|def|class|module|if|case|begin|for|while|until|unless)\b/).size
      closes = code.scan(/\bend\b/).size
      return true if opens > closes

      # Brackets / braces / parentheses
      return true if code.count('(') > code.count(')')
      return true if code.count('[') > code.count(']')
      return true if code.count('{') > code.count('}')

      # Unclosed quotes (simple heuristic, ignores escaped quotes)
      single_quotes = code.scan(/(?<!\\)'/).size
      double_quotes = code.scan(/(?<!\\)"/).size
      return true if single_quotes.odd? || double_quotes.odd?

      # Line continuation with trailing backslash
      return true if code.rstrip.end_with?('\\')

      false
    end

    def execute_code(code)
      # Auto-correct the code
      corrected_code = AutoCorrector.auto_correct_code(code)

      # Show if code was corrected
      if corrected_code != code
        puts Formatter.format_warning("↻ Auto-corrected: #{corrected_code}")
      end

      begin
        # Evaluate the code
        result = eval(corrected_code, @binding)

        # Display the result
        unless result.nil?
          puts Formatter.format_output(result)
        end

      rescue NameError => e
        handle_name_error(e)
      rescue NoMethodError => e
        handle_method_error(e)
      rescue SyntaxError => e
        handle_syntax_error(e)
      rescue StandardError => e
        handle_error(e)
      end
    end

    def handle_name_error(error)
      puts Formatter.format_error("NameError: #{error.message}")
      suggestions = AutoCorrector.suggest_corrections(error)
      puts suggestions if suggestions && !suggestions.empty?
    end

    def handle_method_error(error)
      puts Formatter.format_error("NoMethodError: #{error.message}")
      suggestions = AutoCorrector.suggest_corrections(error)
      puts suggestions if suggestions && !suggestions.empty?
    end

    def handle_syntax_error(error)
      puts Formatter.format_error("SyntaxError: #{error.message}")
      suggestions = AutoCorrector.suggest_corrections(error)
      puts suggestions if suggestions && !suggestions.empty?
    end

    def handle_error(error)
      puts Formatter.format_error("#{error.class}: #{error.message}")
      if error.backtrace
        puts Formatter.format_warning("Backtrace:")
        error.backtrace.first(5).each do |line|
          puts "  #{line}"
        end
      end
    end

    def show_help
      help_text = <<~HELP
        #{'=== Pretty IRB Commands ==='.light_magenta}

        exit, quit          Exit the shell
        help                Show this help message
        clear               Clear the screen

        #{'=== History Commands ==='.light_magenta}

        history                       Show all command history
        history search KEYWORD        Search history
        history last N                Show last N commands
        history export FILE           Export to file
        history clear                 Clear history

        #{'=== Snippet Commands ==='.light_magenta}

        snippet list                  List all snippets
        snippet save NAME CODE        Save code snippet
        snippet load NAME             Load and execute snippet
        snippet show NAME             Show snippet code
        snippet delete NAME           Delete snippet
        snippet search KEYWORD        Search snippets

        #{'=== Variable Commands ==='.light_magenta}

        vars                          List all variables
        vars VARNAME                  Inspect variable
        vars type:TYPE                Variables of type
        vars search:KEYWORD           Search variables
        vars memory                   Memory usage

        #{'=== Benchmark Commands ==='.light_magenta}

        bench CODE                    Benchmark code
        bench compare CODE1 vs CODE2  Compare two snippets
        bench memory CODE             Profile memory

        #{'=== Cheatsheet Commands ==='.light_magenta}

        cheat                         Show Ruby cheatsheet
        cheat TOPIC                   Cheatsheet for topic
                                      (array, hash, string, enumerable, file, regex, date)

        #{'=== AI Help Commands ==='.light_magenta}

        ?explain(method)    Explain a Ruby method
        ?example(topic)     Get code examples
        ?debug(code)        Analyze code for issues
        ?practices(topic)   Learn best practices
        ?ref(keyword)       Quick reference

        #{'You can type any valid Ruby code and it will be executed!'.light_green}
      HELP
      puts help_text
    end

    def handle_history_command(input)
      case input.downcase
      when "history"
        puts @history_manager.all
      when /^history\s+search\s+(.+)$/
        keyword = $1.strip
        puts @history_manager.search(keyword)
      when /^history\s+last\s+(\d+)$/
        n = $1.to_i
        puts @history_manager.last(n)
      when /^history\s+export\s+(.+)$/
        filename = $1.strip
        puts @history_manager.export(filename)
      when "history clear"
        puts @history_manager.clear
      else
        puts Formatter.format_warning("Usage: history | history search KEYWORD | history last N | history export FILE | history clear")
      end
    end

    def handle_snippet_command(input)
      case input.downcase
      when "snippet list"
        puts @snippet_manager.list
      when /^snippet\s+save\s+(\w+)\s+(.+)$/
        name = $1
        code = $2
        puts @snippet_manager.save(name, code)
      when /^snippet\s+load\s+(\w+)$/
        name = $1
        code = @snippet_manager.load(name)
        if code
          puts Formatter.format_success("📌 Loaded snippet: #{name}")
          puts code
          execute_code(code)
        else
          puts code
        end
      when /^snippet\s+show\s+(\w+)$/
        name = $1
        puts @snippet_manager.show(name)
      when /^snippet\s+delete\s+(\w+)$/
        name = $1
        puts @snippet_manager.delete(name)
      when /^snippet\s+search\s+(.+)$/
        keyword = $1.strip
        puts @snippet_manager.search(keyword)
      else
        puts Formatter.format_warning("Usage: snippet list | snippet save NAME CODE | snippet load NAME | snippet show NAME | snippet delete NAME | snippet search KEYWORD")
      end
    end

    def handle_variable_command(input)
      case input.downcase
      when "vars"
        puts @variable_inspector.list_variables
      when /^vars\s+(.+)$/
        var_name = $1.strip
        if var_name == "memory"
          puts @variable_inspector.memory_usage
        elsif var_name.start_with?("type:")
          type = var_name.sub("type:", "").strip
          puts @variable_inspector.by_type(type)
        elsif var_name.start_with?("search:")
          keyword = var_name.sub("search:", "").strip
          puts @variable_inspector.search(keyword)
        else
          puts @variable_inspector.inspect_var(var_name)
        end
      else
        puts Formatter.format_warning("Usage: vars | vars VARNAME | vars type:TYPE | vars search:KEYWORD | vars memory")
      end
    end

    def handle_benchmark_command(input)
      case input
      when /^bench(?:mark)?\s+(.+)$/
        code = $1
        puts Benchmarker.benchmark(code)
      when /^bench(?:mark)?\s+compare\s+(.+?)\s+vs\s+(.+)$/
        code1 = $1
        code2 = $2
        puts Benchmarker.compare(code1, code2)
      when /^bench(?:mark)?\s+memory\s+(.+)$/
        code = $1
        puts Benchmarker.profile_memory(code)
      else
        puts Formatter.format_warning("Usage: bench CODE | bench compare CODE1 vs CODE2 | bench memory CODE")
      end
    end

    def handle_cheatsheet_command(input)
      case input.downcase
      when "cheat"
        puts CheatSheet.show
      when /^cheat\s+(\w+)$/
        topic = $1
        puts CheatSheet.show(topic)
      else
        puts Formatter.format_warning("Usage: cheat | cheat TOPIC")
        puts "Topics: array, hash, string, enumerable, file, regex, date"
      end
    end

    def handle_ai_command(input)
      case input
      when /^\?explain\((.*?)\)$/
        method_name = $1.gsub(/'|"/, "")
        puts AIHelper.explain_method(method_name)
      when /^\?example\((.*?)\)$/
        topic = $1.gsub(/'|"/, "")
        puts AIHelper.get_example(topic)
      when /^\?debug\((.*)\)$/
        code_snippet = $1
        puts AIHelper.debug_code(code_snippet)
      when /^\?practices\((.*?)\)$/
        topic = $1.gsub(/'|"/, "")
        puts AIHelper.best_practices(topic)
      when /^\?ref\((.*?)\)$/
        keyword = $1.gsub(/'|"/, "")
        puts AIHelper.quick_reference(keyword)
      else
        puts Formatter.format_warning("❓ Unknown AI command. Type 'help' for available commands.")
      end
    end
  end
end
