Busy Paws
========================

Busy Paws is a CLI app that allows you to book and manage dog walking appointments.

---

## Getting Started

1. Clone this repository onto your local machine.
2. Run `bundle install` to download all the necessary gems.
3. Run `rake db:migrate` to create the database.
4. Run `rake db:seed` to seed the database with some auto-generated data.
5. Once you've installed everything smoothly, run `ruby bin/run.rb` to start the app!

---

## Main Menu

This should take approximately **half a day**.

Do not begin coding until you have your pitch approved by an instructor. Do not overthink this. Do not spend your whole day whiteboarding out a schema.

#### Built With

Your **first goal** should be to decide on your models and determine the relationships between them. You **must have a minimum of three models consisting of at least _one_ many-to-many relationship.** Here are some ideas:

* `Restaurant`, `User`, `Review`: (Yelp domain) A restaurant has many users and an user has many restaurants; reviews belongs to restaurant and to user.
* `Movie`, `Actor`, `Role`: (IMDb domain) A movie has many actors and an actor has many movies; roles belongs to movie and to actor.
* `Pizza`, `Topping`, `PizzaTopping`: (Domino's domain) A pizza has many toppings and an topping has many pizzas; pizza_toppings belongs to pizza and to topping.

Whiteboard out your ideas and think about what columns you'll want in the corresponding tables, including foreign keys.

#### Built By

Projects need to be approved prior to launching into them, so take some time to brainstorm project options that will fulfill the requirements above. When you are ready to pitch, be sure to bring the following with you when you sit down with your instructor(s):

* schema
* user stories

As you pitch, think about how you would explain your [Minimum Viable Product (MVP)](https://en.wikipedia.org/wiki/Minimum_viable_product). Which user stories are needed to give you a solid base to build off of? Which user stories can be left to later (stretch goals)? Think [skateboard instead of wheel](https://blog.crisp.se/2016/01/25/henrikkniberg/making-sense-of-mvp).

![mvp](https://blog.crisp.se/wp-content/uploads/2016/01/mvp.png)

🎊 Good job on making to the end! 🎊
