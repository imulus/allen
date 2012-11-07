require 'bundler'
require 'allen/dsl'
include Allen::DSL

module Allen
  def self.define_tasks
    load_dependencies
  end

  def self.exec(command)
    sh command
  end

  def self.fail!
    exit 1
  end

  def self.load_dependencies
    begin
      Bundler.require
    rescue
      puts "Installing missing dependencies...\n\n"
      exec "bundle install"
      puts "\nFTFY. Please try again."
      fail!
    end
  end
end

