require 'spec_helper'
require 'rails_helper'



describe 'SuggestionController' do
    describe "test2"  do
      it 'should switch to suggested topic after it got approved' do
        @newtopic = 'Violet and Zoe'


        #sign in as student5404:
        visit 'content_pages/view'
        fill_in "User Name", with: 'student5404'
        fill_in "Password", with: 'password'
        click_button "SIGN IN"
        expect(page).to have_content('Assignments')

        #suggest a topic:
        # signup_preference default to be Y
        visit "/student_task/view?id=28634"
        expect(page).to have_content('Submit or Review work for Writing assignment 1a')
        visit "/suggestion/new?id=711"
        expect(page).to have_content('Suggested topics for Writing assignment 1a')
        fill_in 'Title',with: @newtopic
        expect{click_button "Submit"}.to change(Suggestion, :count).by(1)

        #logout
        click_link "Logout"
        current_path.should == "/"
        visit '/suggestion/new?id=711'
        expect(page).to have_content('This is not allowed')
        expect(page).to have_content('Welcome')

        #sign in as instructor6
        visit 'content_pages/view'
        expect(page).to have_content('Welcome.')
        fill_in "User Name", with: 'instructor6'
        fill_in "Password", with: 'password'
        click_button "SIGN IN"
        expect(page).to have_content('Manage content')

        #approve the suggestion
        visit '/suggestion/list?id=711&type=Assignment'
        expect(page).to have_content('Suggested topics for Writing assignment 1a')
        num = Suggestion.last.id.to_s
        visit "/suggestion/"+num
        expect(page).to have_content('Suggestion')
        expect(page).to have_content('Title: '+@newtopic)
        click_button "Approve suggestion"
        visit "/suggestion/"+num.to_s
        expect(page).to have_content('status:	Approved')

        #logout as instructor6
        click_link "Logout"
        current_path.should == "/"
        visit '/suggestion/new?id=711'
        expect(page).to have_content('This is not allowed')
        expect(page).to have_content('Welcome')

        #sign in as student5404:
        visit 'content_pages/view'
        fill_in "User Name", with: 'student5404'
        fill_in "Password", with: 'password'
        click_button "SIGN IN"
        expect(page).to have_content('Assignments')

        #check the approved suggestion in topics list
        visit "/sign_up_sheet/list?assignment_id=711"
        expect(page).to have_content("Your approved suggested topic")

        # switch to the new topic
        num2 = SignUpTopic.last.id.to_s
        visit "/sign_up_sheet/switch_original_topic_to_approved_suggested_topic/"+num2+"?assignment_id=711"
        expect(page).to have_content("Your topic(s): "+@newtopic)
      end
    end
end
