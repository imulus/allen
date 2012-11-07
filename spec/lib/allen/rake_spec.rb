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

describe "namespaces" do
  before(:each) do
    Allen.reset!
  end

  it "defines a namespace for each project" do
    app = stub
    Rake.stub(:application) { app }
    app.should_receive(:in_namespace).with("georgemichael")
    app.should_receive(:in_namespace).with("maeby")
    project "GeorgeMichael"
    project "Maeby"
    define_tasks
  end
end

