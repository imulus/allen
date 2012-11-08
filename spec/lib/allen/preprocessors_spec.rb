require 'spec_helper'
require 'allen/preprocessors'

describe Allen::Preprocessors do
  describe Allen::Preprocessors::Coyote do
    let(:coyote) { Allen::Preprocessors::Coyote }

    it "has a build command" do
      coyote.should_receive("sh").with("coyote input.less:output.css")
      coyote.build("input.less", "output.css")
    end

    it "has a compress command" do
      coyote.should_receive("sh").with("coyote input.less:output.css --compress")
      coyote.compress("input.less", "output.css")
    end

    it "has a watch command" do
      coyote.should_receive("sh").with("coyote input.less:output.css --watch")
      coyote.watch("input.less", "output.css")
    end
  end

  describe Allen::Preprocessors::Banshee do
    let(:banshee) { Allen::Preprocessors::Banshee }

    it "has a build command" do
      banshee.should_receive("sh").with("banshee input.less:output.css")
      banshee.build("input.less", "output.css")
    end

    it "has a compress command" do
      banshee.should_receive("sh").with("banshee input.less:output.css --compress")
      banshee.compress("input.less", "output.css")
    end

    it "has a watch command" do
      banshee.should_receive("sh").with("banshee input.less:output.css --watch")
      banshee.watch("input.less", "output.css")
    end
  end

  describe Allen::Preprocessors::Sass do
    let(:sass) { Allen::Preprocessors::Sass }

    it "has a build command" do
      sass.should_receive("sh").with("sass input.sass:output.css --style expanded")
      sass.build("input.sass", "output.css")
    end

    it "has a compress command" do
      sass.should_receive("sh").with("sass input.sass:output.css --style compressed")
      sass.compress("input.sass", "output.css")
    end

    it "has a watch command" do
      sass.should_receive("sh").with("sass --watch assets/stylesheets:wwwroot/css --style expanded")
      sass.watch("assets/stylesheets/styles.scss", "wwwroot/css/styles.css")
    end
  end
end

