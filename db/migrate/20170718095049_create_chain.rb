class CreateChain < ActiveRecord::Migration[5.1]
  def change
    create_table :chains do |t|
      # t.references :security, foreign_key: true
      t.references :company, foreign_key: true, nullable: true
      t.string :symbol
      t.integer :order
      t.datetime :start_at
      t.datetime :finish_at
      t.integer :width
      t.integer :timeframe
      t.decimal :change_val
      t.float :change_pct
      t.decimal :prev_val
      t.decimal :curr_val
    end
  end
end
