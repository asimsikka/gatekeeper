class ParentalConsent < ApplicationRecord
  belongs_to :user

  before_validation :generate_token, on: :create

  validates :guardian_email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  def approve!
    update!(approved: true, approved_at: Time.current)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end
