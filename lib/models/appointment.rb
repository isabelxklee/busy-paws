class Appointment < ActiveRecord::Base
    belongs_to :dog
    belongs_to :walker

    def format_time
        appt_time = self.time
        appt_time = "#{appt_time.hour}:#{appt_time.min}"
    end

end