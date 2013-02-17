require 'spec_helper'

describe 'users' do
  before :each do
    @user = create(:user)
    login_admin
    visit users_path
  end

  it 'displays the users' do
    page.should have_selector '.page-header', :text => 'Users'
    page.should have_content 'John Doe'
  end

  it 'edits a user' do
    find("a[data-id='#{@user.id}']").click
    fill_in 'First name', :with => 'Jon'
    fill_in 'Last name', :with => 'Smith'
    click_button 'Update User'

    page.should have_selector '.alert.alert-success', :text => 'User updated'
    page.should have_content 'Jon Smith'
    page.should_not have_content 'Jon Doe'
  end

  it 'deletes a user' do
    find("a[data-delete-id='#{@user.id}']").click

    page.should have_selector '.alert.alert-success', :text => 'User deleted'
    page.should_not have_content 'John Doe'
  end
end