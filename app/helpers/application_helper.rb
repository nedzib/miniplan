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
end
