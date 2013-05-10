require 'grit'

module Allen
  class MetaData
    attr_reader :root_dir, :webroot

    def initialize(settings)
      @root_dir = settings.root_dir
      @webroot = settings.webroot
    end

    def save!
      file = File.open("#{@webroot}/meta.json","w")
      file.print(self.to_json)
      file.close
    end

    def to_json
      { :build => build,
        :commit => commit,
        :allen => allen }.to_json
    end

    def build
      { :date => Time.now.to_s }
    end

    def commit
      repo = Grit::Repo.new(@root_dir)
      commit = repo.commits.first || NullCommit.new

      { :id => commit.id,
        :date => commit.committed_date,
        :author => commit.author,
        :message => commit.message }
    end

    def allen
      { :version => Allen::VERSION }
    end

    class NullCommit
      def method_missing(*args)
        "xxx"
      end
    end

  end
end
