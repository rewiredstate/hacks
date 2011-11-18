class CreateAwardCategories < ActiveRecord::Migration
  def change
    create_table :award_categories do |t|
      t.string :title    
      t.text :description
      t.references :event
      t.timestamps
    end
  end
end
