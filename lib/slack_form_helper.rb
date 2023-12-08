module SlackFormHelper
  def self.build_title_block
    {
      type: "plain_text",
      text: "Retrospective Feedback",
      emoji: true
    }
  end

  def self.build_submit_block
    {
      type: "plain_text",
      text: "Submit",
      emoji: true
    }
  end

  def self.build_close_block
    {
      type: "plain_text",
      text: "Cancel",
      emoji: true
    }
  end

  def self.build_category_block
    {
      type: "input",
      block_id: "category_block",
      element: build_static_select_element,
      label: {
        type: "plain_text",
        text: "Category"
      }
    }
  end

  def self.build_static_select_element
    {
      type: "static_select",
      action_id: "category_select",
      placeholder: {
        type: "plain_text",
        text: "Select category"
      },
      options: [
        build_option("Something we should keep doing", "keep"),
        build_option("Something we should stop doing", "stop"),
        build_option("Something to try", "try")
      ]
    }
  end

  def self.build_option(text, value)
    {
      text: {
        type: "plain_text",
        text: text
      },
      value: value
    }
  end

  def self.build_comment_block
    {
      type: "input",
      block_id: "comment_block",
      element: build_plain_text_input_element("Enter your feedback"),
      label: {
        type: "plain_text",
        text: "Comment"
      }
    }
  end

  def self.build_plain_text_input_element(placeholder_text)
    {
      type: "plain_text_input",
      action_id: "comment_input",
      multiline: true,
      placeholder: {
        type: "plain_text",
        text: placeholder_text
      }
    }
  end

  def self.build_anonymous_block
    {
      type: "input",
      block_id: "anonymous_block",
      optional: true,
      element: build_checkboxes_element,
      label: {
        type: "plain_text",
        text: "Anonymous"
      }
    }
  end

  def self.build_checkboxes_element
    {
      type: "checkboxes",
      action_id: "anonymous_checkbox",
      options: [
        build_option("Yes", "true")
      ]
    }
  end
end
