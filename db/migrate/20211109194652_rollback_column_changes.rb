class RollbackColumnChanges < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :days_available, :string
    add_column :students, :available_times, :string

    remove_column :students, :times
  end
end
