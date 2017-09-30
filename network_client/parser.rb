require 'nokogiri'
require 'byebug'
require 'json'

class Parser

    Game = Struct.new(
    :game_info,
    :home_team_stats,
    :away_team_stats
    )

    GameInfo = Struct.new(
    :game_title,
    :game_date_formatted,
    :game_time_formatted,
    :away_team_name,
    :home_team_name
    )

    TeamStats = Struct.new(
    :team_odds,
    :team_record_overall,
    :team_record_road,
    :team_record_ats_overall,
    :team_record_ats_road,
    :team_record_L10_overall,
    :team_record_L10_road
    )

  def parse_html(html)
    noko_object = nokogirize(html)
    container = noko_object.at_css('.cmg_matchups_list')
    games = container.css('.cmg_matchup_game')

    games_parsed = []
    i = 0
    games.each do |game|
      puts i
      i += 1
      if i == 16
      else
        hashify = lambda do |struct|
          as_hash = struct.to_h
          struct_keys = as_hash.select { |_, v| v.is_a? Struct }.map(&:first)
          struct_keys.each { |key| as_hash[key] = hashify.(as_hash[key]) }
          as_hash
        end
        games_parsed.push(hashify.(parse_game(game)))
      end

    end

    games_parsed
  end

  private

  def nokogirize(html)
    Nokogiri::HTML(html)
  end


  def parse_game(game)
    box = game.css('.cmg_matchup_game_box')
    header = box.css('.cmg_matchup_header')
    away_team_top_info = box.css('.cmg_matchup_list_column_1')
    game_top_info = box.css('.cmg_matchup_list_column_2')
    game_odds = game_top_info.css('.cmg_team_odds')
    home_team_top_info = box.css('.cmg_matchup_list_column_3')
    bottom_row_container = box.css('.cmg_matchup_inshort')
    bottom_row = bottom_row_container.css('.cmg_matchup_in_short_condensed')
    away_team_bottom_row = bottom_row.css('.cmg_matchup_in_short_condensed_away')
    home_team_bottom_row = bottom_row.css('.cmg_matchup_in_short_condensed_home')

    # Chicago at Green Bay
    game_title = header.css('.cmg_matchup_header_team_names').text.strip

    # Thursday, Sep. 28
    game_date_formatted = header.css('.cmg_matchup_header_date').text.strip

    # CHI
    away_team_name = away_team_top_info.css('.cmg_team_name > text()').text.strip

    # +7
    away_team_odds = away_team_top_info.css('.cmg_matchup_list_away_odds > text()').text.strip

    # 8:25 PM ET
    game_time_formatted = game_top_info.css('.cmg_game_time').text.strip

    #GB
    home_team_name = home_team_top_info.css('.cmg_team_name > text()').text.strip

    # -7
    home_team_odds = home_team_top_info.css('.cmg_matchup_list_home_odds > text()').text.strip

    # Away team record
    away_team_record = away_team_bottom_row.css('.cmg_matchup_in_short_condensed_away_record')
    away_team_record_overall = away_team_record.css('span')[1].text
    away_team_record_road = away_team_record.css('span')[2].text

    away_team_record_ats = away_team_bottom_row.css('.cmg_matchup_in_short_condensed_away_ats')
    away_team_record_ats_overall = away_team_record_ats.css('span')[1].text
    away_team_record_ats_road = away_team_record_ats.css('span')[2].text

    away_team_record_L10 = away_team_bottom_row.css('.cmg_matchup_in_short_condensed_away_lastten')
    away_team_record_L10_overall = away_team_record_L10.css('span')[1].text
    away_team_record_L10_road = away_team_record_L10.css('span')[2].text

    # Home team record
    home_team_record = home_team_bottom_row.css('.cmg_matchup_in_short_condensed_home_record')
    home_team_record_overall = home_team_record.css('span')[1].text
    home_team_record_road = home_team_record.css('span')[2].text

    home_team_record_ats = home_team_bottom_row.css('.cmg_matchup_in_short_condensed_home_ats')
    home_team_record_ats_overall = home_team_record_ats.css('span')[1].text
    home_team_record_ats_road = home_team_record_ats.css('span')[2].text

    home_team_record_L10 = home_team_bottom_row.css('.cmg_matchup_in_short_condensed_home_lastten')
    home_team_record_L10_overall = home_team_record_L10.css('span')[1].text
    home_team_record_L10_road = home_team_record_L10.css('span')[2].text

    game_info = GameInfo.new(
    game_title,
    game_date_formatted,
    game_time_formatted,
    away_team_name,
    home_team_name
    )

    home_team_info = TeamStats.new(
    home_team_odds,
    home_team_record_overall,
    home_team_record_road,
    home_team_record_ats_overall,
    home_team_record_ats_road,
    home_team_record_L10_overall,
    home_team_record_L10_road
    )

    away_team_info = TeamStats.new(
    away_team_odds,
    away_team_record_overall,
    away_team_record_road,
    away_team_record_ats_overall,
    away_team_record_ats_road,
    away_team_record_L10_overall,
    away_team_record_L10_road
    )

    Game.new(game_info, home_team_info, away_team_info)

  end
end
