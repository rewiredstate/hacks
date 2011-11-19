class AddEventSecretAndActive < ActiveRecord::Migration
  def up
    add_column :events, :secret, :string
    add_column :events, :active, :boolean, :default => true
  end

  def down                        
    remove_column :events, :active      
    remove_column :events, :secret
  end
end
