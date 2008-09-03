require "test/unit"

require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog]) 

class TestUserStory < Test::Unit::TestCase
  def test_closed
    assert_not_closed "Open"
    assert_not_closed "In Progress"
    assert_closed "Closed"
    assert_closed "Internal Signoff"
    assert_closed "Resolved"
  end
  
private
  
  def assert_not_closed status
    assert !UserStory.new("key", status).closed, "story in status #{status} expected not closed"
  end
  
  def assert_closed status
    assert UserStory.new("key", status).closed, "story in status #{status} expected closed"
  end
  
end