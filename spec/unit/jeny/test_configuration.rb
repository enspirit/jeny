require 'spec_helper'

module Jeny
  describe Configuration, "should_be_edited?" do
    subject{
      config.should_be_edited?(file, content)
    }

    let(:file){
      Path.file
    }

    let(:content) {
      Path.file.read
    }

    context "when using a default config" do
      let(:config){ Configuration.new }

      it{ expect(subject).to be_falsy }
    end

    context "when setting open_editor_on_snippets to true" do
      let(:config){
        Configuration.new{|c|
          c.open_editor_on_snippets = true
        }
      }

      it{ expect(subject).to be_truthy }
    end

    context "when setting open_editor_on_snippets to true, but no editor" do
      let(:config){
        Configuration.new{|c|
          c.editor_command = nil
          c.open_editor_on_snippets = true
        }
      }

      it{ expect(subject).to be_falsy }
    end


    context "when setting open_editor_on_snippets to a regexp" do
      let(:config){
        Configuration.new{|c|
          c.open_editor_on_snippets = /configuration.rb/
        }
      }

      context "when file name matches" do
        it{ expect(subject).to be_truthy }
      end

      context "when file name does not match" do
        let(:file){
          Path.dir/"test_caser.rb"
        }

        it{ expect(subject).to be_falsy }
      end
    end

    context "when setting open_editor_on_snippets to a Proc" do
      let(:config){
        Configuration.new{|c|
          c.open_editor_on_snippets = ->(f,c){
            c == "hello"
          }
        }
      }

      context "when it returns true" do
        let(:content){ "hello" }

        it{ expect(subject).to be_truthy }
      end

      context "when it returns false" do
        let(:content){ "world" }

        it{ expect(subject).to be_falsy }
      end
    end
  end
end