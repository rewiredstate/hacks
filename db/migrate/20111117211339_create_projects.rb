class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title             
      t.string :slug
      t.references :event
      t.text :description
      t.string :team
      t.string :url
      t.text :ideas
      t.text :costs
      t.text :data
      t.string :twitter
      t.string :github_url
      t.string :svn_url
      t.string :code_url
      t.string :secret
      t.timestamps
    end      
  end
end
