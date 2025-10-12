module ApplicationHelper
  def format_date_spanish(date)
    return "" unless date

    days = %w[domingo lunes martes miércoles jueves viernes sábado]
    months = %w[enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre]

    day_name = days[date.wday]
    month_name = months[date.month - 1]

    "#{day_name}, #{date.day} de #{month_name} de #{date.year}"
  end

  def format_time_spanish(time)
    return "" unless time

    time.strftime("%I:%M %p").downcase.gsub("am", "a.m.").gsub("pm", "p.m.")
  end

  def render_field_error(model, field)
    return unless model.errors[field].any?

    content_tag :div, class: "text-red-600 text-sm mt-1" do
      model.errors[field].first
    end
  end
end
