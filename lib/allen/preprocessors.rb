module Allen
  module Preprocessors
    class Preprocessor
      def self.sh_out(cmd)
        sh cmd
      end
    end

    class Coyote < Preprocessor
      def self.build(input, output)
        sh_out "coyote #{input}:#{output}"
      end

      def self.compress(input, output)
        sh_out "coyote #{input}:#{output} --compress"
      end

      def self.watch(input, output)
        sh_out "coyote #{input}:#{output} --watch"
      end
    end

    class Sass < Preprocessor
      def self.build(input, output)
        sh_out "sass #{input}:#{output} --style expanded"
      end

      def self.compress(input, output)
        sh_out "sass #{input}:#{output} --style compressed"
      end

      def self.watch(input_path, output_path)
        sh_out "sass --watch #{input_path}:#{output_path} --style expanded"
      end
    end
  end
end

