# Annotate

* https://github.com/ctran/annotate_models/blob/e60a66644e8a8ea5dccd6a398d31f22878233998/lib/tasks/annotate_models.rake#L21
* https://github.com/search?q=repo%3Actran%2Fannotate_models%20show_check_constraints&type=code
* https://github.com/ctran/annotate_models/blob/e60a66644e8a8ea5dccd6a398d31f22878233998/lib/annotate/annotate_models.rb#L384

```bash
bundle exec rake remove_annotation

ANNOTATE_SHOW_CHECK_CONSTRAINTS=1 bundle exec rake annotate_models -c app/models/comment.rb
ANNOTATE_SHOW_CHECK_CONSTRAINTS=yes bundle exec rake annotate_models -c
```

```ruby
def get_check_constraint_info(klass, options = {})
  cc_info = if options[:format_markdown]
              "#\n# ### Check Constraints\n#\n"
            else
              "#\n# Check Constraints\n#\n"
            end

  return '' unless klass.connection.respond_to?(:supports_check_constraints?) &&
    klass.connection.supports_check_constraints? && klass.connection.respond_to?(:check_constraints)

  check_constraints = klass.connection.check_constraints(klass.table_name)
  return '' if check_constraints.empty?

  max_size = check_constraints.map { |check_constraint| check_constraint.name.size }.max + 1
  check_constraints.sort_by(&:name).each do |check_constraint|
    expression = check_constraint.expression ? "(#{check_constraint.expression.squish})" : nil

    cc_info << if options[:format_markdown]
                  cc_info_markdown = sprintf("# * `%s`", check_constraint.name)
                  cc_info_markdown << sprintf(": `%s`", expression) if expression
                  cc_info_markdown << "\n"
                else
                  sprintf("#  %-#{max_size}.#{max_size}s %s", check_constraint.name, expression).rstrip + "\n"
                end
  end

  cc_info
end

get_check_constraint_info(Comment)
# => "#\n# Check Constraints\n#\n#  check_slack_info_if_not_anonymous  (NOT anonymous OR slack_user_id IS NOT NULL AND slack_username IS NOT NULL)\n"
```

```sql
INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, category, slack_user_id, slack_username)
VALUES ('Example Content', false, 6, NOW(), NOW(), 'keep', '123abc', 'john_doe');

INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, category, slack_user_id, slack_username)
VALUES ('Example Content', false, 6, NOW(), NOW(), 'keep', NULL, NULL);
```
