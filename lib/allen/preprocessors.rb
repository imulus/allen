module Allen
  module Preprocessors

    def self.for(name)
      begin
        const_get(name.capitalize)
      rescue
        raise StandardError, "unknown preprocessor: #{name}"
      end
    end

    class Preprocessor
      extend Rake::DSL if defined? Rake::DSL

      class << self
        attr_accessor :name
        alias_method :name,:name=
      end

      name :echo

      def self.build(input, output)
        sh "#{@name} #{input}:#{output}"
      end

      def self.compress(input, output)
        sh "#{@name} #{input}:#{output} --compress"
      end

      def self.watch(input, output)
        sh "#{@name} #{input}:#{output} --watch"
      end
    end

    class Coyote < Preprocessor
      name :coyote
    end

    class Banshee < Preprocessor
      name :banshee
    end

    class Sass < Preprocessor
      def self.build(input, output)
        sh "sass #{input}:#{output} --style expanded"
      end

      def self.compress(input, output)
        sh "sass #{input}:#{output} --style compressed"
      end

      def self.watch(input, output)
        input_path = input.gsub(/\/\w+\.\w+$/,'')
        output_path = output.gsub(/\/\w+\.\w+$/,'')
        sh "sass --watch #{input_path}:#{output_path} --style expanded"
      end
    end
  end
end

