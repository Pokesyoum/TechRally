class PaperStock < ApplicationRecord
  belongs_to :user

  validates :outline, :paper_url, presence: true
end
