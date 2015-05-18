require 'spec_helper'


describe "Link" do

  let(:link) {Link.new(BASE.to_s)}

  it "responds with the url" do
    expect(link.url).to eql(BASE.to_s)
  end

  it "knows if its a legitimate route" do
    expect(link).to be_truthy
    bad_path_link = Link.new("https://test.com/#")
    expect(bad_path_link.real_path).to be_falsey
  end

  it "should know if its a sub url from BASE" do
    sub_link = Link.new(BASE.to_s + "/stuff")
    expect(sub_link.is_in_scope?).to be_truthy
  end

  it "should know if its not a sub url from BASE" do
    link = Link.new("https://bs.url.com")
    expect(link.is_in_scope?).to be_falsey
  end

  it "know whats a real path" do
    valid_path = Link.new(BASE.to_s + "/path")
    expect(link.valid_path?).to be_falsey
    expect(valid_path.valid_path?).to be_truthy
  end

  it "generates a url when given a path for BASE" do
    path = "/path"
    link = Link.new(path)
    expect(link.url).to eql(BASE.to_s + path)
  end

  it "should tell when to follow" do
    new_link = Link.new("/path")
    expect(new_link.follow?).to be_truthy
  end


end