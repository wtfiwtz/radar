class Crypto < ApplicationRecord
  belongs_to :crypto_currency, optional: true
end