xml = Builder::XmlMarkup.new
xml = Builder::XmlMarkup.new
xml.chart(:caption => "#{@project.name.capitalize} Automation Coverage", :adjustDiv => "0", :formatNumberScale => '0', :xAxisName => 'Market', :yAxisName => 'Coverage', :yAxisMinValue => '0', :yAxisMaxValue => '100', :decimalPrecision => '1', :showLabels => '1', :maxColWidth => '100', :syncAxisLimits => "1", :NumberSuffix => "%", :sNumberSuffix => '%') do
  categories = xml.categories{
    xml.category(:label => 'Overall')
    xml.category(:label => 'Priority 1')
    xml.category(:label => 'Priority 2')
    xml.category(:label => 'Priority 3')
  }

  overall_coverage = @regression_coverage[0]
  p1_covergae = @regression_coverage[1]
  p2_covergae = @regression_coverage[2]
  p3_covergae = @regression_coverage[3]

  xml.dataset(:seriesname => 'Coverage'){
    xml.set(:Value => (overall_coverage==100 ? 99.999 : overall_coverage), :color => "50BD4A", :HoverText => "Overall Coverage = #{overall_coverage.to_s}%")
    xml.set(:Value => (p1_covergae==100 ? 99.999 : p1_covergae),:color => "f34744", :HoverText => "P1 Coverage = #{p1_covergae.to_s}%")
    xml.set(:Value => (p2_covergae==100 ? 99.999 : p2_covergae),:color => "ff7413", :HoverText => "P2 Coverage = #{p2_covergae.to_s}%")
    xml.set(:Value => (p3_covergae==100 ? 99.999 : p3_covergae), :color => "ffd213", :HoverText => "P3 Coverage = #{p3_covergae.to_s}")
  }

  xml.dataset(:seriesname => 'Goal', :parentYAxis => 'S', :lineThickness => '3', :anchorRadius => "5", :color => '993000'){
    xml.set(:Value => (@overall_goal==100 ? 99.999 : @overall_goal), :HoverText => "Overall Goal = #{@overall_goal.to_s}%")
    xml.set(:Value => (@p1_goal==100 ? 99.999 : @p1_goal), :HoverText => "P1 Goal = #{@p1_goal.to_s}%")
    xml.set(:Value => (@p2_goal==100 ? 99.999 : @p2_goal), :HoverText => "P2 Goal = #{@p2_goal.to_s}%")
    xml.set(:Value => (@p3_goal==100 ? 99.999 : @p3_goal), :HoverText => "P3 Goal = #{@p3_goal.to_s}%")
  }

end