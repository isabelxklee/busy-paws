require_relative '../../config/environment'
require_all 'lib'
require 'date'

class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker
    attr_accessor :prompt, :dog_names

    def self.make_appointment(selected_dog, walker_name)
        @prompt = TTY::Prompt.new

        todays_date = Time.now
        puts "Today's date is #{todays_date.strftime("%B %d, %Y")}."
        puts "You can schedule an appointment up to 6 months in advance."
        
        appt_date = @prompt.ask("Which day would you like to walk #{selected_dog}?", convert: :date)
        appt_date = appt_date.strftime("%m/%d/%Y")

        appt_time = @prompt.ask("What time would you like to walk #{selected_dog}?", convert: :datetime)
        appt_time = appt_time.strftime("%I:%M %p")

        Appointment.show_appointment(selected_dog, walker_name, appt_date, appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        dog_id = Dog.find_by(name: selected_dog).id
        walker_id = Walker.find_by(name: walker_name).id
        Appointment.create(dog_id: dog_id, walker_id: walker_id, date: appt_date, time: appt_time)

        puts "Great! #{walker_name}, your dog walking appointment is at #{appt_time} on #{appt_date} with #{selected_dog}."

        Walker.choose_action(walker_name)
    end

    def self.see_upcoming_appointments(walker_name)
        if Walker.find_by(name: walker_name).appointments.length > 0
            walkers_appointments = Walker.find_by(name: walker_name).appointments

            walkers_appointments.each { |appointment|
                puts "You are walking #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%m/%d/%Y")}." 
            }

        else 
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end
    end

    def self.no_appts(walker_name)
        @prompt = TTY::Prompt.new
        answer = @prompt.select("Would you like to schedule a dog walking appointment?", "Yes", "No")

        if answer == "Yes"
            Dog.see_dogs
        else
            puts "Pick something else to do!"
            Walker.choose_action(walker_name)
        end
    end

end