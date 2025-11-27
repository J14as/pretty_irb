module PrettyIRB
  class AutoCorrector
    class << self
      # Suggest corrections for common Ruby mistakes
      def suggest_corrections(error)
        case error
        when NameError
          suggest_name_error(error)
        when NoMethodError
          suggest_method_error(error)
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
        code = fix_method_names(code)
        code
      rescue
        code
      end

      private

      def suggest_name_error(error)
        # Try to get corrections, but safely
        begin
          if error.respond_to?(:corrections)
            corrections = error.corrections
            if corrections.is_a?(Array) && corrections.length > 0
              "\n💡 Did you mean?: #{corrections.join(', ')}"
            else
              ""
            end
          else
            ""
          end
        rescue
          ""
        end
      end

      def suggest_method_error(error)
        begin
          if error.respond_to?(:corrections)
            corrections = error.corrections
            if corrections.is_a?(Array) && corrections.length > 0
              "\n💡 Did you mean?: #{corrections.join(', ')}"
            else
              ""
            end
          else
            ""
          end
        rescue
          ""
        end
      end

      def suggest_syntax_error(error)
        ""
      end

      def fix_method_names(code)
        # Common method name corrections
        code.gsub(/\.lenght/, ".length")
           .gsub(/\.sizze/, ".size")
      end
    end
  end
end
