module Allen
  class Settings
    def initialize
      pwd = Dir.pwd

      defaults = Proc.new do
        client      "Client"
        css_input   "assets/stylesheets/app/application.less"
        css_output  "css/application.css"
        js_input    "assets/javascripts/app/application.coffee"
        js_output   "js/application.js"
        root_dir    { pwd }
        src_dir     { "#{root_dir}/src" }
        solution    { "#{src_dir}/#{client}.sln" }
        targets     [:clean, :build]
        parameters  ""
        webroot     { "#{src_dir}/#{client}.Umbraco" }
      end

      configure defaults
    end

    def configure(configuration=nil, &block)
      instance_eval(&configuration) if configuration
      instance_eval(&block) if block
    end

    def method_missing(method, value=nil, &block)
      set(method, value, block) if value or block
      get(method)
    end

    def set(name, value, block)
      instance_variable_set "@#{name}", !value.nil? ? value : block
    end

    def get(name)
      value = instance_variable_get "@#{name}"
      value = value.call if value.respond_to? :call
      value
    end
  end
end

