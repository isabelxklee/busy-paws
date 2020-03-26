class Interface
    attr_accessor :prompt

    def initialize
        @prompt = TTY::Prompt.new
        Interface.intro
        puts "Welcome to Busy Paws, the best dog walking app in town!".colorize(:color => :white, :background => :magenta)
        self.login_or_create_account
    end

    def self.intro
        puts "
                    |``_/|                  
                    | 0 0   arf arf! 
                    |   <>               
                    |  _/``------____ (( ))
                    |               `--' |   
                ____|_       ___|   |___.' 
                /_/_____/____/_______|     

        ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗    ████████╗ ██████╗ 
        ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝    ╚══██╔══╝██╔═══██╗
        ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗         ██║   ██║   ██║
        ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝         ██║   ██║   ██║
        ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗       ██║   ╚██████╔╝
        ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝       ╚═╝    ╚═════╝ 
        ██████╗ ██╗   ██╗███████╗██╗   ██╗    ██████╗  █████╗ ██╗    ██╗███████╗            
        ██╔══██╗██║   ██║██╔════╝╚██╗ ██╔╝    ██╔══██╗██╔══██╗██║    ██║██╔════╝            
        ██████╔╝██║   ██║███████╗ ╚████╔╝     ██████╔╝███████║██║ █╗ ██║███████╗            
        ██╔══██╗██║   ██║╚════██║  ╚██╔╝      ██╔═══╝ ██╔══██║██║███╗██║╚════██║            
        ██████╔╝╚██████╔╝███████║   ██║       ██║     ██║  ██║╚███╔███╔╝███████║            
        ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝       ╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝   
                                                    |``_/|                  
                                                    | 0 0   woof!                           
                                                    |   <>               
                                                    |  _/``------____ (( ))
                                                    |               `--' |   
                                                ____|_       ___|   |___.' 
                                                /_/_____/____/_______|     
        ".colorize(:magenta)
    end

    def login_or_create_account
         answer = @prompt.select("Would you like to login or create a new account?", "Login", "Create a new account", "Exit")

         case answer
         when "Login"
            self.login
         when "Create a new account"
            self.create_account
         when "Exit"
            puts "Thanks for visiting!".colorize(:color => :white, :background => :magenta)
            system 'exit!'
         end
    end

    def login
        walker_name = @prompt.ask("What's your username?", required: true) 
        
        if Walker.find_walker(walker_name)
            puts "Welcome back, #{walker_name}!".colorize(:color => :white, :background => :magenta)
            Walker.choose_action(walker_name)
        else
            username_doesnt_exist
        end
    end

    def username_doesnt_exist
        puts "Oops, it looks like your username does not exist.".colorize(:yellow)

        answer = @prompt.select("Would you like to create a new account?", "Yes", "No, try logging in again")
        answer == "Yes" ? self.create_account : self.login
    end

    def create_account
        walker_name = @prompt.ask("What would you like your username to be?") do |q|
            q.required true
            q.modify :remove
        end

        if Walker.find_walker(walker_name)
            puts "Looks like that username is already taken.".colorize(:yellow)
            self.create_account
        else
            Walker.create(name: walker_name)
            puts "Welcome to Busy Paws, #{walker_name}!".colorize(:color => :white, :background => :magenta)
            Walker.choose_action(walker_name)
        end
    end
end