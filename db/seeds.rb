require 'faker'

Dog.destroy_all
Walker.destroy_all
Appointment.destroy_all

5.times do 
    Dog.create(name: Faker::Name.first_name, breed: Faker::Creature::Dog.breed, age: Faker::Number.within(range: 1..15))
    
    Walker.create(name: Faker::Name.name)

    Appointment.create(dog_id: Dog.all.sample.id, walker_id: Walker.all.sample.id, date: Faker::Date.forward(days: 60), time: Faker::Time.forward(days: 5,  period: :evening, format: :long))
end 