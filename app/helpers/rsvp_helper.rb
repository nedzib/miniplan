module RsvpHelper
  def rsvp_deadline_passed?(event)
    event.rsvp_deadline_passed?
  end

  def rsvp_deadline_active?(event)
    event.rsvp_deadline_active?
  end

  def time_until_deadline(event)
    return nil unless event.rsvp_deadline && !rsvp_deadline_passed?(event)
    event.rsvp_deadline
  end
end
