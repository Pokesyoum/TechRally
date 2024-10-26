class Rally < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, :abstract, :conclusion, :opinion, :url, presence: true
end
