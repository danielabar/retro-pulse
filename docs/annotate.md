# Annotate

Has support for annotating check constraints but that PR got merged AFTER latest 3.2.0 release.

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
# => "#\n# Check Constraints\n#\n#  check_slack_info_if_not_anonymous  (anonymous AND slack_user_id IS NULL AND slack_username IS NULL)\n"
```

Manual tests in db console:
```sql
-- CASE 1: Anonymous: False, Slack info populated       -> ALLOWED - WORKING
INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, slack_user_id, slack_username)
VALUES ('foo', false, 6, NOW(), NOW(), 'abc.123', 'jane.smith');

-- CASE 2: Anonymous: False, Slack info not populated   -> VIOLATION - WORKING
INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, slack_user_id, slack_username)
VALUES ('foo', false, 6, NOW(), NOW(), NULL, NULL);

-- CASE 3: Anonymous: True, Slack info populated        -> VIOLATION - WORKING
INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, slack_user_id, slack_username)
VALUES ('foo', true, 6, NOW(), NOW(), 'abc.123', 'jane.smith');

-- CASE 4: Anonymous: True, Slack info not populated    -> ALLOWED - WORKING
INSERT INTO comments (content, anonymous, retrospective_id, created_at, updated_at, slack_user_id, slack_username)
VALUES ('foo', true, 6, NOW(), NOW(), NULL, NULL);
```

```ruby
add_check_constraint(
  :comments,
  "(anonymous AND slack_user_id IS NULL AND slack_username IS NULL) OR (NOT anonymous AND slack_user_id IS NOT NULL AND slack_username IS NOT NULL)",
  name: "check_slack_info_if_not_anonymous"
)
```
