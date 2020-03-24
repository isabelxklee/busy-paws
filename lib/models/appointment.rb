require_relative '../../config/environment'
require_all 'lib'

class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker
    attr_accessor :prompt, :dog_names

    def self.make_appointment(selected_dog, walker_name)
        @prompt = TTY::Prompt.new
        
        appt_date = @prompt.ask("Which day would you like to walk #{selected_dog}?", convert: :date)
        appt_time = @prompt.ask("What time would you like to walk #{selected_dog}?", convert: :datetime)

        appt_date = appt_date.strftime("%m/%d/%Y")
        appt_time = appt_time.strftime("%I:%M %p") 

        Appointment.show_appointment(selected_dog, walker_name, appt_date, appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        dog_id = Dog.find_by(name: selected_dog).id
        walker_id = Walker.find_by(name: walker_name).id
        Appointment.new(dog_id: dog_id, walker_id: walker_id, date: appt_date, time: appt_time)

        puts "Great! #{walker_name}, your dog walking appointment is at #{appt_time} on #{appt_date} with #{selected_dog}."

        Walker.choose_action(walker_name)
    end

    # def self.change_appointment()
    # end

end