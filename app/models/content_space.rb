class ContentSpace < ApplicationRecord
  belongs_to :organization

  has_many   :contents, dependent: :destroy

  validates :name, :min_age, :max_age, presence: true
  validates :min_age, :max_age,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate  :min_le_max

  private

  def min_le_max
    errors.add(:min_age, "must be ≤ max_age") if min_age > max_age
  end
end
