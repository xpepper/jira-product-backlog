#!/usr/bin/env ruby

require 'rexml/document' 
require 'date' 

JIRA_HOME_URL="dev.sourcesense.com/jira"
USERNAME="p.dibello"
PASSWORD="namu1253"

UserStory = Struct.new(:key, :status, :estimated_complexity, :team, :title) do
  def closed
    ["Closed"].include?(status)
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
      @stories[key] = UserStory.new(key, status, estimated_complexity(el), team, title)
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
    all_story_of(team).find_all {|story| story.estimated_complexity.nil? && !story.closed}.size
  end
  
  def in_status_for(aStatus, team)
    total = 0
    all_story_of(team).each do |us|
      total += us.estimated_complexity if us.estimated_complexity && us.status == aStatus   
    end
    total
  end
  
  def total_done_for(team)
    in_status_for("Closed", team)  
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
    v = custom_field(el, 'customfield_10030')
    v.to_i if v
  end
  
end

def login
  system "curl -k -s -c cookies.txt -d os_username=#{USERNAME} -d os_password=#{PASSWORD} -o /dev/null https://#{JIRA_HOME_URL}/login.jsp"
end

def get_all_stories 
  url="https://#{JIRA_HOME_URL}/sr/jira.issueviews:searchrequest-xml/10020/SearchRequest-10020.xml?tempMax=1000"
  system "curl -k -b cookies.txt -o all_stories.xml \"#{url}\""
end


