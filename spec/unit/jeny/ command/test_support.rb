require 'spec_helper'
module Jeny
  class Command
    describe Support, "target_for" do
      include Support

      let(:from) {
        FIXTURES/"rubygem"
      }

      let(:to) {
        Path.dir/"expected"
      }

      let(:data) {
        Caser.for_hash({ "op_name" => "hello_world" })
      }

      subject {
        target_for(source, data)
      }

      context "when file name has no variable and no suffix" do
        let(:source){ from/"lib/version.rb" }

        it {
          expect(subject).to eq(to/"lib/version.rb")
        }
      end

      context "when file name has no variable and the .jeny suffix" do
        let(:source){ from/"lib/version.rb.jeny" }

        it {
          expect(subject).to eq(to/"lib/version.rb")
        }
      end

      context "when file name has a variable name" do
        let(:source){ from/"lib/${op_name}.rb" }

        it {
          expect(subject).to eq(to/"lib/hello_world.rb")
        }
      end

      context "when file name has a variable name in ancestors" do
        let(:source){ from/"lib/${op_name}/test_${op_name}.rb" }

        it {
          expect(subject).to eq(to/"lib/hello_world/test_hello_world.rb")
        }
      end

    end
  end
end
