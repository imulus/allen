require 'spec_helper'
require 'allen/preprocessors'

describe Allen::Preprocessors do
  describe Allen::Preprocessors::Preprocessor do
    describe ".relative" do
      it "gets a relative path from an absolute one" do
        Dir.stub(:pwd) { "c:/path/to/some" }
        abs_path = "c:/path/to/some/input/file.css"
        rel_path = "input/file.css"
        Allen::Preprocessors::Preprocessor.relative(abs_path).should == rel_path
      end
    end
  end

  describe Allen::Preprocessors::Coyote do
    let(:coyote) { Allen::Preprocessors::Coyote }
    let(:input) { "c:/path/to/some/input/file.less" }
    let(:output) { "c:/path/to/some/output/file.css" }

    before { Dir.stub(:pwd) { "c:/path/to/some" } }

    it "has a build command" do
      coyote.should_receive("sh").with("coyote input/file.less:output/file.css")
      coyote.build(input, output)
    end

    it "has a compress command" do
      coyote.should_receive("sh").with("coyote input/file.less:output/file.css --compress")
      coyote.compress(input, output)
    end

    it "has a watch command" do
      coyote.should_receive("sh").with("coyote input/file.less:output/file.css --watch")
      coyote.watch(input, output)
    end
  end

  describe Allen::Preprocessors::Banshee do
    let(:banshee) { Allen::Preprocessors::Banshee }
    let(:input) { "c:/path/to/some/input/file.less" }
    let(:output) { "c:/path/to/some/output/file.css" }

    before { Dir.stub(:pwd) { "c:/path/to/some" } }

    it "has a build command" do
      banshee.should_receive("sh").with("banshee input/file.less:output/file.css")
      banshee.build(input, output)
    end

    it "has a compress command" do
      banshee.should_receive("sh").with("banshee input/file.less:output/file.css --compress")
      banshee.compress(input, output)
    end

    it "has a watch command" do
      banshee.should_receive("sh").with("banshee input/file.less:output/file.css --watch")
      banshee.watch(input, output)
    end
  end

  describe Allen::Preprocessors::Sass do
    let(:sass) { Allen::Preprocessors::Sass }
    let(:input) { "c:/path/to/some/input/file.sass" }
    let(:output) { "c:/path/to/some/output/file.css" }

    before { Dir.stub(:pwd) { "c:/path/to" } }

    it "has a build command" do
      sass.should_receive("sh").with("sass some/input/file.sass:some/output/file.css --style expanded")
      sass.build(input, output)
    end

    it "has a compress command" do
      sass.should_receive("sh").with("sass some/input/file.sass:some/output/file.css --style compressed")
      sass.compress(input, output)
    end

    it "has a watch command" do
      sass.should_receive("sh").with("sass --watch some/input:some/output --style expanded")
      sass.watch(input, output)
    end
  end

  describe Allen::Preprocessors::Null do
    let(:null) { Allen::Preprocessors::Null }
    let(:input) { "c:/path/to/some/input/file.css" }
    let(:output) { "c:/path/to/some/output/file.css" }

    it "has a build command that does nothing" do
      null.build(input, output).should eq null
    end

    it "has a compress command that does nothing" do
      null.compress(input, output).should eq null
    end

    it "has a watch command that does nothing" do
      null.watch(input, output).should eq null
    end
  end
end

