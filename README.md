# Technical Evaluation App

* Problem to Solve:
You are the developer in charge of building a cash register. This app will be able to add products to a cart and display total price.

Pre-requites:

* Back-end:
1. Ruby version 3.4.4
2. Rails 7.2.2.1
3. Postgresql

* Front-end:
1. Tailwindcss
2. Haml
3. React
4. Typescript

* Test:
1. Rspec
2. FactoryBot
3. Faker
4. Database Cleaner

* Important commands:
1. Add default products.
~# rails db:seed

2. Clear assets and recompile after fron-end changes.
~# bin/rails assets:clobber assets:precompile  

3. Run rails and yarn
~# bin/dev