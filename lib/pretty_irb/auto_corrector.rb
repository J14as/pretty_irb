module PrettyIRB
  class AutoCorrector
    COMMON_METHOD_TYPOS = {
      "lenght" => "length",
      "sizze"  => "size",
      "empyt?" => "empty?",
      "nil"    => "nil?",
      "to_str" => "to_s",
      "to_int" => "to_i"
    }.freeze

    class << self
      # Suggest corrections for common Ruby mistakes
      def suggest_corrections(error)
        case error
        when NameError
          suggest_name_or_method_error(error)
        when SyntaxError
          suggest_syntax_error(error)
        else
          ""
        end
      rescue
        ""
      end

      # Auto-correct common typos in code
      def auto_correct_code(code)
        fix_method_names(code)
      rescue
        code
      end

      private

      def suggest_name_or_method_error(error)
        hints = []

        if error.respond_to?(:corrections)
          corrections = begin
            error.corrections
          rescue ArgumentError
            nil
          end
          if corrections.is_a?(Array) && !corrections.empty?
            hints << "Did you mean?: #{corrections.join(', ')}"
          end
        end

        if error.is_a?(NoMethodError)
          method_name = error.name.to_s
          if (replacement = COMMON_METHOD_TYPOS[method_name])
            hints << "Did you mean `.#{replacement}`?"
          end

          nil_receiver = begin
            error.respond_to?(:receiver) && error.receiver.nil?
          rescue ArgumentError
            false
          end

          if nil_receiver && !method_name.empty?
            hints << "Receiver is nil — check initialization or use safe navigation (`&.#{method_name}`)"
          end
        end

        hints.empty? ? "" : "\n💡 #{hints.uniq.join(' · ')}"
      end

      def suggest_syntax_error(error)
        msg = error.message.to_s
        if msg.include?("unexpected end-of-input") || msg.include?("unterminated")
          "\n💡 Check for a missing `end`, closing bracket, or closing quote."
        elsif msg.include?("unexpected `end'") || msg.include?("unexpected end")
          "\n💡 Extra `end` detected — check block/method nesting."
        else
          ""
        end
      end

      def fix_method_names(code)
        code.gsub(/\.lenght\b/, ".length")
            .gsub(/\.sizze\b/, ".size")
      end
    end
  end
end
