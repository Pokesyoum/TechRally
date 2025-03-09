class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :name
    validates :email
    validates :password,
              format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/, message: 'must include both letters and numbers' }
  end

  has_many :rallies
  has_many :comments
  has_many :user_missions
  has_many :missions, through: :user_missions
  has_many :look_for_papers
  has_many :paper_stocks

  scope :with_few_missions, lambda { |limit = 2|
    left_outer_joins(:user_missions)
      .where('user_missions.completed = false OR user_missions.id IS NULL')
      .group('users.id')
      .having('COUNT(user_missions.id) <= ?', limit)
  }

  def assigned_mission_ids
    user_missions.where(completed: false).pluck(:mission_id)
  end

  def assign_new_mission(mission_id)
    user_missions.create(mission_id:, completed: false)
  end
end
