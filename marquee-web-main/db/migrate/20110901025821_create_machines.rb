class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :name
      t.string :os_name
      t.string :os_version
      t.references :slave

      t.timestamps
    end
    add_index :machines, :slave_id
    add_foreign_key :machines, :slaves, :column => 'slave_id', :dependent => :delete
  end
end
