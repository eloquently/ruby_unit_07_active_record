class Object
    # a parameter like *variables is called a splat operator
    # you can call my_attr_accessor with an array of variable names
    # like:
    #           my_attr_reader :id, :name
    # then there will be an array called variables inside the
    # my_attr_accessor method that you can access like any other array
    # e.g.
    #           variables[0] # => :id
    #
    # Use the define_method method to create the setter and getter
    # methods for the instance variables passed as parameters
    # for my_attr_reader and my_attr_writer, you should use the methods
    # instance_variable_get and instance_variable_set that are provided
    # by ruby's Object class. Look them up in the documentation for more
    # info and examples of how to use them.

    # writer (aka setter) methods are called variable_name=
    def self.my_attr_reader(*variables)
    end

    def self.my_attr_writer(*variables)
    end

    def self.my_attr_accessor(*variables)
    end
end