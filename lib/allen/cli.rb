require 'active_support/all'

module Allen
  class Cli < Thor
    include Thor::Actions

    attr_reader :name
    source_paths << File.expand_path("../../../templates",__FILE__)

    desc "new ClientName", "Initialize an Umbraco project"
    def new(name)
      @name = name.gsub(/\W/, '_').squeeze('_').camelize
      @umbraco_guid = guid
      @umbraco_assembly_guid = guid.downcase
      @umbraco_extensions_guid = guid
      @umbraco_extensions_assembly_guid = guid.downcase

      empty_directory 'lib'
      directory       'src'
      template        '.gitignore'
      template        'README.md.tt'
      template        'Rakefile'
      template        'Gemfile'
    end

    no_tasks do
      def guid
        SecureRandom.uuid.to_s.upcase
      end
    end
  end
end

