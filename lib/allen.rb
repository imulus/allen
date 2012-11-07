require 'thor'
require 'allen/cli'
require 'allen/version'

module Allen
  def self.settings
    @settings ||= Settings.new
  end

  def self.projects
    @projects ||= []
  end

  def self.reset!
    @settings = nil
    @projects = nil
  end
end

