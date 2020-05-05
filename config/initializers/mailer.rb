require "notify_email_delivery_method"

ActionMailer::Base.add_delivery_method :notify_email,
                                       NotifyEmailDeliveryMethod,
                                       api_key: Rails.application.secrets.notify_api_key,
                                       template_id: ENV["GOVUK_NOTIFY_EMAIL_TEMPLATE_ID"]
