require "benchmark"

module PrettyIRB
  class Benchmarker
    # Benchmark a code snippet
    def self.benchmark(code, iterations = 1000)
      begin
        time = Benchmark.measure do
          iterations.times do
            eval(code)
          end
        end

        total_ms = time.real * 1000
        per_iteration_us = (total_ms * 1000) / iterations

        format_benchmark_result(code, iterations, total_ms, per_iteration_us)
      rescue => e
        "❌ Benchmark failed: #{e.message}"
      end
    end

    # Compare two code snippets
    def self.compare(code1, code2, iterations = 1000)
      begin
        time1 = Benchmark.measure do
          iterations.times { eval(code1) }
        end

        time2 = Benchmark.measure do
          iterations.times { eval(code2) }
        end

        format_comparison(code1, code2, time1, time2, iterations)
      rescue => e
        "❌ Comparison failed: #{e.message}"
      end
    end

    # Profile memory
    def self.profile_memory(code, iterations = 100)
      begin
        gc_stat_before = GC.stat
        
        iterations.times { eval(code) }
        
        gc_stat_after = GC.stat

        format_memory_profile(gc_stat_before, gc_stat_after, iterations)
      rescue => e
        "❌ Memory profile failed: #{e.message}"
      end
    end

    private

    def self.format_benchmark_result(code, iterations, total_ms, per_iteration_us)
      output = "⏱️  Benchmark Results:\n\n"
      output += "Code: #{code.truncate(50)}\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Total Time: #{total_ms.round(2)} ms\n"
      output += "Per Iteration: #{per_iteration_us.round(4)} µs\n"
      output += "Rate: #{(iterations / (total_ms / 1000)).round(0)} ops/sec\n"
      output
    end

    def self.format_comparison(code1, code2, time1, time2, iterations)
      ratio = time2.real / time1.real
      faster = ratio < 1 ? "Code 2 is #{(1/ratio - 1) * 100}% faster" : "Code 1 is #{(ratio - 1) * 100}% faster"

      output = "⚡ Comparison Results:\n\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Code 1 (#{code1.truncate(40)}):\n"
      output += "  Time: #{(time1.real * 1000).round(2)} ms\n\n"
      output += "Code 2 (#{code2.truncate(40)}):\n"
      output += "  Time: #{(time2.real * 1000).round(2)} ms\n\n"
      output += "Winner: #{faster}\n"
      output
    end

    def self.format_memory_profile(before, after, iterations)
      allocated = after[:total_allocated_objects] - before[:total_allocated_objects]
      freed = after[:total_freed_objects] - before[:total_freed_objects]

      output = "💾 Memory Profile:\n\n"
      output += "Iterations: #{iterations}\n\n"
      output += "Objects Allocated: #{allocated}\n"
      output += "Objects Freed: #{freed}\n"
      output += "Net Objects: #{allocated - freed}\n"
      output += "Per Iteration: #{((allocated - freed) / iterations).round(1)} objects\n"
      output
    end
  end
end
