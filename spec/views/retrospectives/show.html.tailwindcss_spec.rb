require "rails_helper"

RSpec.describe "retrospectives/show" do
  before do
    assign(:retrospective, Retrospective.create!(
                             title: "Title"
                           ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
