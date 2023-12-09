require "rails_helper"

RSpec.describe SlackFormBuilder do
  describe ".build_title_block" do
    it "builds a title block" do
      result = described_class.build_title_block
      expect(result).to include(
        type: "plain_text",
        text: "Retrospective Feedback",
        emoji: true
      )
    end
  end

  describe ".build_submit_block" do
    it "builds a submit block" do
      result = described_class.build_submit_block
      expect(result).to include(
        type: "plain_text",
        text: "Submit",
        emoji: true
      )
    end
  end

  describe ".build_close_block" do
    it "builds a close block" do
      result = described_class.build_close_block
      expect(result).to include(
        type: "plain_text",
        text: "Cancel",
        emoji: true
      )
    end
  end

  describe ".build_category_block" do
    it "builds a category block" do
      result = described_class.build_category_block
      expect(result).to include(
        type: "input",
        block_id: "category_block",
        label: include(type: "plain_text", text: "Category"),
        element: be_a(Hash)
      )
    end
  end

  describe ".build_static_select_element" do
    it "builds a static select element" do
      result = described_class.build_static_select_element
      expect(result).to include(
        type: "static_select",
        action_id: "category_select",
        placeholder: include(type: "plain_text", text: "Select category"),
        options: be_an(Array)
      )
    end
  end

  describe ".build_option" do
    it "builds an option" do
      result = described_class.build_option("Some text", "some_value")
      expect(result).to include(
        text: include(type: "plain_text", text: "Some text"),
        value: "some_value"
      )
    end
  end

  describe ".build_comment_block" do
    it "builds a comment block" do
      result = described_class.build_comment_block
      expect(result).to include(
        type: "input",
        block_id: "comment_block",
        label: include(type: "plain_text", text: "Comment"),
        element: be_a(Hash)
      )
    end
  end

  describe ".build_plain_text_input_element" do
    it "builds a plain text input element" do
      result = described_class.build_plain_text_input_element("Enter your feedback")
      expect(result).to include(
        type: "plain_text_input",
        action_id: "comment_input",
        multiline: true,
        placeholder: include(type: "plain_text", text: "Enter your feedback")
      )
    end
  end

  describe ".build_anonymous_block" do
    it "builds an anonymous block" do
      result = described_class.build_anonymous_block
      expect(result).to include(
        type: "input",
        block_id: "anonymous_block",
        optional: true,
        label: include(type: "plain_text", text: "Anonymous"),
        element: be_a(Hash)
      )
    end
  end

  describe ".build_checkboxes_element" do
    it "builds checkboxes element" do
      result = described_class.build_checkboxes_element
      expect(result).to include(
        type: "checkboxes",
        action_id: "anonymous_checkbox",
        options: be_an(Array)
      )
    end
  end
end
