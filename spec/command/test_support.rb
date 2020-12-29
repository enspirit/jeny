require 'spec_helper'
module Jeny
  class Command
    describe Support do
      include Support

      let(:from) {
        FIXTURES/"rubygem"
      }

      let(:to) {
        Path.dir/"hello"
      }

      let(:data) {
        { "name" => "hello" }
      }

      it 'works as expected' do
        t = target_for(from/"_name_.jeny/methods.rb")
        expect(t).to eq(to/"hello/methods.rb")
      end

    end
  end
end
