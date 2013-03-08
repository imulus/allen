require 'active_support/all'
require 'securerandom'

module Allen
  class Cli < Thor
    include Thor::Actions

    attr_reader :name
    source_paths << File.expand_path("../../../templates",__FILE__)

    desc "new ClientName", "Initialize an Umbraco project"
    def new(name)
      @full_name = name
      @name = File.basename(File.expand_path(name)).gsub(/\W/, '_').squeeze('_').camelize
      self.destination_root = File.join(File.dirname(File.expand_path(name)), @name)

      empty_directory destination_root

      @umbraco_guid = guid
      @umbraco_assembly_guid = guid.downcase
      @umbraco_extensions_guid = guid
      @umbraco_extensions_assembly_guid = guid.downcase
      @nuget_guid = guid

      directory 'src'
      directory 'src/.nuget'
      template  '.gitignore'
      template  'README.md.tt'
      template  'Rakefile.tt'
      template  'Gemfile.tt'

      system "git init #{destination_root}"
    end

    no_tasks do
      def guid
        SecureRandom.uuid.to_s.upcase
      end
    end
  end
end
