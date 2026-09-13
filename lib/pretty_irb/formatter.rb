require "colorize"
require "rouge"

module PrettyIRB
  class Formatter
    class << self
      # "=> value" — identical to how IRB shows results
      def format_result(output)
        "=> ".white + format_output(output)
      rescue
        "=> #{output}"
      end

      def format_output(value)
        case value
        when String      then value.inspect.light_yellow
        when Integer     then value.to_s.light_green
        when Float       then value.to_s.light_green
        when Numeric     then value.to_s.light_green
        when TrueClass   then "true".cyan
        when FalseClass  then "false".cyan
        when NilClass    then "nil".light_black
        when Symbol      then value.inspect.light_magenta
        when Array       then format_array(value)
        when Hash        then format_hash(value)
        else                  value.inspect.white
        end
      rescue
        value.to_s
      end

      # Rouge Monokai syntax highlight for Ruby code (used in history / snippets)
      def highlight_code(code)
        formatter = Rouge::Formatters::Terminal256.new(Rouge::Themes::Monokai.new)
        lexer     = Rouge::Lexers::Ruby.new
        formatter.format(lexer.lex(code))
      rescue
        code
      end

      # "ErrorType: message" — red type, dim message
      def format_error(type, message = nil)
        if message
          type.red.bold + ": ".red + message.light_red
        else
          type.red.bold
        end
      rescue
        "#{type}: #{message}"
      end

      def format_success(message)
        message.green
      rescue
        message
      end

      def format_warning(message)
        message.yellow
      rescue
        message
      end

      private

      def format_array(arr)
        return "[]".white if arr.empty?

        items = arr.first(30).map { |v| format_output(v) }
        items << "…  (#{arr.length} total)".light_black if arr.length > 30
        "[".white + items.join(", ".white) + "]".white
      rescue
        arr.inspect
      end

      def format_hash(hash)
        return "{}".white if hash.empty?

        pairs = hash.first(30).map do |k, v|
          format_output(k) + " => ".white + format_output(v)
        end
        pairs << "…  (#{hash.length} total)".light_black if hash.length > 30
        "{".white + pairs.join(", ".white) + "}".white
      rescue
        hash.inspect
      end
    end
  end
end
