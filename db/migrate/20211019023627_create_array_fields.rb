class CreateArrayFields < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :days_available, :string
    add_column :students, :subjects, :string

    add_column :mentors, :days_available, :string
    add_column :mentors, :available_times, :string
    add_column :mentors, :num_students, :integer
    add_column :mentors, :subjects, :string
  end
end
