require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have fixtures
    @event = events(:one)
    # Set current user (adjust based on your authentication system)
    # Current.user = @user
  end

  test "should get index" do
    get events_url
    assert_response :success
    assert_select "h1", "Events"
  end

  test "should get new" do
    get new_event_url
    assert_response :success
    assert_select "h1", "Create New Event"
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: {
        event: {
          title: "Test Event",
          description: "Test Description",
          location: "Test Location",
          start_time: 1.day.from_now,
          end_time: 1.day.from_now + 2.hours
        }
      }
    end

    assert_redirected_to event_url(Event.last)
    assert_equal "Event created successfully.", flash[:notice]
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
    assert_select "h1", @event.title
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
    assert_select "h1", "Edit Event"
  end

  test "should update event" do
    patch event_url(@event), params: {
      event: {
        title: "Updated Title",
        description: @event.description,
        location: @event.location,
        start_time: @event.start_time,
        end_time: @event.end_time
      }
    }
    assert_redirected_to event_url(@event)
    assert_equal "Event updated successfully.", flash[:notice]

    @event.reload
    assert_equal "Updated Title", @event.title
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
    assert_equal "Event deleted successfully.", flash[:notice]
  end

  test "should not create event with invalid data" do
    assert_no_difference("Event.count") do
      post events_url, params: {
        event: {
          title: "", # Invalid: title is required
          description: "Test Description",
          start_time: 1.day.from_now
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".stimulus-error, .bg-red-50"
  end

  test "should not create event with end time before start time" do
    assert_no_difference("Event.count") do
      post events_url, params: {
        event: {
          title: "Test Event",
          start_time: 1.day.from_now,
          end_time: 1.hour.ago # Invalid: end time before start time
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
