require 'my_attr_accessor'

class Hello
    my_attr_accessor :message, :message2

    def initialize(message, message2)
        @message = message
        @message2 = message2
    end
end


# The way these tests are written, none of them will pass
# until you have written all three of my_attr_reader,
# my_attr_writer, and my_attr_accessor. If they are right,
# they will all pass.

describe 'my_attr_accessor' do
    describe 'my_attr_reader' do
        it 'returns instance variable value' do
            h = Hello.new("hello",'hi')
            expect(h.message).to eq("hello")
            expect(h.message2).to eq('hi')
        end
    end

    describe 'my_attr_writer' do
        it 'returns instance variable value' do
            h = Hello.new("hello", 'hi')
            h.message = "goodbye"
            h.message2 = 'bye'
            expect(h.message).to eq("goodbye")
            expect(h.message2).to eq('bye')
        end
    end
end
