class ChangeAutomationCaseResultsErrorMessageAndScreenShotColumnType < ActiveRecord::Migration
  def up
    remove_index :automation_case_results, :automation_script_result_id
    change_column :automation_case_results, :error_message, :text
    change_column :automation_case_results, :screen_shot, :text
    add_index :automation_case_results, :automation_script_result_id, :name => "index_acr_on_asr_id"
  end

  def down
    remove_index :automation_case_results, :automation_script_result_id
    change_column :automation_case_results, :error_message, :string
    change_column :automation_case_results, :screen_shot, :string
    add_index :automation_case_results, :automation_script_result_id, :name => "index_acr_on_asr_id"
  end
end
