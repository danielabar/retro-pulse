require "rails_helper"

RSpec.describe "retrospectives/new" do
  before do
    assign(:retrospective, Retrospective.new(
                             title: "MyString"
                           ))
  end

  it "renders new retrospective form" do
    render

    assert_select "form[action=?][method=?]", retrospectives_path, "post" do
      assert_select "input[name=?]", "retrospective[title]"
    end
  end
end
