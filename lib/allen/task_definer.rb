require 'albacore'

module Allen
  class TaskDefiner
    attr_accessor :settings, :projects

    def initialize(settings, projects)
      extend Rake::DSL if defined? Rake::DSL
      @settings = settings
      @projects = projects
    end

    def define_tasks
      task :default => :build

      desc "Build the solution in debug mode and compile all assets"
      task :build => ['assets:build', 'solution:msbuild']

      namespace :solution do
        desc "Build the solution with a chosen configuration"
        msbuild :msbuild do |msb|
          msb.solution   = "#{settings.solution}"
          msb.properties = { :configuration => :release }
          msb.parameters = settings.parameters
          msb.targets    = settings.targets
        end
      end

      namespace :assets do
        desc "Watches assets for every project"
        multitask :watch => projects.map { |project| "#{project.name.downcase}:assets:watch" }

        desc "Builds assets for every project"
        task :build => projects.map { |project| "#{project.name.downcase}:assets:build" }

        desc "Compresses assets for every project"
        task :compress => projects.map { |project| "#{project.name.downcase}:assets:compress" }
      end

      projects.each do |project|
        namespace project.name.downcase do
          desc "Build the #{project.name} project in debug mode and compile assets"
          task :build do
            project.build!
          end

          task :install do
            project.install!
          end

          namespace :assets do
            desc "Watches assets for the #{project.name} project"
            multitask :watch => ['css:watch', 'js:watch']

            desc "Builds assets for the #{project.name} project"
            multitask :build => ['css:build', 'js:build']

            desc "Compresses assets for the #{project.name} project"
            multitask :compress => ['css:compress', 'js:compress']
          end

          namespace :css do
            desc "Builds CSS for the #{project.name} project"
            task :build do
              project.css.build!
            end

            desc "Compresses CSS for the #{project.name} project"
            task :compress do
              project.css.compress!
            end

            desc "Watches CSS for the #{project.name} project"
            task :watch do
              project.css.watch!
            end
          end

          namespace :js do
            desc "Builds JS for the #{project.name} project"
            task :build do
              project.js.build!
            end

            desc "Compresses JS for the #{project.name} project"
            task :compress do
              project.js.compress!
            end

            desc "Watches JS for the #{project.name} project"
            task :watch do
              project.js.watch!
            end
          end
        end
      end
    end
  end
end
