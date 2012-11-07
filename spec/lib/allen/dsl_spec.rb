require 'allen/dsl'

include Allen::DSL

describe Allen::DSL do

  it "can configure the client" do
    settings do
      client "RichMahogany"
      root_dir { "path/to/root/dir" }
    end
    Allen.settings.client.should == "RichMahogany"
    Allen.settings.root_dir.should == "path/to/root/dir"
  end

  it "can create projects" do
    project "Rocketship"
    project "Racecar"
    Allen.projects.map(&:name).should == ['Rocketship', 'Racecar']
  end

  it "can configure projects" do
    proj = project "Rhino" do
      compile true
      cache { false }
    end

    proj.settings.compile.should == true
    proj.settings.cache.should == false
  end
end

