class AddScriptMainPathToAutomationScripts < ActiveRecord::Migration
  def change
    add_column :automation_scripts, :script_main_path, :text
  end
end
