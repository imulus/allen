require 'settings'

module Allen
  class Settings < ::Settings
    def initialize
      super
      pwd = Dir.pwd

      defaults = Proc.new do
        name             "Umbraco"
        client           "Client"
        type             :umbraco
        css_input        "assets/stylesheets/app/application.less"
        css_output       "css/application.css"
        css_preprocessor :banshee
        js_input         "assets/javascripts/app/application.coffee"
        js_output        "js/application.js"
        js_preprocessor  :banshee
        root_dir         { pwd }
        src_dir          { "#{root_dir}/src" }
        solution         { "#{src_dir}/#{client}.sln" }
        targets          [:clean, :build]
        parameters       ""
        webroot          { "#{src_dir}/#{client}.#{name}" }
      end

      configure defaults
    end
  end
end

