module Helper
    def find_walker(walker_name)
        Walker.find_by(walker_name)
    end
end 

# def convert_time(time, format)
#     if format == "bdy"
#         time.strftime("%B %d, %Y")
#     elsif format == "imp"
#         time.
#     end
# end
# e.g. todays_date = convert_time(Time.now, "bdy")