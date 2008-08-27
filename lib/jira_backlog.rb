#!/usr/bin/env ruby

require 'rexml/document' 
require 'date' 

USERNAME="mvaccari"
PASSWORD="mvaccari"
JIRA_HOME_URL="jira.dev.borsaitaliana.it"

UserStory = Struct.new(:key, :status, :estimated_complexity, :team, :title, :resolution_date) do
  def not_closed
    status != "Closed" && status != "Resolved"
  end
end

class JiraBacklog
  def initialize(all_stories_filename=nil)
    @stories = {}
    return unless all_stories_filename
    xml = REXML::Document.new(File.open(all_stories_filename))
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
  
  def number_of_stories_for(team)
    all_story_of(team).size
  end
  
  def stories
    @stories
  end
  
  def all_story_of(team)
    collected = @stories.collect do |id, us|
      us if us.team == team
    end
    collected.compact
  end
  
  def not_yet_estimated_for(team)
    all_story_of(team).find_all {|story| story.estimated_complexity.nil? && story.not_closed }.size
  end
  
  def total_done_for(team)
    total = 0
    all_story_of(team).each do |us|
      total += us.estimated_complexity if us.estimated_complexity && us.status == "Closed"   
    end
    total
  end

  def total_of_all_for(team)
    total = 0
    all_story_of(team).each do |us|
      total += us.estimated_complexity if us.estimated_complexity      
    end
    total
  end

  def [](key)
    @stories[key]
  end
  
  def []=(key, value)
    @stories[key] = value
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

def login
  system "curl -s -c cookies.txt -d os_username=#{USERNAME} -d os_password=#{PASSWORD} -o /dev/null #{JIRA_HOME_URL}/login.jsp"
end

def get_all_stories 
  url="#{JIRA_HOME_URL}/sr/jira.issueviews:searchrequest-xml/10031/SearchRequest-10031.xml?tempMax=1000"
  system "curl -b cookies.txt -o all_stories.xml \"#{url}\""
end


