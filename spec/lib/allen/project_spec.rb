require 'allen'
require 'allen/project'

describe Allen::Project do

  it "has good defaults" do
    project = Allen::Project.new
    project.name.should == "Umbraco"
  end

  it "makes its name also available in its settings" do
    project = Allen::Project.new("Blog")
    project.name.should == "Blog"
    project.settings.name.should == "Blog"
  end

  it "derives its settings" do
    Allen.settings.configure do
      client "Ron Swanson"
      name "Global Name"
      cache true
    end

    project = Allen::Project.new "MustacheProject"

    Allen.settings.name.should == "Global Name"
    project.settings.name.should == "MustacheProject"
    project.settings.cache.should == true
  end

end

