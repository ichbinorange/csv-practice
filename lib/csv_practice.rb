require 'csv'
require 'awesome_print'

def get_all_olympic_athletes(filename)
  olympic_data = CSV.read(filename, headers: true).map { |row| row.to_h.slice("ID", "Name", "Height", "Team", "Year", "City", "Sport", "Event", "Medal") }
  return olympic_data
end

def total_medals_per_team(olympic_data)
  olympic_data.select! { |athlete| athlete['Medal'] != "NA" }
  medals_info_for_each_team = Hash.new
  olympic_data.each do |athlete|
    if !(medals_info_for_each_team.keys.include? (athlete['Team'])) 
      medals_info_for_each_team[athlete['Team']] = olympic_data.count { |each_athlete| each_athlete["Team"] == athlete['Team'] }
    end
  end
  return medals_info_for_each_team
end

def get_all_gold_medalists(olympic_data)
  gold_medals = olympic_data.filter! { |athlete| athlete['Medal'] == "Gold" }
  return gold_medals
end

# Optional - team_with_most_medals
def team_with_most_medals(medal_totals)
  max_medals = medal_totals.max_by { |team, metals| metals }
  most_medals_team = medal_totals.select { |team, metals| metals == max_medals[1] }

  result_for_most_medals = Hash("Team"=> most_medals_team.keys, "Count"=> max_medals[1] )
  return result_for_most_medals
end

# Optional - athlete_height_in_inches
def athlete_height_in_inches(olympic_data)
  olympic_data.each do |athlete| 
    if athlete["Height"].class == Integer || athlete["Height"].class == Float
      athlete["Height"] = (athlete["Height"] * (1 / 2.54)).round(2)
    elsif athlete["Height"].to_i.to_s == athlete["Height"] || athlete["Height"].to_f.to_s == athlete["Height"]
      athlete["Height"] = (athlete["Height"].to_i * (1 / 2.54)).round(2)
    else
      athlete["Height"] = ""
    end
  end
  return olympic_data
end
