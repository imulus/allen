require 'allen/settings'
require 'allen/preprocessors'

module Allen
  class Project
    attr_accessor :name, :settings

    def initialize(name="Umbraco", block=nil)
      @name = name
      @settings = Allen.settings.clone
      @settings.configure do
        name name
      end
      @settings.configure(block) if block
    end

    def css_preprocessor
      Preprocessors.for(settings.css_preprocessor)
    end

    def js_preprocessor
      Preprocessors.for(settings.js_preprocessor)
    end
  end
end
