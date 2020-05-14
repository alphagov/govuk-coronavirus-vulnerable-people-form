require "prometheus/middleware/collector"
require "sidekiq_stats_prometheus_exporter"

class ApplicationConfig
  def self.call
    Rack::Builder.app do
      use Prometheus::Middleware::Collector

      map "/metrics" do
        use Rack::Deflater
        use SidekiqStatsPrometheusExporter, path: ""
        run ->(_) { [500, { "Content-Type" => "text/html" }, ["Metrics endpoint is unreachable!"]] }
      end

      run Rails.application
    end
  end
end
