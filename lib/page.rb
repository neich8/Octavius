require 'link'

class Page
  attr_accessor :visited
  attr_reader :status_code, :body, :page_url, :error, :request_id

  def initialize(page, status_code, error, extras= {})
    @page_url = Link.new(URI(page))
    @status_code = status_code
    @error = error
    @body = extras[:extras]
    @request_id = set_request_id(extras)
    csv
  end

  def set_request_id(extras)
    if extras[:resp]
      extras[:resp].headers["x-request-id"]
    end
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
      csv << [location, status_code, error, request_id, Time.now]
    end
  end
end