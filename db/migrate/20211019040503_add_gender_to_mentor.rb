class AddGenderToMentor < ActiveRecord::Migration[6.1]
  def change
    add_column :mentors, :gender, :boolean

    change_column :students, :genpref, 'integer USING genpref::integer'
  end
end
