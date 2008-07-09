#!/usr/bin/env ruby
require './script/jira_backlog.rb'

login
get_all_stories
backlog = JiraBacklog.new("all_stories.xml")
puts backlog.report
