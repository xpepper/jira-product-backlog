#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog.rb])
require File.join(File.dirname(__FILE__), *%w[.. lib report.rb])

login
get_all_stories
report = Report.new(JiraBacklog.new("all_stories.xml"))
puts report.report("PRICES", "NEWS", "DOCUMENTS", "SSO", "COMMON")
