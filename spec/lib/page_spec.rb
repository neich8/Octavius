require "spec_helper"

describe "Page" do
  let(:page) {Page.new(BASE, 200, false)}
  it "has a link" do
  	binding.pry
    expect(page.link.uri).to eql(Link.new(BASE).uri)
  end

end