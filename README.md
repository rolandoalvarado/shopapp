# Technical Evaluation App

### Problem to Solve:
You are the developer in charge of building a cash register. This app will be able to add products to a cart and display total price.

### Ruby: ruby 3.4.4 (2025-05-14 revision a38531fd3f) +PRISM [x86_64-darwin24]
### Rails: Rails 7.2.2.1
### Database: Postgresql
### App Servers: Puma
### Linters:
* rubocop
* rubocop-rspec
* rubocop-rails
* rubocop-performance
* brakeman
* haml_lint
* es_lint

### Front-end:
* Tailwindcss
* Haml
* React
* Typescript

### Test:
* Rspec
* FactoryBot
* Faker
* Database Cleaner

### Configuration:
* Setup Linters
```
bin/dev/ensure_tools
```

* Setup Database
```
rails db:create
rails db:migrate
rails db:seed
```

* Clear assets and recompile after fron-end changes.
```
~# bin/rails assets:clobber assets:precompile  
```
* Run rails and yarn
```
~# bin/dev
```
