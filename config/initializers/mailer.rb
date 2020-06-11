# typed: strict
require "notify_email_delivery_method"
require "notify_sms_delivery_method"

ActionMailer::Base.add_delivery_method :notify_email,
                                       NotifyEmailDeliveryMethod,
                                       api_key: Rails.application.secrets.notify_api_key,
                                       template_id: ENV["GOVUK_NOTIFY_EMAIL_TEMPLATE_ID"]

ActionMailer::Base.add_delivery_method :notify_sms,
                                       NotifySmsDeliveryMethod,
                                       api_key: Rails.application.secrets.notify_api_key,
                                       template_id: ENV["GOVUK_NOTIFY_SMS_TEMPLATE_ID"]
