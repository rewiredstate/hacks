class CreateCentres < ActiveRecord::Migration
  def change
    create_table :centres do |t|
      t.string :name
      t.string :slug
      t.references :event
      t.timestamps
    end

    add_column :events, :use_centres, :boolean, :default => false
    add_column :projects, :centre_id, :integer
  end
end
