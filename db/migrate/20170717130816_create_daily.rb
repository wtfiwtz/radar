class CreateDaily < ActiveRecord::Migration[5.1]
  def change
    create_table :dailies do |t|
      t.references :company
      t.string :symbol
      t.datetime :date
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.decimal :volume
    end
  end
end
