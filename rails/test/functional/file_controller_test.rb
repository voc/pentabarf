require File.dirname(__FILE__) + '/../test_helper'
require 'file_controller'

# Re-raise errors caught by the controller.
class FileController; def rescue_action(e) raise e end; end

class FileControllerTest < Test::Unit::TestCase
  def setup
    @controller = FileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    authenticate_user( Account.select_single(:login_name=>'testcase_committee') )
  end

  def test_event_attachment
    get :event_attachment, {:id => 1}
    assert_response :success
  end

end
