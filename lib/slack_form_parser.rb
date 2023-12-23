module SlackFormParser
  module_function

  def parse_user_info(payload)
    {
      user_id: payload["user"]["id"],
      slack_user_id: payload["user"]["id"],
      slack_username: payload["user"]["username"]
    }
  end

  def parse_feedback_info(payload)
    view_state = payload["view"]["state"]
    {
      category: view_state["values"]["category_block"]["category_select"]["selected_option"]["value"],
      comment: view_state["values"]["comment_block"]["comment_input"]["value"],
      anonymous: view_state["values"]["anonymous_block"]["anonymous_checkbox"]["selected_options"].present?
    }
  end
end
