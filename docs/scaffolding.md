## Scaffolding

```bash
bin/rails generate scaffold retrospective title:string:uniq
bin/rails generate model comment content:text anonymous:boolean retrospective:references
# bin/rails generate member ...
bin/rails generate stimulus SlackTeamRegistration
```
