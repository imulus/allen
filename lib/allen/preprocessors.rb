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

      def self.relative(path)
        path.gsub(Dir.pwd + '/',"")
      end

      def self.build(input, output)
        sh "#{@name} #{relative input}:#{relative output}"
      end

      def self.compress(input, output)
        sh "#{@name} #{relative input}:#{relative output} --compress"
      end

      def self.watch(input, output)
        sh "#{@name} #{relative input}:#{relative output} --watch"
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
        sh "sass #{relative input}:#{relative output} --style expanded"
      end

      def self.compress(input, output)
        sh "sass #{relative input}:#{relative output} --style compressed"
      end

      def self.watch(input, output)
        input_path = relative(input).gsub(/\/\w+\.\w+$/,'')
        output_path = relative(output).gsub(/\/\w+\.\w+$/,'')
        sh "sass --watch #{input_path}:#{output_path} --style expanded"
      end
    end
  end
end

