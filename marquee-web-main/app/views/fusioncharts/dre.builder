#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
labelStep = (arr_data.length/max_x_label_count) + 1
xml.chart(:bgColor => 'E9E9E9', :outCnvBaseFontColor => '666666', :caption=>caption, :formatNumberScale=>'0', :adjustDiv => '0', :xAxis => 'Date', :PYAxisName => 'DRE', :SYAxisName => 'DRE', :showValues => '0',:decimalPrecision=>'1', :syncAxisLimits => '1', :anchorAlpha => '0', :plotGradientColor => ' ', :numDivLines => '5', :labelStep => labelStep, :labelDisplay => 'Wrap') do

  xml.categories do
    arr_data.each do |data|
      xml.category(:label => format_date(data.date, "%m/%d/%y"))
    end
  end

  xml.dataset(:color => color, :renderas => 'area', :plotBorderColor => color) do
    for item in arr_data
      xml.set(:value=>item.value)
    end
  end

end
