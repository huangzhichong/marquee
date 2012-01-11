#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length / 15) + 1
xml.chart(:caption=> caption, :formatNumberScale=>'0',:decimalPrecision=>'1', :xAxis => 'Date', :yAxis => 'Issues', :yAxisMinValue => '0', :showValues => '0', :anchorAlpha => '0', :labelStep => labelStep) do
  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data.date, "%y/%m/%d"))
    end
  end

  xml.dataset(:seriesName => 'Sev1', :color => 'FF0000', :plotBorderColor => 'FF0000') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%y/%m/%d"), :value=>item.severity_1)
    end
  end

  xml.dataset(:seriesName => 'Sev2', :color => 'FF8000', :plotBorderColor => 'FF8000') do
    for item in arr_data
      xml.set(:label=>format_date(item.date, "%y/%m/%d"), :value=>item.severity_2)
    end
  end

end
