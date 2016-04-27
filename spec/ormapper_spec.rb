require 'ormapper'
require 'sqlite3'

db_path = 'db/seeded_test_db.sqlite3'
clean_db_path = 'db/seeded_test_db_clean.sqlite3'

$database_path = db_path

class School < ORMapper
end
class HighSchool < ORMapper
end
class Student < ORMapper
end

describe ORMapper do

    before :each do
        FileUtils.rm(db_path)
        FileUtils.cp(clean_db_path, db_path)
    end

    describe '::table_name' do
        it 'gives correct table name by default' do
            expect(School.table_name).to eq('schools')
            expect(HighSchool.table_name).to eq('high_schools')
        end

        it 'allows custom table name' do
            class CustomSchool < ORMapper
                self.table_name = 'my_schools_table'
            end

            expect(CustomSchool.table_name).to eq('my_schools_table')
        end
    end
=begin
    describe '::columns' do
        it 'returns list of columns' do
            expect(School.columns).to eq([:id, :name, :min_grade, :max_grade, :next_school_id])
            expect(Student.columns).to eq([:id, :first_name, :last_name, :school_id, :grade_level])
        end
        it 'does not overwrite other descendents' do
            expect(School.columns).to eq([:id, :name, :min_grade, :max_grade, :next_school_id])
            expect(Student.columns).to eq([:id, :first_name, :last_name, :school_id, :grade_level])
            expect(School.columns).to eq([:id, :name, :min_grade, :max_grade, :next_school_id])
        end
    end

    describe '#attributes' do
        it 'returns a hash of the attributes' do
            s = School.new
            expect(s.attributes).to eq( {id: nil, name: nil, min_grade: nil, max_grade: nil, next_school_id: nil})
        end
    end

    describe '::create_column_accessors' do
        class School < ORMapper
            self.create_column_accessors
        end
        class Student < ORMapper
            self.create_column_accessors
        end
        class Test < ORMapper
            self.create_column_accessors
        end
        it 'creates setter and getter methods' do
            s = School.new
            expect(s.respond_to?(:name)).to eq(true)
            expect(s.respond_to?(:name=)).to eq(true)
        end
        it 'creates methods that work' do
            s = School.new
            expect(s.name).to be_nil
            s.name = 'Tempe High'
            expect(s.name).to eq('Tempe High')
        end
    end

    describe '#initialize' do
        it 'creates new object with correct attributes' do
            s = School.new(name: 'Tempe High')
            expect(s.name).to eq('Tempe High')

            s2 = School.new(name: 'McClintock High', min_grade: 9, max_grade: 12)
            expect(s2.name).to eq('McClintock High')
            expect(s2.min_grade).to eq(9)
            expect(s2.max_grade).to eq(12)
        end

        it 'ignores parameters that are not columns in the table' do
            s = School.new(name: 'Tempe High', fake_param: 'test')
            expect(s.name).to eq('Tempe High')
            expect(s.attributes.values.include?('test')).to eq(false)
        end

        it 'works with (i.e. ignores) integer keys' do
            s = School.new(name: 'Tempe High', 0 => 'test')
            expect(s.name).to eq('Tempe High')
            expect(s.attributes.values.include?('test')).to eq(false)
        end

        it 'works with string keys' do
            s = School.new("name" => 'Tempe High')
            expect(s.name).to eq('Tempe High')
        end
    end

    describe '::all' do
        it 'finds all schools in the table' do
            schools = School.all
            expect(schools.count).to eq(6)
            students = Student.all
            expect(students.count).to eq(1200)
        end

        it 'returns an array of objects with correct columns' do
            schools = School.all
            schools.each do |school|
                expect(school.is_a? School).to eq(true)
                expect(school.id).to_not be_nil
                expect(school.name).to_not be_nil
                expect(school.min_grade).to_not be_nil
                expect(school.max_grade).to_not be_nil
            end
        end
    end

    describe '::count' do
        it 'returns the number of records in the database' do
            expect(School.count).to eq(6)
            expect(Student.count).to eq(1200)
        end
    end

    describe '::find' do
        it 'finds the correct record' do
            s = School.find(1)
            expect(s.name).to eq("Phoenix High School")
        end

        it 'returns false if the record is not found' do
            expect(School.find(-1)).to eq(false)
        end
    end

    describe "::where" do
        it 'finds multiple records' do
            expect(Test.where(score: 80).count).to be > 1
            expect(Student.where(school_id: 1, grade_level: 11).count).to be > 1
        end

        it 'returns an array of objects with columns' do
            results = Test.where(score: 80)
            results.each do |r|
                expect(r.is_a? Test).to eq(true)
                expect(r.score).to eq(80)
                expect(r.name).to_not be_nil
                expect(r.class_id).to_not be_nil
                expect(r.student_id).to_not be_nil
            end
        end

    end

    describe '#insert' do
        it 'inserts new record into database' do
            s = School.new(name: "Mesa High School", min_grade: 9, max_grade: 12)
            expect{ s.insert }.to change { School.count }.by 1

            st = Student.new(first_name: "Harriet", last_name: "Tubman", school_id: 1, grade_level: 9 )
            expect{ st.insert }.to change { Student.count }.by 1
        end

        it 'updates id on ruby object' do
            s = School.new(name: "Mesa Middle School", min_grade: 6, max_grade: 8)
            s.insert
            expect(s.id).to_not be_nil
            expect(s.id).to be >= 1
        end

        it 'returns true if successful' do
            s = School.new(name: "Mesa Elementary School", min_grade: 1, max_grade: 5)
            expect(s.insert).to eq(true)
        end

        it 'returns false if unsuccessful' do
            # this query will fail because we have are putting text into an INTEGER column
            s = School.new(name: nil, min_grade: 9, max_grade: 12)
            expect(s.insert).to eq(false)
        end
    end

    describe '#update' do
        it 'updates fields' do
            s = Student.all[0]
            s.first_name = "Hubert"
            s.last_name = "Humphrey"
            s.update
            reloaded_student = Student.all[0]
            expect(reloaded_student.first_name).to eq("Hubert")
            expect(reloaded_student.last_name).to eq("Humphrey")
        end

        it 'does not add any new rows' do
            s = Student.all[0]
            s.first_name = "Hubert"
            s.last_name = "Humphrey"
            expect { s.update }.to change { Student.count }.by 0
        end

        it 'does not change id' do
            s = Student.all[0]
            s.first_name = "Hubert"
            s.last_name = "Humphrey"
            orig_id = s.id
            s.update
            reloaded_student = Student.all[0]
            expect(reloaded_student.id).to eq(orig_id)
        end
    end

    describe '#save' do
        it 'updates if student is already in database' do
            school = School.find(1)
            school.name = "Schooly McSchoolface"
            expect(school).to receive(:update).and_return(nil)
            school.save
        end
        it 'updates if student is already in database' do
            school = School.new(name: "Schooly McSchoolface")
            expect(school).to receive(:insert).and_return(nil)
            school.save
        end
    end
=end
end