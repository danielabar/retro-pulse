require "rails_helper"

RSpec.describe "Welcome routing" do
  describe "Root route" do
    it "routes to welcome#index" do
      expect(get: "/").to route_to("welcome#index")
    end
  end
end
