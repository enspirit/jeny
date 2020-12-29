require 'spec_helper'
module Jeny
  describe Command::Snippets do

    let(:source) {
      Path.dir/"source"
    }

    let(:expected) {
      Path.dir/"expected"
    }

    subject {
      Command.new.call(argv)
      Path.dir/"source"
    }

    after(:each) do
      system("git checkout #{source}/foo.rb")
    end

    context "when data is passed inline" do
      let(:argv) {
        [
          "-d", "name:foo",
          "snippets",
          "method",
          source.to_s,
        ]
      }

      it 'works as expected' do
        subject
        expect((source/"foo.rb").read).to eq(<<~Y)
        module Foo

          def hello
            "World"
          end

          def foo
            # TODO: implement me
          end

          #jeny(method) def ${name}
          #jeny(method)   # TODO: implement me
          #jeny(method) end
        
        end
        Y
      end
    end

  end
end
