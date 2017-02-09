require 'spec_helper'

feature "Session" do
  context 'Given I am an unauthorized person' do
    scenario 'When I submit the sign in form correctly Then show me the sign in form And show me not found error message next to email input' do
      # an unauthorized person
      person = {:first_name => 'me@example.com', :last_name => 'password123'}

      # submits the sign in form correctly
      visit '/session/new'
      within('#new_session') do
        fill_in 'session[email]', :with => person[:first_name]
        fill_in 'session[password]', :with => person[:last_name]
      end
      click_button 'Sign in'

      # assertions
      # shows the sign in form
      expect(page).to have_selector 'form#new_session'
      # shows the not found error message next to email input
      find('.session_email.error').should have_content 'not found'
    end
  end
  context 'Given I am an authorized person' do
    scenario 'When I submit the sign in form correctly Then show me a page with the word Pages#home And show me a link to sign out' do
      # an authorized person
      person = FactoryGirl.create(:person)

      # submits the sign in form correctly
      visit '/session/new'
      within('#new_session') do
        fill_in 'session[email]', :with => 'me@example.com'
        fill_in 'session[password]', :with => 'password123'
      end
      click_button 'Sign in'

      # assertions
      # shows the page with the work Pages#home
      expect(page).to have_content 'Pages#home'
      # shows the link to sign out
      find('.nav').should have_link 'Sign out'
    end
    scenario 'When I have clicked the sign out link Then show me a page with the word Pages#home And show me a link to sign in' do
      # create a new person
      person = FactoryGirl.create(:person)

      # authenticated person signs in
      visit '/session/new'
      within('#new_session') do
        fill_in 'session[email]', :with => 'me@example.com'
        fill_in 'session[password]', :with => 'password123'
      end
      click_button 'Sign in'
      find('.nav').should have_link 'Sign out'
      expect(page).to have_content 'Pages#home'

      click_link 'Sign out'
      expect(page).to have_content 'Pages#home'
      find('.nav').should have_link 'Sign in'
    end
  end
  context 'Given I have clicked the Create Person button' do
    scenario 'When I haven\'t filled out any fields Then show me the page with some error messages' do
      # person signs up to become authenticated
      visit '/people/new'

      click_button 'Create Person'
      expect(page).to have_content 'Please review the problems below:'
    end
    scenario 'When I have filled in all the fields correctly Then show me my page with my name' do
      # person signs up to become authenticated
      visit '/people/new'
      within('#new_person') do
        fill_in 'person[first_name]', :with => 'Fred'
        fill_in 'person[last_name]', :with => 'Smith'
        fill_in 'person[born_on]', :with => '01/01/1965'
        select 'male', :from => 'person[gender]'
        fill_in 'person[password]', :with => 'password123'
        fill_in 'person[password_confirmation]', :with => 'password123'
        fill_in 'person[email]', :with => 'me@example.com'
        fill_in 'person[phone_number]', :with => '4155551212'
      end
      click_button 'Create Person'
      expect(page).to have_content 'First name: Fred'
    end
  end
end
