require 'test_helper'

class QueuedEpisodesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in(@user, '123greetings')
  end

  test "should get index" do
    get queued_episodes_index_path
    assert_response :success
  end

  test "index should display nav bar" do
    get queued_episodes_index_path
    assert_select 'nav'
  end

  test "should display index page" do
    get queued_episodes_index_path
    assert_select "li:match('class', ?)", /empty-queue/
    # add test for when episodes are queued as well
  end

end
