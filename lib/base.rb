# TODO REMOVE AND TREAT AS A LINK
require "link"

class Base < Link

  attr_reader :url, :uri, :robots_disallow_list

  def initialize(url)
    @url = url
    @uri = URI(url)
    generate
  end

  def scheme
    @uri.scheme
  end

  def path
    @uri.path
  end

  def host
    @uri.host
  end




end