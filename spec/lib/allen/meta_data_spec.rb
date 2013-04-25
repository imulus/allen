require 'allen'
require 'allen/meta_data'

describe Allen::MetaData do
  let(:root_dir)  { "/dev/null" }
  let(:webroot)   { root_dir + "/the_webroot" }
  let(:settings)  { stub(:settings, :root_dir => root_dir, :webroot => webroot) }
  let(:meta_data) { Allen::MetaData.new(settings) }

  describe "#save!" do
    it "saves the JSON blob to the webroot" do
      meta_data.stub(:to_json).and_return("json blob")
      file = stub(:file)
      File.should_receive(:open).with("/dev/null/the_webroot/meta.json", "w").and_return(file)
      file.should_receive(:print).with(meta_data.to_json)
      file.should_receive(:close)
      meta_data.save!
    end
  end

  describe "#to_json" do
    it "returns a blob with build and commit information" do
      meta_data.stub(:build).and_return({ :date => "build date" })
      meta_data.stub(:commit).and_return({ :id => "commit id",
                                           :date => "commit date",
                                           :author => "commit author",
                                           :message => "commit message" })
      meta_data.stub(:allen).and_return({ :version => "allen version" })
      meta_data.to_json.should == "{\"build\":{\"date\":\"build date\"},\"commit\":{\"id\":\"commit id\",\"date\":\"commit date\",\"author\":\"commit author\",\"message\":\"commit message\"},\"allen\":{\"version\":\"allen version\"}}"
    end
  end

  describe "#build" do
    it "includes information about the build" do
      date = stub(:date, :to_s => "build date")
      Time.stub(:now).and_return(date)
      meta_data.build.should == { :date => "build date" }
    end
  end

  describe "#commit" do
    it "includes information about the most recent commit" do
      repo = stub(:repo, :commits => [stub(:commit, :id => "commit id",
                                                    :committed_date => "commit date",
                                                    :author => "commit author",
                                                    :message => "commit message")])

      Grit::Repo.should_receive(:new).with("/dev/null").and_return(repo)

      meta_data.commit.should == { :id => "commit id",
                                   :date => "commit date",
                                   :author => "commit author",
                                   :message => "commit message" }
    end

    it "includes no information when there are no commits" do
      repo = stub(:repo, :commits => [])
      Grit::Repo.should_receive(:new).with("/dev/null").and_return(repo)
      meta_data.commit.should == { :id => "xxx",
                                   :date => "xxx",
                                   :author => "xxx",
                                   :message => "xxx" }
    end
  end
end

