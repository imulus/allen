require 'allen/rake'

describe "included modules" do
  it "includes the DSL on kernel" do
    Kernel.methods.should include :project, :settings
  end
end

