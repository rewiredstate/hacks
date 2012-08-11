class AddFeaturedToAwardCategories < ActiveRecord::Migration
  def change
    add_column :award_categories, :featured, :boolean, :default => true
  end
end
