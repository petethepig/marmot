module Marmot
  class MarmotError < StandardError ; end
end

require 'marmot/version'
require 'marmot/options_sanitizer'
require 'marmot/client'