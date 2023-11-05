require "rails_helper"

RSpec.describe "retrospectives/edit" do
  let(:retrospective) do
    Retrospective.create!(
      title: "MyString"
    )
  end

  before do
    assign(:retrospective, retrospective)
  end

  it "renders the edit retrospective form" do
    render

    assert_select "form[action=?][method=?]", retrospective_path(retrospective), "post" do
      assert_select "input[name=?]", "retrospective[title]"
    end
  end
end
