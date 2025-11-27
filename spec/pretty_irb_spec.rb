require "spec_helper"

RSpec.describe PrettyIRB do
  it "has a version number" do
    expect(PrettyIRB::VERSION).not_to be nil
  end

  it "has a start method" do
    expect(PrettyIRB).to respond_to(:start)
  end
end
