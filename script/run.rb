#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog.rb])

login
get_all_stories
backlog = JiraBacklog.new("all_stories.xml")
puts backlog.report
