#!/usr/bin/env ruby

require 'rexml/document' 
require 'date' 

USERNAME="mvaccari"
PASSWORD="mvaccari"

UserStory = Struct.new(:key, :status, :estimated_complexity, :team, :title, :resolution_date)

class JiraBacklog
  def initialize(all_stories_filename)
    xml = REXML::Document.new(File.open(all_stories_filename))
    @stories = {}
    xml.elements.each("//item") do |el|
      key = subelement(el, "key")
      status = subelement(el, "status")
      team = subelement(el, "component")
      title = subelement(el, "title")
      @stories[key] = UserStory.new(key, status, estimated_complexity(el), team, title, resolution_date(el))
    end
  end
  
  def number_of_stories
    @stories.keys.size
  end
  
  def [](key)
    @stories[key]
  end
  
  def report
    puts "key:team:status:estimated complexity:title:resolution_date"
    @stories.keys.sort.each do |key|
      s = @stories[key]
      puts "#{s.key}:#{s.team}:#{s.status}:#{s.estimated_complexity}:#{s.title}:#{s.resolution_date}"
    end
  end
  
  protected
  
  def subelement(el, path)
    sub = el.elements[path]
    sub.text if sub
  end
  
  def custom_field(el, id)
    xpath = "customfields/customfield[@id='#{id}']/customfieldvalues/customfieldvalue"
    x = el.elements[xpath]
    x.text if x
  end

  def estimated_complexity(el)
    v = custom_field(el, 'customfield_10010')
    v.to_i if v
  end
  
  def resolution_date(el)
    s = custom_field el, 'customfield_10000'
    return nil unless s
    DateTime.parse(s).strftime("%Y-%m-%d")
  end
end




def produce_report

  def login
    system "curl -s -c cookies.txt -d os_username=#{USERNAME} -d os_password=#{PASSWORD} -o /dev/null http://jira.ea.borsaitaliana.it/login.jsp"
  end

  def get_all_stories 
      url="http://jira.ea.borsaitaliana.it/sr/jira.issueviews:searchrequest-xml/10031/SearchRequest-10031.xml?tempMax=1000"
      system "curl -b cookies.txt -o all_stories.xml #{url}"
  end

  login
  get_all_stories
  backlog = JiraBacklog.new("all_stories.xml")
  backlog.report
end


