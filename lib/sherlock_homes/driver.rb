module SherlockHomes
  class Driver

    class << self

      def phantomjs_options
        options = [
          '--ignore-ssl-errors=yes',
          '--ssl-protocol=any',
          '--web-security=no',
          '--load-images=false',
          '--local-to-remote-url-access=true'
        ]

        options << [
          "--proxy=#{SherlockHomes.config.proxy_host}:#{SherlockHomes.config.proxy_port}",
          '--proxy-type=http'
        ] if SherlockHomes.config.proxy?

        options
      end

      def options
        options = {
          js_errors: false,
          debug: false,
          inspector: false,
          timeout: SherlockHomes.config.timeout,
          phantomjs_options: phantomjs_options
        }

        options.merge!(
          logger: nil,
          phantomjs_logger: StringIO.new,
        ) unless SherlockHomes.config.debug?

        options
      end

      def load!
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, options)
        end

        Capybara.configure do |config|
          config.ignore_hidden_elements = false
          config.default_driver    = SherlockHomes.config.driver
          config.javascript_driver = SherlockHomes.config.driver
          config.default_wait_time = SherlockHomes.config.wait_time
        end

      end
    end

  end
end
