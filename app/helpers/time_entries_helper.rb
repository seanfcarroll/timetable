# frozen_string_literal: true

module TimeEntriesHelper
  def format_distance_of_minutes amount
    hours = amount / 60
    minutes = amount % 60
    "#{hours}:#{minutes.to_s.rjust 2, '0'}"
  end

  def format_distance_of_minutes_as_hours amount
    number_with_precision amount.to_f / 60, precision: 2
  end
end
