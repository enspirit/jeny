require 'spec_helper'
module Jeny
  describe Command do

    subject {
      Command.new
    }

    let(:empty_env){{
      'JENY_EDITOR' => nil,
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
        expect(cfg.editor_command).to eq("code")
        expect(cfg.state_manager.class).to eq(StateManager)
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

        it 'takes the priority' do
          cfg = subject.config
          expect(cfg.state_manager.class).to eq(StateManager)
        end
      end
    end

  end
end

