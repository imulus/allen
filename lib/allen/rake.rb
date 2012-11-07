require 'bundler'
require 'allen/dsl'
require 'allen/task_definer'

module Allen
  module RakeDSL
    def define_tasks
      TaskDefiner.new(Allen.settings, Allen.projects).define_tasks
    end
  end
end

include Allen::DSL
include Allen::RakeDSL

