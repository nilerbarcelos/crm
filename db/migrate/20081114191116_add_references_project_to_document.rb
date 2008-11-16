class AddReferencesProjectToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :project_id, :integer
  end

  def self.down
    remove_column :documents, :project_id
  end
end
