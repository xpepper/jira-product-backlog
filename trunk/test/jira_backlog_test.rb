#!/usr/bin/env ruby

require "test/unit"
require File.dirname(__FILE__) + '/../lib/jira_backlog'


class JiraBacklogTest < Test::Unit::TestCase
  @@backlog = JiraBacklog.new(File.join(File.dirname(__FILE__), "test.xml"))

  def test_ker_227
    story = @@backlog["STORM-167"]
    assert_not_nil story
    assert_equal "STORM-167", story.key
    assert_equal "[STORM-167] Freeze/unfreeze sprint", story.title
    assert_equal "Open", story.status
    assert_equal 15, story.estimated_complexity
    assert_equal Fixnum, story.estimated_complexity.class
    assert_equal "Agile Planning Tool", story.team
  end
    
  def test_story_count_totals
    assert_equal 160, @@backlog.stories.size
    assert_equal 160,  @@backlog.all_story_of("Agile Planning Tool").size
        
    assert_equal 25, @@backlog.not_yet_estimated_for("Agile Planning Tool")    
    assert_equal 51, @@backlog.total_done_for("Agile Planning Tool")
        
    assert_equal 252,  @@backlog.in_status_for("Open", "Agile Planning Tool")
    assert_equal 3,  @@backlog.in_status_for("Resolved", "Agile Planning Tool")
    assert_equal 10,  @@backlog.in_status_for("Reopened", "Agile Planning Tool")
    assert_equal 51,  @@backlog.in_status_for("Closed", "Agile Planning Tool")
    assert_equal 252 + 3 + 10 + 51, @@backlog.total_of_all_for("Agile Planning Tool")

    assert_equal 0,  @@backlog.in_status_for("Open", "unknown component")
  end
  
  def test_null_complexity
    story = @@backlog["STORM-25"]
    assert_nil story.estimated_complexity
  end
  
  def test_number_of_stories_for
    assert_equal 160, @@backlog.number_of_stories_for("Agile Planning Tool")
  end

end
