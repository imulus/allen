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

  it "assumes the project is an UmbracoProject" do
    proj1 = project "Ralphy"
    proj1.settings.type.should == :umbraco
    proj1.class.should == Allen::UmbracoProject
  end

  it "can have a type other than umbraco" do
    proj1 = project "Ralphy" do
      type :static
    end
    proj1.settings.type.should == :static
    proj1.class.should == Allen::StaticProject
  end
end

