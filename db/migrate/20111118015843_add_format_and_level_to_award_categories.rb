class AddFormatAndLevelToAwardCategories < ActiveRecord::Migration
  def change
    add_column :award_categories, :format, :string
    add_column :award_categories, :level, :string
  end
end
