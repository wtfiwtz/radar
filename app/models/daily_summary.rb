class DailySummary < ApplicationRecord
  belongs_to :company, optional: true
end