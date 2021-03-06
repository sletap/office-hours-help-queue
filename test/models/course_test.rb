require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    @course = courses(:eecs398)
  end

  test "open queues returns only open queues" do
    open_queues = @course.open_queues

    assert     open_queues.include? course_queues(:eecs398_queue)
    assert_not open_queues.include? course_queues(:closed_queue)
  end

  test "group string serializes correctly" do
    group_string = <<-EOF
steve@umich.edu,mterwil@umich.edu
marysmith@umich.edu,jimbob@umich.edu
EOF

    assert courses(:eecs482).get_group_string.strip == group_string.strip
  end

  test "demo queue gets created with course" do
    my_course = Course.create!(
      name: 'test',
      long_name: 'My Test Course',
      slug: 'testcourse'
    )

    assert my_course.course_queues.count > 0, "Course create should also create a queue"
  end

  test "courses that already have a queue do not get the default" do
    new_course = Course.new(
      name: 'test',
      long_name: 'Hello',
      slug: 'woo'
    )

    new_course.course_queues << new_course.course_queues.new(name: 'Test', location: 'Test')

    new_course.save!

    assert new_course.course_queues.count == 1, "Skip default create if there is alreay a queue"
  end
end
