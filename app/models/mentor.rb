class Mentor < ApplicationRecord
    has_many :students

    serialize :times, Hash
    serialize :subjects, Array
end
