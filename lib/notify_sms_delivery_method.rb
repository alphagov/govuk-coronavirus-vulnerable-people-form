# typed: true
require "notifications/client"

class NotifySmsDeliveryMethod
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    client.send_sms(payload(mail))
  end

private

  def client
    @client ||= Notifications::Client.new(settings[:api_key])
  end

  def payload(mail)
    {
      phone_number: mail.to.first,
      template_id: settings[:template_id],
      personalisation: {
        message: mail.body.raw_source,
      },
    }
  end
end
