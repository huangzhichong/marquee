class AddPriorityToSlave < ActiveRecord::Migration
  def change
    add_column :slaves, :test_type, :string
    add_column :slaves, :priority, :integer, :default => 10
  end
end
