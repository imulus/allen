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
      if settings.css_preprocessor == :coyote
        Allen::Preprocessors::Coyote
      elsif settings.css_preprocessor == :sass
        Allen::Preprocessors::Sass
      else
        raise StandardError, "unknown CSS preprocessor: #{settings.css_preprocessor}"
      end
    end

    def js_preprocessor
      if settings.js_preprocessor == :coyote
        Allen::Preprocessors::Coyote
      else
        raise StandardError, "unknown JS preprocessor: #{settings.js_preprocessor}"
      end
    end
  end
end
