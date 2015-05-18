
# Require all files in Lib
Dir[File.join(File.dirname(__FILE__), "..", "lib" , "**.rb")].each{|f| require f}

require 'rspec'
require 'pry'
require 'uri'

BASE = URI("https://testing.com")

RSpec.configure do |c|
  c.order = "random"
  c.formatter = 'documentation'
  c.color = true
    c.tty = true
  # c.fail_fast = true

end