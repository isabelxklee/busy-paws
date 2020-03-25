class Walker < ActiveRecord::Base
    has_many :appointments
    has_many :dogs, through: :appointments
    attr_accessor :prompt

    def self.choose_action(walker_name)
        @prompt = TTY::Prompt.new
        answer = @prompt.select("What would you like to do?", "Walk a dog", "See my upcoming appointments", "Change an appointment", "Cancel an appointment", "See all the dogs I've walked", "Exit")

        case answer
        when "Walk a dog"
            Dog.see_dogs(walker_name)
        when "See my upcoming appointments"
            Appointment.see_upcoming_appointments(walker_name)            
        when "Change an appointment"
            Appointment.change_appointment(walker_name)
        when "Cancel an appointment"
            Appointment.cancel_appointment(walker_name)
        when "See all the dogs I've walked"
            Dog.see_dogs_walked(walker_name)
        when "Exit"
            Walker.exit
        end
    end

    def self.find_walker(walker_name)
        Walker.find_by(name: walker_name)
    end

    def self.id(walker_name)
        Walker.find_by(name: walker_name).id
    end

    def self.appointments(walker_name)
        Walker.find_walker(walker_name).appointments
    end

    def self.num_of_appointments(walker_name)
        Walker.find_walker(walker_name).appointments.length
    end

    def self.walkers_dogs(walker_name)
        walked_dogs = Walker.appointments(walker_name).map { |appointment|
            appointment.dog.name
        }.uniq.join(", ")
        puts "You've walked #{walked_dogs}!"
    end

    def self.exit
        puts "Thanks for visiting!"
        system 'exit!'
    end

end