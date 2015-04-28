#TODO 
#Handle the extra / at the end of urls
# Handle Crazy Redirects ex 5 redirects <- Doing 
# Handle JS Error Check
# Better Queueing system ie Redis...
# handle robots for new sites entered into the queue

# Icebox 
#  Handle url params when too many of same 
# Handle Subdomains ?
# Check For Layout errors/warnings
# Thread Responsibly
# SiteMaps
require 'robots'

class Crawl

  attr :robots, :base_page

  def initialize(base_page,options={})
    # TO be searched
    @queue = []
    @pages = {}
    @base_page = base_page
    check_robots
    get_links_for parse_document(base_page.location)
  end

  def check_robots
    @robots = Robots.new(base_page.page_url.uri)
    @robots.discover
  end

  def breadth
    while @queue.length > 0
      doc = parse_document(@queue.pop)
      if doc
        get_links_for(doc)
      end
    end
    puts "\n\n\n\n\n" 
    puts "searched #{@pages.length} pages"
  end

  # breadth

  private
# The logic for previously visited Is currently not working.
# Once Working Crawler should be alive!
  def get_links_for doc
    doc.links.each  do |a|
      link = Link.new(a)
      if link.real && !already_grabbed?(link) && link.follow? && link.get_links? && !@robots.included?(link.url)
        @queue.push(link.url)
      end
    end
  end

  def already_grabbed?(link)
    @queue.include?(link.url) || @pages[link.url]
  end

# Yes, I know this is a wrapper however this will catch errors and not follow said pages
  def get url
    begin
      HTTParty.get(url)
    rescue Exception => e 
      false
    end
  end

  def parse_document url
    puts "visiting #{url}"
    resp = get url
    if resp
      parsed = Nokogiri::HTML(resp)
      @pages[url] = Page.new(url, resp, parsed)
      @pages[url].visited = true
      @pages[url]
    else
      @pages[url] = Page.new(url, 404)
      false
    end
  end

end