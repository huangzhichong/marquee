#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 10) + 1
xml.chart(:caption=> caption, :formatNumberScale=>'1', :xAxis => 'Date', :yAxis => 'Issues', :yAxisMinValue => '0', :yAxisMaxValue => '100', :syncAxisLimits => '1', :numberSuffix=>'%', :showValues => '0', :anchorAlpha => '0', :labelStep => labelStep, :labelDisplay => 'Wrap') do
  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data.date, "%m/%d/%y"))
    end
  end

  xml.dataset(:seriesName => 'P0', :color => 'FF0000', :plotBorderColor => 'FF0000') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.priority_0)
    end
  end

  xml.dataset(:seriesName => 'P1', :color => 'FF8200', :plotBorderColor => 'FF8200') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.priority_1)
    end
  end

  xml.dataset(:seriesName => 'P2', :color => 'FFDE00', :plotBorderColor => 'FFDE00') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.priority_2)
    end
  end

  xml.dataset(:seriesName => 'P3', :color => '2CFF00', :plotBorderColor => '2CFF00') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.priority_3)
    end
  end

  xml.dataset(:seriesName => 'P4', :color => '00CFFF', :plotBorderColor => '00CFFF') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.priority_4)
    end
  end

end