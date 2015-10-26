require 'spec_helper'
require 'rails_helper'

require File.join('./app/controllers/application_controller')

require File.join('./app/controllers/suggestion_controller')


describe "SuggestionController" do
  describe "#Test1:approve_suggestion_in_waitlist" do
  
    before(:each) do
        @assignment_id = 711
        @topic_id = 2864
        @team_id = 27816
        @assignment = Assignment.find_by_id(@assignment_id)
        @topc = SignUpTopic.find_by_assignment_id(@topic_id)
        @team = Team.find_by_id(@team_id)
        
        if !@assignment.nil?
          @assignment.update_attribute(:allow_suggestions, 1);
          # puts "==> modify success? " + @assignment.allow_suggestions.to_s
        else
          puts "==> assignment is nil"
        end
    end

    it "should be able to login " do
      visit 'content_pages/view'
      expect(page).to have_content('Welcome')
      fill_in "User Name", with: "student5717"
      fill_in "Password", with: "password"
      click_button "SIGN IN"
    
      expect(page).to have_content('Assignments')
      expect(page).to have_content('Writing assignment 1a')
      
      visit '/suggestion/new?id=711'
      expect(page).to have_content('New suggestion')
    end
    
    it "should be able to suggest a new topic " do
      # login with account student5717
      visit 'content_pages/view'
      expect(page).to have_content('Welcome')
      fill_in "User Name", with: "student5717"
      fill_in "Password", with: "password"
      click_button "SIGN IN"
    
      visit '/suggestion/new?id=711'
      fill_in 'suggestion_title',  with: 'RSpect'
      fill_in 'suggestion_description',  with: 'RSpect is a ROR test framework. It focus on function test'
      # select 'suggestion_signup_preference', with: 'Y'
      expect{click_button "Submit"}.to change(Suggestion, :count).by(1)
    end
    
    it " should be able to logout " do
      visit 'content_pages/view'
      expect(page).to have_content('Welcome')
      fill_in "User Name", with: "student5717"
      fill_in "Password", with: "password"
      click_button "SIGN IN"
    
      visit '/suggestion/new?id=711'
      click_link "Logout"
      current_path.should == "/"
      
      visit '/suggestion/new?id=711'
      expect(page).to have_content('This is not allowed')
      expect(page).to have_content('Welcome')
      expect(page).to have_no_content('User: student5717')
      
      visit '/menu/Course%20Evaluation'
      expect(page).to have_content('This is not allowed')
      expect(page).to have_content('Welcome')
    end

    it " should be able to approve a new suggestion " do
      # Login with student5717 account
      visit 'content_pages/view'
      expect(page).to have_content('Welcome')
      fill_in "User Name", with: "student5717"
      fill_in "Password", with: "password"
      click_button "SIGN IN"
    
      # suggest a new suggestion
      visit '/suggestion/new?id=711'
      fill_in 'suggestion_title',  with: 'RSpect'
      fill_in 'suggestion_description',  with: 'RSpect is a ROR test framework. It focus on function test'
      # select 'suggestion_signup_preference', with: 'Y'
      expect{click_button "Submit"}.to change(Suggestion, :count).by(1)
    
      # Logout current account student5717
      visit '/suggestion/new?id=711'
      click_link "Logout"
      current_path.should == "/"
      
      # Login with account instructor6
      visit 'content_pages/view'
      expect(page).to have_content('Welcome.')
      fill_in "User Name", with: 'instructor6'
      fill_in "Password", with: 'password'
      click_button "SIGN IN"
      
      # approve the suggestion
      expect(page).to have_content('Manage content')
      visit '/suggestion/list?id=711&type=Assignment'
      expect(page).to have_content('Suggested topics for Writing assignment 1a')
      expect(page).to have_content('RSpect')
      
      num = Suggestion.last.id
      visit "/suggestion/"+num.to_s
      expect(page).to have_content('Suggestion')
      expect(page).to have_content('Title:	RSpect')
      click_button "Approve suggestion"
      visit "/suggestion/"+num.to_s
      expect(page).to have_content('status:	Approved')
      
      # Logout current account instructor6
      visit '/suggestion/new?id=711'
      click_link "Logout"
      current_path.should == "/"
      
      # Login with student5717 account
      visit 'content_pages/view'
      expect(page).to have_content('Welcome')
      fill_in "User Name", with: "student5717"
      fill_in "Password", with: "password"
      click_button "SIGN IN"
      
      # Check if you select the topic successfully
      visit '/sign_up_sheet/list?assignment_id=711'
      expect(page).to have_content('Your topic(s): RSpect')
      
    end


  end
end 