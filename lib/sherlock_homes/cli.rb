module SherlockHomes
  class CLI

    def self.run(address)
      property = SherlockHomes::Pipeline.new(raw_location: address).run.context.property
      write_to_file(address, property)
      download_images(property)
    end

    def self.write_to_file(address, property)
      f = File.open("#{address.titleize.gsub(/[^\w]/,"").underscore}.json","w")
      f.write(property.to_json)
      f.close
    end

    def self.download_images(property)
      SherlockHomes::Downloader.store(property.neighborhood_stats_chart)
    end

  end
end
