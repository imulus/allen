require 'allen'
require 'allen/project'
Dir[File.dirname(__FILE__) + '/projects/*.rb'].each {|file| require file }
require 'allen/settings'

module Allen
  module DSL
    def settings(&block)
      Allen.settings.configure(block)
    end

    def project(name, &block)
      settings = Allen.settings.clone
      settings.configure(block)
      klass = Allen.const_get (settings.type.to_s + "_project").classify
      project = klass.new(name, settings)
      Allen.projects << project
      project
    end
  end
end

