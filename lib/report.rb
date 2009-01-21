class Report
  
  def initialize(backlog=nil)
    @backlog = backlog
  end
  
  def row_for(team)
    all_stories = @backlog.number_of_stories_for(team)
    not_estimated = @backlog.not_yet_estimated_for(team)
    
    total_points = @backlog.total_of_all_for(team)
    points_earned = @backlog.total_done_for(team)
    points_remaining = total_points - points_earned
    
    [team.slice(0,7), points_remaining, total_points, points_earned, all_stories, not_estimated].join("\t")
  end
  
  def header
    "--------------------------------------------------\n" +
    "Team\tRemain\tTotal\tEarned\t#U.S.\tNotYetEstimated"
  end
  
  def report(*teams)
    rows = teams.map {|t| row_for(t)}
    header + "\n" + rows.join("\n")
  end
end