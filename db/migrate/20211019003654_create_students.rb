class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.belongs_to :mentor, null: true, index: true, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
