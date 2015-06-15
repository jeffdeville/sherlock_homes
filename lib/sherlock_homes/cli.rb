module SherlockHomes
  class CLI
    def self.run(address)
      puts SherlockHomes::Pipeline.new(raw_location: address).run.context.property.inspect
    end
  end
end
