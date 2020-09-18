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


