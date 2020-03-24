require_relative '../config/environment'
require_all 'lib'

interface = Interface.new()

# just call the first runner method, and chain the class methods to each other
# don't be afraid to create different classes for different pages / actions
# write class methods for methods that can be called between different classes
# write instance methods as private methods

# walker setup
# in the walker method, save the new walker instance as a variable
# use walker as a param for other methods
