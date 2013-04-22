require 'allen'
require 'allen/project'

describe Allen::Project do

  describe "#build!" do
    it "builds the assets and generates the meta data" do
      project = Allen::Project.new
      assets = stub(:assets, :build => stub)
      project.stub(:assets).and_return(assets)
      project.stub(:generate_meta_data!)
      assets.should_receive(:build!)
      project.build!
    end
  end

  describe "#generate_meta_data!" do
    it "writes the version and hash files" do
      project = Allen::Project.new

      version_file = stub(:version_file, :puts => stub)
      File.should_receive(:open).with(project.settings.webroot + "/version", "w").and_return(version_file)
      version_file.should_receive(:close)

      hash_file = stub(:hash_file, :print => stub)
      File.should_receive(:open).with(project.settings.webroot + "/commit-hash", "w").and_return(hash_file)
      hash_file.should_receive(:close)

      project.generate_meta_data!
    end
  end

  describe "settings" do
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

  describe "preprocessors" do
    it "knows its css preprocessor" do
      project = Allen::Project.new
      project.settings.css_preprocessor :coyote
      project.css.preprocessor.should == Allen::Preprocessors::Coyote
    end

    it "knows about sass" do
      project = Allen::Project.new
      project.settings.css_preprocessor :sass
      project.css.preprocessor.should == Allen::Preprocessors::Sass
    end

    it "knows about banshee" do
      project = Allen::Project.new
      project.settings.css_preprocessor :banshee
      project.css.preprocessor.should == Allen::Preprocessors::Banshee
    end

    it "raises when it doesn't know the css preprocessor" do
      project = Allen::Project.new
      project.settings.css_preprocessor :pawikwkasdf
      expect {
        project.css.preprocessor
      }.to raise_error StandardError, /unknown preprocessor: pawikwkasdf/
    end

    it "knows its js preprocessor" do
      project = Allen::Project.new
      project.settings.js_preprocessor :coyote
      project.js.preprocessor.should == Allen::Preprocessors::Coyote
    end

    it "knows about banshee" do
      project = Allen::Project.new
      project.settings.js_preprocessor :banshee
      project.js.preprocessor.should == Allen::Preprocessors::Banshee
    end

    it "raises when it doesn't know the js preprocessor" do
      project = Allen::Project.new
      project.settings.js_preprocessor :fsdfasdfadsf
      expect {
        project.js.preprocessor
      }.to raise_error StandardError, /unknown preprocessor: fsdfasdfadsf/
    end
  end
end

