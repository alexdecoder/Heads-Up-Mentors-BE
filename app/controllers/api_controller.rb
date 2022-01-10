require 'pp'
require 'csv'

class ApiController < ApplicationController
    def test
        Object.send :remove_const, :Sort
        load 'sort'
        Sort.sort_students

        render plain: 'done.'
    end

    def index
        response_buffer = {
            result: 'value',
            data: {
                mentors: [],
                students: []
            }
        }
        Mentor.all.each do |mentor|
            name_buffer = []
            mentor.students.each do |student|
                name_buffer.append student.name
            end

            response_buffer[:data][:mentors].append(
                {
                    name: mentor.name,
                    times: mentor.times,
                    subjects: mentor.subjects,
                    students: name_buffer,
                    pairingLimit: mentor.num_students,
                }
            )
        end

        Student.all.each do |student|
            if student.mentor_id != nil
                mentor_name = Mentor.where(id: student.mentor_id).first.name
            else
                mentor_name = "N/A"
            end

            response_buffer[:data][:students].append(
                {
                    status: student.paired,
                    name: student.name,
                    daysAvailable: student.days_available,
                    timesAvailable: student.available_times,
                    subjects: student.subjects,
                    email: student.email,
                    mentor: mentor_name,
                }
            )
        end

        render json: response_buffer
    end

    def csv_actions
        if params.has_key?(:a)
            case params[:a]
            when "import"
                if params.has_key?(:csv)
                    Student.delete_all

                    csv = CSV.parse(params[:csv].read.force_encoding "UTF-8")
                    
                    target_value_columns = {
                        first_name: 1,
                        last_name: 2,
                        email: 21,
                        available_times: 10,
                        days_available: 9,
                        subjects: 7,
                        genpref: 4,
                    }
                    
                    i = 0
                    csv.each do |student|
                        if i > 0
                            if student[target_value_columns[:genpref]] == "Does not matter"
                                genpref = 0
                            elsif student[target_value_columns[:genpref]] == "Male"
                                genpref = 1
                            else
                                genpref = 2
                            end

                            Student.create(
                                name: student[target_value_columns[:first_name]] + " " + student[target_value_columns[:last_name]],
                                genpref: genpref,
                                email: student[target_value_columns[:email]],
                                available_times: CSV.parse(student[target_value_columns[:available_times]])[0],
                                days_available: CSV.parse(student[target_value_columns[:days_available]])[0],
                                subjects: CSV.parse(student[target_value_columns[:subjects]])[0],
                            )
                        end

                        i += 1
                    end

                    Sort.sort_students

                    render json: {
                        result: 'value',
                        data: 'done',
                    }
                else
                    render json: {
                        result: "error",
                        data: "invalid_request",
                    }
                end
            when "exportmstr"
                render plain: params[:a]
            when "importmentors"
                if params.has_key?(:csv)
                    Student.delete_all
                    Mentor.delete_all

                    column_mapping = {
                        first_name: 1,
                        last_name: 2,
                        num_students: 14,
                        subjects: 7,
                        gender: 4,
                    }
                    time_column_mapping = [
                        8,
                        9,
                        10,
                        11,
                        12,
                    ]

                    csv = CSV.parse(params[:csv].read.force_encoding "UTF-8")
                    csv.shift # Removes first node (title)
                    
                    csv.each do |student|
                        time_buffer = {}
                        time_column_mapping.each_with_index do |_, i|
                            if student[time_column_mapping[i]] != nil
                                time_buffer[i] = {}
                                CSV.parse(student[time_column_mapping[i]])[0].each_with_index do |k|
                                    time_buffer[i][k] = false
                                end
                            end
                        end

                        Mentor.create(
                            name: student[column_mapping[:first_name]] +  ' ' + student[column_mapping[:last_name]],
                            num_students: student[column_mapping[:num_students]],
                            subjects: CSV.parse(student[column_mapping[:subjects]])[0],
                            times: time_buffer,
                            gender: student[column_mapping[:gender]] == 'Male'
                        )
                    end
                end

                Sort.sort_students

                render json: csv
            else
                render json: {
                    result: "error",
                    data: "invalid_query",
                }
            end
        end
    end

    def export_csv
        Student.all
        csv_string = CSV.generate do |csv|
            csv << [
                'Student Name',
                'Paired',
                'Gender Pref.',
                'Email',
                'Mentor',
            ]
            Student.where(paired: nil).or(Student.where paired: false).each do |student|
                if student.genpref == 0
                    gen_pref = 'No Pref.'
                elsif student.genpref == 1
                    gen_pref = 'MALE'
                else
                    gen_pref = 'FEMALE'
                end

                csv << [
                    student.name,
                    'NO',
                    gen_pref,
                    student.email,
                    'N/A', #Mentor.find(id: student.mentor_id).name
                ]
            end
            Student.where(paired: true).each do |student|
                puts student.mentor_id

                if student.genpref == 0
                    gen_pref = 'No Pref.'
                elsif student.genpref == 1
                    gen_pref = 'MALE'
                else
                    gen_pref = 'FEMALE'
                end

                csv << [
                    student.name,
                    'YES',
                    gen_pref,
                    student.email,
                    Mentor.where(id: student.mentor_id).first.name,
                ]
            end
        end

        send_data csv_string, type: 'text/csv; charset=utf-8; header=present', :disposition => 'attachment; filename=HUM_mastersheet.csv'
    end
end

