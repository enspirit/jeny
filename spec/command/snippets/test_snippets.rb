require 'spec_helper'
module Jeny
  describe Command::Snippets do

    EXPECTED_BLOCK_CONTENT = <<~TXT
    module Foo

      METHOD_LIST = [
        :hello,
        :foo,
        #jeny(method) :${op_name},
      ]

      def hello
        "World"
      end

      def foo
        # TODO: implement me
      end

      #jeny(method) def ${op_name}
      #jeny(method)   # TODO: implement me
      #jeny(method) end

    end
    TXT

    let(:source) {
      Path.dir/"source"
    }

    subject {
      Command.new.call(argv)
      Path.dir/"source"
    }

    after(:each) do
      system("git checkout #{source}/block.rb")
      (source/"foo").rm_rf
    end

    context "when data is passed inline" do
      let(:argv) {
        [
          "-d", "op_name:foo",
          "snippets",
          "method",
          source.to_s,
        ]
      }

      it 'works as expected' do
        subject
        expect((source/"block.rb").read).to eq(EXPECTED_BLOCK_CONTENT)
        expect((source/"foo/foo.rb").read).to eq(<<~Y)
        puts "Hello foo"
        Y
        expect((source/"foo/foo.js").read).to eq(<<~Y)
        console.log("Hello foo")
        Y
        expect((source/"foo/foo.txt").exist?).to eq(false)
      end
    end

    context "when passing a single file" do
      let(:argv) {
        [
          "-d", "op_name:foo",
          "snippets",
          "method",
          (source/"block.rb").to_s,
        ]
      }

      it 'instantiates the file only' do
        subject
        expect((source/"block.rb").read).to eq(EXPECTED_BLOCK_CONTENT)
        expect((source/"foo/foo.rb").file?).to eql(false)
        expect((source/"foo/foo.js").file?).to eql(false)
        expect((source/"foo/foo.txt").file?).to eql(false)
      end
    end

    context "when passing a list of files" do
      let(:argv) {
        [
          "-d", "op_name:foo",
          "snippets",
          "method",
          (source/"block.rb").to_s,
          (source/"${op_name}.jeny/${op_name}.rb.jeny").to_s,
        ]
      }

      it 'instantiates those files only' do
        subject
        expect((source/"block.rb").read).to eq(EXPECTED_BLOCK_CONTENT)
        expect((source/"foo/foo.rb").read).to eq(<<~Y)
        puts "Hello foo"
        Y
      end
    end
  end
end
