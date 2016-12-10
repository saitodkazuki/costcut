class Expense < ApplicationRecord
  validates :paid_at, presence: true
  validates :amount, presence: true
  validates :tag, presence: true
end
