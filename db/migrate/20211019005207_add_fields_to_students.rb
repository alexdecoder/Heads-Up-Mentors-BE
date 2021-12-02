class AddFieldsToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :genpref, :boolean
    add_column :students, :paired, :boolean
    add_column :students, :email, :string
    add_column :students, :available_times, :string
  end
end
