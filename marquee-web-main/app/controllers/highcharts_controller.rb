require 'csv'

class HighchartsController < ApplicationController
  layout 'no_sidebar'

  def index
    %w(Endurance Sports Membership RTP Camps).each do |m|
      p = Project.find_by_name(m)
      eval "@#{m.downcase}_link = url_for([:coverage,p])"
      eval "@#{m.downcase}_automated = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Automated'})"
      eval "@#{m.downcase}_update_needed = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Update Needed'})"
      eval "@#{m.downcase}_not_candidate = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Not a Candidate'}) + p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Manual'})"
      eval "@#{m.downcase}_total = p.count_test_case_by_plan_type_and_options('regression')"
      eval "@#{m.downcase}_overall_coverage = Project.caculate_coverage_by_project_and_priority_and_type('#{m.downcase}', 'Overall','regression')"
    end

  end
end
