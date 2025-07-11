class ConsentMailer < ApplicationMailer
  default from: "no-reply@gatekeeper.com"

  def approval_email(user, approver_email)
    @user = user
    @approval_url = approve_consents_url(token: user.consent_token)
    mail(to: approver_email, subject: "Approve Access for #{@user.email}")
  end

  def consent_request_email(consent)
    @consent = consent
    @user    = consent.user
    mail(
      to: @consent.guardian_email,
      subject: "Consent request for #{@user.name}"
    )
  end
end
