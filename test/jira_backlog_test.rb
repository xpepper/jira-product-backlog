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

  def test_story_count
    assert_equal 18, @@backlog.number_of_stories
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