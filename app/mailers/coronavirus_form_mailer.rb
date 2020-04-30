class CoronavirusFormMailer < ApplicationMailer
  self.delivery_job = EmailDeliveryJob

  def confirmation_email(email_address)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @reference_number = params[:reference_number]
    mail(to: email_address, subject: I18n.t("emails.confirmation.subject"))
  end
end
