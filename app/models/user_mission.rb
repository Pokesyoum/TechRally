class UserMission < ApplicationRecord
  has_many :users
  has_many :missions
end
