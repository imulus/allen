class Settings
  def configure(configuration=nil, &block)
    instance_eval(&configuration) if configuration
    instance_eval(&block) if block
  end

  def method_missing(method, value=nil, &block)
    set(method, value, block) if !value.nil? or block
    get(method)
  end

  private

  def set(name, value, block)
    instance_variable_set "@#{name}", !value.nil? ? value : block
  end

  def get(name)
    value = instance_variable_get "@#{name}"
    value = value.call if value.respond_to? :call
    value
  end
end
