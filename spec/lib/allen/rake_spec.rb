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

describe "tasks" do
  before(:each) do
    Allen.reset!
  end

  describe ".define_tasks" do
    it "defines all the tasks" do
      Allen.should_receive(:define_convenience_tasks)
      Allen.should_receive(:define_solution_tasks)
      Allen.should_receive(:define_deploy_tasks)
      Allen.should_receive(:define_assets_tasks)
      Allen.should_receive(:define_project_tasks)
      define_tasks
    end
  end

  describe ".define_convenience_tasks" do
    it "defines convenience tasks in the top-level namespace" do
      app = stub
      Rake.stub(:application) { app }
      app.should_receive(:in_namespace).with(nil)
      Allen.define_convenience_tasks
    end
  end

  describe ".define_solution_tasks" do
    it "creates a solution namespace" do
      app = stub
      Rake.stub(:application) { app }
      app.should_receive(:in_namespace).with("solution")
      Allen.define_solution_tasks
    end
  end

  describe ".define_assets_tasks" do
    it "creates an assets namespace" do
      app = stub
      Rake.stub(:application) { app }
      app.should_receive(:in_namespace).with("assets")
      Allen.define_assets_tasks
    end
  end

  describe ".define_project_tasks" do
    it "creates a namespace for each project" do
      app = stub
      Rake.stub(:application) { app }
      app.should_receive(:in_namespace).with("georgemichael")
      app.should_receive(:in_namespace).with("maeby")
      project "GeorgeMichael"
      project "Maeby"
      Allen.define_project_tasks
    end
  end

  describe ".define_deploy_tasks" do
    it "creates a deploy namespace" do
      app = stub
      Rake.stub(:application) { app }
      app.should_receive(:in_namespace).with("deploy")
      Allen.define_deploy_tasks
    end
  end
end
