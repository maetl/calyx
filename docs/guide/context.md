# Dynamic Context

Template expansions can be dynamically constructed at runtime by passing a context map of rules to the `#generate` method:

```ruby
class AppGreeting < Calyx::Grammar
  start 'Hi {username}!', 'Welcome back {username}...', 'Hola {username}'
end

context = {
  username: UserModel.username
}

greeting = AppGreeting.new
greeting.generate(context)
```
