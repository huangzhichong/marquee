#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
xml.chart(:caption => "Markets Automation Coverage", :adjustDiv => "0", :formatNumberScale => '0', :xAxisName => 'Market', :yAxisName => 'Coverage', :yAxisMinValue => '0', :yAxisMaxValue => '100', :decimalPrecision => '1', :showLabels => '1', :maxColWidth => '70', :syncAxisLimits => "1", :NumberSuffix => "%", :sNumberSuffix => '%') do
  # categories = xml.categories{
  #   xml.category(:label => 'Camps')
  #   xml.category(:label => 'Endurance')
  #   xml.category(:label => 'Sports')
  # }
  camps_link = Project.find_by_name('Camps').nil? ? "#" : "/projects/#{Project.find_by_name('Camps').id}/coverage"
  # endurance_link = Project.find_by_name('Endurance').nil? ? "#" : "/projects/#{Project.find_by_name('Endurance').id}/coverage"
  # membership_link = Project.find_by_name('MemberShip').nil? ? "#" : "/projects/#{Project.find_by_name('MemberShip').id}/coverage"
  # sports_link = Project.find_by_name('Sports').nil? ? "#" : "/projects/#{Project.find_by_name('Sports').id}/coverage"
  
  # xml.dataset(:seriesname => 'Coverage'){
    xml.set(:Label => "Camps", :Value => (@camps_overall_coverage==100 ? 99.999 : @camps_overall_coverage), :link => camps_link, :color => "8BBA00", :HoverText => "Camps Coverage = #{@camps_overall_coverage.to_s}%")
    # xml.set(:Label => "Endurance", :Value => (@endurance_overall_coverage==100 ? 99.999 : @endurance_overall_coverage), :link => endurance_link, :color => "00a8f4", :HoverText => "Endurance Coverage = #{@endurance_overall_coverage.to_s}%")
    # xml.set(:Label => "MemberShip", :Value => (@membership_overall_coverage==100 ? 99.999 : @membership_overall_coverage), :link => membership_link, :color => "f85a2b", :HoverText => "Membership Coverage = #{@membership_overall_coverage.to_s}%")
    # xml.set(:Label => "Sports", :Value => (@sports_overall_coverage==100 ? 99.999 : @sports_overall_coverage), :link => sports_link, :color => "F6BD0F", :HoverText => "Sports Coverage = #{@sports_overall_coverage.to_s}%")
  # }

  # xml.dataset(:seriesname => 'Goal', :parentYAxis => 'S', :lineThickness => '3', :anchorRadius => "5", :color => '993000'){
  #   xml.set(:Value => (@camps_overall_goal==100 ? 99.999 : @camps_overall_goal), :HoverText => "Camps Goal = #{@camps_overall_goal.to_s}%")
  #   xml.set(:Value => (@endurance_overall_goal==100 ? 99.999 : @endurance_overall_goal), :HoverText => "Endurance Goal = #{@endurance_overall_goal.to_s}%")
  #   xml.set(:Value => (@sports_overall_goal==100 ? 99.999 : @sports_overall_goal), :HoverText => "Sports Goal = #{@sports_overall_goal.to_s}%")
  # }

end
