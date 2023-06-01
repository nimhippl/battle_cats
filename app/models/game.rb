class Game < ApplicationRecord
  validates :winner, :left_cat, :right_cat, :number,  presence: true
end
