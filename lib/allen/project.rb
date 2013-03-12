require 'allen/settings'
require 'allen/preprocessors'
require 'allen/asset_bundle'

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
        input  = "#{settings.src_dir}/#{settings.client}.#{name}/#{settings.js_input}"
        output = "#{settings.src_dir}/#{settings.client}.#{name}/#{settings.js_output}"
        AssetBundle.new(preprocessor, input, output)
      end
    end

    def css
      @css_asset_bundle ||= begin
        preprocessor = Preprocessors.for(settings.css_preprocessor)
        input  = "#{settings.src_dir}/#{settings.client}.#{name}/#{settings.css_input}"
        output = "#{settings.src_dir}/#{settings.client}.#{name}/#{settings.css_output}"
        AssetBundle.new(preprocessor, input, output)
      end
    end

  private

    def generate_meta_data!
      #create a version file with the time and the latest git commit
      version_file = File.open("#{settings.webroot}/version","w")
      version_file.puts "built: #{Time.now.to_s}"
      version_file.puts `git log -1`
      version_file.close

      #create a commit-hash file with just the last commit hash in it
      hash_file = File.open("#{settings.webroot}/commit-hash","w")
      hash_file.print  `git log -1 --format="%H"`.chomp
      hash_file.close
    end

  end
end
