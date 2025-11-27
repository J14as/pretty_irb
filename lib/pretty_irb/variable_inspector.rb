module PrettyIRB
  class VariableInspector
    def initialize(binding)
      @binding = binding
    end

    # List all local variables
    def list_variables
      variables = @binding.local_variables
      return "📦 No variables defined yet" if variables.empty?

      output = "📦 Local Variables (#{variables.length}):\n\n"
      variables.each do |var|
        value = @binding.local_variable_get(var)
        output += format_variable(var, value)
      end
      output
    end

    # Get variable details
    def inspect_var(var_name)
      begin
        value = @binding.local_variable_get(var_name.to_sym)
        detailed_info(var_name, value)
      rescue NameError
        "❌ Variable '#{var_name}' not found"
      end
    end

    # Get variable value
    def get(var_name)
      begin
        @binding.local_variable_get(var_name.to_sym)
      rescue NameError
        nil
      end
    end

    # List variables of a specific type
    def by_type(type)
      variables = @binding.local_variables
      filtered = variables.select do |var|
        value = @binding.local_variable_get(var)
        value.class.name.include?(type.capitalize)
      end

      return "❌ No variables of type #{type}" if filtered.empty?

      output = "📦 Variables of type #{type} (#{filtered.length}):\n\n"
      filtered.each do |var|
        value = @binding.local_variable_get(var)
        output += format_variable(var, value)
      end
      output
    end

    # Search variables by name
    def search(keyword)
      variables = @binding.local_variables
      filtered = variables.select { |var| var.to_s.include?(keyword) }

      return "🔍 No variables matching '#{keyword}'" if filtered.empty?

      output = "🔍 Found #{filtered.length} variable(s):\n\n"
      filtered.each do |var|
        value = @binding.local_variable_get(var)
        output += format_variable(var, value)
      end
      output
    end

    # Memory usage estimation
    def memory_usage
      variables = @binding.local_variables
      total_size = variables.sum do |var|
        value = @binding.local_variable_get(var)
        estimate_size(value)
      end

      output = "💾 Memory Usage:\n\n"
      output += "Total: ~#{total_size / 1024} KB\n\n"
      
      variables.each do |var|
        value = @binding.local_variable_get(var)
        size = estimate_size(value)
        output += "  #{var}: ~#{size} bytes\n"
      end
      output
    end

    private

    def format_variable(name, value)
      type = value.class.name
      size = estimate_size(value)
      
      value_str = value.inspect
      value_str = value_str.length > 60 ? value_str[0..56] + '...' : value_str
      "  #{name}: #{type} (#{size} bytes)\n    = #{value_str}\n\n"
    end

    def detailed_info(name, value)
      output = "📦 Variable: #{name}\n\n"
      output += "Type: #{value.class}\n"
      output += "Size: ~#{estimate_size(value)} bytes\n"
      output += "Value: #{value.inspect}\n\n"
      
      case value
      when String
        output += "String Info:\n"
        output += "  Length: #{value.length}\n"
        output += "  Encoding: #{value.encoding}\n"
      when Array
        output += "Array Info:\n"
        output += "  Length: #{value.length}\n"
        output += "  First: #{value.first.inspect}\n"
        output += "  Last: #{value.last.inspect}\n"
      when Hash
        output += "Hash Info:\n"
        output += "  Size: #{value.length}\n"
        output += "  Keys: #{value.keys.inspect}\n"
      when Numeric
        output += "Number Info:\n"
        output += "  Value: #{value}\n"
        output += "  Even?: #{value.even?}\n" if value.is_a?(Integer)
      end
      
      output
    end

    def estimate_size(obj)
      case obj
      when String
        obj.bytesize
      when Array
        obj.length * 8 + obj.sum { |item| estimate_size(item) }
      when Hash
        obj.length * 16 + obj.sum { |k, v| estimate_size(k) + estimate_size(v) }
      when Numeric
        24
      when TrueClass, FalseClass, NilClass
        8
      else
        obj.to_s.bytesize
      end
    end
  end
end
