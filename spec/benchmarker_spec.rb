require "spec_helper"

RSpec.describe PrettyIRB::Benchmarker do
  describe ".benchmark" do
    it "benchmarks a block of code and returns formatted string" do
      result = PrettyIRB::Benchmarker.benchmark("1 + 1", 100)
      expect(result).to include("Benchmark Results")
      expect(result).to include("Iterations: 100")
      expect(result).to include("Total Time:")
      expect(result).to include("ops/sec")
    end

    it "handles errors gracefully" do
      result = PrettyIRB::Benchmarker.benchmark("raise 'boom'", 10)
      expect(result).to include("❌ Benchmark failed: boom")
    end

    it "supports evaluation with a binding" do
      x = 42
      b = binding
      result = PrettyIRB::Benchmarker.benchmark("x * 2", 50, b)
      expect(result).to include("Benchmark Results")
    end
  end

  describe ".compare" do
    it "compares two pieces of code" do
      result = PrettyIRB::Benchmarker.compare("1 + 1", "2 + 2", 100)
      expect(result).to include("Comparison Results")
      expect(result).to include("Code 1")
      expect(result).to include("Code 2")
      expect(result).to include("Winner:")
    end

    it "handles errors during comparison gracefully" do
      result = PrettyIRB::Benchmarker.compare("1 + 1", "raise 'fail'", 10)
      expect(result).to include("❌ Comparison failed: fail")
    end
  end

  describe ".profile_memory" do
    it "profiles memory allocations" do
      result = PrettyIRB::Benchmarker.profile_memory("[1, 2, 3] * 10", 50)
      expect(result).to include("Memory Profile")
      expect(result).to include("Objects Allocated:")
      expect(result).to include("Objects Freed:")
    end

    it "handles memory profiling errors gracefully" do
      result = PrettyIRB::Benchmarker.profile_memory("raise 'mem error'", 10)
      expect(result).to include("❌ Memory profile failed: mem error")
    end
  end
end
