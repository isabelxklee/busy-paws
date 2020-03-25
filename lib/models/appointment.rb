class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    attr_accessor :prompt, :dog_names

    def self.make_appointment(selected_dog, walker_name)
        @prompt = TTY::Prompt.new

        todays_date = Time.now.strftime("%B %d, %Y")
        puts "Today's date is #{todays_date}."
        puts "You can schedule an appointment up to 6 months in advance."
        
        appt_date = @prompt.ask("Which date would you like to walk #{selected_dog}? (Example format: May 1, 2020)", convert: :date)

        appt_time = @prompt.ask("What time would you like to walk #{selected_dog}?", convert: :datetime)

        Appointment.show_appointment(selected_dog, walker_name, appt_date, appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        dog_id = Dog.find_by(name: selected_dog).id
        
        walker_id = Walker.find_walker(walker_name).id
        Appointment.create(dog_id: dog_id, walker_id: walker_id, date: appt_date, time: appt_time)

        puts "Great! #{walker_name}, your dog walking appointment is at #{appt_time.strftime("%I:%M %p")} on #{appt_date.strftime("%D")} with #{selected_dog}."

        Walker.choose_action(walker_name)
    end

    def self.see_upcoming_appointments(walker_name)
        walkers_apps = Walker.appointments(walker_name)

        if Walker.num_of_appointments(walker_name) > 0
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

    def self.cancel_appointment(walker_name)
        @prompt = TTY::Prompt.new
        i=0
        walkers_apps = Walker.appointments(walker_name)

        if Walker.num_of_appointments(walker_name) > 0
            formatted_list_of_walkers_apps = walkers_apps.map { |appointment|
                "#{i+=1}. #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
            }

            selected_app = @prompt.select("Which appointment would you like to cancel?", formatted_list_of_walkers_apps)

            # find the correct appointment
            app_position = selected_app.split('')[0].to_i - 1
            walkers_apps[app_position].delete

            puts "Your appointment has been cancelled."
            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end 
    end

    def self.change_appointment(walker_name)
        @prompt = TTY::Prompt.new
        i=0
        walkers_apps = Walker.appointments(walker_name)

        if Walker.num_of_appointments(walker_name) > 0
            formatted_list_of_walkers_apps = walkers_apps.map { |appointment|
                "#{i+=1}. #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
            }

            selected_app = @prompt.select("Which appointment would you like to change?", formatted_list_of_walkers_apps)

            # find the correct appointment
            app_position = selected_app.split('')[0]
            app_position = app_position.to_i
            app_position -= 1

            # update the appointment
            date_or_time = @prompt.select("Would you like to change the date or the time?", "Date", "Time")

            if date_or_time == "Date"
                new_date = @prompt.ask("Pick your new date (Example format: May 1, 2020)", convert: :date)
                walkers_apps[app_position].date = new_date
                walkers_apps[app_position].save
                puts "Your updated appointment is at #{walkers_apps[app_position].time.strftime("%I:%M %p")} on #{new_date.strftime("%D")}."
            else
                new_time = @prompt.ask("Pick your new time", convert: :datetime)
                walkers_apps[app_position].time = new_time
                walkers_apps[app_position].save
                puts "Your updated appointment is at #{new_time.strftime("%I:%M %p")} on #{walkers_apps[app_position].date.strftime("%D")}."
            end 

            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end 
    end

end