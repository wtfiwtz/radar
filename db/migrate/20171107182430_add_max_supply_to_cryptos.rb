class AddMaxSupplyToCryptos < ActiveRecord::Migration[5.1]
  def change
    add_column :cryptos, :max_supply, :float
  end
end
