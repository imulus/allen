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
    proj1 = project "Rhino" do
      compile true
      cache { false }
    end

    proj2 = project "Rupert" do
      compressor :uglify
    end

    proj1.settings.compile.should == true
    proj1.settings.cache.should == false
    proj2.settings.compressor.should == :uglify
  end
end

