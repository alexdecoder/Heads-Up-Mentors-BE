require 'pp'

class Sort
    def self.sort_students
        # Randomly pair students into mentors based on subjects if unpaired after Sort completed
        # Prioritize the mentors without students for pairing
        unsorted_students = Student.where(paired: false).or(Student.where paired: nil)
        unsorted_students.each do |student|
            # Start by querying all available mentors with appropriate gender
            if student.genpref == 0
                mentor_buffer = Mentor.all
            else
                mentor_buffer = Mentor.where gender: student.genpref == 1
            end

            # Check which mentors have slots available
            buffer_hold = []
            mentor_buffer.each do |mentor|
                if mentor.students.count < mentor.num_students
                    buffer_hold.append mentor
                end
            end
            mentor_buffer = buffer_hold

            # Check which mentors have matching subjects
            buffer_hold = []
            mentor_buffer.each do |mentor|
                if (mentor.subjects - student.subjects).count != mentor.subjects.count
                    buffer_hold.append mentor
                end
            end
            mentor_buffer = buffer_hold

            day_mapping = {
                Monday: 0,
                Tuesday: 1,
                Wednesday: 2,
                Thursday: 3,
                Friday: 4,
            }

            catch :completed do
                mentor_buffer.each do |mentor|
                    student.days_available.each do |day|
                        buffer = mentor.times[day_mapping[day.to_sym]]
                        if buffer != nil
                            student.available_times.each do |time|
                                buffer.each do |k, v|
                                    if time == k && !v
                                        mentor.students << student # add student to matched mentor list

                                        mentor.times[day_mapping[day.to_sym]][k] = true
                                        mentor.save

                                        student.paired = true
                                        student.save

                                        throw :completed
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        # This block of code will identify all unpaired students and place them
        # with mentors prioritizing the mentors that have no pairings
        unpaired_mentors = Mentor.where.missing(:students)
        unpaired_students = Student.where(paired: false).or(Student.where(paired: nil))
        index = 0
        if unpaired_mentors.count < unpaired_students.count
            unpaired_mentors.each do |unpaired_mentor|
                unpaired_student = Student.offset(index).first
                unpaired_mentor.students << unpaired_student
                unpaired_mentor.save

                unpaired_student.paired = true
                unpaired_student.save

                index += 1
            end
        else
            unpaired_students.each do |unpaired_student|
                unpaired_mentor = Mentor.offset(index).first
                unpaired_mentor.students << unpaired_student
                unpaired_mentor.save

                unpaired_student.paired = true
                unpaired_student.save

                index += 1
            end
        end

        # By this point, all students with subjects matching those of mentors
        # without students will now be paired. The remaining students are to
        # be paired randomly
        unpaired_students = Student.where(paired: false).or(Student.where(paired: nil))
        unpaired_students.each do |unpaired_student|
            mentor = Mentor.offset(rand(Mentor.count)).first!
            mentor.students << unpaired_student
            mentor.save

            unpaired_student.paired = true
            unpaired_student.save
        end
    end
end