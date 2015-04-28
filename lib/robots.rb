
# Not follow an link in that category
#if * assume thats a param
#  if * falls between 2 /'s then check for a param between those
#  if * falls after a word within a param block all urls that match including /click* blocks /clickhole
#  if * falls before param the

# needs to support crawl delays
class Robots

 attr_reader :base_uri, :disallow

 def initialize(base_uri)
  @no_trespassing = true
  @base_uri = base_uri
 end

 def set_no_trespassing
  unless @disallow.select{|dnf| dnf == "/"}.length > 0
    @no_trespassing = false
  end
 end

  def discover
    @txt = get_robots.body
    create_disallow_list
  end

  def robots
    base_uri.scheme + "://" + base_uri.host + "/robots.txt"
  end

  def get_robots
    HTTParty.get(robots, headers: {"User-Agent" => USER_AGENT})
  end

  def included?(link)
    if @disallow.select{|dnf| match?(link, dnf)}.length > 0 || @no_trespassing
      true
    else
      false
    end
  end

  def match?(link, dnf)
    if dnf.select{|word| link.include?(word)}.length == dnf.length
      true
    else
      false
    end
  end

  def create_disallow_list
    clean_up
    @txt = @txt.split("user-agent:").map!{|ua| ua.split("disallow:") }
    @disallow = find_user_agents_disallow_list
    @disallow.flatten!.shift
    strip_stuff_for_now
  end 

  def user_agent_on_robots?
    @txt.include?(USER_AGENT)
  end

  def find_user_agents_disallow_list
    if user_agent_on_robots?
      search USER_AGENT
    else
      search "*"
    end
  end

  def search(ua)
    @txt.select { |list| list.include?(ua)}
  end

  def clean_up
    @txt.downcase!.gsub!("\n", "").gsub!("\s", "").gsub!("\t", "")
  end
  
  # strips spaces and splits words for each 
  # sets the no_trespassing here cause this is where it fits
  # I don't like it here though
  def strip_stuff_for_now
    @disallow.map!{|dnf| dnf.gsub("*", "").gsub("$", "")}
    set_no_trespassing
    @disallow.map!{|dnf| dnf.split("/") }
    @disallow.each{|dnf| dnf.delete("")}
  end
end