class ModifyDateFormat < ActiveRecord::Migration[6.1]
  def change
    remove_column :students, :available_times
    remove_column :students, :days_available

    add_column :students, :times, :string
  end
end
