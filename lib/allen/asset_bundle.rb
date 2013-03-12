module Allen
  class AssetBundle < Struct.new(:preprocessor, :input, :output)
    def build
      Bundler.with_clean_env { preprocessor.build(input, output) }
    end

    def compress
      Bundler.with_clean_env { preprocessor.compress(input, output) }
    end

    def watch
      Bundler.with_clean_env { preprocessor.watch(input, output) }
    end

    alias_method :build!, :build
    alias_method :watch!, :watch
    alias_method :compress!, :compress
  end


  class AssetBundleCollection < Struct.new(:js_bundle, :css_bundle)
    def bundles
      [js_bundle, css_bundle]
    end

    def build
      bundles.each(&:build)
    end

    def compress
      bundles.each(&:compress)
    end

    def watch
      bundles.each(&:watch)
    end

    alias_method :build!, :build
    alias_method :watch!, :watch
    alias_method :compress!, :compress
  end
end

