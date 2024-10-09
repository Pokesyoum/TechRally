class Mission < ApplicationRecord
  has_many :user_missions
  has_many :users, through: :user_missions
end
