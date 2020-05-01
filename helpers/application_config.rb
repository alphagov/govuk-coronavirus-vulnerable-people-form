require "prometheus/middleware/collector"
require "prometheus/middleware/exporter"

class ApplicationConfig
  def self.call
    Rack::Builder.app do
      use Prometheus::Middleware::Collector

      map "/metrics" do
        use Rack::Deflater
        use Prometheus::Middleware::Exporter, path: ""
        run ->(_) { [500, { "Content-Type" => "text/html" }, ["Metrics endpoint is unreachable!"]] }
      end

      run Rails.application
    end
  end
end
