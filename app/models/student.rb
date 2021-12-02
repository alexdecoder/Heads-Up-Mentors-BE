class Student < ApplicationRecord
    serialize :available_times, Array
    serialize :subjects, Array
    serialize :days_available, Array
end
