require_relative '../config/environment'
require_all 'lib'

interface = Interface.new()
interface.greet
interface.login_or_create_account
interface.choose_action

# Florencia Hilpert II
# think about writing class methods vs. instance methods for prompt tty