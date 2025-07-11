class MembershipMailer < ApplicationMailer
  def invitation_email(membership)
    @membership     = membership
    @recipient_name = if membership.user
                        "#{membership.user.first_name} #{membership.user.last_name}"
                      else
                        membership.invite_email
                      end

    mail(
      to: membership.invite_email,
      subject: "You’re invited to join #{membership.organization.name}"
    )
  end
end
