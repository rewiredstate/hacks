class AddImageColumnsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :image_file_name,    :string
    add_column :projects, :image_content_type, :string
    add_column :projects, :image_file_size,    :integer
    add_column :projects, :image_updated_at,   :datetime
  end
end
