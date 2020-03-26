class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    attr_accessor :prompt, :dog_names, :appt_date, :appt_time, :selected_dog

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
        puts "Please enter a date in the future (example format: May 1, 2020)."
        @appt_date = gets.chomp
        @appt_date = Date.parse(@appt_date).strftime("%B %d, %Y")
        puts "The date you've selected is #{@appt_date}."
    end

    def self.get_time
        puts "Please enter a time."
        @appt_time = gets.chomp
        @appt_time = Time.parse(@appt_time).strftime("%I:%M %p")
        puts "The time you've selected is #{@appt_time}."
    end

    def self.make_appointment(selected_dog, walker_name)
        Appointment.todays_date
        Appointment.get_date
        Appointment.get_time

        Appointment.create(dog_id: Dog.id(@selected_dog), walker_id: Walker.id(walker_name), date: @appt_date, time: @appt_time)
        Appointment.show_appointment(@selected_dog, walker_name, @appt_date, @appt_time)
    end

    def self.show_appointment(selected_dog, walker_name, appt_date, appt_time)
        puts "Great! #{walker_name}, your dog walking appointment is at #{@appt_time} on #{@appt_date} with #{@selected_dog}."

        Walker.choose_action(walker_name)
    end

    def self.see_upcoming_appointments(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Walker.appointments(walker_name).each { |appointment|
                puts "You are walking #{appointment.dog.name} at #{Appointment.convert(appointment.time, "imp")} on #{Appointment.convert(appointment.date, "bdy")}." 
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

    def self.list_of_appointments(walker_name)
        i = 0
        @formatted_list_of_walkers_apps = Walker.appointments(walker_name).map { |appointment|
            "#{i+=1}. #{appointment.dog.name} at #{appointment.time.strftime("%I:%M %p")} on #{appointment.date.strftime("%D")}"
        }
    end

    def self.select_appointment(walker_name)
        Appointment.list_of_appointments(walker_name)
        selected_app = @prompt.select("Which appointment would you like to cancel?", @formatted_list_of_walkers_apps)

        # find the correct appointment
        @app_position = selected_app.split('')[0].to_i - 1
    end

    def self.cancel_appointment(walker_name)
        @prompt = TTY::Prompt.new
        if Walker.num_of_appointments(walker_name) > 0
            Appointment.select_appointment(walker_name)
            Walker.appointments(walker_name)[@app_position].delete
            puts "Your appointment has been cancelled."
            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end 
    end

    def self.change_appointment(walker_name)
        @prompt = TTY::Prompt.new
        if Walker.num_of_appointments(walker_name) > 0
            Appointment.select_appointment(walker_name)

            # update the appointment
            Appointment.get_date
            Appointment.get_time

            # i don't think this part is working
            # for some reason, the date is not being saved. maybe there's something wrong with @appt_date?
            Walker.appointments(walker_name)[@app_position].date = @appt_date
            Walker.appointments(walker_name)[@app_position].time = @appt_time
            Walker.appointments(walker_name)[@app_position].save

            puts "Your appointment has been updated to #{@appt_time} on #{@appt_date}."
            Walker.choose_action(walker_name)
        else
            puts "You don't have any appointments."
            Appointment.no_appts(walker_name)
        end 
    end

end