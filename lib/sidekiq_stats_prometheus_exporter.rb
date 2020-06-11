# typed: false
require "sidekiq/api"
require "prometheus/middleware/exporter"

class SidekiqStatsPrometheusExporter < Prometheus::Middleware::Exporter
  def initialize(app, options = {})
    super(app, options)

    @prometheus = Prometheus::Client.registry

    @sidekiq_total_processed_jobs = @prometheus.gauge(:sidekiq_processed_jobs, docstring: "The number of jobs processed by sidekiq")
    @sidekiq_total_failed_jobs = @prometheus.gauge(:sidekiq_failed_jobs, docstring: "The number of failed sidekick jobs")
    @sidekiq_total_dead_jobs = @prometheus.gauge(:sidekiq_dead_jobs, docstring: "The number of jobs dead sidekiq jobs")
    @sidekiq_mailers_queue_size = @prometheus.gauge(:sidekiq_mailers_queue_size, docstring: "The number of jobs in the 'mailers' queue")
    @sidekiq_mailers_queue_latency = @prometheus.gauge(:sidekiq_mailers_queue_latency, docstring: "The latency of the sideqkiq 'mailers' queue")
  end

  def gather_sidekick_metrics
    stats = Sidekiq::Stats.new
    mailer_queue = Sidekiq::Queue.new("mailers")
    @sidekiq_total_processed_jobs.set(stats.processed)
    @sidekiq_total_failed_jobs.set(stats.failed)
    @sidekiq_total_dead_jobs.set(stats.dead_size)
    @sidekiq_mailers_queue_size.set(mailer_queue.size)
    @sidekiq_mailers_queue_latency.set(mailer_queue.latency)
  rescue StandardError => e
    Rails.logger.error ["Error gathering sidekiq stats", e.message, *e.backtrace].join($INPUT_RECORD_SEPARATOR)
  end

  def respond_with(format)
    gather_sidekick_metrics
    [
      200,
      { "Content-Type" => format::CONTENT_TYPE },
      [format.marshal(@registry)],
    ]
  end
end
