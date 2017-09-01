class CreateCrypto < ActiveRecord::Migration[5.1]
  def change
    create_table :cryptos do |t|
      t.datetime :date
      t.string :sym
      t.string :name
      t.string :symbol
      t.integer :rank
      t.decimal :price_usd
      t.decimal :price_btc
      t.decimal :volume_24h_usd
      t.decimal :market_cap_usd
      t.float :available_supply
      t.float :total_supply
      t.float :percent_change_1h
      t.float :percent_change_24h
      t.float :percent_change_7d
      t.integer :last_updated
    end
  end
end
