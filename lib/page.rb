require 'link'

class Page
  attr_accessor :visited
  attr_reader :status_code, :body, :page_url

  def initialize(page, status_code=200, body=nil)
    @page_url = Link.new(URI(page))
    @status_code = status_code
    @body = body
  end

  def links
    body.css("a").map{|a| a.attributes["href"].to_s}
  end

  def images
    body.css("img").map{|a| a.attributes["src"].to_s}
  end

  def location
    @page_url.url
  end
end