module Allen
  module Preprocessors
    class Preprocessor
      extend Rake::DSL if defined? Rake::DSL
    end

    class Coyote < Preprocessor
      def self.build(input, output)
        sh "coyote #{input}:#{output}"
      end

      def self.compress(input, output)
        sh "coyote #{input}:#{output} --compress"
      end

      def self.watch(input, output)
        sh "coyote #{input}:#{output} --watch"
      end
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

