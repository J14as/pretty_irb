module PrettyIRB
  # Methods mixed into IRB's main object at startup.
  # Names intentionally avoid IRB's own built-in commands
  # (history, hist, help, ls, exit, quit, …) because IRB intercepts
  # those at the statement level before method dispatch.
  module IRBCommands

    # ── commands ──────────────────────────────────────────────────────────
    # Show all pretty_irb extras (use IRB's own `help` for core IRB commands)

    def commands
      ui = PrettyIRB::UI
      section = ->(title) { puts "\n  #{ui.paint(title, :white, :bold)}" }
      row     = ->(name, desc) { puts ui.table_row(ui.paint(name, :cyan), ui.paint(desc, :light_black), left_width: 40, indent: 4) }

      title = "#{ui.paint('pretty_irb', :white, :bold)} #{ui.paint("v#{PrettyIRB::VERSION}", :cyan)}"
      puts
      puts ui.box(
        ["#{ui.paint('Command Reference', :white)} #{ui.paint('· type help for built-in IRB commands', :light_black)}"],
        title: title,
        min_width: 64
      )

      section.("Snippets")
      row.("snippet",                      "list all saved snippets")
      row.("snippet(:save, 'n', 'code')",  "save a snippet")
      row.("snippet(:load, 'name')",       "load and run snippet")
      row.("snippet(:show, 'name')",       "show snippet code")
      row.("snippet(:delete, 'name')",     "delete snippet")
      row.("snippet(:search, 'keyword')",  "search snippets")

      section.("Variables")
      row.("vars",                  "list all local variables")
      row.("vars('name')",          "inspect one variable")
      row.("vars(type: 'String')",  "filter by type")
      row.("vars(search: 'kw')",    "search by name")
      row.("vars(memory: true)",    "estimate memory usage")

      section.("Benchmark")
      row.("bench('code')",                   "time code (1,000 iterations)")
      row.("bench('a', vs: 'b')",             "compare two snippets")
      row.("bench('code', memory: true)",     "GC / object allocation profile")
      row.("bench('code', iterations: 5000)", "custom iteration count")

      section.("Cheatsheet & Docs")
      row.("cheat / cheat('array')", "Ruby reference (array hash string enumerable file regex date)")
      row.("explain('method')",      "explain a Ruby method")
      row.("example('topic')",       "code examples for a topic")
      row.("practices('topic')",     "best practices for a topic")
      row.("ref('keyword')",         "quick reference lookup")

      puts
      puts "  #{ui.rule(64)}"
      built_ins = "history  ls  show_source  show_doc  help  exit"
      built_ins += "  reload!  app  helper" if defined?(Rails)
      puts "  #{ui.paint('IRB built-ins:', :light_black)} #{ui.paint(built_ins, :white)}"
      puts
      nil
    end

    # ── snippets ──────────────────────────────────────────────────────────

    def snippet(action = :list, name = nil, code = nil, description: "")
      ui  = PrettyIRB::UI
      mgr = PrettyIRB::Shell.snippet_manager
      case action.to_sym
      when :list
        puts format_panel(mgr.list)
      when :save
        puts "  #{ui.paint(mgr.save(name.to_s, code.to_s, description), :green)}"
      when :load
        src = mgr.load(name.to_s)
        if src.is_a?(String) && !src.start_with?("❌")
          puts "  #{ui.paint("loaded:", :light_black)} #{ui.paint(name.to_s, :cyan, :bold)}"
          puts PrettyIRB::Formatter.highlight_code(src)
          eval(src, IRB.CurrentContext.workspace.binding)
        else
          puts "  #{ui.paint(src, :light_red)}"
        end
      when :show
        puts PrettyIRB::Formatter.highlight_code(mgr.show(name.to_s))
      when :delete
        puts "  #{ui.paint(mgr.delete(name.to_s), :yellow)}"
      when :search
        puts format_panel(mgr.search(name.to_s))
      else
        puts "  #{ui.paint('actions: :list  :save  :load  :show  :delete  :search', :yellow)}"
      end
      nil
    end

    # ── variables ─────────────────────────────────────────────────────────

    def vars(name = nil, type: nil, search: nil, memory: false)
      inspector = PrettyIRB::VariableInspector.new(IRB.CurrentContext.workspace.binding)
      output = if    memory then inspector.memory_usage
               elsif type   then inspector.by_type(type.to_s)
               elsif search then inspector.search(search.to_s)
               elsif name   then inspector.inspect_var(name.to_s)
               else              inspector.list_variables
               end
      puts format_panel(output)
      nil
    end

    # ── benchmark ─────────────────────────────────────────────────────────

    def bench(code, vs: nil, memory: false, iterations: 1000)
      b = IRB.CurrentContext.workspace.binding
      output = if    memory then PrettyIRB::Benchmarker.profile_memory(code.to_s, iterations, b)
               elsif vs     then PrettyIRB::Benchmarker.compare(code.to_s, vs.to_s, iterations, b)
               else              PrettyIRB::Benchmarker.benchmark(code.to_s, iterations, b)
               end
      puts format_panel(output)
      nil
    end

    # ── cheatsheet ────────────────────────────────────────────────────────

    def cheat(topic = nil)
      puts format_panel(PrettyIRB::CheatSheet.show(topic))
      nil
    end

    # ── docs ──────────────────────────────────────────────────────────────

    def explain(method_name)
      puts format_panel(PrettyIRB::AIHelper.explain_method(method_name.to_s))
      nil
    end

    def example(topic)
      puts format_panel(PrettyIRB::AIHelper.get_example(topic.to_s))
      nil
    end

    def practices(topic)
      puts format_panel(PrettyIRB::AIHelper.best_practices(topic.to_s))
      nil
    end

    def ref(keyword)
      puts format_panel(PrettyIRB::AIHelper.quick_reference(keyword.to_s))
      nil
    end

    private

    def format_panel(text)
      lines = text.to_s.lines.map(&:rstrip)
      return "" if lines.empty?

      ui = PrettyIRB::UI
      header = ui.paint(lines.first, :cyan, :bold)
      rest   = lines.drop(1).map { |line| format_panel_line(line, ui) }
      (["\n  #{header}", "  #{ui.rule(56)}"] + rest + [""]).join("\n")
    end

    def format_panel_line(line, ui)
      return "" if line.strip.empty?
      return "  #{ui.paint(line, :light_red)}" if line.lstrip.start_with?("❌", "✗")
      return "  #{ui.paint(line, :green)}"     if line.lstrip.start_with?("✓")

      if (m = line.match(/\A(\s*)(= )(.+)\z/))
        "  #{m[1]}#{ui.paint(m[2], :light_black)}#{ui.paint(m[3], :cyan)}"
      elsif (m = line.match(/\A(\s*[•🔸📌]\s+)(.+)\z/))
        "  #{ui.paint(m[1], :cyan)}#{m[2]}"
      elsif (m = line.match(/\A([A-Za-z][A-Za-z0-9 &\/-]{1,34}:)\s*\z/))
        "  #{ui.paint(m[1], :white, :bold)}"
      elsif (m = line.match(/\A(\s*)([A-Z][A-Za-z0-9 _?\/-]{1,22}:)(\s+)(.+)\z/))
        value_color = m[2] == "Winner:" ? :green : :white
        "  #{m[1]}#{ui.paint(m[2], :light_black)}#{m[3]}#{ui.paint(m[4], value_color)}"
      elsif (m = line.match(/\A(\s+.+?)(\s{2,}# .+)\z/))
        "  #{m[1]}#{ui.paint(m[2], :light_black)}"
      else
        "  #{line}"
      end
    end
  end
end
