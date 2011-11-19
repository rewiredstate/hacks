class AddEventSecretAndActive < ActiveRecord::Migration
  def up
    add_column :events, :secret, :string
    add_column :events, :active, :bool, :default => true
  end

  def down                              
    remove_column :events, :secret
    remove_column :events, :active
  end
end
