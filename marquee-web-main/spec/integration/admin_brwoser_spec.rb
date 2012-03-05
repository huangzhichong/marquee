require 'spec_helper'

describe 'browser admin page' do
  before do
    @user = User.create!(:email => 'test@marquee.com',
                         :password => 'testtest',
                         :password_confirmation => 'testtest',
                         :display_name => "Marquee Test"
                         )
    ab = AbilityDefinition.create!(:ability => :manage,
                              :resource => 'Browser',
                              )
    AbilityDefinitionsUsers.create!(:user_id => @user.id,
                                    :ability_definition_id => ab.id
                                    )
    Capybara.reset_sessions!
    visit '/users/sign_in'
    page.should have_content('Sign in')
    page.should have_button('Sign in')
    fill_in 'user[email]', :with => 'test@marquee.com'
    fill_in 'user[password]', :with => 'testtest'

    click_button('Sign in')
    page.should have_content('Login as Marquee Test')
  end

  it 'should display browser secion on Admin page' do
    visit '/admin/projects'
    page.should have_link("Browsers", {:href => '/admin/browsers'})
  end

  it "should display no data indication when no browser" do
    visit '/admin/browsers'
    page.should have_content('Listing Browsers')
    page.should have_content('No data')
  end

  it "should display browser data if there's any" do
    Browser.create!(:name => 'IE',
                    :version => '6.0'
                    )
    visit '/admin/browsers'
    page.should_not have_content('No data')
    page.should have_content("IE")
    page.should have_content("6.0")
  end

  it "should be able to create browser" do
    visit '/admin/browsers'
    page.should have_link("New Browser")
    page.click_link "New Browser"
    page.should have_content("New Browser")
    fill_in 'browser[version]', :with => "3.5"
    fill_in 'browser[name]', :with => "Firefox"
    click_button "Save"
    Browser.count.should eql 1
    page.should have_content("Firefox")
    page.should have_content("3.5")
    Browser.all.each do |b|
      page.should have_link("", {:href => "/admin/browsers/#{b.id}/edit"})
      page.should have_link("", {:href => "/admin/browsers/#{b.id}", "data-method" => 'delete'})
    end
  end
end
