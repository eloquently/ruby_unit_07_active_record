# to run your tests, you will need to run the following command to set up the
# db. It will take a couple minutes to run. Note: don't just copy your db files
# from the previous exercises. The schema is slightly different, so they needd
# to be created from scratch
#       ruby spec/set_up_dbs.rb

require 'active_support/inflector'
require 'sqlite3'

# change this if necessary
$database_path ||= "db/seeded_test_db.sqlite3"

# use this db object to query the database
$db = SQLite3::Database.new($database_path)
$db.results_as_hash = true

# close db when program quits
at_exit do
    puts "Closing db..."
    $db.close if $db != nil
    puts "Exiting program"
end

class ORMapper
    # We need a class variable and accessor methods to keep track of what table
    # we'll be accessing. By default, the table name will be based on the class
    # name. The convention is to have class names be singular nouns in
    # CamelCase and table names be plural nouns in snake_case
    # e.g. the SchoolDistrict class would map to the school_districts table

    # Use the pluralize and underscore methods from active_support/inflector to
    # convert.

    # Since users of your ORmapper class may want custom table names or
    # active_support may give the wrong pluralization of a word (see what
    # happens if you try to pluralize human or singularize harddrives), we will
    # also need to let users use a custom table_name.

    # This method will return the table_name class variable if its set.
    # Otherwise return the default table name (pluralized and snake_case version
    # of the class name)
    @table_name = nil
    def self.table_name
        # return ____ || self.new.class.to_s.___________________
    end

    # This method will allow users to choose their own table name instead of the
    # default table name
    def self.table_name=(table_name)
    end

    # This method will return an array of columns in the table corresponding
    # to the object. It should work lazily -- that is, it shouldn't calculate
    # the columns until the method is called. Once it has been called, it should
    # store the columns in a class variable, and then if it's called in the
    # future it should return that class variable.

    # the column names should be symbols

    # Use the sqlite3 gem's execute2 method to get the column names.

    # since ::columns is a class method rather than an instance method,
    # if you want to refer to from inside an instance method, use
    # self.class.columns (same for table_name)
    @columns = nil
    def self.columns
    end

    # We want to be able to store data kept in the rows of our database in our
    # object. To do that we will create a hash called attributes. Attributes
    # will have a key/value pair for each column in the database. For a new
    # object, the values should all be nil, but the keys should all be present.

    # create an attributes getter method that will return the @attributes
    # instance variable if it exists. If it doesn't exist, it return create a
    # hash with a key for each column in the database, with nil for each value
    @attributes = nil
    def attributes
    end

    # Now all we need is setter and getter methods for each column.
    # Think about the my_attr_accessor methods that you wrote earlier. The main
    # difference here is that these setters and getters will read/write the
    # attributes hash rather than instance variables
    # this will allow us to do things like:
    # school = School.new
    # school.attributes # => {id: nil, name: nil, min_grade: nil, max_grade: nil, next_school_id: nil}
    # school.name = "Tempe High"
    # school.attributes # => {id: nil, name: "Tempe High", min_grade: nil, max_grade: nil, next_school_id: nil}
    # school.name # => "Tempe High"

    def self.create_column_accessors
    end

    # Instead of setting each attribute individually, it would be much easier to
    # do so with a hash when we construct a new object. Write a constructor
    # for the class that takes a hash, params, as the argument.
    # params will be a hash of key value pairs, where the keys are names of
    # columns and the values are the values for those columns.
    # You should avoid manipulating the @attributes hash directly here and
    # instead use the setter methods you created. (Use the Object#send method
    # we discussed during the lecture).
    #
    # It's possbile that some keys in params will not be columns in the table.
    # Therefore, you should only try to set a param if the key is in the
    # attributes hash.
    #
    # In order to make this class as flexible as possible, you should make it
    # work if the keys of params are symbols, strings, or integers (as the
    # sqlite3 gem returns). Hint: you should convert each key to a string and then
    # to a symbol when you check to see if it's in the attribute hash's keys.
    #
    # When calling the constructor to make a new object that is not in your
    # database, you should not give it an id. Let the database handle this
    # for you when you save the object (this will work out great if you use
    # autoincrement on your primary key when you create the table).
    def initialize(params={})
    end

    # Now that the general framework for our ORM mapper is set up, let's start
    # getting actually doing the mapping!

    # Write a method that will get all of the records from the database, and
    # return an array of them in object form.
    def self.all
    end

    # Let's write a method that counts how many elements there are.
    # It would be possible to do ORMapper.all.count, but this is not very
    # efficient, as it must load every item in the database into memory.
    # We can use the COUNT(*) SQL aggregator to get the count without needing to
    # load the rest of the data.
    def self.count
    end

    # Find a record by primary key. This should return an object or false if no
    # record is found.
    # Remember to use the ? substitution so you are not vulnerable to SQL
    # injection attacks.
    def self.find(id)
    end

    # We might want to search records by some of their attributes, rather than
    # looking them up by primary key.
    # This method takes a hash, params, and searches the table for records where
    # the keys (column names) are equal to the values. For example,
    #   Student.where(school_id: 1, grade_level: 9)
    # will run the query:
    #
    #   SELECT
    #       *
    #   FROM
    #       students
    #   WHERE
    #       school_id = ? AND grade_level = ?;
    #
    # If no records are found, this method should return an empty array
    def self.where(params)
    end

    # We want a way to save new objects we create in ruby back to our database.
    # This method will run an insert statement against the database and return
    # true if it succeeds and false if it fails.
    # The insert statement should look something like this:
    #
    #   INSERT INTO
    #          schools (name, min_grade, max_grade, next_school_id)
    #   VALUES
    #       (?, ?, ?, ?);
    #
    # Then, when you call this method, you would use:
    # $db.execute(sql, *["Test School", 1, 12, 2])
    #
    # Since this method needs to work more generallly, you will need lists
    # of column names and question marks that are based on the attributes hash
    #
    # Because we are using AUTOINCREMENT on our id columns we let the database
    # take care of assigning an id for us. If the insert is successful, we
    # should get the id from the database and save it to our attributes hash.
    # You'll need another query to do that. You can use the MAX() aggregation
    # function on the id column to get the latest id.
    def insert
    end

    # If the object has already been saved in the database and we want to
    # change it, we'll need an update query. The update will look like:
    #
    #   UPDATE
    #       schools
    #   SET
    #       name = ?, min_grade = ?, max_grade = ?, next_school_id = ?
    #   WHERE
    #       id=?;
    #
    # and then to call the method you would do something like:
    #   $db.execute(sql, *["Test School", 1, 12, 2, 1])
    def update
    end

    # It's annoying for developers to remember whether their objects have
    # already been persisted to the database and if they should save them using
    # #insert or #update.
    # This method is a convenience method that will Do the Right Thing:
    # insert the record if it has not already been persisted
    # otherwise, update the record.
    def save
    end
end