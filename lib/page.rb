require 'link'

class Page
  attr_accessor :visited
  attr_reader :status_code, :body, :page_url, :error

  def initialize(page, status_code, error, body=nil, storage="csv")
    @page_url = Link.new(URI(page))
    @status_code = status_code
    @error = error
    @body = body
    send(storage.to_sym)
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

  def csv
    CSV.open(CSV_NAME, "ab") do |csv|
      csv << [location, status_code, error]
    end
  end
end