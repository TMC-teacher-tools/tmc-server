require 'spec_helper'

feature 'Teacher can add new teacher to an organization', feature: true do
  include IntegrationTestActions

  before :each do
    @teacher = FactoryGirl.create :user, password: 'foobar'
    @new_teacher = FactoryGirl.create :user, password: 'newfoobar'
    @organization = FactoryGirl.create :accepted_organization, slug: 'slug'
    Teachership.create!(user: @teacher, organization: @organization)
    visit '/org/slug'
  end

  scenario 'Teacher succeeds add new teacher when valid username is given' do
    log_in_as(@teacher.username, 'foobar')
    click_link 'Show teachers in this organization'
    fill_in 'username', with: @new_teacher.username
    click_button 'Add a new teacher'
    expect(page).to have_content 'Teacher added to organization'
    expect(page).to have_content @new_teacher.username
  end

  scenario 'Teacher cannot give teachership for non-existing user' do
    log_in_as(@teacher.username, 'foobar')
    click_link 'Show teachers in this organization'
    fill_in 'username', with: 'notusername'
    click_button 'Add a new teacher'
    expect(page).to have_content 'User does not exist'
  end

  scenario 'Teacher cannot access teacher management page if organization is pending' do
    @organization = FactoryGirl.create :organization, slug: 'slug2'
    Teachership.create!(user: @teacher, organization: @organization)
    log_in_as(@teacher.username, 'foobar')

    visit '/org/slug2'
    expect(page).to_not have_content 'Show teachers in this organization'
  end
end