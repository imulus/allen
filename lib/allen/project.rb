require 'allen/settings'

module Allen
  class Project
    attr_accessor :name, :settings

    def initialize(name, block)
      @name = name
      @settings = Settings.new
      @settings.configure(block) if block
    end
  end
end
