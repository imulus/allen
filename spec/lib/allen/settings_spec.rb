require 'allen/settings'

describe Allen::Settings do
  let(:pwd) { Dir.pwd }

  it "has good defaults" do
    settings = Allen::Settings.new
    settings.client.should            == "Client"
    settings.css_input.should         == "assets/stylesheets/app/application.less"
    settings.css_output.should        == "css/application.css"
    settings.css_preprocessor.should  == :coyote
    settings.js_input.should          == "assets/javascripts/app/application.coffee"
    settings.js_output.should         == "js/application.js"
    settings.js_preprocessor.should   == :coyote
    settings.root_dir.should          == pwd
    settings.src_dir.should           == "#{pwd}/src"
    settings.solution.should          == "#{pwd}/src/Client.sln"
    settings.targets.should           == [:clean, :build]
    settings.parameters.should        == ""
    settings.webroot.should           == "#{pwd}/src/Client.Umbraco"
  end

  it "allows the defaults to be overridden" do
    settings = Allen::Settings.new
    settings.configure do
      client "FlavaFlav"
      root_dir "~/Desktop"
    end

    settings.client.should == "FlavaFlav"
    settings.root_dir.should == "~/Desktop"
    settings.solution.should == "~/Desktop/src/FlavaFlav.sln"
  end

  it "can be copied and overriden" do
    global_settings = Allen::Settings.new
    global_settings.configure do
      client "PedoBear"
      webroot { "~/Desktop/#{client}/wwwroot" }
      cache false
    end

    local_settings = global_settings.clone
    local_settings.configure do
      client "GoodGuyGreg"
      webroot { "~/Desktop/#{client}/public" }
    end

    global_settings.client.should == "PedoBear"
    global_settings.webroot.should == "~/Desktop/PedoBear/wwwroot"
    global_settings.cache.should == false
    local_settings.client.should == "GoodGuyGreg"
    local_settings.webroot.should == "~/Desktop/GoodGuyGreg/public"
    local_settings.cache.should == false
  end
end

