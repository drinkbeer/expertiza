require 'spec_helper'
require 'rails_helper'

describe "test3" do

  it "test" do
    # login as student and submit a suggestion
    visit 'content_pages/view'
    fill_in "User Name", with: "student5404"
    fill_in "Password", with: "password"
    click_button "SIGN IN"

    visit '/suggestion/new?id=711'
    fill_in 'suggestion_title',  with: 'test title'
    fill_in 'suggestion_description',  with: 'test description'
    click_button "Submit"

    click_link "Logout"

    #login as a professor and approve the suggestion
    visit 'content_pages/view'
    fill_in "User Name", with: 'instructor6'
    fill_in "Password", with: 'password'
    click_button "SIGN IN"

    num = Suggestion.last.id
    path = "/suggestion/" + num.to_s
    visit path
    click_button "Approve suggestion"

    click_link "Logout"

    #login again as a student, check if the topic is changed
    visit 'content_pages/view'
    fill_in "User Name", with: 'student5404'
    fill_in "Password", with: 'password'
    click_button "SIGN IN"

    visit '/sign_up_sheet/list?assignment_id=711'
    expect(page).to have_content('Your topic(s): Amazon S3 and Rails')

  end

end