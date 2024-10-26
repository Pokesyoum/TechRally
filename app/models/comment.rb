class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :rally

  validates :content, presence: true
end
