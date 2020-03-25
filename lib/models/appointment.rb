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
        
        appt_date = @prompt.ask("Which date would you like to walk #{selected_dog}? (Example format: May 1, 2020)", convert: :date)
        # appt_date = appt_date.strftime("%D")

        appt_time = @prompt.ask("What time would you like to walk #{selected_dog}?", convert: :datetime)
        # appt_time = appt_time.strftime("%I:%M %p")

        Appointment.show_appointment(selected_dog, walker_name, appt_date, appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        dog_id = Dog.find_by(name: selected_dog).id
        walker_id = Walker.find_by(name: walker_name).id
        Appointment.create(dog_id: dog_id, walker_id: walker_id, date: appt_date, time: appt_time)

        puts "Great! #{walker_name}, your dog walking appointment is at #{appt_time.strftime("%I:%M %p")} on #{appt_date.strftime("%D")} with #{selected_dog}."

        Walker.choose_action(walker_name)
    end

    def self.see_upcoming_appointments(walker_name)
        walkers_apps = Walker.find_by(name: walker_name).appointments

        if Walker.find_by(name: walker_name).appointments.length > 0
            walkers_apps.each { |appointment|
                puts "You are walking #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}." 
              }
        else 
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end

        Walker.choose_action(walker_name)
    end

    def self.no_appts(walker_name)
        @prompt = TTY::Prompt.new
        answer = @prompt.select("Would you like to schedule a dog walking appointment?", "Yes", "No")

        if answer == "Yes"
            Dog.see_dogs(walker_name)
        else
            puts "Pick something else to do!"
            Walker.choose_action(walker_name)
        end
    end

    # def self.cancel_appointment(walker_name)
    #     @prompt = TTY::Prompt.new

    #     walkers_apps = Walker.find_by(name: walker_name).appointments.map { |appointment|
    #         "#{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
    #     }

    #     answer = @prompt.select("Which appointment would you like to cancel?", walkers_apps)
    # end

    ################## SIMPLE WAY OF DOING THIS ########################
    # def self.cancel_appointment(walker_name)
    #     @prompt = TTY::Prompt.new

    #     walkers_apps = Walker.find_by(name: walker_name).appointments
    #     selected_app = @prompt.select("Which appointment would you like to cancel?", walkers_apps)
    #     puts selected_app
    #     selected_app.delete
    #     puts "Your appointment has been cancelled."
    # end

    ##################### SLIGHTLY MORE COMPLICATED WAY OF DOING THIS #######################
    # can we identify the appointment with its place in the array of appointments?
    # user-facing: number the appointments available to them
    # back-end: delete the correct appointment by subtracting 1 from the user-facing number to find the index in an array of appointments
    def self.cancel_appointment(walker_name)
        @prompt = TTY::Prompt.new
        i=0
        walkers_apps = Walker.find_by(name: walker_name).appointments
        formatted_list_of_walkers_apps = walkers_apps.map { |appointment|
            "#{i+=1}. #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
        }

        selected_app = @prompt.select("Which appointment would you like to cancel?", formatted_list_of_walkers_apps)

        # find the correct appointment
        app_position = selected_app.split('')[0]
        app_position = app_position.to_i
        app_position -= 1
        walkers_apps[app_position].delete

        puts "Your appointment has been cancelled."
    end

end