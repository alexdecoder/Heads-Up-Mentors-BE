# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Mentor.create(
    name: 'Udbhav Raghukanth',
    times: {
        4 => [
            '6-7',
            '7-8',
        ],
        3 => [
            '6-7',
        ]
    },
    num_students: 2,
    subjects: ['Math'],
    gender: true,
)
Mentor.create(
    name: 'Sanjay Sairam',
    times: {
        2 => [
            '6-7',
            '7-8',
        ],
        0 => [
            '6-7',
        ]
    },
    num_students: 1,
    subjects: ['Science', 'Math'],
    gender: true,
)
Mentor.create(
    name: 'Jill Adams',
    times: {
        1 => [
            '6-7',
            '7-8',
        ],
        4 => [
            '6-7',
        ]
    },
    num_students: 1,
    subjects: ['Engish', 'History'],
    gender: false,
)

# Students begin in the unpaired state

Student.create( 
    # This student doesn't match any of the seeded mentors
    paired: false,
    name: 'Rohan Suggala',
    genpref: 0,
    email: 'rohansuggala@gmail.com',
    days_available: ['Fri', 'Thu'],
    available_times: ['6-7', '7-8'],
    subjects: ['Writing', 'Math'],
)
Student.create( 
    # This student doesn't match any of the seeded mentors
    # All values match with Jill Adams minus the pref gender (is male)
    paired: false,
    name: 'Nandan Suggala',
    genpref: 0,
    email: 'nandansuggala@gmail.com',
    days_available: ['Tue', 'Fri'],
    available_times: ['6-7', '7-8'],
    subjects: ['History', 'English'],
)
Student.create( 
    # This student matches with Sanjay or Udbhav
    paired: false,
    name: 'Alex Rankin',
    genpref: 1,
    email: 'alexander.m.rankin@gmail.com',
    days_available: ['Fri', 'Thu'],
    available_times: ['5-6', '7-8'],
    subjects: ['Writing', 'Math'],
)