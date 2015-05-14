
require 'robots'

class Crawl

  attr :robots, :base_page

  def initialize(base_page,options={})
    # TO be searched
    @queue = []
    @pages = {}
    @base_page = base_page    
  end

  def start
    get_links_for parse_document(@base_page.link.url)
  end

  def check_robots
    @robots = Robots.new(@base_page.link.uri)
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
      [true, HTTParty.get(url)]
    rescue Exception => e 
      [false, e]
    end
  end

  def parse_document url
    puts "visiting #{url}"
    resp = get url
    if resp[0]
      parsed = Nokogiri::HTML(resp[1])
      @pages[url] = Page.new(url, resp[1].code, false, parsed)
      @pages[url].visited = true
      @pages[url]
    else
      @pages[url] = Page.new(url,404, resp[1])
      false
    end
  end

end