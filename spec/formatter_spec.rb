require "spec_helper"

RSpec.describe PrettyIRB::Formatter do
  after { PrettyIRB.reset_configuration! }

  describe ".format_result" do
    it "prepends => with proper color" do
      result = PrettyIRB::Formatter.format_result(123)
      expect(result).to include("=> ")
      expect(result).to include("123")
    end
  end

  describe ".format_output" do
    it "formats strings in yellow" do
      result = PrettyIRB::Formatter.format_output("hello")
      expect(result).to include("\e[0;93;49m") # light_yellow ANSI code
    end

    it "formats numbers in green" do
      result = PrettyIRB::Formatter.format_output(42)
      expect(result).to include("\e[0;92;49m") # light_green ANSI code
    end

    it "formats floats in green" do
      result = PrettyIRB::Formatter.format_output(3.14)
      expect(result).to include("\e[0;92;49m")
    end

    it "formats true in cyan" do
      result = PrettyIRB::Formatter.format_output(true)
      expect(result).to include("\e[0;36;49m") # cyan
    end

    it "formats false in cyan" do
      result = PrettyIRB::Formatter.format_output(false)
      expect(result).to include("\e[0;36;49m") # cyan
    end

    it "formats nil in dim black" do
      result = PrettyIRB::Formatter.format_output(nil)
      expect(result).to include("nil")
    end

    it "formats symbols in magenta" do
      result = PrettyIRB::Formatter.format_output(:my_symbol)
      expect(result).to include("\e[0;95;49m") # light_magenta
    end

    it "formats empty arrays" do
      result = PrettyIRB::Formatter.format_output([])
      expect(result).to include("[]")
    end

    it "formats arrays with elements" do
      result = PrettyIRB::Formatter.format_output([1, 2, 3])
      expect(result).to include("[")
      expect(result).to include("]")
    end

    it "formats large arrays with truncation" do
      result = PrettyIRB::Formatter.format_output((1..40).to_a)
      expect(result).to include("40 total")
      expect(result).to include("\n")
    end

    it "formats large hashes across aligned multiple lines" do
      PrettyIRB.configure { |c| c.colorize = false }
      result = PrettyIRB::Formatter.format_output({ a: 1, b: 2, c: 3, d: 4, e: 5 })
      expect(result).to include("\n  :a => 1")
      expect(result).to include(":e => 5\n}")
    end

    it "formats Regexps, Ranges, and Classes distinctly" do
      expect(PrettyIRB::Formatter.format_output(/abc/)).to include("/abc/")
      expect(PrettyIRB::Formatter.format_output(1..5)).to include("1..5")
      expect(PrettyIRB::Formatter.format_output(String)).to include("String")
    end

    it "formats Struct instances with named fields" do
      PrettyIRB.configure { |c| c.colorize = false }
      point_class = Struct.new(:x, :y)
      stub_const("Point", point_class)
      expect(PrettyIRB::Formatter.format_output(Point.new(3, 4))).to eq("#<struct Point x: 3, y: 4>")
    end

    it "formats ActiveRecord::Base models cleanly (inline and multi-line)" do
      PrettyIRB.configure { |c| c.colorize = false }
      ar_base = Class.new do
        attr_reader :attributes

        def initialize(attrs, new_rec = false)
          @attributes = attrs
          @new_rec = new_rec
        end

        def new_record?
          @new_rec
        end
      end
      user_class = Class.new(ar_base)
      stub_const("ActiveRecord::Base", ar_base)
      stub_const("User", user_class)

      compact = User.new({ "id" => 1, "name" => "Alice" }, true)
      expect(PrettyIRB::Formatter.format_output(compact)).to eq('#<User (new) id: 1, name: "Alice">')

      wide = User.new({ "id" => 1, "name" => "Alice", "email" => "a@b.com", "admin" => true })
      formatted = PrettyIRB::Formatter.format_output(wide)
      expect(formatted).to include("#<User\n")
      expect(formatted).to include('email: "a@b.com"')
      expect(formatted).to include("admin: true")
    end

    it "formats ActiveRecord::Relation with bounded query loading" do
      PrettyIRB.configure { |c| c.colorize = false }
      ar_relation = Class.new do
        attr_reader :limit_arg

        def initialize(records, loaded:)
          @records = records
          @loaded  = loaded
        end

        def loaded?
          @loaded
        end

        def limit(n)
          @limit_arg = n
          self.class.new(@records.first(n), loaded: false)
        end

        def to_a
          @records
        end
      end
      stub_const("ActiveRecord::Relation", ar_relation)

      unloaded = ActiveRecord::Relation.new((1..35).to_a, loaded: false)
      expect(unloaded).to receive(:limit).with(PrettyIRB::Formatter::MAX_COLLECTION_ITEMS + 1).and_call_original
      formatted = PrettyIRB::Formatter.format_output(unloaded)
      expect(formatted).to include("#<ActiveRecord::Relation [")
      expect(formatted).to include("showing first 30")
      expect(formatted).not_to include("31")

      empty_rel = ActiveRecord::Relation.new([], loaded: true)
      expect(PrettyIRB::Formatter.format_output(empty_rel)).to eq("#<ActiveRecord::Relation []>")
    end

    it "formats empty hashes" do
      result = PrettyIRB::Formatter.format_output({})
      expect(result).to include("{}")
    end

    it "formats hashes with elements" do
      result = PrettyIRB::Formatter.format_output({ a: 1, b: 2 })
      expect(result).to include("{")
      expect(result).to include("=>")
      expect(result).to include("}")
    end

    it "formats other objects with inspect in white" do
      obj = Object.new
      result = PrettyIRB::Formatter.format_output(obj)
      expect(result).to include(obj.inspect)
    end
  end

  describe ".highlight_code" do
    it "highlights ruby code using Rouge" do
      highlighted = PrettyIRB::Formatter.highlight_code("def hello; puts 'world'; end")
      expect(highlighted).to be_a(String)
      expect(highlighted).to include("hello")
    end
  end

  describe ".format_error" do
    it "formats error type and message" do
      result = PrettyIRB::Formatter.format_error("NameError", "undefined local variable")
      expect(result).to include("NameError")
      expect(result).to include("undefined local variable")
    end

    it "formats error type alone if no message" do
      result = PrettyIRB::Formatter.format_error("StandardError")
      expect(result).to include("StandardError")
    end
  end

  describe ".format_success and .format_warning" do
    it "formats success in green" do
      expect(PrettyIRB::Formatter.format_success("Done")).to include("Done")
    end

    it "formats warning in yellow" do
      expect(PrettyIRB::Formatter.format_warning("Watch out")).to include("Watch out")
    end
  end

  describe "when colorize or syntax_highlight is disabled" do
    it "returns plain formatted output without ANSI codes" do
      PrettyIRB.configure { |c| c.colorize = false }

      expect(PrettyIRB::Formatter.format_result("hello")).to eq('=> "hello"')
      expect(PrettyIRB::Formatter.format_output([1, true, nil])).to eq("[1, true, nil]")
      expect(PrettyIRB::Formatter.format_error("NameError", "bad")).to eq("NameError: bad")
      expect(PrettyIRB::Formatter.highlight_code("x = 1")).to eq("x = 1")
    end

    it "returns raw code when syntax_highlight is false" do
      PrettyIRB.configure { |c| c.syntax_highlight = false }

      expect(PrettyIRB::Formatter.highlight_code("def foo; end")).to eq("def foo; end")
    end
  end
end
