require "test/unit"

require File.join(File.dirname(__FILE__), *%w[.. lib report])
require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog])

class ReportTest < Test::Unit::TestCase
  
  def setup
    @backlog = JiraBacklog.new
    @backlog["STORM-001"] = UserStory.new("STORM-001", "Open", nil, "Agile Planning Tool")
    @backlog["STORM-002"] = UserStory.new("STORM-002", "Open", 15, "Agile Planning Tool")
    @backlog["STORM-003"] = UserStory.new("STORM-003", "In Progress", 5, "Agile Planning Tool")
    @backlog["STORM-004"] = UserStory.new("STORM-004", "In Progress", 10, "Agile Planning Tool")
    @backlog["STORM-005"] = UserStory.new("STORM-005", "Resolved", 15, "Agile Planning Tool")
    @backlog["STORM-006"] = UserStory.new("STORM-006", "Resolved", 5, "Agile Planning Tool")
    @backlog["STORM-007"] = UserStory.new("STORM-007", "Reopened", 5, "Agile Planning Tool")
    @backlog["STORM-008"] = UserStory.new("STORM-008", "Closed", 15, "Agile Planning Tool")
  end
  
  def test_total_points
    assert_equal 70, @backlog.total_of_all_for("Agile Planning Tool")
  end
  
  def test_report_header
    report = Report.new
    assert_equal "--------------------------------------------------\n" + 
                 "Team\tRemain\tTotal\tEarned\t#U.S.\tNotYetEstimated", report.header
  end
  
  def test_report_row
    report = Report.new(@backlog)
    assert_equal "Agile P\t55\t70\t15\t8\t1", report.row_for("Agile Planning Tool")
  end
end