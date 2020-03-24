require_relative '../../config/environment'
require_all 'lib'

# As a User, I want to be able to…
# ✅login or create an account
# ✅browse available dogs
# ✅read information about the dog i will be walking
# ✅schedule a dog walking appointment
# ❌see all my upcoming walks
# ❌see all the dogs i've walked
# ❌see how many dogs i've walked
# ❌change my walking appointment
# ❌cancel my walking appointment

class Interface
    attr_accessor :prompt

    def initialize
        @prompt = TTY::Prompt.new
    end

    def greet
        puts 'Welcome to Busy Paws, the best dog walking app in the world!'
    end

    def login_or_create_account
        answer = prompt.select("Would you like to login or create a new account?", "Login", "Create a new account")

        if answer == "Login"
            login
        else
            create_account
        end
    end

    def login
        walker_name = prompt.ask("What's your name?") #do |q|
        #     q.required true
        #     q.validate /\A\w+\Z/
        #     q.modify   :capitalize
        # end

        puts "Welcome back, #{walker_name}!"
        Walker.choose_action(walker_name)
    end

    def create_account
        walker_name = prompt.ask("What's your name?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            q.modify   :capitalize
        end

        Walker.create(name: walker_name)
        puts "Welcome to Busy Paws, #{walker_name}!"
        Walker.choose_action(walker_name)
    end

    # def see_upcoming_appointments
    #     if Walker.find_by(name: walker_name).appointments.length > 0
    #         walkers_appointments = Walker.find_by(name: walker_name).appointments
    #         walkers_appointments.each { |appointment|
    #             puts "You are walking #{appointment.dog.name} at #{appointment.time} on #{appointment.date}." 
    #         }
    #     else 
    #         puts "You don't have any appointments."
    #         zero_appointments
    #     end
    # end

    # def zero_appointments
    #     answer = prompt.select("Would you like to make a dog walking appointment?", "Yes", "No")

    #     if answer == "Yes"
    #         see_dogs
    #     else
    #         puts "Pick something else to do!"
    #         choose_action
    #     end
    # end

    # def see_walkers_dogs
    #     walkers_dogs = Walker.find_by(name: walker_name).dogs
    #     walkers_dogs = walkers_dogs.all.map { |dog|
    #         dog.name
    #     }

    #     puts "Here are all the dogs you've walked: #{walkers_dogs.join(", ")}."
    # end

end