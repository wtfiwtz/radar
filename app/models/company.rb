class Company < ApplicationRecord
  has_many :dailies
  has_many :daily_summaries
  has_many :chains
  has_many :watchlists, through: :watchlist_companies
  has_many :watchlist_companies
end