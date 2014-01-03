#Creates xml with values for sales data of products
#along with their names.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is
#itself an array with first element as label and second element as value
xml = Builder::XmlMarkup.new
xml.chart(:caption => "Markets Automation Coverage", :adjustDiv => "0", :formatNumberScale => '0', :xAxisName => 'Market', :yAxisName => 'Coverage', :yAxisMinValue => '0', :yAxisMaxValue => '100', :decimalPrecision => '1', :showLabels => '1', :maxColWidth => '70', :syncAxisLimits => "1", :NumberSuffix => "%", :sNumberSuffix => '%') do

  camps_link = Project.find_by_name('Camps').nil? ? "#" : "/projects/#{Project.find_by_name('Camps').id}/coverage"
  endurance_link = Project.find_by_name('Endurance').nil? ? "#" : "/projects/#{Project.find_by_name('Endurance').id}/coverage"
  membership_link = Project.find_by_name('MemberShip').nil? ? "#" : "/projects/#{Project.find_by_name('MemberShip').id}/coverage"
  sports_link = Project.find_by_name('Sports').nil? ? "#" : "/projects/#{Project.find_by_name('Sports').id}/coverage"
  rtp_link = Project.find_by_name('RTP').nil? ? "#" : "/projects/#{Project.find_by_name('RTP').id}/coverage"

  xml.set(:Label => "Camps", 
          :Value => (@camps_overall_coverage==100 ? 99.999 : @camps_overall_coverage),
          :link => camps_link, 
          :HoverText => "#{'Automated:'.ljust(15,' ')}#{@camps_automated}{br}#{'UpdateNeeded:'.ljust(15,' ')}#{@camps_update_needed}{br}#{'NotCandidate:'.ljust(15,' ')}#{@camps_not_candidate}{br}#{'TotalCases:'.ljust(15,' ')}#{@camps_total}")
  xml.set(:Label => "Endurance", 
          :Value => (@endurance_overall_coverage==100 ? 99.999 : @endurance_overall_coverage), 
          :link => endurance_link, 
          :HoverText => "#{'Automated:'.ljust(15,' ')}#{@endurance_automated}{br}#{'UpdateNeeded:'.ljust(15,' ')}#{@endurance_update_needed}{br}#{'NotCandidate:'.ljust(15,' ')}#{@endurance_not_candidate}{br}#{'TotalCases:'.ljust(15,' ')}#{@endurance_total}")
  xml.set(:Label => "Membership", 
          :Value => (@membership_overall_coverage==100 ? 99.999 : @membership_overall_coverage), 
          :link => endurance_link, 
          :HoverText => "#{'Automated:'.ljust(15,' ')}#{@membership_automated}{br}#{'UpdateNeeded:'.ljust(15,' ')}#{@membership_update_needed}{br}#{'NotCandidate:'.ljust(15,' ')}#{@membership_not_candidate}{br}#{'TotalCases:'.ljust(15,' ')}#{@membership_total}")
  xml.set(:Label => "RTP", 
          :Value => (@rtp_overall_coverage==100 ? 99.999 : @rtp_overall_coverage), 
          :link => endurance_link, 
          :HoverText => "#{'Automated:'.ljust(15,' ')}#{@rtp_automated}{br}#{'UpdateNeeded:'.ljust(15,' ')}#{@rtp_update_needed}{br}#{'NotCandidate:'.ljust(15,' ')}#{@rtp_not_candidate}{br}#{'TotalCases:'.ljust(15,' ')}#{@rtp_total}")
  xml.set(:Label => "Sports", 
          :Value => (@sports_overall_coverage==100 ? 99.999 : @sports_overall_coverage), 
          :link => endurance_link, 
          :HoverText => "#{'Automated:'.ljust(15,' ')}#{@sports_automated}{br}#{'UpdateNeeded:'.ljust(15,' ')}#{@sports_update_needed}{br}#{'NotCandidate:'.ljust(15,' ')}#{@sports_not_candidate}{br}#{'TotalCases:'.ljust(15,' ')}#{@sports_total}")
  xml.styles{
    xml.definition{
      xml.style(:name => 'hoverTextFont', :type=>'font', :font=>'Monaco', :algin=>'left')
    }
    xml.application{
      xml.apply(:toObject => 'ToolTip', :styles=>'hoverTextFont')
    }
  }
end