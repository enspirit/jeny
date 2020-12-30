require 'spec_helper'

module Jeny
  describe Configuration, "should_be_edited?" do
    subject{
      config.should_be_edited?(file, content)
    }

    def a_config(editor = "code")
      Configuration.new{|c|
        c.editor_command = editor
        yield(c) if block_given?
      }
    end


    let(:file){
      Path.file
    }

    let(:content) {
      Path.file.read
    }

    context "when using a default config" do
      let(:config){ a_config(nil) }

      it{ expect(subject).to be_falsy }
    end

    context "when setting edit_changed_files to true" do
      let(:config){
        a_config("code"){|c|
          c.edit_changed_files = true
        }
      }

      it{ expect(subject).to be_truthy }
    end

    context "when setting edit_changed_files to true, but no editor" do
      let(:config){
        a_config(nil){|c|
          c.edit_changed_files = true
        }
      }

      it{ expect(subject).to be_falsy }
    end


    context "when setting edit_changed_files to a regexp" do
      let(:config){
        a_config("code"){|c|
          c.edit_changed_files = /configuration.rb/
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

    context "when setting edit_changed_files to a Proc" do
      let(:config){
        a_config("code"){|c|
          c.edit_changed_files = ->(f,c){
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