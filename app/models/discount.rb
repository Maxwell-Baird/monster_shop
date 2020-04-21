class Discount < ApplicationRecord
  belongs_to :merchant

  validates_inclusion_of :percent, in: 1..100
end
