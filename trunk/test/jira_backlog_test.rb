#!/usr/bin/env ruby

require "test/unit"
require File.dirname(__FILE__) + '/../script/jira_backlog'

class JiraBacklogTest < Test::Unit::TestCase
  @@backlog = JiraBacklog.new("test/test.xml")

  def test_ker_227
    story = @@backlog["KER-227"]
    assert_not_nil story
    assert_equal "KER-227", story.key
    assert_equal "[KER-227] LSE Beta Products - About The Exchange", story.title
    assert_equal "Open", story.status
    assert_equal 10, story.estimated_complexity
    assert_equal Fixnum, story.estimated_complexity.class
    assert_equal "IPO", story.team
  end

  
  def test_story_count_totals
    assert_equal 18, @@backlog.stories.size
    assert_equal 5,  @@backlog.all_story_of("PRICES") .size
    
    assert_equal 3, @@backlog.not_yet_estimated_for("PRICES")
    assert_equal 12, @@backlog.total_done_for("PRICES")
    assert_equal 47 + 12, @@backlog.total_of_all_for("PRICES")

    
    assert_equal 10,  @@backlog.all_story_of("IPO") .size
    assert_equal 9, @@backlog.not_yet_estimated_for("IPO")
    assert_equal 10, @@backlog.total_of_all_for("IPO")
   
    assert_equal 3,  @@backlog.all_story_of("NEWS") .size
  end
  
  def test_report
    puts @@backlog.report
  end

  def test_null_complexity
    story = @@backlog["KER-209"]
    assert_nil story.estimated_complexity
  end
  
  def test_resolution_date
    story = @@backlog["KER-209"]
    assert_equal "2008-06-18", story.resolution_date
  end

end
