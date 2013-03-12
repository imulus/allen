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


      namespace :umbraco do
        task :install do
          packages = Nokogiri::XML(File.read("#{settings.webroot}/packages.config"))
          umbraco  = packages.xpath("//package[@id='UmbracoCms']")

          package_name    = umbraco.xpath('@id').text
          package_version = umbraco.xpath('@version').text
          package_path    = "#{src_dir}/packages/#{package_name}.#{package_version}/UmbracoFiles"

          ['umbraco', 'umbraco_client', 'install'].map do |directory|
            File.join package_path, directory
          end.each do |directory|
            cp_r directory, settings.webroot
          end
        end
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
            preprocessor = project.css_preprocessor

            task :build do
              Bundler.with_clean_env { preprocessor.build(input, output) }
            end

            task :compress do
              Bundler.with_clean_env { preprocessor.compress(input, output) }
            end

            task :watch do
              Bundler.with_clean_env { preprocessor.watch(input, output) }
            end
          end

          namespace :js do
            desc "Builds JS for the #{project.name} project"
            input  = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_input}"
            output = "#{project.settings.src_dir}/#{project.settings.client}.#{project.name}/#{project.settings.js_output}"
            preprocessor = project.js_preprocessor

            task :build do
              Bundler.with_clean_env { preprocessor.build(input, output) }
            end

            task :compress do
              Bundler.with_clean_env { preprocessor.compress(input, output) }
            end

            task :watch do
              Bundler.with_clean_env { preprocessor.watch(input, output) }
            end
          end
        end
      end
    end
  end
end

