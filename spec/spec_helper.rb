def sh(*args)
end

module Fake
  class Task
    def self.define_task(*args)
    end
  end

  module DSL
  end

  def self.application
  end
end

Rake = Fake unless defined? Rake


# stfu
$stdout = StringIO.new

