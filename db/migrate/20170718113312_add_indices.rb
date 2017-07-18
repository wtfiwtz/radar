class AddIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :dailies, %i[symbol date]
    add_index :dailies, :date
    add_index :daily_summaries, %i[symbol date]
    add_index :daily_summaries, :date
    add_index :chains, %i[symbol start_at]
    add_index :chains, :finish_at
    add_index :chains, :change_pct
  end
end
