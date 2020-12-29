require 'spec_helper'
module Jeny
  describe Command::Generate do

    let(:from) {
      (FIXTURES/"rubygem")
    }

    let(:to) {
      Path.dir/"got/hello"
    }

    subject {
      Command.new.call(argv)
      Path.dir/"expected/hello"
    }

    before(:each) do
      to.rm_rf
    end

    shared_examples_for "A hello rubygem generated" do
      it 'is generated as expected' do
        subject.glob("**/*") do |path|
          target = path.relocate(subject, to)
          expect(target).to exist
          expect(target.read).to eq(path.read) if target.file?
        end
      end
    end

    context "when data is passed inline" do
      let(:argv) {
        [
          "-d", "name:hello",
          "generate",
          from.to_s,
          to.to_s
        ]
      }

      it_behaves_like "A hello rubygem generated"
    end

    context "when data is passed as a file" do
      let(:argv) {
        [
          "-f", (Path.dir/"gdata.json").to_s,
          "generate",
          from.to_s,
          to.to_s
        ]
      }

      it_behaves_like "A hello rubygem generated"
    end

  end
end
