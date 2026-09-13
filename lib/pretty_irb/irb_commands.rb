module PrettyIRB
  # Methods mixed into IRB's main object at startup.
  # Names intentionally avoid IRB's own built-in commands
  # (history, hist, help, ls, exit, quit, …) because IRB intercepts
  # those at the statement level before method dispatch.
  module IRBCommands

    # ── commands ──────────────────────────────────────────────────────────
    # Show all pretty_irb extras (use IRB's own `help` for core IRB commands)

    def commands
      section = ->(t) { puts "\n  #{t}".cyan }
      row     = ->(n, d) { puts "    #{"%-40s" % n}#{d.light_black}" }

      puts "\n  pretty_irb  v#{PrettyIRB::VERSION}".cyan + \
           "  ·  type  help  for core IRB commands".light_black
      puts "  " + ("─" * 60).light_black

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
      row.("bench('code')",                   "time code  (1 000 iterations)")
      row.("bench('a', vs: 'b')",             "compare two snippets")
      row.("bench('code', memory: true)",     "GC / object allocation profile")
      row.("bench('code', iterations: 5000)", "custom iteration count")

      section.("Cheatsheet")
      row.("cheat",           "general Ruby reference")
      row.("cheat('array')",  "topic: array hash string enumerable file regex date")

      section.("Docs")
      row.("explain('method')",   "explain a Ruby method")
      row.("example('topic')",    "code examples for a topic")
      row.("practices('topic')",  "best practices for a topic")
      row.("ref('keyword')",      "quick reference lookup")

      puts "\n  tip: IRB built-ins — ".light_black +
           "history  ls  show_source  show_doc  help  exit".white
      puts
      nil
    end

    # ── snippets ──────────────────────────────────────────────────────────

    def snippet(action = :list, name = nil, code = nil, description: "")
      mgr = PrettyIRB::Shell.snippet_manager
      case action.to_sym
      when :list
        puts mgr.list
      when :save
        puts mgr.save(name.to_s, code.to_s, description)
      when :load
        src = mgr.load(name.to_s)
        if src.is_a?(String) && !src.start_with?("❌")
          puts "  loaded: #{name}".cyan
          puts PrettyIRB::Formatter.highlight_code(src)
          eval(src, IRB.CurrentContext.workspace.binding)
        else
          puts src
        end
      when :show
        puts PrettyIRB::Formatter.highlight_code(mgr.show(name.to_s))
      when :delete
        puts mgr.delete(name.to_s)
      when :search
        puts mgr.search(name.to_s)
      else
        puts "  actions: :list  :save  :load  :show  :delete  :search".yellow
      end
      nil
    end

    # ── variables ─────────────────────────────────────────────────────────

    def vars(name = nil, type: nil, search: nil, memory: false)
      inspector = PrettyIRB::VariableInspector.new(IRB.CurrentContext.workspace.binding)
      if    memory then puts inspector.memory_usage
      elsif type   then puts inspector.by_type(type.to_s)
      elsif search then puts inspector.search(search.to_s)
      elsif name   then puts inspector.inspect_var(name.to_s)
      else              puts inspector.list_variables
      end
      nil
    end

    # ── benchmark ─────────────────────────────────────────────────────────

    def bench(code, vs: nil, memory: false, iterations: 1000)
      b = IRB.CurrentContext.workspace.binding
      if    memory then puts PrettyIRB::Benchmarker.profile_memory(code.to_s, iterations, b)
      elsif vs     then puts PrettyIRB::Benchmarker.compare(code.to_s, vs.to_s, iterations, b)
      else              puts PrettyIRB::Benchmarker.benchmark(code.to_s, iterations, b)
      end
      nil
    end

    # ── cheatsheet ────────────────────────────────────────────────────────

    def cheat(topic = nil)
      puts PrettyIRB::CheatSheet.show(topic)
      nil
    end

    # ── docs ──────────────────────────────────────────────────────────────

    def explain(method_name)
      puts PrettyIRB::AIHelper.explain_method(method_name.to_s)
      nil
    end

    def example(topic)
      puts PrettyIRB::AIHelper.get_example(topic.to_s)
      nil
    end

    def practices(topic)
      puts PrettyIRB::AIHelper.best_practices(topic.to_s)
      nil
    end

    def ref(keyword)
      puts PrettyIRB::AIHelper.quick_reference(keyword.to_s)
      nil
    end
  end
end
