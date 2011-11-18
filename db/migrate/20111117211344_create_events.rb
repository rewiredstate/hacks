class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title  
      t.string :slug
      t.string :hashtag
      t.timestamps
    end
  end
end
