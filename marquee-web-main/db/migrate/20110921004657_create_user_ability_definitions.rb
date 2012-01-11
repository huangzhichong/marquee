class CreateUserAbilityDefinitions < ActiveRecord::Migration
  def change
    create_table :user_ability_definitions do |t|
      t.references :user
      t.string :ability
      t.string :resource

      t.timestamps
    end
    add_index :user_ability_definitions, :user_id
  end
end
