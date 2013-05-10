require 'allen/settings'
require 'allen/preprocessors'
require 'allen/asset_bundle'
require 'allen/meta_data'

module Allen
  class Project
    attr_accessor :name, :settings

    def initialize(name="Umbraco", settings=Allen.settings.clone)
      @name = name
      @settings = settings
      @settings.configure do
        name name
      end
    end

    def build!
      assets.build!
      generate_meta_data!
    end

    def install!
    end

    def uninstall!
    end

    def assets
      @asset_bundle_collection ||= AssetBundleCollection.new(js, css)
    end

    def js
      @js_asset_bundle ||= begin
        preprocessor = Preprocessors.for(settings.js_preprocessor)
        input  = "#{settings.webroot}/#{settings.js_input}"
        output = "#{settings.webroot}/#{settings.js_output}"
        AssetBundle.new(preprocessor, input, output)
      end
    end

    def css
      @css_asset_bundle ||= begin
        preprocessor = Preprocessors.for(settings.css_preprocessor)
        input  = "#{settings.webroot}/#{settings.css_input}"
        output = "#{settings.webroot}/#{settings.css_output}"
        AssetBundle.new(preprocessor, input, output)
      end
    end

    def generate_meta_data!
      MetaData.new(settings).save!
    end

  end
end
