require "net/https"
require "json"

module EventLogger
  class Logger
    def initialize(application:, environment:, host:, type: "event", fake_requests: false)
      @application = application
      @environment = environment
      @host = host
      @type = type
      @fake_requests = fake_requests
    end

    def event!(data)
      return if @fake_requests

      data = clone_data(data)
      data["application"] = @application
      data["environment"] = @environment
      transform_dates!(data)

      uri = URI.parse("#{@host}/data/#{@type}")
      client = Net::HTTP.new(uri.host, uri.port)
      headers = { "User-Agent" => "AlphaSightsEventLogger/#{EventLogger::Logger} (+https://github.com/alphasights/event_logger)", "Accept" => "application/json" }
      post = Net::HTTP::Post.new(uri, headers)
      client.use_ssl = uri.scheme == "https"

      client.request(post, JSON.generate(data))
    end

    private

    def clone_data(data)
      Marshal.load(Marshal.dump(data))
    end

    def transform_dates!(data)
      data.each do |k, v|
        if v.is_a?(Hash)
          transform_dates!(v)
        elsif v.is_a?(Time) || v.is_a?(Date) || v.is_a?(DateTime)
          data[k] = v.iso8601
        end
      end
    end
  end
end
