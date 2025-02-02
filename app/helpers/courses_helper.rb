module CoursesHelper
  def course_dates(course)
    "#{format_date(course.startdate)}-#{format_date(course.enddate)}"
  end
end
