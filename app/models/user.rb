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
end
