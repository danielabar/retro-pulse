require "rails_helper"

RSpec.describe "retrospectives/index" do
  before do
    assign(:retrospectives, [
             Retrospective.create!(title: "Title 1"),
             Retrospective.create!(title: "Title 2")
           ])
  end

  it "renders a list of retrospectives" do
    render
    cell_selector = Rails::VERSION::STRING >= "7" ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
  end
end
