# External URL
# JS Script link
# Image

# 

class Link
  attr_reader :uri
  attr_accessor :page, :visited, :real

  def initialize(og_url)
    begin
      @uri = URI(og_url)
      @visited = false
      generate
      @real = true
    rescue Exception => e 
      @real = false
    end
  end

  def generate
    begin
      @uri.scheme ||= BASE.scheme
      @uri.host ||= BASE.host
      @uri.port = if BASE.uri.port == "3000" && !@uri.port
                    BASE.uri.port
                  end
    if is_in_scope? 
      @follow = true
    else
      @follow = false
    end
    rescue Exception => e 
      @follow = false
    end
  end

  def follow?
    !@visited && valid?
  end

  def is_in_scope?
    valid_path? && get_links? && valid_scheme?
  end

  def get_links?
    begin
      url.include?(BASE.url)
    rescue Exception => e 
      binding.pry
    end
  end

  def valid?
    valid_path? && valid_scheme?
  end

  def valid_scheme?
    @uri.scheme == nil  || @uri.scheme.include?("http")
  end

  def valid_path?
    @uri.respond_to?(:path) &&  !real_path
  end

  def real_path
    ["#", "", "/", "/sitemap.xml"].include?(@uri.path)
  end

  def url
    key = @uri
    key.query, key.fragment = nil, nil
    key.to_s
  end

end