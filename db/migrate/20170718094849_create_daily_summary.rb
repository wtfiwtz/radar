class CreateDailySummary < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_summaries do |t|
      t.references :company, foreign_key: true, nullable: true
      t.string :symbol
      t.string :kind
      t.text :parameters
      t.datetime :date
      t.integer :timeframe
      t.integer :index
      t.decimal :prev_val
      t.decimal :curr_val
      t.decimal :change_val
      t.float :change_pct
    end
  end
end
