class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rallies
  has_many :comments
  has_many :user_missions
  has_many :missions, through: :user_missions
  has_many :look_for_papers
  has_many :paper_stock

  def self.with_few_missions(limit = 2)
    joins('LEFT JOIN user_missions ON users.id = user_missions.user_id AND user_missions.completed = false')
      .group('users.id')
      .having('COUNT(user_missions.id) <= ?', limit)
  end

  def completed_mission_ids
    user_missions.where(completed: false).pluck(:mission_id)
  end

  def assign_new_mission(mission_id)
    user_missions.create(mission_id:, completed: false)
  end

  def self.assign_missions
    with_few_missions.each do |user|
      completed_mission_ids = user.completed_mission_ids
      available_mission_ids = (1..5).to_a - completed_mission_ids
      next if available_mission_ids.empty?

      mission_id = available_mission_ids.sample
      user.assign_new_mission(mission_id)
    end
  end
end
