class UserMission < ApplicationRecord
  belongs_to :user
  belongs_to :mission

  scope :top_users, lambda {
    where(completed: true).select('user_id, COUNT(user_id) AS user_count').group(:user_id).order('user_count DESC').limit(3)
  }
  scope :monthly_top_users, lambda {
    where('completed = ? AND created_at >= ? AND created_at <= ?', true, Time.now.beginning_of_month, Time.now.end_of_month)
      .select('user_id, COUNT(user_id) AS user_count')
      .group(:user_id)
      .order('user_count DESC')
      .limit(3)
  }
end
