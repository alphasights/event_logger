require_relative "helper"
require "minitest/autorun"
require "event_logger"
require "json"

class TestLogger < Minitest::Test
  def test_standard_request
    logger = EventLogger::Logger.new(
      application: "brazil",
      environment: "development",
      host: "https://elasticsearch.dev:9200",
      username: "foo",
      password: "bar",
    )

    expected_json = %q({"interaction_id":12345,"type":"analyst_picked_up","timestamp":"2012-01-02T03:04:05-06:00","twilio_code":"12345","attempts":2,"advisor":{"name":"John Bohn","email":"jjbohn@gmail.com","phone":"555-521-6937"},"client":{"name":"A Client","email":"client@example.com","phone":"555-344-1790"},"analyst":{"name":"Sandy Reid","email":"the.sandy@alphasights.com","phone":"555-813-8113"},"application":"brazil","environment":"development"})
     stub_request(:post, "https://foo:bar@elasticsearch.dev:9200/data/event").
       with(body: expected_json,
            headers: {"Accept" => "application/json",
                      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                      "Host" => "elasticsearch.dev:9200",
                      "User-Agent" => "AlphaSightsEventLogger/EventLogger::Logger (+https://github.com/alphasights/event_logger)"})

    logger.event!(interaction_id: 12345,
      type: :analyst_picked_up,
      timestamp: Time.new(2012, 1, 2, 3, 4, 5, "-06:00"),
      twilio_code: "12345",
      attempts: 2,
      advisor: { name: "John Bohn",  email: "jjbohn@gmail.com", phone: "555-521-6937" },
      client: { name: "A Client", email: "client@example.com", phone: "555-344-1790" },
      analyst: { name: "Sandy Reid", email: "the.sandy@alphasights.com", phone: "555-813-8113" })
  end

  def test_no_requests_are_made_when_fake_requests_is_true
    logger = EventLogger::Logger.new(
      application: "brazil",
      environment: "development",
      host: "https://elasticsearch.dev:9200",
      username: "foo",
      password: "bar",
      fake_requests: true,
    )

    logger.event!(interaction_id: 12345,
      type: :analyst_picked_up,
      timestamp: Time.new(2012, 1, 2, 3, 4, 5, "-06:00"),
      twilio_code: "12345",
      attempts: 2,
      advisor: { name: "John Bohn",  email: "jjbohn@gmail.com", phone: "555-521-6937" },
      client: { name: "A Client", email: "client@example.com", phone: "555-344-1790" },
      analyst: { name: "Sandy Reid", email: "the.sandy@alphasights.com", phone: "555-813-8113" })
  end
end
