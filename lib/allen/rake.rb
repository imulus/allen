require 'bundler'
require 'allen/dsl'

module Allen
  module RakeDSL
    def define_tasks
      Allen.define_tasks
    end
  end

  def self.define_tasks
    Allen.projects.each do |project|
      Rake.application.in_namespace(project.name.downcase) do
      end
    end
  end
end

include Allen::DSL
include Allen::RakeDSL

