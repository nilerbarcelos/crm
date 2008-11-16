class AddPolymorphicToDocument < ActiveRecord::Migration
  def self.up
    remove_column :documents, :project_id
    add_column :documents, :archivable_id, :integer
    add_column :documents, :archivable_type, :string
  end

  def self.down
    remove_column :documents, :archivable_id, :integer
    remove_column :documents, :archivable_type, :string
    add_column :documents, :project_id, :integer
  end
end
