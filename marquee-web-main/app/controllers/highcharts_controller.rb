require 'csv'

class HighchartsController < ApplicationController
  layout 'no_sidebar'

  def index
    @project_count = Project.count
    @automation_script_count = AutomationScript.count
    @automation_case_count = AutomationCase.count
    @test_round_count = TestRound.count

    %w(Endurance Sports Membership RTP Camps).each do |m|
      p = Project.find_by_name(m)
      eval "@#{m.downcase}_automated = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Automated'})"
      eval "@#{m.downcase}_update_needed = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Update Needed'})"
      eval "@#{m.downcase}_not_candidate = p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Not a Candidate'}) + p.count_test_case_by_plan_type_and_options('regression',{:automated_status => 'Manual'})"
      eval "@#{m.downcase}_total = p.count_test_case_by_plan_type_and_options('regression')"
      eval "@#{m.downcase}_overall_coverage = Project.caculate_coverage_by_project_and_priority_and_type('#{m.downcase}', 'Overall','regression')"
    end
    # @chart = LazyHighCharts::HighChart.new('column') do |f|
    #   f.title(:text => "Population vs GDP For 5 Big Countries [2009]")
    #   f.xAxis(:categories => ["United States", "Japan", "China", "Germany", "France"])
    #   f.series(:name => "GDP in Billions", :yAxis => 0, :data => [14119, 5068, 4985, 3339, 2656])
    #   f.series(:name => "Population in Millions", :yAxis => 1, :data => [310, 127, 1340, 81, 65])

    #   f.yAxis [
    #     {:title => {:text => "GDP in Billions", :margin => 70} },
    #     {:title => {:text => "Population in Millions"}, :opposite => true},
    #   ]

    #   f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    #   f.chart({:defaultSeriesType=>"column"})
    # end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text=>"Combination chart"})
      f.xAxis(:categories => ["United States", "Japan", "China", "Germany", "France"])
      # f.options[:xAxis][:categories] = ['Apples', 'Oranges', 'Pears', 'Bananas', 'Plums']
      f.labels(:items=>[:html=>"Total fruit consumption", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ])      
      f.series(:type=> 'column',:name=> 'Jane',:data=> [3, 2, 1, 3, 4])
      f.series(:type=> 'column',:name=> 'John',:data=> [2, 3, 5, 7, 6])
      f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])
      f.series(:type=> 'spline',:name=> 'Average', :data=> [3, 2.67, 3, 6.33, 3.33])
      f.series(:type=> 'pie',:name=> 'Total consumption', 
        :data=> [
          {:name=> 'Jane', :y=> 13, :color=> 'red'}, 
          {:name=> 'John', :y=> 23,:color=> 'green'},
          {:name=> 'Joe', :y=> 19,:color=> 'blue'}
        ],
        :center=> [100, 80], :size=> 100, :showInLegend=> false)
    end

  end
end

