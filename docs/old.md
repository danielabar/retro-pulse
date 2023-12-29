# Old Experiments

```ruby
# app/interactors/discuss_retrospective.rb
  # displays side-by-side, but too big
  # def build_comment_context(comment)
  #   {
  #     type: "section",
  #     fields: [
  #       {
  #         type: "plain_text",
  #         text: ":bust_in_silhouette: #{comment.user_info}"
  #       },
  #       {
  #         type: "plain_text",
  #         text: ":date: #{comment.created_at.strftime('%Y-%m-%d')}"
  #       }
  #     ]
  #   }
  # end

  # try with block quote
  # def build_comment_context(comment)
  #   {
  #     type: "section",
  #     text: {
  #       type: "mrkdwn",
  #       text: ">Posted by #{comment.user_info}, at #{comment.created_at.strftime('%Y-%m-%d')}"
  #     }
  #   }
  # end
```
