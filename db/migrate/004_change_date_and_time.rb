class ChangeDateAndTime < ActiveRecord::Migration[5.2]
    def change
        change_column :appointments, :date, :date
        change_column :appointments, :time, :time
    end
end