#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 10) + 1
xml.chart(:caption=>caption, :formatNumberScale=>'0', :xAxis => 'Requirements', :yAxis => 'Issues', :yAxisMinValue => '0', :showValues => '0', :anchorAlpha => '0', :lineThickness => '5', :labelStep => labelStep, :labelDisplay => 'Wrap') do
  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data.date, "%m/%d/%y"))
    end
  end

  xml.dataset(:seriesName => 'Closed Requirements', :renderAs => "Line", :parentYAxis => 'P') do
    for item in arr_data
      xml.set(:label => format_date(item.date, "%m/%d/%y"), :value => item.closed_requirements)
    end
  end

  xml.dataset(:seriesName => 'Externally Found', :parentYAxis => 'S',  :color => 'FF0000', :plotBorderColor => 'FF0000') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.external)
    end
  end

  xml.dataset(:seriesName => 'Internally Found', :parentYAxis => 'S', :color => '00FF00', :plotBorderColor => '00FF00') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.internal)
    end
  end

end