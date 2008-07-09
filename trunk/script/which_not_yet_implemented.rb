#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog.rb])

unless ARGV[0] 
  puts "Please call me with one among IPO - PRICES - NEWS "
  exit
end


backlog = JiraBacklog.new("all_stories.xml")
which = backlog.all_story_of(ARGV[0]).collect do |us|
      us.key + " " +  us.status unless us.estimated_complexity 
end
puts which.compact