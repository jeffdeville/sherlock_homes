require 'open-uri'
require 'tempfile'
require 'fileutils'

module SherlockHomes
  class Downloader
    attr_reader :url, :tmp_file

    def self.store(url)
      new.store_from(url)
    end

    def store_from(url)
      Tempfile.open SecureRandom.hex do |file|
        file << open(url).read
        dest_path = "#{SherlockHomes.config.store_dir}/#{SecureRandom.hex}.#{extension(file.path)}"
        FileUtils.cp file.path, dest_path
        File.open(dest_path)
      end
    end


    def extension(file_path)
      file_type = `file --brief --mime-type #{file_path}`.strip
      case file_type
      when 'image/png', 'image/gif'
        file_type.split('/').last.downcase
      when 'image/jpeg'
        'jpg'
      else
        'unknown'
      end
    end

  end
end

