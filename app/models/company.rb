class Company < ApplicationRecord
  has_many :dailies
  has_many :daily_summaries
  has_many :chains
end