require 'allen'

module Allen
  module DSL
  end
end

class Settings
  def configure(block)
    instance_eval(&block)
  end

  def method_missing(method, value=nil, &block)
    value = block.call if block
    if value
      instance_variable_set "@#{method}", value
    else
      instance_variable_get "@#{method}"
    end
  end
end

module Allen
  def self.settings
    @settings ||= Settings.new
  end
end

def settings(&block)
  Allen.settings.configure(block)
end

describe Allen::DSL do

  it "can configure the client" do
    settings do
      client "RichMahogany"
      root_dir { "path/to/root/dir" }
    end
    Allen.settings.client.should == "RichMahogany"
    Allen.settings.root_dir.should == "path/to/root/dir"
  end

end

