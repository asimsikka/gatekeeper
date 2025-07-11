class User < ApplicationRecord
  MINIMUM_AGE = 13
  AGE_GROUPS = {
    minor: 0..12,
    teen: 13..17,
    adult: 18..Float::INFINITY
  }.freeze
  AGE_TARGETS = AGE_GROUPS.keys.freeze
  UNKNOWN_AGE_GROUP = :unknown
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  has_many :parental_consents, dependent: :destroy
  has_many :contents, dependent: :destroy

  validates :first_name, :last_name, :date_of_birth, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validate :age_must_be_valid

  # TODO: evaluate whether this is needed or not :|
  # validates :parental_consent, acceptance: true, if: -> { underage? }

   AGE_TARGETS.each do |group|
    define_method("#{group}?") do
      age_group == group
    end
  end

  def age_group
    return UNKNOWN_AGE_GROUP unless date_of_birth.present?

    current_age = calculate_age
    return UNKNOWN_AGE_GROUP if current_age.nil? || current_age.negative?

    AGE_GROUPS.each do |group, range|
      return group if range.cover?(current_age)
    end

    UNKNOWN_AGE_GROUP
  end

  def underage?
    age.present? && age < MINIMUM_AGE
  end

  def age
    calculate_age
  end

  def unknown_age_group?
    age_group == UNKNOWN_AGE_GROUP
  end

  def needs_parental_consent?
    (minor? || teen?) && !parental_consent?
  end

  def generate_consent_token!
    update!(
      consent_token: SecureRandom.hex(20),
      consent_sent_at: Time.current
    )
  end

  def approve_consent!
    update!(
      parental_consent: true,
      consent_token: nil,
      consent_approved_at: Time.current
    )
  end

  private

  def age_must_be_valid
    if date_of_birth.present? && date_of_birth > Time.zone.today
      errors.add(:date_of_birth, "can't be in the future")
    end
  end

  def calculate_age
    return 0 unless date_of_birth
    now = Time.zone.today
    now.year - date_of_birth.year - (now.yday < date_of_birth.yday ? 1 : 0)
  end
end
