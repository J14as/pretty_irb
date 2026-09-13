require "benchmark"

module PrettyIRB
  class Benchmarker
    # Benchmark a code snippet, optionally with caller's binding for variable access
    def self.benchmark(code, iterations = 1000, binding = nil)
      time = Benchmark.measure do
        iterations.times do
          binding ? eval(code, binding) : eval(code)
        end
      end

      total_ms = time.real * 1000
      per_iteration_us = (total_ms * 1000).to_f / iterations

      format_benchmark_result(code, iterations, total_ms, per_iteration_us)
    rescue => e
      "❌ Benchmark failed: #{e.message}"
    end

    # Compare two code snippets
    def self.compare(code1, code2, iterations = 1000, binding = nil)
      time1 = Benchmark.measure do
        iterations.times { binding ? eval(code1, binding) : eval(code1) }
      end

      time2 = Benchmark.measure do
        iterations.times { binding ? eval(code2, binding) : eval(code2) }
      end

      format_comparison(code1, code2, time1, time2, iterations)
    rescue => e
      "❌ Comparison failed: #{e.message}"
    end

    # Profile memory
    def self.profile_memory(code, iterations = 100, binding = nil)
      gc_stat_before = GC.stat

      iterations.times { binding ? eval(code, binding) : eval(code) }

      gc_stat_after = GC.stat

      format_memory_profile(gc_stat_before, gc_stat_after, iterations)
    rescue => e
      "❌ Memory profile failed: #{e.message}"
    end

    private

    def self.truncate(str, max)
      str.length > max ? str[0, max - 3] + "..." : str
    end

    def self.format_benchmark_result(code, iterations, total_ms, per_iteration_us)
      output = "⏱️  Benchmark Results:\n\n"
      output += "Code: #{truncate(code, 50)}\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Total Time: #{total_ms.round(2)} ms\n"
      output += "Per Iteration: #{per_iteration_us.round(4)} µs\n"
      output += "Rate: #{(iterations / (total_ms / 1000.0)).round(0)} ops/sec\n"
      output
    end

    def self.format_comparison(code1, code2, time1, time2, iterations)
      ratio = time1.real > 0 ? time2.real / time1.real : 1.0
      faster = if ratio < 1
        "Code 2 is #{((1.0 / ratio - 1) * 100).round(1)}% faster"
      else
        "Code 1 is #{((ratio - 1) * 100).round(1)}% faster"
      end

      output = "⚡ Comparison Results:\n\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Code 1 (#{truncate(code1, 40)}):\n"
      output += "  Time: #{(time1.real * 1000).round(2)} ms\n\n"
      output += "Code 2 (#{truncate(code2, 40)}):\n"
      output += "  Time: #{(time2.real * 1000).round(2)} ms\n\n"
      output += "Winner: #{faster}\n"
      output
    end

    def self.format_memory_profile(before, after, iterations)
      allocated = after[:total_allocated_objects] - before[:total_allocated_objects]
      freed = after[:total_freed_objects] - before[:total_freed_objects]
      net = allocated - freed

      output = "💾 Memory Profile:\n\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Objects Allocated: #{allocated}\n"
      output += "Objects Freed: #{freed}\n"
      output += "Net Objects: #{net}\n"
      output += "Per Iteration: #{(net.to_f / iterations).round(2)} objects\n"
      output
    end
  end
end
