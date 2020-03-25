class Dog < ActiveRecord::Base
    # require_relative 'module.rb'
    # include Helper

    has_many :appointments
    has_many :walkers, through: :appointments
    attr_accessor :prompt, :appt_date, :appt_time, :dog_names

    def self.dog_age(dog_name)
        Dog.find_by(name: dog_name).age
    end

    def self.dog_breed(dog_name)
        Dog.find_by(name: dog_name).breed
    end 

    def self.see_dogs(walker_name)
        @prompt = TTY::Prompt.new
        answer = @prompt.select("Would you like to see all our available dogs?", "Yes", "No")
        
        if answer == "Yes"
            puts "Great! Let's see those pups."
            Dog.all_dogs(walker_name)
        else
            puts "Boo hoo."
            Walker.choose_action(walker_name)
        end
    end 

    def self.all_dogs(walker_name)
        @dog_names = Dog.all.map(&:name)
        puts "Here are all our available dogs: #{@dog_names.join(", ")}"

        Dog.dog_info(walker_name)
    end

    def self.dog_info(walker_name)
        selected_dog = @prompt.select("Which dog would you like to walk?", @dog_names)
        puts "#{selected_dog} is #{Dog.dog_age(selected_dog)}-years old and a #{Dog.dog_breed(selected_dog)}."
        Appointment.make_appointment(selected_dog, walker_name)
    end

    def self.see_dogs_walked(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Walker.walkers_dogs(walker_name)
        else
            puts "You haven't walked any dogs yet."
            Appointment.no_appts(walker_name)
        end
    end

end