# csv_practice_test.rb

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/pride'
require "minitest/skip_dsl"
require 'pry'

require_relative '../lib/csv_practice'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

REQUIRED_OLYMPIAN_FIELDS = %w[ID Name Height Team Year City Sport Event Medal]
MEDAL_TOTALS_FILENAME = 'data/medal_totals.csv'
OLYMPIC_DATA_FILENAME = 'data/athlete_events.csv'

describe "CSV and Enumerables Exercise" do

  describe 'get_all_olympic_athletes' do
    it 'returns an array of Olympic athletes hashes with the correct information' do
      # Arrange: Nothing to arrange
      #   besides the OLYMPIC_DATA_FILENAME constant variable above

      # Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert:
      # Check that we get back an array
      expect(olympic_athletes).must_be_instance_of Array

      olympic_athletes.each do |athlete|
        # Check that each element in the array is a hash
        expect(athlete).must_be_instance_of Hash

        # Check that each Olympian hash has the necessary keys
        #   (defined in the constant REQUIRED_OLYMPIAN_FIELDS above)
        expect(athlete.keys.length).must_equal REQUIRED_OLYMPIAN_FIELDS.length
        REQUIRED_OLYMPIAN_FIELDS.each do |required_field|
          expect(athlete.keys).must_include required_field
        end
      end
    end

    it 'has the proper number of rows' do
      # Arrange & Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert
      expect(olympic_athletes.length).must_equal 49503
    end

    it 'has the right 1st and last row' do
      # Arrange & Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert
      expect(olympic_athletes.first['ID']).must_equal '21'
      expect(olympic_athletes.first['Name']).must_equal 'Ragnhild Margrethe Aamodt'
      expect(olympic_athletes.first['Team']).must_equal 'Norway'
      expect(olympic_athletes.last['ID']).must_equal '135568'
      expect(olympic_athletes.last['Name']).must_equal 'Olga Igorevna Zyuzkova'
      expect(olympic_athletes.last['Team']).must_equal 'Belarus'
    end
  end

  describe 'total_medals_per_team' do

    it 'should return a hash of accurate team and count' do
      # Arrange
      expected_totals = {
        'Norway' => 133,
        'United States' => 944,
        'Canada' => 321,
        'Russia' => 470,
        'China' => 423,
        'Bahrain' => 3,
        'Jamaica' => 69,
        'United Arab Emirates' => 1
      }
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      total_medals = total_medals_per_team(data)

      # Assert
      expect(total_medals).must_be_instance_of Hash
      expected_totals.each do |expected_team, expected_count|
        expect(total_medals[expected_team]).must_equal expected_count
      end
    end
  end

  describe 'get_all_gold_medalists' do
    
    it 'returns an array of gold medalists' do
      # Arrange
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      all_gold_medalists = get_all_gold_medalists(data)

      # Assert
      expect(all_gold_medalists).must_be_instance_of Array
      all_gold_medalists.each do |medalist|
        expect(medalist).must_be_instance_of Hash
        expect(medalist['Medal']).must_equal "Gold"
      end
    end

    it 'has the correct number of gold medalists' do
      # Arrange
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      all_gold_medalists = get_all_gold_medalists(data)

      # Assert
      expect(all_gold_medalists.length).must_equal 2344
    end
  end

  describe 'team_with_most_medals' do
    it 'returns an hash of the team with the most medals' do
      # Arrange
      data = [
        {"Team"=> "Taiwan","Medal"=> "NA"},
      {"Team"=> "Norway", "Medal"=> "Gold"},
      {"Team"=> "Japan", "Medal"=> "Silver"},
      {"Team"=> "Norway", "Medal"=> "Bronze"}
      ]
      total_medals = total_medals_per_team(data)

      # Act
      most_medals = team_with_most_medals(total_medals)

      # Assert
      expect(most_medals).must_be_instance_of Hash
      expect(most_medals.keys).must_equal ["Team", "Count"]
    end
    
    it 'has the correct country and number of medals' do
      # Arrange
      most_metals_country = {"Team" =>['United States'], "Count" => 944}
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)
      total_medals = total_medals_per_team(data)

      # Act
      most_medals = team_with_most_medals(total_medals)

      # Assert
      expect(most_medals["Team"]).must_equal ['United States']
      expect(most_medals["Count"]).must_equal 944
    end
    
    it 'has a tie for the teams with the most medals' do
      # Arrange
      data = [
        {"Team"=> "Japan","Medal"=> "Gold"},
      {"Team"=> "Norway", "Medal"=> "Gold"},
      {"Team"=> "Japan", "Medal"=> "Silver"},
      {"Team"=> "Norway", "Medal"=> "Bronze"}
     ]
      total_medals = total_medals_per_team(data)

      # Act
      most_medals = team_with_most_medals(total_medals)

      # Assert
      expect(most_medals["Team"]).must_equal ["Japan", "Norway"] || ["Norway", "Japan"]
      expect(most_medals["Count"]).must_equal 2
    end
  end

  describe 'athlete_height_in_inches' do
    it 'returns an array of Olympic athletes hashes with height in inches' do
      # Arrange
      data = [
        {"Height"=> 168.4},
        {"Height"=> 158},
        {"Height"=> 201.1},
        {"Height"=> 175}
      ]

      # Act
      height_in_inch = athlete_height_in_inches(data)

      # Assert
      expect(height_in_inch).must_be_instance_of Array
      height_in_inch.each do |athlete|
        expect(athlete["Height"]).must_be_instance_of Float 
      end
    end
    
    it 'has the right 1st and last row with Height converted from centimeter to inch' do
      # Arrange
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      height_in_inch = athlete_height_in_inches(data)

      # Assert
      expect(height_in_inch.first['ID']).must_equal '21'
      expect(height_in_inch.first['Name']).must_equal 'Ragnhild Margrethe Aamodt'
      expect(height_in_inch.first['Height']).must_equal 64.17
      expect(height_in_inch.last['ID']).must_equal '135568'
      expect(height_in_inch.last['Name']).must_equal 'Olga Igorevna Zyuzkova'
      expect(height_in_inch.last['Height']).must_equal 67.32
    end
    
    it 'has a string or nil class of data for conversion' do
      # Arrange
      data = [
        {"Height"=> "NA"},
        {"Height"=> ""},
        {"Height"=> nil}
      ]

      # Act
      height_in_inch = athlete_height_in_inches(data)

      # Assert
      height_in_inch.each do |athlete|
        expect(athlete["Height"]).must_be_instance_of String
      end

      # Arrange
      data = [
        {"Height"=> "139"},
        {"Height"=> "189.5"}
      ]

      # Act
      height_in_inch = athlete_height_in_inches(data)

      # Assert
      height_in_inch.each do |athlete|
        expect(athlete["Height"]).must_be_instance_of Float
      end
    end
  end
end
