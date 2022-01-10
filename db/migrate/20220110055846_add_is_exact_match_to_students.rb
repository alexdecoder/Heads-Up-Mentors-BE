class AddIsExactMatchToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :isExactMatch, :boolean, null: true
  end
end
