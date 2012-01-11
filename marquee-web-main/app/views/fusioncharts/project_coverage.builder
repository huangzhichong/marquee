#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
xml.chart(:caption => "#{@project.name.capitalize} Automation Coverage", :adjustDiv => "0", :formatNumberScale => '0', :xAxisName => 'Market', :yAxisName => 'Coverage', :yAxisMinValue => '0', :yAxisMaxValue => '100', :yAxisValuesPadding => "10", :decimalPrecision => '1', :syncAxisLimits => "1", :NumberSuffix => "%", :sNumberSuffix => '%') do
  categories = xml.categories{
    xml.category(:label => 'Overall')
    xml.category(:label => 'Priority 1')
    xml.category(:label => 'Priority 2')
    xml.category(:label => 'Priority 3')
  }
  
  aui_overall_coverage = @aui_coverage[0]
  aui_p1_covergae = @aui_coverage[1]
  aui_p2_covergae = @aui_coverage[2]
  aui_p3_covergae = @aui_coverage[3]
  
  cui_overall_coverage = @cui_coverage[0]
  cui_p1_covergae = @cui_coverage[1]
  cui_p2_covergae = @cui_coverage[2]
  cui_p3_covergae = @cui_coverage[3]

  xml.dataset(:seriesname => 'AUI', :color => "8BBA00"){
    xml.set(:Value => (aui_overall_coverage==100 ? 99.999 : aui_overall_coverage), :HoverText => "AUI Overall Coverage = #{aui_overall_coverage.to_s}%")
    xml.set(:Value => (aui_p1_covergae==100 ? 99.999 : aui_p1_covergae), :HoverText => "AUI P1 Coverage = #{aui_p1_covergae.to_s}%")
    xml.set(:Value => (aui_p2_covergae==100 ? 99.999 : aui_p2_covergae), :HoverText => "AUI P2 Coverage = #{aui_p2_covergae.to_s}%")
    xml.set(:Value => (aui_p3_covergae==100 ? 99.999 : aui_p3_covergae), :HoverText => "AUI P3 Coverage = #{aui_p3_covergae.to_s}")
  }

  xml.dataset(:seriesname => 'CUI', :color => "F6BD0F"){
    xml.set(:Value => (cui_overall_coverage==100 ? 99.999 : cui_overall_coverage), :HoverText => "CUI Overall Coverage = #{cui_overall_coverage.to_s}%")
    xml.set(:Value => (cui_p1_covergae==100 ? 99.999 : cui_p1_covergae), :HoverText => "CUI P1 Coverage = #{cui_p1_covergae.to_s}%")
    xml.set(:Value => (cui_p2_covergae==100 ? 99.999 : cui_p2_covergae), :HoverText => "CUI P2 Coverage = #{cui_p2_covergae.to_s}%")
    xml.set(:Value => (cui_p3_covergae==100 ? 99.999 : cui_p3_covergae), :HoverText => "CUI P3 Coverage = #{cui_p3_covergae.to_s}%")
  }
  
  # xml.dataset(:seriesname => 'AUI Goal', :renderAs => "Line", :lineThickness => '4', :anchorRadius => "5", :color => "BBDA00"){
  #   xml.set(:Value => (@aui_overall_goal==100 ? 99.999 : @aui_overall_goal), :HoverText => "AUI Overall Coverage = #{@aui_overall_goal.to_s}%")
  #   xml.set(:Value => (@aui_p1_goal==100 ? 99.999 : @aui_p1_goal), :HoverText => "P1 Coverage = #{@aui_p1_goal.to_s}%")
  #   xml.set(:Value => (@aui_p2_goal==100 ? 99.999 : @aui_p2_goal), :HoverText => "P2 Coverage = #{@aui_p2_goal.to_s}%")
  #   xml.set(:Value => (@aui_p3_goal==100 ? 99.999 : @aui_p3_goal), :HoverText => "P3 Coverage = #{@aui_p3_goal.to_s}")
  # }
  # 
  # xml.dataset(:seriesname => 'CUI Goal', :renderAs => "Line", :lineThickness => '4', :anchorRadius => "5", :color => "e97b00"){
  #   xml.set(:Value => (@cui_overall_goal==100 ? 99.999 : @cui_overall_goal), :HoverText => "Overall Goal = #{@cui_overall_goal.to_s}%")
  #   xml.set(:Value => (@cui_p1_goal==100 ? 99.999 : @cui_p1_goal), :HoverText => "P1 Goal = #{@cui_p1_goal.to_s}%")
  #   xml.set(:Value => (@cui_p2_goal==100 ? 99.999 : @cui_p2_goal), :HoverText => "P2 Goal = #{@cui_p2_goal.to_s}%")
  #   xml.set(:Value => (@cui_p3_goal==100 ? 99.999 : @cui_p3_goal), :HoverText => "P3 Goal = #{@cui_p3_goal.to_s}%")
  # }

end
