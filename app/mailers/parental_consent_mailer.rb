class ParentalConsentMailer < ApplicationMailer
  def consent_request_email(consent)
    @consent = consent
    @user    = consent.user
    mail(
      to:      consent.guardian_email,
      subject: "Consent request for #{@user.first_name}"
    )
  end
end
