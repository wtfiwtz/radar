class Chain < ApplicationRecord
  belongs_to :company, optional: true
end