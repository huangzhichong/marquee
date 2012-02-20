#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 10) + 1
xml.chart(:caption=>caption, :formatNumberScale=>'0', :xAxis => 'Date', :yAxis => 'Issues', :yAxisMinValue => '0', :showValues => '0', :anchorAlpha => '0', :lineThickness => '5', :labelStep => labelStep, :labelDisplay => 'Rotate', :slantLabels=>'1') do
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

  xml.dataset(:seriesName => 'Sev3', :color => '0000FF', :plotBorderColor => '0000FF') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.severity_3)
    end
  end

  xml.dataset(:seriesName => 'Sev4', :color => '00FF00', :plotBorderColor => '00FF00') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.severity_4)
    end
  end

  xml.dataset(:seriesName => 'Sev-NYD', :color => '00FFFF', :plotBorderColor => '00FFFF') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%m/%d/%y"), :value=>item.severity_nyd)
    end
  end

end
