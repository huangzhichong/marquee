#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
xml.chart(:caption=> caption, :formatNumberScale=>'0', :xAxis => 'Week', :yAxis => 'Hours', :yAxisMinValue => '0', :numdivlines => '9', :yaxisname => 'Hours', :xaxisname => 'Week', :decimalPrecision => '1', :showLabels => '1', :animation => '1', :useRoundEdges => '0') do
  categories = xml.categories{
    logs.each do |log|
      xml.category(:label => log.week.to_s)
    end
  }

  dateset1 = xml.dataset{
    xml.dataset(:seriesname => 'Approved' , :color => '9AB656'){
      logs.each do |log|
        xml.set(:Value => log.time_card_actual, :color => '9AB656', :HoverText => "Hours Approved = #{log.time_card_actual}")
      end
    }
    xml.dataset(:seriesname => 'Missing', :color => 'FFDD62', :showValues => '0'){
      logs.each do |log|
        xml.set(:Value => log.time_card_needed - log.time_card_actual, :oclor => 'FFDD62', :HoverText => "Hours Missing = #{log.time_card_needed - log.time_card_actual}")
      end
    }
  }

end
