class CoronavirusFormMailer < ApplicationMailer
  self.delivery_job = EmailDeliveryJob

  def confirmation_email(email_address)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @reference_number = params[:reference_number]
    @contact_gp = params[:contact_gp]

    mail(
      to: email_address,
      subject: I18n.t("emails.confirmation.subject"),
      delivery_method: :notify_email,
    )
  end

  def confirmation_sms(telephone_number)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @reference_number = params[:reference_number]
    @contact_gp = params[:contact_gp]

    mail(
      to: telephone_number,
      delivery_method: :notify_sms,
    )
  end
end
