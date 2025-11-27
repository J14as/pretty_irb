require "colorize"

module PrettyIRB
  class Formatter
    class << self
      # Pretty print output with colors
      def format_output(output)
        case output
        when String
          output.light_blue
        when Numeric
          output.to_s.light_green
        when TrueClass, FalseClass
          output.to_s.light_cyan
        when NilClass
          "nil".light_black
        when Array
          format_array(output)
        when Hash
          format_hash(output)
        else
          output.inspect.light_yellow
        end
      rescue
        output.to_s
      end

      # Format error messages with pretty colors
      def format_error(error_message)
        error_message.red.bold
      rescue
        error_message
      end

      # Format success messages
      def format_success(message)
        message.green
      rescue
        message
      end

      # Format warning messages
      def format_warning(message)
        message.yellow
      rescue
        message
      end

      private

      def format_array(array)
        formatted = array.map { |item| format_output(item) }.join(", ")
        "[#{formatted}]".light_blue
      rescue
        array.inspect
      end

      def format_hash(hash)
        formatted = hash.map { |k, v| "#{format_output(k)}=>#{format_output(v)}" }.join(", ")
        "{#{formatted}}".light_blue
      rescue
        hash.inspect
      end
    end
  end
end
