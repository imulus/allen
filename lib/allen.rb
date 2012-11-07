require 'thor'
require 'allen/cli'
require 'allen/version'

module Allen
  def self.settings
    @settings ||= Settings.new
  end

  def self.projects
    @project ||= []
  end
end

