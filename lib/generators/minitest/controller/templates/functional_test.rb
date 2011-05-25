require 'test_helper'

<% module_namespacing do -%>
class <%= class_name %>ControllerTest < MiniTest::Unit::TestCase
  load_code_to_test_controller

<% if actions.empty? -%>
  # def test_truth
  #   assert true
  # end
<% else -%>
<% actions.each do |action| -%>
  def test_<%= action %>
    get :<%= action %>
    assert_response :success
  end

<% end -%>
<% end -%>
end
<% end -%>
