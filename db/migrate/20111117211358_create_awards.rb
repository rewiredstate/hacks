class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.references :award_category
      t.references :project
      t.timestamps
    end
  end
end
