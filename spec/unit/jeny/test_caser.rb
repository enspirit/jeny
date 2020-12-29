require 'spec_helper'
module Jeny
  describe Caser do

    let(:src){
      "hello world"
    }

    {
      :flat => "helloworld",
      :upper => "HELLO WORLD",
      :upperflat => "HELLOWORLD",
      :screaming => "HELLO_WORLD",
      :constant => "HELLO_WORLD",
      :macro => "HELLO_WORLD",
      :underscore => "hello_world",
      :snake => "hello_world",
      :camel => "helloWorld",
      :pascal => "HelloWorld",
      :kebab => "hello-world",
      :train => "Hello-World",
      :header => "Hello-World",
      :cobol => "HELLO-WORLD",
      :donner => "hello|world",
    }.each_pair do |k,v|
      describe k do
        it 'works' do
          expect(Caser.send(k, src)).to eq(v)
        end
      end
    end

    describe '.for_hash' do
      it 'works as expected' do
        got = Caser.for_hash({
          "name" => "hello",
          "op" => [
            { "name" => "world" }
          ]
        })
        expect(got).to eql({
          "name" => "hello",
          "Name" => "Hello",
          "NAME" => "HELLO",
          "op" => [{
            "name" => "world",
            "Name" => "World",
            "NAME" => "WORLD",
          }]
        })
      end
    end

  end
end