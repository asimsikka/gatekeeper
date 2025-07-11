class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :content_spaces, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :email_domain,
            format: { with: /\A[\w\.\-]+\.[A-Za-z]{2,}\z/ },
            allow_blank: true
end
