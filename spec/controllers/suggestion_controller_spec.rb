
describe 'SuggestionController' do
  describe "test2" do
    before(:each) do
      @a_id = 711
      @tm_id = 23781
      @assigment = Assignment.find_by_id(@a_id)
      @topc = SignUpTopic.find_by_assignment_id(@a_id)
      @team = Team.find_by_id(@tm_id)
    end
  end

end