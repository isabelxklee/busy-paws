class Dog < ActiveRecord::Base

    has_many :appointments
    has_many :walkers, through: :appointments
    attr_accessor :appt_date, :appt_time, :dog_names

    @@prompt = TTY::Prompt.new

    def self.happy_dog
        puts "
   .-------------.       .    .   *       *   
   /_/_/_/_/_/_/_/ \         *       .   )    .
  //_/_/_/_/_/_// _ \ __          .        .   
 /_/_/_/_/_/_/_/|/ \.' .`-o                    
  |             ||-'(/ ,--'                    
  |             ||  _ |                        
  |             ||'' ||                        
  |_____________|| |_|L                     
        ".colorize(:magenta)
    end

    def self.age(dog_name)
        Dog.find_by(name: dog_name).age
    end

    def self.breed(dog_name)
        Dog.find_by(name: dog_name).breed
    end 

    def self.id(dog_name)
        Dog.find_by(name: dog_name).id
    end 

    def self.see_dogs(walker_name)
        sleep 1
        answer = @@prompt.select("Would you like to see all our available dogs?", "Yes", "No")
        sleep 1
        if answer == "Yes"
            puts "Great! Let's see those pups.".colorize(:color => :white, :background => :magenta)
            sleep 1
            Dog.happy_dog
            Dog.all_dogs(walker_name)
        else
            puts "Boo hoo.".colorize(:yellow)
            sleep 1
            Walker.choose_action(walker_name)
        end
    end 

    def self.all_dogs(walker_name)
        @dog_names = Dog.all.map(&:name)
        sleep 1
        puts "Here are all our available dogs: #{@dog_names.join(", ")}"
        sleep 1
        Dog.dog_info(walker_name)
    end

    def self.dog_info(walker_name)
        selected_dog = @@prompt.select("Which dog would you like to walk?", @dog_names)
        sleep 1
        puts "#{selected_dog} is #{Dog.age(selected_dog)}-years old and a(n) #{Dog.breed(selected_dog)}."
        sleep 1
        Appointment.make_appointment(selected_dog, walker_name)
    end

    def self.see_dogs_walked(walker_name)
        if Walker.num_of_appointments(walker_name) > 0
            Walker.walkers_dogs(walker_name)
            sleep 1
            Walker.choose_action(walker_name)
        else
            puts "You haven't walked any dogs yet.".colorize(:yellow)
            sleep 1
            Appointment.no_appts(walker_name)
        end
    end

end