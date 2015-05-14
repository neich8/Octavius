require 'spec_helper'

describe "crawl" do
  it "requires a base_page" do
    Crawl.new("http://google.com")
  end
 
  it "gets links for base_page" do
    Crawl.any_instance.stub(:foo).and_return(:return_value)

   crawl = Crawl.new("https://test.com").start

  end



end