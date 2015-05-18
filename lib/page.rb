require 'link'

class Page
  attr_accessor :visited
<<<<<<< HEAD
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
=======
  attr_reader :status_code, :body, :link, :error

  def initialize(page, status_code, error, body=nil, storage="csv")
    @link = Link.new(URI(page))
    @status_code = status_code
    @error = error
    @body = body
    # send(storage.to_sym)
>>>>>>> 2413ae9dd012bd5272618fb2c5db089a5dd715d2
  end

  def links
    body.css("a").map{|a| a.attributes["href"].to_s}
  end

  def images
    body.css("img").map{|a| a.attributes["src"].to_s}
  end

  def csv
    CSV.open(CSV_NAME, "ab") do |csv|
<<<<<<< HEAD
      csv << [location, status_code, error, request_id, Time.now]
=======
      csv << [link.url, status_code, error]
>>>>>>> 2413ae9dd012bd5272618fb2c5db089a5dd715d2
    end
  end
end