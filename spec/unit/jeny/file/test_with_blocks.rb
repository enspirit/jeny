require 'spec_helper'

module Jeny
  describe File::WithBlocks do

    let(:config) {
      Configuration.new{|c|
      }
    }

    let(:file){
      File::WithBlocks.new(path, config)
    }

    describe 'has_jeny_blocks?' do
      context 'with default configuration' do
        subject{
          file.has_jeny_blocks?
        }

        context 'on a non jeny file' do
          let(:path){ FIXTURES/"various/no_block.rb" }

          it{ expect(subject).to eq(false) }
        end

        context 'on a jeny file' do
          let(:path){ FIXTURES/"various/one_block.rb" }

          it{ expect(subject).to eq(true) }
        end
      end
    end

    describe 'jeny_blocks' do
      subject{
        file.jeny_blocks
      }

      context 'on a file with only one block' do
        let(:path){
          FIXTURES/"various/one_block.rb"
        }

        it 'works as expected' do
          expect(subject).to be_a(Array)
          expect(subject.size).to eq(1)
          expect(subject.all?{|b| b.is_a?(CodeBlock) }).to eq(true)
          expect(subject.first.asset).to eq("op")
          expect(subject.first.source).to eq(<<Y)
  def ${name}
    # TODO
  end
Y
          expect(subject.first.line).to eq(9)
        end
      end
    end

    describe 'instantiate' do
      let(:path){
        FIXTURES/"various/one_block.rb"
      }

      context 'when op is not there' do
        subject{
          file.instantiate({})
        }
  
        it 'works as expected' do
          expect(subject).to eq(<<~RB)
          class Example

            def some_method
            end
          
            def another_one
            end
          
            #jeny(op) def ${name}
            #jeny(op)   # TODO
            #jeny(op) end
          
          end
          RB
        end
      end

      context 'when op is a Hash' do
        subject{
          file.instantiate({ "op" => { "name" => "hello" } })
        }
  
        it 'works as expected' do
          expect(subject).to eq(<<~RB)
          class Example

            def some_method
            end
          
            def another_one
            end
          
            def hello
              # TODO
            end
          
            #jeny(op) def ${name}
            #jeny(op)   # TODO
            #jeny(op) end
          
          end
          RB
        end
      end

      context 'when op is an Array of hashes' do
        subject{
          file.instantiate({ "op" => [{ "name" => "hello" },{ "name" => "world" }]})
        }
  
        it 'works as expected' do
          expect(subject).to eq(<<~RB)
          class Example

            def some_method
            end
          
            def another_one
            end
          
            def hello
              # TODO
            end
          
            def world
              # TODO
            end
          
            #jeny(op) def ${name}
            #jeny(op)   # TODO
            #jeny(op) end
          
          end
          RB
        end
      end
    end
  end
end
