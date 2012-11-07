require 'spec_helper'
require 'allen/rake'

describe "included modules" do
  it "includes the DSL on kernel" do
    Kernel.methods.should include :project, :settings
  end

  it "includes the rake DSL on the kernel" do
    Kernel.methods.should include :define_tasks
  end
end

