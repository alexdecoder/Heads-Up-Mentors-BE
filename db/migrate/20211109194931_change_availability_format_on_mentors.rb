class ChangeAvailabilityFormatOnMentors < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentors, :available_times
    remove_column :mentors, :days_available

    add_column :mentors, :times, :string
  end
end
