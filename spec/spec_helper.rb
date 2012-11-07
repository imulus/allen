def sh(*args)
end

class Fake
  def application
  end
end

Rake = Fake unless defined? Rake


# stfu
$stdout = StringIO.new

