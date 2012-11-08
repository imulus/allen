require 'albacore'

module Allen
  class TaskDefiner
    include Rake::DSL
    attr_accessor :settings, :projects

    def initialize(settings, projects)
      @settings = settings
      @projects = projects
    end

    def define_tasks
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

      namespace :solution do
        desc "Build the solution with a chosen configuration"
        msbuild :msbuild, :config do |msb, args|
          msb.solution   = "#{settings.solution}"
          msb.properties = { :configuration => args.config.to_sym }
          msb.parameters = settings.parameters
          msb.targets    = settings.targets
        end
      end

      namespace :deploy do
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
            input  = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.css_input}"
            output = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.css_output}"

            task :build do
              Bundler.with_clean_env do
                sh "#{project.settings.css_preprocessor} #{input}:#{output}"
              end
            end

            task :compress do
              Bundler.with_clean_env do
                sh "#{project.settings.css_preprocessor} #{input}:#{output} -c"
              end
            end

            task :watch do
              Bundler.with_clean_env do
                sh "#{project.settings.css_preprocessor} #{input}:#{output} -w"
              end
            end
          end

          namespace :js do
            desc "Builds JS for the #{project.name} project"
            input  = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_input}"
            output = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_output}"

            task :build do
              Bundler.with_clean_env do
                sh "#{project.settings.js_preprocessor} #{input}:#{output}"
              end
            end

            task :compress do
              Bundler.with_clean_env do
                sh "#{project.settings.js_preprocessor} #{input}:#{output} -c"
              end
            end

            task :watch do
              Bundler.with_clean_env do
                sh "#{project.settings.js_preprocessor} #{input}:#{output} -w"
              end
            end
          end
        end
      end
    end
  end
end

