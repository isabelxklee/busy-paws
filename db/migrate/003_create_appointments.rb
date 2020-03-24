class CreateAppointments < ActiveRecord::Migration[5.2]
    def change
        create_table :appointments do |t|
            t.integer :dog_id
            t.integer :walker_id
            t.date :date
            t.time :time
        end 
    end
end