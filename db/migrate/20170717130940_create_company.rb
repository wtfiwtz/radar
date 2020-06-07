class CreateCompany < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :symbol
      t.string :name
      t.string :category_name
      t.bigint :market_cap
      t.references :category, null: true
    end
  end
end
