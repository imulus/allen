require 'bundler'
require 'allen/dsl'

module Allen
  module RakeDSL
    def define_tasks
      Allen.define_tasks
    end
  end

  def self.define_tasks
    define_convenience_tasks
    define_solution_tasks
    define_deploy_tasks
    define_assets_tasks
    define_project_tasks
  end


  def self.define_convenience_tasks
    Rake.application.in_namespace(nil) do
      # Default Tasks
      task :default => :build

      # Build Task
      desc "Build the solution in debug mode and compile all assets"
      task :build => ['assets:build', 'deploy:build'] do
        Rake.application.invoke_task('solution:msbuild["debug"]')
      end

      # Release Build
      desc "Build the solution in release mode, compile and compress all assets"
      task :release => ['assets:build', 'assets:compress'] do
        Rake.application.invoke_task('solution:msbuild["release"]')
      end
    end
  end


  def self.define_solution_tasks
    Rake.application.in_namespace("solution") do
      desc "Build the solution with a chosen configuration"
      msbuild :msbuild, :config do |msb, args|
        msb.solution   = "#{settings.solution}"
        msb.properties = { :configuration => args.config.to_sym }
        msb.parameters = settings.parameters
        msb.targets    = settings.targets
      end
    end
  end


  def self.define_deploy_tasks
    Rake.application.in_namespace("deploy") do
      desc "Creates files for deployment"
      task :build do
        #create a version file with the time and the latest git commit
        version_file = File.open("#{settings.webroot}/version","w")
        version_file.puts "built: #{Time.now.to_s}"
        version_file.puts `git log -1`
        version_file.close

        #create a commit-hash file with just the last commit hash in it
        hash_file = File.open("#{settings.webroot}/commit-hash","w")
        hash_file.print  `git log -1 --format="%H"`.chomp
        hash_file.close
      end
    end
  end


  def self.define_assets_tasks
    Rake.application.in_namespace("assets") do
      desc "Watches assets for every project"
      multitask :watch => projects.map(&:name).each { |name| "#{name.downcase}:assets:watch" }

      desc "Builds assets for every project"
      task :build => projects.map(&:name).each { |name| "#{name.downcase}:assets:build" }

      desc "Compresses assets for every project"
      task :compress => projects.map(&:name).each { |name| "#{name.downcase}:assets:compress" }
    end
  end


  def self.define_project_tasks
    projects.each do |project|
      Rake.application.in_namespace(project.name.downcase) do
        desc "Build the #{project.name} project in debug mode and compile assets"
        task :build => ['assets:build'] do
          Rake.application.invoke_task(project.name.downcase + ':msbuild["debug"]')
        end

        desc "Build the #{project.name} project in debug mode"
        msbuild :msbuild, :config do |msb, args|
          msb.solution   = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.client}.#{project.name}.csproj"
          msb.properties = { :configuration => args.config.to_sym }
          msb.parameters = project.settings.parameters
          msb.targets    = project.settings.targets
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
          coyote do |config|
            config.input  = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.css_input}"
            config.output = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.css_output}"
          end
        end

        namespace :js do
          desc "Builds JS for the #{project.name} project"
          coyote do |config|
            config.input  = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_input}"
            config.output = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_output}"
          end
        end
      end
    end
  end
end

include Allen::DSL
include Allen::RakeDSL

