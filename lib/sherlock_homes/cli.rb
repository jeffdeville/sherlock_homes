module SherlockHomes
  class CLI
    def self.run(address)
      SherlockHomes::Pipeline.new(raw_location: address).run
    end
  end
end
