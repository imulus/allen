require 'allen'
require 'allen/project'
require 'allen/settings'

module Allen
  module DSL
    def settings(&block)
      Allen.settings.configure(block)
    end

    def project(name, &block)
      project = Allen::Project.new(name, block)
      Allen.projects << project
      project
    end
  end
end

