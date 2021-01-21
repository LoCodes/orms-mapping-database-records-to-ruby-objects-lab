class Student
  # attributes
  # has an id, name, grade
  attr_accessor :id, :name, :grade


# .new_from_db
# creates an instance with corresponding attribute values
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new # or Student.new 
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student     #return newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
     SELECT *
     FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  # .create_table
  # creates a student table
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  # .drop_table
  # drops the student table

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  # .find_by_name
  # returns an instance of student that matches the name from the DB 
    # find the student in the database given a name
    # return a new instance of the Student class
  def self.find_by_name(name)   
    sql = <<-SQL
      SELECT *
      FROM students 
      WHERE name = ?
      LIMIT 1 
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end 

  def self.all_students_in_grade_9
    sql = <<-SQL 
      SELECT * 
      FROM students
      WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end 

  # .students_below_12th_grade
  # returns an array of all students in grades 11 or below

  def self.students_below_12th_grade 
    sql = <<-SQL 
     SELECT * 
     FROM students
     WHERE grade < 12
     SQL

     DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
     end 
  end 

  # .first_X_students_in_grade_10
  # returns an array of the first X students in grade 10
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT ?
    SQL

    DB[:conn].execute(sql, number).map do |row|
      self.new_from_db(row)
    end
  end

  # .first_student_in_grade_10
  # returns the first student in grade 10

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * 
    FROM students 
    WHERE grade = 10 
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first 
  end 

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL 
      SELECT *
      FROM students 
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end 
  end 
end
