require 'test_helper'

class GjdControllerTest < ActionController::TestCase
  test "should get jobid:string" do
    get :jobid:string
    assert_response :success
  end

end
