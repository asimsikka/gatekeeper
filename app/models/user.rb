class User < ApplicationRecord
  MINIMUM_AGE = 18
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  validates :date_of_birth, presence: true
  validate :age_must_be_valid

  validates :parental_consent, acceptance: true, if: -> { underage? }

  def age
    return 0 unless date_of_birth
    now = Time.zone.today
    now.year - date_of_birth.year - (now.yday < date_of_birth.yday ? 1 : 0)
  end

  def underage?
    age.present? && age < MINIMUM_AGE
  end

  private

  def age_must_be_valid
    if date_of_birth.present? && date_of_birth > Time.zone.today
      errors.add(:date_of_birth, "can't be in the future")
    end
  end
end
