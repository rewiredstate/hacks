class AddEnableProjectCreationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :enable_project_creation, :boolean, :default => true
  end
end
