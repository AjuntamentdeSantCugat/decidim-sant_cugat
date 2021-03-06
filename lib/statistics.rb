module Statistics
  def percentage_participants_of_zone(census_data, total_participants_zone)
    total_participants = census_data.select { |participant| total_participants_zone.include? participant }
    percentage = ((total_participants.count.to_f / total_participants_zone.count.to_f) * 100.0).round(2)

    "Total participants: #{total_participants.uniq.count}, Percentage: #{percentage} %"
  end
end
