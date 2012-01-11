#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 10) + 1
xml.chart(:caption=>'Customer Impacting Issues Reported by Day - All Teams', :formatNumberScale=>'0', :xAxis => 'Date', :yAxis => 'Issues', :yAxisMinValue => '0', :yAxisMaxValue => '5', :showValues => '0', :anchorAlpha => '0', :lineThickness => '5', :adjustDiv => '0', :labelStep => labelStep, :labelDisplay => 'Wrap') do
  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data.date, "%m/%d/%y"))
    end
  end

  xml.dataset(:seriesName => 'Sev1', :color => 'FF0000', :plotBorderColor => 'FF0000') do
    for item in arr_data
      xml.set(:label => format_date(item.date, "%m/%d/%y"), :value => item.severity_1)
    end
  end

  xml.dataset(:seriesName => 'Sev2', :color => 'FF8000', :plotBorderColor => 'FF8000') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.severity_2)
    end
  end
end
