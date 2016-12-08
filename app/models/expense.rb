class Expense < ApplicationRecord
  validates :title, presence: true
end
