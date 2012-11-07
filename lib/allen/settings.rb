module Allen
  class Settings
    def configure(block)
      instance_eval(&block)
    end

    def method_missing(method, value=nil, &block)
      value = block.call if block
      if !value.nil?
        instance_variable_set "@#{method}", value
      else
        instance_variable_get "@#{method}"
      end
    end
  end
end

