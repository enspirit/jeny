require 'spec_helper'

module Jeny
  describe File::Full do

    let(:config) {
      Configuration.new{|c|
      }
    }

    let(:file){
      File::Full.new(path, config)
    }

    describe 'instantiate' do
      subject{
        file.instantiate({ "name" => "hello", "Name" => "Hello" })
      }
      let(:path){
        FIXTURES/"rubygem/lib/_name_.rb.jeny"
      }

      it 'works as expected' do
        expect(subject).to eq(<<~RB)
          module Hello
          end
          require_relative 'hello/version'
        RB
      end
    end

  end
end
