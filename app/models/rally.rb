class Rally < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, :abstract, :conclusion, :opinion, :url, presence: true

  scope :top_users, -> { select('user_id, COUNT(user_id) AS user_count').group(:user_id).order('user_count DESC').limit(3) }
  scope :monthly_top_users, lambda {
    where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_month, Time.now.end_of_month)
      .top_users
  }
end
