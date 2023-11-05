### Grape Routes

```ruby
Api.routes.each do |route|
  method = route.request_method.ljust(10)
  path = route.path
  puts "#{method} #{path} #{controller}"
  nil
end
nil
```

```
GET        /api(.:format)
GET        /api/status(.:format)
GET        /api/teams/:id(.:format)
GET        /api/teams(.:format)
POST       /api/teams(.:format)
GET        /api/swagger_doc(.:format)
GET        /api/swagger_doc/:name(.:format)
POST       /api/slack/command(.:format)
POST       /api/slack/action(.:format)
POST       /api/slack/event(.:format)
```
