require 'spec_helper'
require 'allen/rake'

describe "included modules" do
  it "includes the DSL on kernel" do
    Kernel.methods.should include :project, :settings
  end
end

describe "dependencies" do
  it "loads up the dependencies" do
    Bundler.stub(:require)
    Bundler.should_receive(:require)
    Allen.define_tasks
  end

  it "runs `bundle install` and exits if there are missing dependencies" do
    Bundler.stub(:require) { raise StandardError }
    Allen.should_receive(:exec).with("bundle install")
    Allen.stub(:fail!)
    Allen.should_receive(:fail!)
    Allen.define_tasks
  end
end

