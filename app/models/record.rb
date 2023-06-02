class Record < ApplicationRecord
  validates :winner, :left_cat, :right_cat, :number,  presence: true
  belongs_to :user
end
