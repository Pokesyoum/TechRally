class LookForPaper < ApplicationRecord
  belongs_to :user

  validates :look_for_paper, presence: true
end
