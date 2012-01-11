#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 10) + 1
xml.chart(:caption=>'Open Customer Impacting Issues Reported by Day - All Teams - All Severity',  :formatNumberScale=>'0', :xAxis => 'Date', :PYAxisName => 'Issues', :SYAxisName => 'Bugs', :showValues => '0', :syncAxisLimits => '1', :anchorAlpha => '0', :adjustDiv => '0', :showLegend => '0', :labelStep => labelStep, :labelDisplay => 'Wrap') do
  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data[0], "%m/%d/%y"))
    end
  end

  xml.dataset(:seriesName => 'Bug', :color => '8DB4E3',:renderas => 'area', :plotBorderColor => '8DB4E3') do
    for item in arr_data
      xml.set(:lable => item[0], :value => item[1])
    end
  end
end
