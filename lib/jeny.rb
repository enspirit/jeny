require 'path'
require 'wlang'
module Jeny
  class Error < StandardError; end
end
require_relative 'jeny/version'
require_relative 'jeny/configuration'
require_relative 'jeny/caser'
require_relative 'jeny/dialect'
require_relative 'jeny/file'
require_relative 'jeny/code_block'
require_relative 'jeny/command'
