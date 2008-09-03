require "test/unit"

require File.join(File.dirname(__FILE__), *%w[.. lib report])
require File.join(File.dirname(__FILE__), *%w[.. lib jira_backlog])

class ReportTest < Test::Unit::TestCase
  
  def setup
    @backlog = JiraBacklog.new
    @backlog["KER-001"] = UserStory.new("KER-001", "Waiting", 10, "IPO")
    @backlog["KER-002"] = UserStory.new("KER-002", "Waiting", 15, "IPO")
    @backlog["KER-003"] = UserStory.new("KER-003", "Internal Signoff", 7, "IPO")
    @backlog["KER-004"] = UserStory.new("KER-004", "Waiting", 22, "PRICE")
    @backlog["KER-005"] = UserStory.new("KER-005", "Waiting", nil, "IPO")
    @backlog["KER-006"] = UserStory.new("KER-006", "Waiting", nil, "PRICE")
    @backlog["KER-007"] = UserStory.new("KER-007", "Internal Signoff", nil, "PRICE")
  end
  
  def test_total_points
    assert_equal 32, @backlog.total_of_all_for("IPO")
  end
  
  def test_report_header
    report = Report.new
    assert_equal "Team\tRemain\tTotal\tEarned\t#U.S.\tNon-estimated stories", report.header
  end
  
  def test_report_row
    report = Report.new(@backlog)
    assert_equal "IPO\t25\t32\t7\t4\t1", report.row_for("IPO")
    assert_equal "PRICE\t22\t22\t0\t3\t1", report.row_for("PRICE")
  end
end