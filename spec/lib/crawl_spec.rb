require 'spec_helper'

describe "crawl" do
  it "requires a base_page" do
    Crawl.new("http://google.com")
  end

end