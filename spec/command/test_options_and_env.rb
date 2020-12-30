require 'spec_helper'
module Jeny
  describe Command do

    subject {
      Command.new
    }

    let(:empty_env){{
      'JENY_EDITOR' => nil,
      'EDITOR' => nil,
      'GIT_EDITOR' => nil,
      'JENY_STATE_MANAGER' => nil
    }}

    let(:saved_env){
      {}
    }

    let(:config) {
      Configuration.new
    }

    before(:each) do
      env.each_pair do |k,v|
        saved_env[k] = ENV[k]
        ENV[k] = v
      end
    end

    before(:each) do
      subject.parse_argv!(argv, config)
    end

    after(:each) do
      saved_env.each_pair do |k,v|
        ENV[k] = v
      end
    end

    context "when no argument nor env at all" do
      let(:argv){
        []
      }
      let(:env){
        empty_env
      }

      it 'should have a default config' do
        cfg = subject.config
        expect(cfg.jeny_block_delimiter).to eq("#jeny")
        expect(cfg.editor_command).to be_nil
        expect(cfg.state_manager.class).to eq(StateManager)
        expect(cfg.edit_changed_files?).to be_truthy
        expect(cfg.sm_commit?).to eq(true)
      end
    end

    context "when JENY_STATE_MANAGER is set to 'git'" do
      let(:argv){
        []
      }
      let(:env){empty_env.merge({
        'JENY_STATE_MANAGER' => 'git'
      })}

      context "on a default config" do
        it 'has a Git state manager' do
          cfg = subject.config
          expect(cfg.state_manager.class).to eq(StateManager::Git)
        end
      end

      context "on a config having another manager" do
        let(:config){
          Configuration.new{|c|
            c.state_manager = :none
          }
        }

        context 'when no argv are passed' do
          it 'the .jeny config takes the priority' do
            cfg = subject.config
            expect(cfg.state_manager.class).to eq(StateManager)
          end
        end

        context "when using --git" do
          let(:argv){
            [ "--git" ]
          }

          it '--git takes the priority' do
            cfg = subject.config
            expect(cfg.state_manager.class).to eq(StateManager::Git)
          end
        end
      end
    end

    context "when using --no-commit and --no-stash" do
      let(:argv){
        [ "--no-commit", "--no-stash" ]
      }
      let(:env){
        empty_env
      }

      it 'should set respective options to false' do
        cfg = subject.config
        expect(cfg.sm_stash?).to eq(false)
        expect(cfg.sm_commit?).to eq(false)
      end
    end

    context "when using --no-edit" do
      let(:argv){
        [ "--no-edit" ]
      }
      let(:env){
        empty_env
      }

      it 'should set edit_changed_files to false' do
        cfg = subject.config
        expect(cfg.edit_changed_files?).to eq(false)
      end
    end

    context "when using --edit" do
      let(:argv){
        [ "--edit" ]
      }
      let(:env){
        empty_env
      }

      it 'should set edit_changed_files to true' do
        cfg = subject.config
        expect(cfg.edit_changed_files?).to eq(Configuration::DEFAULT_EDIT_PROC)
      end
    end

    context "when using --edit-if" do
      let(:argv){
        [ "--edit-if=TRIC" ]
      }
      let(:env){
        empty_env
      }

      it 'should set edit_changed_files to true' do
        cfg = subject.config
        expect(cfg.edit_changed_files?).to be_a(Proc)
        expect(cfg.edit_changed_files?).not_to eq(Configuration::DEFAULT_EDIT_PROC)
        expect(cfg.edit_changed_files.call(Path.file, "Hello\n\nworld and TRIC\n")).to be_truthy
        expect(cfg.edit_changed_files.call(Path.file, "Hello\n\nworld and TROC\n")).to be_falsy
      end
    end

  end
end

