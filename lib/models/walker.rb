require_relative '../../config/environment'
require_all 'lib'

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

        when "Cancel an appointment"

        when "See all the dogs I've walked"
            Dog.see_dogs_walked(walker_name)
        when "Exit"
            Walker.exit(walker_name)
        end
    end

    def self.exit(walker_name)
        puts "Thanks for visiting!"
        system 'exit!'
    end

end