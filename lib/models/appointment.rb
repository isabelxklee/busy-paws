class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    @@prompt = TTY::Prompt.new

    attr_accessor :dog_names, :appt_date, :appt_time

    def self.convert(datetime, format)
        if format == "bdy"
            datetime.strftime("%B %d, %Y")
        elsif format == "imp"
            datetime.strftime("%I:%M %p")
        end
    end

    def self.todays_date
        todays_date = Time.now.strftime("%B %d, %Y")
        puts "Today's date is #{todays_date}."
    end 

    def self.get_date
        puts "Please enter a date in the future (example format: May 1, 2020).".colorize(:color => :white, :background => :magenta)
        sleep 1
        @appt_date = gets.chomp
        Appointment.future_date
    end

    def self.get_time
        puts "Please enter a time between 8:00 AM and 8:00 PM.".colorize(:color => :white, :background => :magenta)
        sleep 1
        @appt_time = gets.chomp
        Appointment.time_range
    end

    def self.time_range
        start_time = "8:00AM"
        end_time = "8:00pm"
    
        if Time.parse(@appt_time) < Time.parse(start_time)
            puts "Time must be after 8:00 AM.".colorize(:yellow)
            sleep 1
            Appointment.get_time
        elsif Time.parse(@appt_time) > Time.parse(end_time)
            puts "Time must be before 8:00 PM.".colorize(:yellow)
            sleep 1
            Appointment.get_time
        else
            @appt_time = Time.parse(@appt_time).strftime("%I:%M %p")
            puts "The time you've selected is #{@appt_time}."
        end
    end
    
    def self.future_date
        if Date.parse(@appt_date) < Date.today+1
            puts "Date must be in the future.".colorize(:yellow)
            sleep 1
            Appointment.get_date
        else
            @appt_date = Date.parse(@appt_date).strftime("%B %d, %Y")
            puts "The date you've selected is #{@appt_date}."
        end
    end

    def self.make_appointment(selected_dog, walker_name)
        Appointment.todays_date
        Appointment.get_date
        Appointment.get_time

        Appointment.create(dog_id: Dog.id(selected_dog), walker_id: Walker.id(walker_name), date: @appt_date, time: @appt_time)
        Appointment.show_appointment(selected_dog, walker_name, @appt_date, @appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        puts "Great! #{walker_name}, your dog walking appointment is at #{@appt_time} on #{@appt_date} with #{selected_dog}.".colorize(:color => :white, :background => :magenta)
        sleep 1
        Walker.choose_action(walker_name)
    end

    def self.see_upcoming_appointments(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Appointment.appointment_confirmation(walker_name)
        else 
            puts "You don't have any appointments.".colorize(:yellow)
            sleep 1
            Appointment.no_appts(walker_name)
        end

        Walker.choose_action(walker_name)
    end

    def self.appointment_confirmation(walker_name)
        Walker.appointments(walker_name).each { |appointment|
            puts "You're walking #{appointment.dog.name} at #{Appointment.convert(appointment.time, "imp")} on #{Appointment.convert(appointment.date, "bdy")}."
                }
    end

    def self.no_appts(walker_name)
        answer = @@prompt.select("Would you like to schedule a dog walking appointment?", "Yes", "No")

        if answer == "Yes"
            Dog.see_dogs(walker_name)
        else
            puts "Pick something else to do!"
            sleep 1
            Walker.choose_action(walker_name)
        end
    end

    def self.list_of_appointments(walker_name)
        i = 0
        @formatted_list_of_walkers_apps = Walker.appointments(walker_name).map { |appointment|
            "#{i+=1}. #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
        }
    end

    def self.select_appointment(walker_name)
        Appointment.list_of_appointments(walker_name)
        sleep 1
        selected_app = @@prompt.select("Which appointment would you like to choose?", @formatted_list_of_walkers_apps)

        # find the correct appointment
        @app_position = selected_app.split('')[0].to_i - 1
    end

    def self.cancel_appointment(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Appointment.select_appointment(walker_name)
            Walker.appointments(walker_name)[@app_position].delete
            puts "Your appointment has been cancelled."
            sleep 1
            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments.".colorize(:yellow)
            sleep 1
            Appointment.no_appts(walker_name)
        end 
    end

    def self.change_appointment(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Appointment.select_appointment(walker_name)

            Appointment.get_date
            Appointment.get_time

            Walker.appointments(walker_name)[@app_position].update(date: @appt_date)
            Walker.appointments(walker_name)[@app_position].update(time: @appt_time)

            puts "Your appointment has been updated to #{@appt_time} on #{@appt_date}."
            sleep 1
            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments.".colorize(:yellow)
            sleep 1
            Appointment.no_appts(walker_name)
        end 
    end

end