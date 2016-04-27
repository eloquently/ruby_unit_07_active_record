require 'sqlite3'
require 'fileutils'

db_path = 'db/seeded_test_db.sqlite3'
clean_db_path = 'db/seeded_test_db_clean.sqlite3'

if !File.exist?(clean_db_path)
    @db = SQLite3::Database.new(clean_db_path)
    schema_sql = File.read('lib/schema.sql')
    puts "Setting up clean copy of db from schema and seed data"
    @db.execute_batch(schema_sql)
    seed_data = File.read('lib/seed_data.sql')
    puts "Seeding db... this may take a few min (and should only run once)"
    @db.execute_batch(seed_data)
    puts "Seeding complete"
    @db.close
else
    puts "clean copy of db exists ... done"
end
FileUtils.cp(clean_db_path, db_path)