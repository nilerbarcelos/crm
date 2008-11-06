class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.references :owner
      t.string :priority
      t.integer :progress
      t.datetime :started_at
      t.datetime :ended_at
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
