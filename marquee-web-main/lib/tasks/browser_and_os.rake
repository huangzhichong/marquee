desc "init browsers and operation systems, also process existing ci mappings"
task :init_browser_and_os => :environment do
  win = OperationSystem.create!(:name => 'windows', :version => 'xp')
  ie = Browser.create!(:name => 'ie', :version => '6.0')
  firefox = Browser.create!(:name => 'firefox', :version => '3.5')
  chrome = Browser.create!(:name => 'chrome', :version => '17')

  Project.all.each do |p|
    p.browsers << ie
    p.browsers << firefox
    p.browsers << chrome
    p.operation_systems << win
    p.save!
  end

  CiMapping.all.each do |mapping|
    if mapping.browser.nil?
      mapping.browser = ie
      mapping.operation_system = win
      mapping.save!
    end
  end
end
