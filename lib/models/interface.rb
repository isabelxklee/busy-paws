require_relative '../../config/environment'
require_all 'lib'

# As a User, I want to be able to…
# ✅login or create an account
    # if the user logs in, what should they be able to do?
# ✅browse available dogs
# ✅read information about the dog i will be walking
# ✅schedule a dog walking appointment
    # make sure users can only schedule future appointments
    # create an available time range from 8am to 10pm
    # how can i format the time and date globally?
    # so that i don't have to do it in each method?
# ✅see all my upcoming walks
# ✅see all the dogs i've walked
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
        @walker_name = prompt.ask("What's your name?") #do |q|
        #     q.required true
        #     q.validate /\A\w+\Z/
        #     q.modify   :capitalize
        # end

        puts "Welcome back, #{@walker_name}!"
    end

    def create_account
        @walker_name = prompt.ask("What's your name?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            q.modify   :capitalize
        end

        Walker.create(name: @walker_name)
        puts "Welcome to Busy Paws, #{@walker_name}!"
    end

    def choose_action
        answer = prompt.select("What would you like to do?", "Walk a dog", "See my upcoming appointments", "Change an appointment", "Cancel an appointment", "See all the dogs I've walked")

        case answer
        when "Walk a dog"
            see_dogs
        when "See my upcoming appointments"
            see_upcoming_appointments
        when "Change an appointment"

        when "Cancel an appointment"

        when "See all the dogs I've walked"
            see_walkers_dogs
        end
    end

    # def format_time
    #     # Appointment.all.map { |appointment|
    #     #     appt_time = appointment.time.strftime("%I:%M %p")
    #     # }

    #     self.time.strftime("%I:%M %p")
    # end

    # def format_date
    #     # Appointment.all.map { |appointment|
    #     #     appt_date = appointment.date.strftime("%m/%d/%Y")
    #     # }
    #     self.date.strftime("%m/%d/%Y")
    # end

    def see_upcoming_appointments
        if Walker.find_by(name: @walker_name).appointments.length > 0
            walkers_appointments = Walker.find_by(name: @walker_name).appointments
            walkers_appointments.each { |appointment|
                puts "You are walking #{appointment.dog.name} at #{appointment.time} on #{appointment.date}." 
            }
        else 
            puts "You don't have any appointments."
            zero_appointments
        end
    end

    def zero_appointments
        answer = prompt.select("Would you like to make a dog walking appointment?", "Yes", "No")

        if answer == "Yes"
            see_dogs
        else
            puts "Pick something else to do!"
            choose_action
        end
    end

    def see_dogs
        answer = prompt.select("Would you like to see all our available dogs?", "Yes", "No")

        if answer == "Yes"
            puts "Great! Let's see those puppers."
            all_dogs
        else
            puts "Boo hoo."
        end
    end 

    def all_dogs
        @dog_names = Dog.all.map { |dog|
            dog.name
        }
        puts "Here are all our available dogs: #{@dog_names.join(", ")}"

        dog_info
    end

    def dog_info
        @selected_dog = prompt.select("Which dog would you like to walk?", @dog_names)

        dog_age = Dog.find_by(name: @selected_dog).age
        dog_breed = Dog.find_by(name: @selected_dog).breed
        puts "#{@selected_dog} is #{dog_age}-years old and a #{dog_breed}."

        make_appointment
    end

    def make_appointment
        @appt_date = prompt.ask("Which day would you like to walk #{@selected_dog}?", convert: :date)
        @appt_time = prompt.ask("What time would you like to walk #{@selected_dog}?", convert: :datetime)

        @appt_date = @appt_date.strftime("%m/%d/%Y")
        @appt_time = @appt_time.strftime("%I:%M %p") 

        show_appointment
    end

    def show_appointment
        dog_id = Dog.find_by(name: @selected_dog).id
        walker_id = Walker.find_by(name: @walker_name).id
        Appointment.new(dog_id: dog_id, walker_id: walker_id, date: @appt_date, time: @appt_time)

        puts "Great! #{@walker_name}, your dog walking appointment is at #{@appt_time} on #{@appt_date} with #{@selected_dog}."   
    end

    def see_walkers_dogs
        walkers_dogs = Walker.find_by(name: @walker_name).dogs
        walkers_dogs = walkers_dogs.all.map { |dog|
            dog.name
        }

        puts "Here are all the dogs you've walked: #{walkers_dogs.join(", ")}."
    end

end