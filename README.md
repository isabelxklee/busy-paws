🐾 Busy Paws 🐾
========================

Busy Paws is a CLI app that allows you to book and manage dog walking appointments. Built using Ruby and Active Record.

![Starting up Busy Paws](https://i.imgur.com/Ov88HIP.png)

## Getting Started

1. Clone this repository onto your local machine.
2. Run `bundle install` to download all the necessary gems.
3. Run `rake db:migrate` to create the database.
4. Run `rake db:seed` to seed the database with some auto-generated data.
5. Once you've installed everything smoothly, run `ruby bin/run.rb` to start the app!

## Main Menu

* Login or create an account
* Walk a dog
* See upcoming appointments
* Change appointments
* Cancel appointments
* See a list of dogs that you've walked
* Exit

## Features

* Models have `has_many`, `belongs_to` and `has_many through` associations
* Global datetime conversion using conditional formatting and regex
* Login method validates existing users in the database
* Get and store user's input with TTY::Prompt


## Built With

Here are some tools that I used to build Busy Paws:

* [TTY::Prompt](https://github.com/piotrmurach/tty-prompt): interactive command line prompt
* [Colorize](https://github.com/fazibear/colorize): adds color to text and backgrounds
* [Faker](https://github.com/faker-ruby/faker): fake data generator
* [Date](https://github.com/ruby/date): easy way to handle date objects
* [Text to ASCII Art Generator](http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20): generates ASCII art from inputted text
* [ASCII Art Archive](https://www.asciiart.eu/): collection of ASCII art
