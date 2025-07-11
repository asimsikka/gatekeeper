class Content < ApplicationRecord
  belongs_to :user
  belongs_to :content_space

  validates :title, :age_rating, presence: true
  validates :age_rating,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def accessible_by?(user)
    user.age >= age_rating
  end
end
