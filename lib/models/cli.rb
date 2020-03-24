require_relative '../../config/environment'
require_all 'lib'

# As a User, I want to be able to…
    # browse available dogs
    # read information about the dog i will be walking
    # see all my previous walks
    # see the dog’s previous walks
    # schedule a dog walking appointment
    # change my walking appointment
    # cancel my walking appointment

# class CommandLineInterface
#     attr_accessor :dog_name
    
#     def greet
#         puts 'Welcome to Busy Paws, the best dog walking app in the world!'
#     end
# end

# def run
#     cli = CommandLineInterface.new
#     cli.greet
# end 

# def get_walker_name
#     puts "Thinking of walking a dog? We can help you with that!"
#     puts "First of all, tell us your name."
#     # prompt = TTY::Prompt.new
#     @walker_name = STDIN.gets.chomp.capitalize
#     Walker.create(name: @walker_name)
# end 

# def ask_to_see_dogs
#     puts "Nice to meet you, #{@walker_name}!"
#     puts "Now, would you like to see all our available dogs?"
#     @boolean = STDIN.gets.chomp
# end

# def all_dogs
#     positive_answers = ["yes", "yup", "yeah"]
#     if positive_answers.include?(@boolean.downcase)
#         dog_names = []
#         Dog.all.select { |dog|
#             dog_names << dog.name
#         }
#         puts "Here are all our available dogs: #{dog_names.join(", ")}"
#     else
#         puts "Goodbye!"
#     end
# end

# def dog_info
#     puts "Which dog would you like to walk?"
#     @dog_name = STDIN.gets.chomp

#     dog_age = Dog.find_by(name: @dog_name).age
#     dog_breed = Dog.find_by(name: @dog_name).breed
#     puts "#{@dog_name} is #{dog_age}-years old and a #{dog_breed}."
# end

# def make_appointment
#     puts "Which day would you like to walk #{@dog_name}?"
#     @appt_date = STDIN.gets.chomp

#     puts "What time would you like to walk #{@dog_name}?"
#     @appt_time = STDIN.gets.chomp
#     @appt_time = @appt_time.to_time

#     dog_id = Dog.find_by(name: @dog_name).id
#     walker_id = Walker.find_by(name: @walker_name).id

#     Appointment.new(dog_id: dog_id, walker_id: walker_id, date: @appt_date, time: @appt_time)
#     puts "Great! #{@walker_name}, your walking appointment is at #{@appt_time.hour}:#{@appt_time.min} on #{@appt_date.to_date} with #{@dog_name}."   
# end

# def does_dog_exist
#     if Dog.find_by(name: @dog_name)
#         puts "That's a real dog!"
#         p Dog.find_by(name: @dog_name).appointments
#     else
#         puts "Sorry that dog doesn't exist."
#     end
# end

# def show_appointments
#     appointments = Dog.find_by(name: @dog_name).appointments
#     appointments.each { |appointment|
#         puts "#{appointment.dog.name} is going to be walked by #{appointment.walker.name}."
#     }
# end