class AddStartDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :date
  end
end
