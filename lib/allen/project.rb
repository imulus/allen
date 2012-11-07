require 'allen/settings'

module Allen
  class Project
    attr_accessor :name, :settings

    def initialize(name="Umbraco", block=nil)
      @name = name
      @settings = Allen.settings.clone
      @settings.configure do
        name name
      end
      @settings.configure(block) if block
    end
  end
end
