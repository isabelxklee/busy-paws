require_relative '../../config/environment'
require_all 'lib'

# As a User, I want to be able to…
# ✅login or create an account
# ✅browse available dogs
# ✅read information about the dog i will be walking
# ✅schedule a dog walking appointment
# ✅see all my upcoming walks
# ✅see all the dogs i've walked
# ✅see how many dogs i've walked
# ❌change my walking appointment
# ❌cancel my walking appointment

class Interface
    attr_accessor :prompt

    def initialize
        @prompt = TTY::Prompt.new
        puts 'Welcome to Busy Paws, the best dog walking app in the world!'
        self.login_or_create_account
    end

    def login_or_create_account
         answer = @prompt.select("Would you like to login or create a new account?", "Login", "Create a new account")

        if answer == "Login"
            self.login
        else
            self.create_account
        end
    end

    def login
        walker_name = @prompt.ask("What's your username?", required: true) 
        
        if Walker.find_by(name: walker_name)
            puts "Welcome back, #{walker_name}!"
            Walker.choose_action(walker_name)
        else
            puts "Oops, it looks like your username does not exist."
            answer = @prompt.select("Would you like to create a new account?", "Yes", "No, try logging in again")

        if answer == "Yes"
            self.create_account
        else
            self.login
        end
        end
    end

    def create_account
        walker_name = @prompt.ask("What would you like your username to be?") do |q|
            q.required true
            q.modify :remove
        end

        if Walker.find_by(name: walker_name)
            puts "Looks like that username is already taken."
            self.create_account
        else
            Walker.create(name: walker_name)
            puts "Welcome to Busy Paws, #{walker_name}!"
            Walker.choose_action(walker_name)
        end
    end

    # def see_walkers_dogs
    #     walkers_dogs = Walker.find_by(name: walker_name).dogs
    #     walkers_dogs = walkers_dogs.all.map { |dog|
    #         dog.name
    #     }

    #     puts "Here are all the dogs you've walked: #{walkers_dogs.join(", ")}."
    # end

end