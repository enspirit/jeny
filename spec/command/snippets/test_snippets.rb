require 'spec_helper'
module Jeny
  describe Command::Snippets do

    let(:source) {
      Path.dir/"source"
    }

    subject {
      Command.new.call(argv)
      Path.dir/"source"
    }

    after(:each) do
      system("git checkout #{source}/block.rb")
      (source/"context.rb").rm_rf
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
        expect((source/"block.rb").read).to eq(<<~Y)
        module Foo

          METHOD_LIST = [
            :hello,
            :foo,
            #jeny(method) :${name},
          ]

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
        expect((source/"context.rb").read).to eq(<<~Y)
        puts "Hello foo"
        Y
      end
    end

  end
end
