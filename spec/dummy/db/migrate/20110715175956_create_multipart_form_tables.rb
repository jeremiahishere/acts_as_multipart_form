class CreateMultipartFormTables < ActiveRecord::Migration
  def self.up
    create_table :in_progress_forms do |t|
      t.string :form_subject_type
      t.integer :form_subject_id
      t.string :form_name
      t.string :last_completed_step
      t.boolean :completed

      t.timestamps
    end
  end
  
  def self.down
    drop_table :in_progress_forms
  end
end
